class CreateEntityServiceAccountTrxns < ActiveRecord::Migration[5.2]
  def change
    create_table :entity_service_account_trxns do |t|
      t.string :entity_div_code
      t.decimal :gross_bal_bef, precision: 11, scale: 3
      t.decimal :gross_bal_aft, precision: 11, scale: 3
      t.decimal :net_bal_bef, precision: 11, scale: 3
      t.decimal :net_bal_aft, precision: 11, scale: 3
      t.string :processing_id
      t.decimal :charge, precision: 11, scale: 3
      t.string :trans_type
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
