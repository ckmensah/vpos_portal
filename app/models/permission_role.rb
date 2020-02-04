class PermissionRole < ApplicationRecord
  belongs_to :role, class_name: 'Role', foreign_key: :role_id
  belongs_to :permission, class_name: 'Permission', foreign_key: :permission_id
end
