class ActivitySubDivClass < ApplicationRecord
  self.table_name="activity_sub_div_class"
  self.primary_key = :id
  attr_accessor :class_one, :class_two, :class_three, :class_four, :class_five, :max_num_one, :max_num_two,
                :max_num_three, :max_num_four, :max_num_five, :act_group_one, :act_group_two, :act_group_three,
                :act_group_four, :act_group_five
  has_many :activity_sub_divs, class_name: 'ActivitySubDiv', foreign_key: :classification
  belongs_to :entity_division, class_name: 'EntityDivision', foreign_key: :entity_div_code
  belongs_to :activity_group, class_name: 'ActivityGroup', foreign_key: :activity_group_code

  validates :entity_div_code, presence: {message: " cannot be empty."}
  validates :class_desc, presence: {message: " cannot be empty."}
  validates :activity_group_code, presence: {message: " cannot be empty."}


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



    if (class_instans.class_one.present? && class_instans.act_group_one.present?) || (class_instans.class_two.present? && class_instans.act_group_two.present?) || (class_instans.class_three.present? && class_instans.act_group_three.present?) || (class_instans.class_four.present? && class_instans.act_group_four.present?) || (class_instans.class_five.present? && class_instans.act_group_five.present?)
      validity_result = true
    end
    validity_result
  end

  def self.save_classes(class_instans)

    if class_instans.class_one.present? && class_instans.act_group_one.present?
      max_num = class_instans.max_num_one.present? ? class_instans.max_num_one : 0
      @save_class1 = ActivitySubDivClass.new(entity_div_code: class_instans.entity_div_code, activity_group_code: class_instans.act_group_one,
                                             class_desc: class_instans.class_one, max_num: max_num, active_status: true,
                                             del_status: false)
      @save_class1.save(validate: false)
    end
    if class_instans.class_two.present? && class_instans.act_group_two.present?
      max_num = class_instans.max_num_two.present? ? class_instans.max_num_two : 0
      @save_class2 = ActivitySubDivClass.new(entity_div_code: class_instans.entity_div_code, activity_group_code: class_instans.act_group_two,
                                             class_desc: class_instans.class_two, max_num: max_num, active_status: true,
                                             del_status: false)
      @save_class2.save(validate: false)
    end
    if class_instans.class_three.present? && class_instans.act_group_three.present?
      max_num = class_instans.max_num_three.present? ? class_instans.max_num_three : 0
      @save_class3 = ActivitySubDivClass.new(entity_div_code: class_instans.entity_div_code, activity_group_code: class_instans.act_group_three,
                                             class_desc: class_instans.class_three, max_num: max_num, active_status: true,
                                             del_status: false)
      @save_class3.save(validate: false)
    end
    if class_instans.class_four.present? && class_instans.act_group_four.present?
      max_num = class_instans.max_num_four.present? ? class_instans.max_num_four : 0
      @save_class4 = ActivitySubDivClass.new(entity_div_code: class_instans.entity_div_code, activity_group_code: class_instans.act_group_four,
                                             class_desc: class_instans.class_four, max_num: max_num, active_status: true,
                                             del_status: false)
      @save_class4.save(validate: false)
    end
    if class_instans.class_five.present? && class_instans.act_group_five.present?
      max_num = class_instans.max_num_five.present? ? class_instans.max_num_five : 0
      @save_class5 = ActivitySubDivClass.new(entity_div_code: class_instans.entity_div_code, activity_group_code: class_instans.act_group_five,
                                             class_desc: class_instans.class_five, max_num: max_num, active_status: true,
                                             del_status: false)
      @save_class5.save(validate: false)
    end
  end




end
