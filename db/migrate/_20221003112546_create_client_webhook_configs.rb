class CreateClientWebhookConfigs < ActiveRecord::Migration[7.0]
  def change
    create_table :client_webhook_configs do |t|
      t.string :entity_div_code
      t.string :trans_type
      t.string :url
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
