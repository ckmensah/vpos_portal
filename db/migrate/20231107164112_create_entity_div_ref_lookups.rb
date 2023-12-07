class CreateEntityDivRefLookups < ActiveRecord::Migration[7.1]
  def change
    create_table :entity_div_ref_lookups do |t|
      t.string :entity_div_code
      t.string :pan
      t.string :name
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
