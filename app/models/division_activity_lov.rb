class DivisionActivityLov < ApplicationRecord
  self.table_name="division_activity_lov"
  belongs_to :entity_division, class_name: 'EntityDivision', foreign_key: :division_code

  validates :activity_code, presence: {message: " cannot be empty."}
  validates :division_code, presence: {message: " cannot be empty."}
end
