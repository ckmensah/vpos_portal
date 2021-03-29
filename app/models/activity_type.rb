class ActivityType < ApplicationRecord
  self.table_name="activity_type"
  self.primary_key = :assigned_code
  validates_uniqueness_of :assigned_code

  has_many :entity_divisions, class_name: 'EntityDivision', foreign_key: :activity_type_code

  validates :assigned_code, presence: {message: " cannot be empty."}
  validates :activity_type_desc, presence: {message: " cannot be empty."}

  def activity_name
    "#{activity_type_desc} (#{assigned_code})"
  end

end
