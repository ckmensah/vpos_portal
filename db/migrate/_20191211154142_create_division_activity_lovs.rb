class CreateDivisionActivityLovs < ActiveRecord::Migration[5.2]
  def change
    create_table :division_activity_lovs do |t|
      t.string :activity_code
      t.string :division_code
      t.text :lov_desc
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
