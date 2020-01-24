class CreatePaymentDetailsMatvs < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_details_matvs do |t|

      t.timestamps
    end
  end
end
