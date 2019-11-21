class CreateEntityWalletConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :entity_wallet_configs do |t|
      t.string :division_code
      t.integer :service_id
      t.string :secret_key
      t.string :client_key
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
