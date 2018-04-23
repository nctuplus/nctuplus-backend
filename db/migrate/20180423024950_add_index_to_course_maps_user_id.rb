class AddIndexToCourseMapsUserId < ActiveRecord::Migration[5.0]
  def change
    add_index :course_maps, :user_id
  end
end
