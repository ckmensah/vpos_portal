class MultiUserRole < ApplicationRecord
  belongs_to :user, -> { where active_status: true }, class_name: "User", foreign_key: :user_id
  belongs_to :role, -> { where active_status: true }, class_name: "Role", foreign_key: :role_code, primary_key: :assigned_code
  belongs_to :user_roles, -> { where active_status: true }, class_name: "UserRole", foreign_key: :user_id
  belongs_to :entity_info, -> { where active_status: true }, class_name: "EntityInfo", foreign_key: :entity_code, primary_key: :assigned_code

end
