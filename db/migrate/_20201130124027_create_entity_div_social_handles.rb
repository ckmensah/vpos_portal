class CreateEntityDivSocialHandles < ActiveRecord::Migration[5.2]
  def change
    create_table :entity_div_social_handles do |t|
      t.string :entity_div_code
      t.string :assigned_code
      t.string :handle
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
