class SubActivityMaster < ApplicationRecord
  self.table_name="sub_activity_master"
  self.primary_key = :assigned_code
  validates_uniqueness_of :activity_desc, :assigned_code

  has_many :entity_div_sub_activities, class_name: "EntityDivSubActivity", foreign_key: :sub_activity_code

  validates :activity_desc, presence: {message: " cannot be empty."}
  validates :assigned_code, presence: {message: " cannot be empty."}

  def sub_activity_name
    "#{activity_desc} (#{assigned_code})"
  end

end
