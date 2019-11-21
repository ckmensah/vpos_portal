class EntityWalletConfig < ApplicationRecord

  belongs_to :entity_division, class_name: 'EntityDivision', foreign_key: :division_code, primary_key: :assigned_code

  validates :division_code, presence: true
  validates :service_id, presence: {message: " cannot be empty."}
  validates :secret_key, presence: {message: " cannot be empty."}
  validates :client_key, presence: {message: " cannot be empty."}

end
