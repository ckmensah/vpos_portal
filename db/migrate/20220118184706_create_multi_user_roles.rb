class CreateMultiUserRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :multi_user_roles do |t|
      t.integer :user_id
      t.string :entity_code
      t.string :role_code
      t.integer :creator_id
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status

      t.timestamps
    end
  end
end
