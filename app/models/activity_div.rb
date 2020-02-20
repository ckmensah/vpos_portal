class ActivityDiv < ApplicationRecord

  attr_accessor :sport_type, :sport_category, :category_type
  belongs_to :entity_division, class_name: 'EntityDivision', foreign_key: :division_code
  belongs_to :activity_fixture, class_name: 'ActivityFixture', foreign_key: :activity_fixture_id
  has_many :activity_sub_div, class_name: 'ActivitySubDiv', foreign_key: :activity_div_id


  validates :division_code, presence: {message: " cannot be empty."}
  validates :activity_div_desc, presence: {message: " cannot be empty."}
  validates :activity_date, presence: {message: " cannot be empty."}
  #validates :activity_fixture_id, presence: {message: " cannot be empty."}

end

