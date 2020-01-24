class CreatePaymentInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_infos do |t|
      t.string :session_id
      t.string :entity_div_code
      t.integer :activity_lov_id
      t.integer :activity_div_id
      t.integer :activity_sub_div_id
      t.boolean :processed
      t.string :src
      t.string :payment_mode
      t.decimal :amount, precision: 11, scale: 3
      t.string :customer_number
      t.string :trans_type
      t.decimal :charge, precision: 11, scale: 3
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
