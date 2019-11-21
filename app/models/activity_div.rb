class ActivityDiv < ApplicationRecord

  belongs_to :entity_division, class_name: 'EntityDivision', foreign_key: :division_code
  has_many :activity_sub_div, class_name: 'ActivitySubDiv', foreign_key: :activity_div_id

  validates :division_code, presence: {message: " cannot be empty."}
  validates :activity_div_desc, presence: {message: " cannot be empty."}
  validates :activity_date, presence: {message: " cannot be empty."}

end
