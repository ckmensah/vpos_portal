class CreateActivityGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_groups do |t|
      t.string :assigned_code
      t.string :activity_group_desc
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
