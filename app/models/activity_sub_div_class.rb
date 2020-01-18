class ActivitySubDivClass < ApplicationRecord
  self.table_name="activity_sub_div_class"
  has_many :activity_sub_div, class_name: 'ActivitySubDiv', foreign_key: :classification
  belongs_to :entity_division, class_name: 'EntityDivision', foreign_key: :entity_div_code

  validates :entity_div_code, presence: {message: " cannot be empty."}
  validates :class_desc, presence: {message: " cannot be empty."}
end
