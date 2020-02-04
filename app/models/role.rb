class Role < ApplicationRecord
  has_many :users, class_name: "User", foreign_key: :user_id
  has_many :permission_roles, class_name: "PermissionRole", foreign_key: :role_id
  has_many :permissions, through: :permission_roles
  # has_and_belongs_to_many :permissions, class_name: "Permission"

  validates :role_name, presence: true, uniqueness: true


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
