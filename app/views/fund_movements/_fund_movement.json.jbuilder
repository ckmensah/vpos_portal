json.extract! fund_movement, :id, :entity_div_code, :service_id, :ref_id, :amount, :narration, :trans_type, :trans_status, :trans_desc, :processed, :created_at, :updated_at
json.url fund_movement_url(fund_movement, format: :json)
