json.extract! payment_info, :id, :session_id, :entity_div_code, :activity_lov_id, :activity_div_id, :activity_sub_div_id, :processed, :src, :payment_mode, :amount, :customer_number, :trans_type, :charge, :active_status, :del_status, :user_id, :created_at, :updated_at
json.url payment_info_url(payment_info, format: :json)
