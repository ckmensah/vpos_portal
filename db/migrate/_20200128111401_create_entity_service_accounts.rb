class CreateEntityServiceAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :entity_service_accounts do |t|
      t.string :entity_div_code
      t.decimal :gross_bal, precision: 11, scale: 3
      t.decimal :net_bal, precision: 11, scale: 3
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
