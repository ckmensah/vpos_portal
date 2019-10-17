class CreateActivitySubDivs < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_sub_divs do |t|
      t.integer :activity_div_id
      t.datetime :activity_time
      t.string :classification
      t.decimal :amount, precision: 8, scale: 2
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
