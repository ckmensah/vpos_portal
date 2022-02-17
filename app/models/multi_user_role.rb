class MultiUserRole < ApplicationRecord
  belongs_to :user_id, -> { where active_status: true }, class_name: "User", foreign_key: :user_id
  belongs_to :role_code, -> { where active_status: true }, class_name: "Role", foreign_key: :role_code, primary_key: :assigned_code
  belongs_to :entity_code, -> { where active_status: true }, class_name: "EntityInfo", foreign_key: :entity_code, primary_key: :assigned_code

end
