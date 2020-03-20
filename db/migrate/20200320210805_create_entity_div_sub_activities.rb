class CreateEntityDivSubActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :entity_div_sub_activities do |t|
      t.string :sub_activity_code
      t.string :div_sub_activity_desc
      t.string :entity_div_code
      t.integer :user_id
      t.boolean :active_status
      t.boolean :del_status

      t.timestamps
    end
  end
end
