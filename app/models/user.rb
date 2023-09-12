class User < ApplicationRecord
  attr_accessor :for_role_code, :for_the_portal, :for_division_code,
                :for_creator_id, :for_show_charge, :for_entity_code, :for_entity_code_multi
  validates_uniqueness_of :user_name
  CTRYCODE = "233"
  #has_many :entity_, class_name: 'ActivitySubDivClass', foreign_key: :entity_div_code
  has_many :user_roles, -> { where active_status: true }, class_name: "UserRole", foreign_key: :user_id
  has_many :multi_user_roles, -> { where active_status: true }, class_name: "MultiUserRole", foreign_key: :user_id
  # has_many :multi_service_roles, -> { where active_status: true }, class_name: "MultiServiceRole", foreign_key: :user_id
  #belongs_to :role, class_name: "Role", foreign_key: :role_id
  #belongs_to :entity_info, -> { where active_status: true }, class_name: "EntityInfo", foreign_key: :entity_code
  belongs_to :entity_division, -> { where active_status: true }, class_name: "EntityDivision", foreign_key: :division_code
  has_many :roles, through: :user_roles, primary_key: :assigned_code
  has_many :multi_users, through: :multi_user_roles, primary_key: :assigned_code
  has_many :entity_infos, through: :user_roles, primary_key: :assigned_code
  has_many :client_webhook_configs, class_name: "ClientWebhookConfig", foreign_key: :user_id

  #default_scope {where(active_status: true, for_portal: true)}
  default_scope {user_roles_join.where("users.active_status = true AND user_roles.del_status = false AND user_roles.for_portal = true")}

  validates :user_name, presence: {message: " cannot be empty."} #, uniqueness: {scope: :entity_id, message: "Momo Number has already been set up." }
  validates :last_name, presence: {message: " cannot be empty."}
  validates :first_name, presence: {message: " cannot be empty."}
  #validates :entity_code, presence: {message: " cannot be empty."}
  #validates :division_code, presence: {message: " cannot be empty."}
  #validates :assigned_no, presence: {message: "Momo Number cannot be empty."}, :if => :assigned_no_valid#, uniqueness: {scope: :entity_id, message: "Mobile Money Number has already been set up." }, :if => :assigned_no_valid
  validates :contact_number, presence: {message: " cannot be empty."}, numericality: {message: " accepts only positive numbers."}
  validates :email, presence: {message: " cannot be empty."}
  #validates :role_id, presence: {message: "Please choose a role"}
  validates :for_role_code, presence: {message: "Please choose a role"}

  validate :validate_division_code #, :if => :skip_update_validation
  validate :validate_entity_code #, :if => :skip_update_validation


  def mobile_number_validation
    mobile_num = EntityAdminWhitelist.break_number(self.mobile_number)
    logger.info "Mobile Number is #{mobile_num.inspect}"
    if EntityAdminWhitelist.is_number?(mobile_num) && mobile_num.length == 12
      entity_admin = EntityAdminWhitelist.where(active_status: true, del_status: false, mobile_number: mobile_num,
                                                entity_division_code: self.entity_division_code).
          order(created_at: :desc).first
      unless entity_admin
        errors.add :mobile_number, " already in existence for this service."
      end
    else
      errors.add :mobile_number, " is incorrect."
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


  def validate_division_code
    if self.for_role_code == "MS" || self.for_role_code == "TV"
      unless self.for_division_code.present?
        errors.add :for_division_code, " cannot be empty."
      end
    end
  end


  def validate_entity_code
    if self.for_role_code == "MA" || self.for_role_code == "MS" || self.for_role_code == "TV"
      unless self.for_entity_code.present? #|| self.for_entity_code_multi.present?
        errors.add :for_entity_code, " cannot be empty." if :for_entity_code.present?
      end
    elsif self.for_role_code == "MMA"
      unless self.for_entity_code_multi.present?
        errors.add :for_entity_code_multi, " cannot be empty."
      end
    # elsif self.for_role_code == "MSA"
    #   unless self.for_entity_code_multi.present?
    #     errors.add :for_entity_code_multi, " cannot be empty."
    #   end
     end
  end


  def user_fullname
    "#{last_name} #{first_name} (#{user_name})"
  end

  def last_name=(value)
    self[:last_name] = value.to_s.strip.capitalize
  end

  def first_name=(value)
    self[:first_name] = value.to_s.strip.capitalize
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable


  #############################################################################
  ########################### USER ROLES ######################################
  #############################################################################

  def self.user_roles_join
    joins("LEFT JOIN user_roles ON users.id = user_roles.user_id")
  end

  def self.multi_user_roles_join
    joins("LEFT JOIN multi_user_roles ON users.id = multi_user_roles.user_id")
    # joins("LEFT JOIN multi_user_roles ON user_roles.user_id = multi_user_roles.user_id")
  end

  def super_admin?
    #logger.info "I was here ================== 1"
    self.roles.first.assigned_code == "SA" if self.roles.first
  end

  def super_user?
    self.roles.first.assigned_code == "SU" if self.roles.first
  end

  def merchant_admin?
    self.roles.first.assigned_code == "MA" if self.roles.first
  end

  def multi_merchant_admin?
    self.roles.first.assigned_code == "MMA" if self.roles.first
  end

  def merchant_service?
    self.roles.first.assigned_code == "MS" if self.roles.first
  end

  def validator?
    self.roles.first.assigned_code == "TV" if self.roles.first
  end



  #############################################################################
  ########################### EXTRA USER VALUES ###############################
  #############################################################################

  def user_entity_code
    user_role_obj = self.user_roles&.order(created_at: :desc).first
    user_role_obj ? user_role_obj.entity_code : ""
  end

  def multi_user_entity_code
    entity_code_arr =[]
    user_role_obj = self.multi_user_roles&.order(created_at: :desc)
    if user_role_obj.present?
      user_role_obj.each do |code|
        entity_code_arr << "'#{code}'"
      end
    end
    entity_code_arr
    p "#{entity_code_arr}"
  end

  def multi_user_service_code
    service_code_arr =[]
    user_role_obj = self.multi_service_roles&.order(created_at: :desc)
    if user_role_obj.present?
      user_role_obj.each do |code|
        service_code_arr << "'#{code}'"
      end
    end
    service_code_arr
    p "#{service_code_arr}"
  end

  def user_division_code
    user_role_obj = self.user_roles&.order(created_at: :desc).first
    user_role_obj ? user_role_obj.division_code : ""
  end

  def user_show_charge
    user_role_obj = self.user_roles&.order(created_at: :desc).first
    user_role_obj ? user_role_obj.show_charge : nil
  end

  def user_creator_id
    user_role_obj = self.user_roles&.order(created_at: :desc).first
    user_role_obj ? user_role_obj.creator_id : ""
  end

  def user_for_portal
    user_role_obj = self.user_roles&.order(created_at: :desc).first
    user_role_obj ? user_role_obj.for_portal : nil
  end

  def user_role_code
    user_role_obj = self.user_roles&.order(created_at: :desc).first
    user_role_obj ? user_role_obj.role_code : nil
  end



end
