class RegionMaster < ApplicationRecord
  validates_uniqueness_of :region_name
  has_many :cities, class_name: 'CityTownMaster', foreign_key: :region_id
  validates :region_name, presence: {message: "Region name cannot be empty."}

  def region_name=(value)
    self[:region_name] = value.to_s.strip.capitalize
  end

end
