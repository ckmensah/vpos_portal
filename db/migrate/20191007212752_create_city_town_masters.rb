class CreateCityTownMasters < ActiveRecord::Migration[5.2]
  def change
    create_table :city_town_masters do |t|
      t.string :city_town_name
      t.integer :region_id
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
