json.extract! payment_callback, :id, :trans_status, :nw_trans_id, :trans_ref, :trans_msg, :active_status, :del_status, :user_id, :created_at, :updated_at
json.url payment_callback_url(payment_callback, format: :json)
