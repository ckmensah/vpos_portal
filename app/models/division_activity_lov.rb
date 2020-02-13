class DivisionActivityLov < ApplicationRecord
  self.table_name="division_activity_lov"
  self.primary_key = :id
  has_many :payment_reports, class_name: 'PaymentReport', foreign_key: :activity_lov_id
  belongs_to :entity_division, class_name: 'EntityDivision', foreign_key: :division_code

  validates :activity_code, presence: {message: " cannot be empty."}
  validates :division_code, presence: {message: " cannot be empty."}
end
