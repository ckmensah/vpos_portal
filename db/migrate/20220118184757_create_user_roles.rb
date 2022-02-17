class CreateUserRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :user_roles do |t|
      t.integer :user_id
      t.string :role_code
      t.string :entity_code
      t.string :division_code
      t.boolean :show_charge
      t.boolean :for_portal
      t.integer :creator_id
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status

      t.timestamps
    end
  end
end
