json.extract! entity_info_extra, :id, :entity_code, :contact_number, :web_url, :contact_email, :location_address, :postal_address, :comment, :active_status, :del_status, :user_id, :created_at, :updated_at
json.url entity_info_extra_url(entity_info_extra, format: :json)
