class ActivityGroup < ApplicationRecord
  self.primary_key = :assigned_code
  has_many :activity_sub_div_classes, class_name: 'ActivitySubDivClass', foreign_key: :activity_group_code

  validates :assigned_code, presence: {message: " cannot be empty."}
  validates :activity_group_desc, presence: {message: " cannot be empty."}

  def full_group_name
    "#{activity_group_desc} (#{assigned_code})"
  end
  
end
