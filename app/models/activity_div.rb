class ActivityDiv < ApplicationRecord
  CTRYCODE = "233"
  attr_accessor :sport_type, :sport_category, :category_type, :for_fixture, :activity_sub_plan_id, :recipient_number,
                :recipient_email, :amt, :entity_div_code, :src, :payment_mode, :nw, :qty, :customer_name, :ticket_valid

  belongs_to :entity_division, -> { where active_status: true }, class_name: 'EntityDivision', foreign_key: :division_code
  belongs_to :activity_fixture, class_name: 'ActivityFixture', foreign_key: :activity_fixture_id
  has_many :activity_sub_div, class_name: 'ActivitySubDiv', foreign_key: :activity_div_id


  validates :division_code, presence: {message: " cannot be empty."}
  validates :activity_div_desc, presence: {message: " cannot be empty."}
  validates :activity_date, presence: {message: " cannot be empty."}
  validates :activity_fixture_id, presence: {message: " cannot be empty."}, :if => :for_fixture


  validate :for_sport_type, :if => :for_fixture
  validate :for_sport_category, :if => :for_fixture
  validate :for_category_type, :if => :for_fixture

  validates :activity_sub_plan_id, presence: {message: " cannot be empty."} , :if => :ticket_valid
  #validates :recipient_number, presence: {message: " cannot be empty."} , :if => :ticket_valid
  validates :recipient_email, format: { with: URI::MailTo::EMAIL_REGEXP } , :if => :ticket_valid
  validates :amt, presence: {message: " cannot be empty."} , :if => :ticket_valid
  #validates :nw, presence: {message: " cannot be empty."} , :if => :ticket_valid
  validates :entity_div_code, presence: {message: " cannot be empty."} , :if => :ticket_valid
  validates :src, presence: {message: " cannot be empty."} , :if => :ticket_valid
  validates :payment_mode, presence: {message: " cannot be empty."} , :if => :ticket_valid
  validates :customer_name, presence: {message: " cannot be empty."} , :if => :ticket_valid
  validates :qty, presence: {message: " cannot be empty."} , :if => :ticket_valid
  validate :mobile_number_validation, if: :ticket_valid

  #validates :activity_fixture_id, presence: {message: " cannot be empty."}

  def mobile_number_validation
    mobile_num = ActivityDiv.break_number(self.recipient_number)
    logger.info "Mobile Number is #{mobile_num.inspect}"
    unless ActivityDiv.is_number?(mobile_num) && mobile_num.length == 12
      errors.add :recipient_number, " is incorrect."
    end
  end


  def self.break_number(mobile_number)
    wildcard_search = "#{mobile_number}"
    if wildcard_search[0..2]=='233' && wildcard_search.length==12
      wildcard_search=CTRYCODE+"#{wildcard_search[3..wildcard_search.length]}"
    elsif wildcard_search[0]=='0' && wildcard_search.length==10
      wildcard_search=CTRYCODE+"#{wildcard_search[1..wildcard_search.length]}"
    elsif wildcard_search[0]=='+' && wildcard_search[1..3]=='233'&& wildcard_search[4..wildcard_search.length].length==9
      wildcard_search=CTRYCODE+"#{wildcard_search[4..wildcard_search.length]}"
    elsif wildcard_search[0]!="+" && wildcard_search[0..2]!='233' && wildcard_search.length==9
      wildcard_search=CTRYCODE+"#{wildcard_search[0..wildcard_search.length]}"
    else
      #wildcard_search
    end
  end


  def self.is_number?(string)
    true if Float(string) rescue false
  end


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

