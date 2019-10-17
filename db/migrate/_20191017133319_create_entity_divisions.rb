class CreateEntityDivisions < ActiveRecord::Migration[5.2]
  def change
    create_table :entity_divisions do |t|
      t.string :entity_code
      t.string :assigned_code
      t.string :division_name
      t.integer :suburb_id
      t.string :activity_code
      t.string :service_label
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
