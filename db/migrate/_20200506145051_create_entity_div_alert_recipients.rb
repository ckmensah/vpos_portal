class CreateEntityDivAlertRecipients < ActiveRecord::Migration[5.2]
  def change
    create_table :entity_div_alert_recipients do |t|
      t.string :entity_div_code
      t.string :recipient_name
      t.string :mobile_number
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
