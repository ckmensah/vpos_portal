class CreateAssignedServiceCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :assigned_service_codes do |t|
      t.string :entity_div_code
      t.string :service_code
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
