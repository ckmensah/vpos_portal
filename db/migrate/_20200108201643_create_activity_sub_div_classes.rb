class CreateActivitySubDivClasses < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_sub_div_classes do |t|
      t.string :entity_div_code
      t.string :class_desc
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
