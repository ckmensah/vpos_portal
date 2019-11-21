class ActivityType < ApplicationRecord
  self.table_name="activity_type"
  self.primary_key = :assigned_code
  # validates_uniqueness_of :type_desc

  has_many :entity_divisions, class_name: 'EntityDivision', foreign_key: :activity_code

  validates :assigned_code, presence: {message: "Assigned code cannot be empty."}
  validates :activity_type_desc, presence: {message: "Type description cannot be empty."}

  def activity_name
    "#{activity_type_desc} (#{assigned_code})"
  end

end
