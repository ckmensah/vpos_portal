class AssignedServiceCode < ApplicationRecord
  self.table_name="assigned_service_code"
  self.primary_key = :id
  belongs_to :entity_division, class_name: 'EntityDivision', foreign_key: :entity_div_code

  validates :entity_div_code, presence: {message: " cannot be empty."}
  validates :service_code, presence: {message: " cannot be empty."}, format: { with: /\A\d+\z/, message: "must be numbers only." }

end
