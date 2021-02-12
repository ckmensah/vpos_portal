class CreateEntityDivMedia < ActiveRecord::Migration[5.2]
  def change
    create_table :entity_div_media do |t|
      t.string :entity_div_code
      t.string :media_path
      t.string :media_data
      t.string :media_type
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
