class CreateActivityCategoryDivs < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_category_divs do |t|
      t.string :division_code
      t.integer :activity_category_id
      t.integer :activity_div_cat_id
      t.string :category_div_desc
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
