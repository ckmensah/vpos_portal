class EntityDivSubActivity < ApplicationRecord
  self.table_name="entity_div_sub_activity"
  self.primary_key = :id

  belongs_to :sub_activity_master, class_name: "SubActivityMaster", foreign_key: :sub_activity_code
  belongs_to :entity_division, class_name: "EntityDivision", foreign_key: :entity_div_code

  validates :sub_activity_code, presence: {message: " cannot be empty."}
  validates :entity_div_code, presence: {message: " cannot be empty."}
  validates :div_sub_activity_desc, presence: {message: " cannot be empty."}

end
