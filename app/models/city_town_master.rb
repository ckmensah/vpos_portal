class CityTownMaster < ApplicationRecord
  # attr_accessor :region_name
  validates_uniqueness_of :city_town_name
  has_many :suburb_masters, class_name: 'SuburbMaster', foreign_key: :city_town_id
  belongs_to :a_region, class_name: 'RegionMaster', foreign_key: :region_id
  validates :city_town_name, presence: {message: " cannot be empty."}
  validates :region_id, presence: {message: " must be chosen."}

  def city_town_name=(value)
    self[:city_town_name] = value.to_s.strip.capitalize
  end

end
