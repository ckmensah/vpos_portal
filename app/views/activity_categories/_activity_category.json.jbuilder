json.extract! activity_category, :id, :assigned_code, :activity_cat_desc, :image_data, :image_path, :comment, :active_status, :del_status, :user_id, :created_at, :updated_at
json.url activity_category_url(activity_category, format: :json)
