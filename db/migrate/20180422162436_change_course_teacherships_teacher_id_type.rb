class ChangeCourseTeachershipsTeacherIdType < ActiveRecord::Migration[5.0]
  def change
    change_column :course_teacherships, :teacher_id, :string
  end
end
