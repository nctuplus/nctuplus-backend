class ChangeFileInfoToPastExam < ActiveRecord::Migration[5.0]
  def change
    rename_table :file_infos, :past_exams
    rename_column :past_exams, :owner_id, :user_id
    add_column :past_exams, :is_anonymous, :boolean, :default=>false, :after=> :semester_id
    add_index :past_exams, :course_teachership_id
    add_index :past_exams, :semester_id
  end
end
