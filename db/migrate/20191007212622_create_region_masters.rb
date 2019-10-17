class CreateRegionMasters < ActiveRecord::Migration[5.2]
  def change
    create_table :region_masters do |t|
      t.string :region_name
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
