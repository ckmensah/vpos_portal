class CreateActivityDivCats < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_div_cats do |t|
      t.string :division_code
      t.string :div_cat_desc
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
