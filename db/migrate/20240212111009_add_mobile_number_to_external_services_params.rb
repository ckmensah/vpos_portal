class AddMobileNumberToExternalServicesParams < ActiveRecord::Migration[7.1]
  def change
    add_column :external_services_params, :mobile_number, :string
  end
end
