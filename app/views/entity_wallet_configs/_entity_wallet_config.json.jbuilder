json.extract! entity_wallet_config, :id, :division_code, :service_id, :secret_key, :client_key, :comment, :active_status, :del_status, :user_id, :created_at, :updated_at
json.url entity_wallet_config_url(entity_wallet_config, format: :json)
