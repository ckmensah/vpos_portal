class EntityWalletConfig < ApplicationRecord
  # self.primary_key = :id
  belongs_to :entity_info, class_name: 'EntityInfo', foreign_key: :entity_code, primary_key: :assigned_code
  belongs_to :activity_type, class_name: 'ActivityType', foreign_key: :activity_type_code, primary_key: :assigned_code

  validates :entity_code, presence: true
  validates :activity_type_code, presence: {message: " cannot be empty."}
  validates :service_id, presence: {message: " cannot be empty."}, format: { with: /\A\d+\z/, message: "must be numbers only." }#, uniqueness: {message: " exists already" }
  validates :secret_key, presence: {message: " cannot be empty."}#, uniqueness: {message: " exists already" }
  validates :client_key, presence: {message: " cannot be empty."}#, uniqueness: {message: " exists already" }

end
