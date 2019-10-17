class CreateEntityCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :entity_categories do |t|
      t.string :assigned_code
      t.string :category_name
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
