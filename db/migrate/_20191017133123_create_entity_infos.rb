class CreateEntityInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :entity_infos do |t|
      t.string :assigned_code
      t.string :entity_name
      t.string :entity_alias
      t.string :entity_cat_id
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
