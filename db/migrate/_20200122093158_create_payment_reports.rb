class CreatePaymentReports < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_reports do |t|

      t.timestamps
    end
  end
end
