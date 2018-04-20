class Api::V1::CoursesController < ApiController
  def index
    sem_sel = Semester.all.order(id: :desc).pluck(:name, :id)
    if params[:custom_search].present? or params[:q].present? # if query something
      q = CourseDetail.search_by_q_and_text(params[:q], params[:custom_search])
    elsif current_v1_user.try(:department_id) and current_v1_user.department.has_courses # e.x 資工系資工組/網多/資電
      q = CourseDetail.search({:department_id_eq=>current_user.department_id})
    else
      q = CourseDetail.search({})
    end
    cds = q.result(distinct: true).includes(:course, :course_teachership, :semester, :department)
    cds = cds.page(params[:page]).order(semester_id: :desc).order(view_times: :desc)

    render json: cds
  end

  def show
    cd = CourseDetail.includes(:course_teachership, :course, :semester, :department, :normal_scores).find(params[:id])	
    incViewTime(cd)
    data = {
      :course_id=>cd.course.id.to_s,
      :course_detail_id=>cd.id.to_s,
      :course_teachership_id=>cd.course_teachership.id.to_s,
      :course_name=>cd.course_ch_name,
      :course_teachers=>cd.teacher_name,
      :course_real_id=>cd.course.real_id.to_s,
      :temp_cos_id=>cd.temp_cos_id,
      :year=>cd.semester_year,
      :half=>cd.semester_half,
      :course_credit=>cd.course.credit,
      :open_on_latest=>(cd.course_teachership.course_details.last.semester_id == Semester::LAST.id) ? true : false,
      :related_cds=>cd.course_teachership.course_details.includes(:semester, :department).order(semester_id: :desc),
      :updated_at=>cd.updated_at,
      :recommend_courses=>get_recommend_courses(cd.course.ch_name, cd.normal_scores.pluck(:user_id))
    }

    render json: data
  end

private

  def incViewTime(cd)
    current_time = Time.new
    c_id = cd.id.to_s
    session[:course] = {} if session[:course].nil?
    if session[:course][c_id] != current_time.day
      session[:course][c_id] = current_time.day
      cd.incViewTimes!
    end
  end

  def get_recommend_courses(ch_name, students)
    courses_they_take = []
    scores = NormalScore.where(:user_id => students)
    scores.each do |s|
      courses_they_take << s.course.ch_name
    end
    count_hash = count_times(ch_name, courses_they_take)
    ch_names = extract_keys_with_largest_n_values(count_hash, 5)
    results = []
    ch_names.each do |ch_name|
      results << { "id"=>Course.find_by_ch_name(ch_name).course_details.sort_by{|s| -s[:semester_id]}.first.id, "name"=>ch_name }
    end
    return results
  end

  def extract_keys_with_largest_n_values(hash, n)
    n = hash.length if n > hash.length
    min = hash.values.sort[-n]
    results = []
    i = 0
    hash.each{|k, v| (results.push(k) and i += 1) if i < n and v >= min}
    return results
  end

  def count_times(ch_name, array)
    count_hash = {}
    array.each do |key|
      if count = count_hash[key]
        count_hash[key] = count + 1
      else
        count_hash[key] = 1
      end
    end
    count_hash[ch_name] = 0 #should not pick this course itself
    trivial_courses = ['導師時間','服務學習','服務學習(一)','服務學習(二)','基礎程式設計','程式設計','計算機概論（一）','計算機概論（二）','計算機概論','計算機概論與程式設計','微積分甲（一）','微積分甲（二）','微積分乙（一）','微積分乙（二）','微積分丙（一）','微積分丙（二）','微積分A（一）','微積分A（二）','微積分B（一）','微積分B（二）','物理(一)','物理(二)','化學(一)','化學(二)','大一英文（一）','大一英文（二）','大一體育','藝文賞析教育']
    trivial_courses.each do |t|
      count_hash[t] = 0
    end
    return count_hash
  end
end
