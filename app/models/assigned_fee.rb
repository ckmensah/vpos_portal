class AssignedFee < ApplicationRecord
  #self.table_name="assigned_fee"
  self.primary_key = :id
  #validates_uniqueness_of :activity_type_desc, :assigned_code

  #has_many :entity_divisions, class_name: 'EntityDivision', foreign_key: :activity_type_code
  belongs_to :entity_division, class_name: 'EntityDivision', foreign_key: :entity_div_code

  validates :entity_div_code, presence: {message: " cannot be empty."}
  validates :trans_type, presence: {message: " cannot be empty."}
  validates :fee, presence: {message: " cannot be empty."}
  validates :flat_percent, presence: {message: " cannot be empty."}
  validates :cap, presence: {message: " cannot be empty."}
  validates :limit_capped, presence: {message: " cannot be empty."}
  validates :charged_to, presence: {message: " cannot be empty."}


end
