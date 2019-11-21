class CreateActivityDivs < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_divs do |t|
      t.string :division_code
      t.string :activity_div_desc
      t.date :activity_date
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
