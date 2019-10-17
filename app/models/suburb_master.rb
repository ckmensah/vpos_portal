class SuburbMaster < ApplicationRecord
  attr_accessor :region_name #, :city_town_name
  validates_uniqueness_of :suburb_name
  # has_many :entity_divisions, class_name: 'EntityDivision', foreign_key: :suburb_id
  belongs_to :a_city, class_name: 'CityTownMaster', foreign_key: :city_town_id
  validates :suburb_name, presence: {message:  "Suburb name cannot be empty."}
  validates :city_town_id, presence: {message: "Please choose a City/Town."}
  validates :region_name, presence: {message: "Please choose a region."}

  def suburb_name=(value)
    self[:suburb_name] = value.to_s.strip.capitalize
  end

end
