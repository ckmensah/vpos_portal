class CreateEntityInfoExtras < ActiveRecord::Migration[5.2]
  def change
    create_table :entity_info_extras do |t|
      t.string :entity_code
      t.string :contact_number
      t.string :web_url
      t.string :contact_email
      t.text :location_address
      t.text :postal_address
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
