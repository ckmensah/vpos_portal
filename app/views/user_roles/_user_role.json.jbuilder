json.extract! user_role, :id, :user_id, :role_code, :entity_code, :division_code, :show_charge, :for_portal, :creator_id, :comment, :active_status, :del_status, :created_at, :updated_at
json.url user_role_url(user_role, format: :json)
