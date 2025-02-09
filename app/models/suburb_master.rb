class SuburbMaster < ApplicationRecord
  attr_accessor :region_name #, :city_town_name
  validates_uniqueness_of :suburb_name
  has_many :entity_divisions, class_name: 'EntityDivision', foreign_key: :suburb_id, primary_key: :assigned_code
  belongs_to :a_city, class_name: 'CityTownMaster', foreign_key: :city_town_id
  validates :suburb_name, presence: {message:  " cannot be empty."}
  validates :city_town_id, presence: {message: " must be chosen."}
  validates :region_name, presence: {message: " must be chosen."}

  def suburb_name=(value)
    self[:suburb_name] = value.to_s.strip.capitalize
  end

end
