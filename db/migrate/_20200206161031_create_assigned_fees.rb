class CreateAssignedFees < ActiveRecord::Migration[5.2]
  def change
    create_table :assigned_fees do |t|
      t.string :entity_div_code
      t.string :trans_type
      t.decimal :fee, precision: 11, scale: 3
      t.string :flat_percent
      t.decimal :cap, precision: 11, scale: 3
      t.decimal :limit_capped, precision: 11, scale: 3
      t.string :charged_to
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end

