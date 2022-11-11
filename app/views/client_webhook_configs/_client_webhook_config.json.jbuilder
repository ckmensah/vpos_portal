json.extract! client_webhook_config, :id, :entity_div_code, :trans_type, :url, :active_status, :del_status, :user_id, :created_at, :updated_at
json.url client_webhook_config_url(client_webhook_config, format: :json)
