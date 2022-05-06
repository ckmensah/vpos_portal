json.extract! loan_request, :id, :full_name, :id_number, :ref_number, :location, :amount, :comment, :active_status, :del_status, :user_id, :created_at, :updated_at
json.url loan_request_url(loan_request, format: :json)
