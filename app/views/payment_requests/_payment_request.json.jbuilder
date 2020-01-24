json.extract! payment_request, :id, :payment_info_id, :processing_id, :customer_number, :nw, :trans_type, :amount, :service_id, :payment_mode, :reference, :processed, :active_status, :del_status, :user_id, :created_at, :updated_at
json.url payment_request_url(payment_request, format: :json)
