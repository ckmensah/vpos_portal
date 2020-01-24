class CreatePaymentCallbacks < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_callbacks do |t|
      t.string :trans_status
      t.string :nw_trans_id
      t.string :trans_ref
      t.string :trans_msg
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
