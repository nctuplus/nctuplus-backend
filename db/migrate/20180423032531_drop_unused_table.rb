class DropUnusedTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :ckeditor_assets
    drop_table :course_map_public_comments
    drop_table :course_simulations
    drop_table :event_images
    drop_table :new_courses
    drop_table :new_departments
    drop_table :top_managers
  end
end
