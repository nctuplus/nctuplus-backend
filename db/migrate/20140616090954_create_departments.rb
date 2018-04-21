class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :ch_name
      t.string :eng_name
      t.integer :degree
      t.integer :college_id, default: 0
      t.string :dep_id
      t.timestamps
    end
    add_index :departments, :degree
    add_index :departments, :college_id
  end
end
