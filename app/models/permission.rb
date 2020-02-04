class Permission < ApplicationRecord
  has_many :permission_roles, class_name: "PermissionRole", foreign_key: :permission_id
  has_many :roles, through: :permission_roles
end
