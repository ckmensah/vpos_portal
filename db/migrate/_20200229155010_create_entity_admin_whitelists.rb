class CreateEntityAdminWhitelists < ActiveRecord::Migration[5.2]
  def change
    create_table :entity_admin_whitelists do |t|
      t.string :entity_division_code
      t.string :full_name
      t.string :mobile_number
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
