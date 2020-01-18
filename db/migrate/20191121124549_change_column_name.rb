class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :entity_wallet_configs, :division_code, :entity_code
    add_column :entity_wallet_configs, :activity_type_code, :string
  end
end
