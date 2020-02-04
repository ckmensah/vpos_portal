json.extract! activity_participant, :id, :assigned_code, :division_code, :participant_name, :participant_alias, :image_data, :image_path, :comment, :active_status, :del_status, :user_id, :created_at, :updated_at
json.url activity_participant_url(activity_participant, format: :json)
