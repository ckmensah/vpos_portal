class CreatePaymentRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_requests do |t|
      t.integer :payment_info_id
      t.string :processing_id
      t.string :customer_number
      t.string :nw
      t.string :trans_type
      t.decimal :amount, precision: 11, scale: 2
      t.integer :service_id
      t.string :payment_mode
      t.string :reference
      t.boolean :processed
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
