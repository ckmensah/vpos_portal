class CreateActivityTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_types do |t|
      t.string :assigned_code
      t.string :type_desc
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
