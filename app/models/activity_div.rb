class ActivityDiv < ApplicationRecord

  attr_accessor :sport_type, :sport_category, :category_type, :for_fixture
  belongs_to :entity_division, class_name: 'EntityDivision', foreign_key: :division_code
  belongs_to :activity_fixture, class_name: 'ActivityFixture', foreign_key: :activity_fixture_id
  has_many :activity_sub_div, class_name: 'ActivitySubDiv', foreign_key: :activity_div_id


  validates :division_code, presence: {message: " cannot be empty."}
  validates :activity_div_desc, presence: {message: " cannot be empty."}
  validates :activity_date, presence: {message: " cannot be empty."}
  validates :activity_fixture_id, presence: {message: " cannot be empty."}


  validate :for_sport_type, :if => :for_fixture
  validate :for_sport_category, :if => :for_fixture
  validate :for_category_type, :if => :for_fixture

  #validates :activity_fixture_id, presence: {message: " cannot be empty."}


  def for_sport_type
    unless self.sport_type.present?
      logger.info "Existing Service Code Error ........................................................................."
      errors.add :sport_type, " cannot be empty."
    end
  end

  def for_sport_category
    unless self.sport_category.present?
      logger.info "Existing Service Code Error ........................................................................."
      errors.add :sport_category, " cannot be empty."
    end
  end

  def for_category_type
    unless self.category_type.present?
      logger.info "Existing Service Code Error ........................................................................."
      errors.add :category_type, " cannot be empty."
    end
  end



end

