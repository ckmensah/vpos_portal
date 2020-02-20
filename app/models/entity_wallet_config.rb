class EntityWalletConfig < ApplicationRecord
  # self.primary_key = :id
  belongs_to :entity_info, class_name: 'EntityInfo', foreign_key: :entity_code, primary_key: :assigned_code
  belongs_to :activity_type, class_name: 'ActivityType', foreign_key: :activity_type_code, primary_key: :assigned_code
  belongs_to :entity_division, class_name: 'EntityDivision', foreign_key: :division_code #, primary_key: :id

  validates :entity_code, presence: true
  validates :activity_type_code, presence: {message: " cannot be empty."}
  validates :service_id, presence: {message: " cannot be empty."}, format: { with: /\A\d+\z/, message: "must be numbers only." }#, uniqueness: {message: " exists already" }
  validates :secret_key, presence: {message: " cannot be empty."}#, uniqueness: {message: " exists already" }
  validates :client_key, presence: {message: " cannot be empty."}#, uniqueness: {message: " exists already" }

  #validate :activity_type_validity



  def activity_type_validity

    unless self.division_code.present?
      unless self.activity_type_code.present?
        logger.info "Existing Service Code Error ........................................................................."
        errors.add :activity_type_code, " cannot be empty."
      end
    end
  end




end
