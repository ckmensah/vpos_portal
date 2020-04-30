class CreateFundMovements < ActiveRecord::Migration[5.2]
  def change
    create_table :fund_movements do |t|
      t.string :entity_div_code
      t.integer :service_id
      t.string :ref_id
      t.decimal :amount, precision: 11, scale: 3
      t.string :narration
      t.string :trans_type
      t.string :trans_status
      t.string :trans_desc
      t.boolean :processed

      t.timestamps
    end
  end
end
