class CreateExternalServicesParams < ActiveRecord::Migration[7.1]
  def change
    create_table :external_services_params do |t|
      t.string :entity_div_code
      t.string :username
      t.string :password
      t.string :company_code
      t.string :company_url
      t.integer :user_id
      t.boolean :active_status
      t.boolean :del_status

      t.timestamps
    end
  end
end
