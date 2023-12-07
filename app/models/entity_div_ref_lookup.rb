class EntityDivRefLookup < ApplicationRecord
  self.table_name = :entity_div_ref_lookups
  self.primary_key = :id

  belongs_to :entity_division, -> { where active_status: true}, class_name: 'EntityDivision', foreign_key: :entity_div_code
  belongs_to :users, class_name: 'User', foreign_key: :user_id


  validates :pan, presence: true
  validates :entity_div_code, presence: true
  validates :name, presence: true
end
