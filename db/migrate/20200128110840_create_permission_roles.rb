class CreatePermissionRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :permission_roles do |t|
      t.integer :role_id
      t.integer :permission_id
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
