class CreateSubActivityMasters < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_activity_masters do |t|
      t.string :assigned_code
      t.string :activity_desc
      t.integer :user_id
      t.boolean :active_status
      t.boolean :del_status

      t.timestamps
    end
  end
end

