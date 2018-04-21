class RenameNewCourseTeacherRatings < ActiveRecord::Migration[5.0]
  def change
    rename_table :new_course_teacher_ratings, :course_teacher_ratings
  end
end
