class Role < ApplicationRecord
  has_many :permission_roles, class_name: "PermissionRole", foreign_key: :role_code, primary_key: :assigned_code
  has_many :user_roles, class_name: "UserRole", foreign_key: :role_code
  has_many :permissions, through: :permission_roles
  has_many :users, through: :user_roles

  validates :assigned_code, presence: true
  validates :role_name, presence: true, uniqueness: true

  def full_roles
    "#{role_name} (#{assigned_code})"
  end
  
  def set_permissions(permissions)
    permissions.each do |id|
      permission = Permission.find(id)
      self.permissions << permission
      case permission.subject_class
      when "Part"
        case permission.action
        when "create"
          self.permissions << Permission.where(subject_class: "Drawing", action: "create")
        when "update"
          self.permissions << Permission.where(subject_class: "Drawing", action: ["update", "destroy"])
        end
      end
    end
  end

end
