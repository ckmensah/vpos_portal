class ActivitySubDivClass < ApplicationRecord
  self.table_name="activity_sub_div_class"
  self.primary_key = :id
  attr_accessor :class_one, :class_two, :class_three, :class_four, :class_five
  has_many :activity_sub_div, class_name: 'ActivitySubDiv', foreign_key: :classification
  belongs_to :entity_division, class_name: 'EntityDivision', foreign_key: :entity_div_code

  validates :entity_div_code, presence: {message: " cannot be empty."}
  validates :class_desc, presence: {message: " cannot be empty."}
  # validates :class_one, presence: {message: " cannot be empty."}
  # validates :class_two, presence: {message: " cannot be empty."}
  # validates :class_three, presence: {message: " cannot be empty."}
  # validates :class_four, presence: {message: " cannot be empty."}
  #validates :class_five, presence: {message: " cannot be empty."}


  def self.validate_classes(class_instans)
    validity_result = false
    #list_of_avail_classes = []
    #@act_sub_div_class = ActivitySubDivClass.where(entity_div_code: class_instans.entity_div_code)
    #if @act_sub_div_class.exists?
    #  @act_sub_div_class.each_with_index do |act_sub_div_class, ind|
    #    logger.info "List of Sub Div Class:: #{act_sub_div_class.inspect}"
    #    list_of_avail_classes << act_sub_div_class.class_desc
    #  end
    #end



    if class_instans.class_one.present? || class_instans.class_two.present? || class_instans.class_three.present? || class_instans.class_four.present? || class_instans.class_five.present?
      validity_result = true
    end
    validity_result
  end

  def self.save_classes(class_instans)
    if class_instans.class_one.present?
      @save_class1 = ActivitySubDivClass.new(entity_div_code: class_instans.entity_div_code, class_desc: class_instans.class_one, active_status: true, del_status: false)
      @save_class1.save(validate: false)
    end
    if class_instans.class_two.present?
      @save_class2 = ActivitySubDivClass.new(entity_div_code: class_instans.entity_div_code, class_desc: class_instans.class_two, active_status: true, del_status: false)
      @save_class2.save(validate: false)
    end
    if class_instans.class_three.present?
      @save_class3 = ActivitySubDivClass.new(entity_div_code: class_instans.entity_div_code, class_desc: class_instans.class_three, active_status: true, del_status: false)
      @save_class3.save(validate: false)
    end
    if class_instans.class_four.present?
      @save_class4 = ActivitySubDivClass.new(entity_div_code: class_instans.entity_div_code, class_desc: class_instans.class_four, active_status: true, del_status: false)
      @save_class4.save(validate: false)
    end
    if class_instans.class_five.present?
      @save_class5 = ActivitySubDivClass.new(entity_div_code: class_instans.entity_div_code, class_desc: class_instans.class_five, active_status: true, del_status: false)
      @save_class5.save(validate: false)
    end
  end




end
