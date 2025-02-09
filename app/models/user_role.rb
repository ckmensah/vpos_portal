class UserRole < ApplicationRecord
  belongs_to :role, -> { where active_status: true }, class_name: "Role", foreign_key: :role_code, primary_key: :assigned_code
  belongs_to :user, -> { where active_status: true }, class_name: "User", foreign_key: :user_id
  belongs_to :entity_info, -> { where active_status: true}, class_name: "EntityInfo", foreign_key: :entity_code, primary_key: :assigned_code, optional: true
  belongs_to :entity_division, -> { where active_status: true}, class_name: "EntityDivision", foreign_key: :division_code, primary_key: :assigned_code, optional: true
  has_many :multi_user_roles, -> { where active_status: true }, class_name: "MultiUserRole", foreign_key: :user_id, primary_key: :user_id

end
