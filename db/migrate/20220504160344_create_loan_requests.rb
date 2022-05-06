class CreateLoanRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :loan_requests do |t|
      t.string :division_code
      t.string :full_name
      t.string :id_number
      t.string :ref_number
      t.string :location
      t.decimal :amount, precision: 11, scale: 2
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
