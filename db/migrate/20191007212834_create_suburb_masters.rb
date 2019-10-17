class CreateSuburbMasters < ActiveRecord::Migration[5.2]
  def change
    create_table :suburb_masters do |t|
      t.string :suburb_name
      t.integer :city_town_id
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
