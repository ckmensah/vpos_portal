class User < ApplicationRecord
  validates_uniqueness_of :user_name

  #has_many :entity_, class_name: 'ActivitySubDivClass', foreign_key: :entity_div_code
  belongs_to :role, class_name: "Role", foreign_key: :role_id
  belongs_to :entity_info, class_name: "EntityInfo", foreign_key: :entity_code
  belongs_to :entity_division, class_name: "EntityDivision", foreign_key: :division_code

  default_scope {where(active_status: true, for_portal: true)}

  validates :user_name, presence: {message: " cannot be empty."} #, uniqueness: {scope: :entity_id, message: "Momo Number has already been set up." }
  validates :last_name, presence: {message: " cannot be empty."}
  validates :first_name, presence: {message: " cannot be empty."}
  #validates :entity_code, presence: {message: " cannot be empty."}
  #validates :division_code, presence: {message: " cannot be empty."}
  #validates :assigned_no, presence: {message: "Momo Number cannot be empty."}, :if => :assigned_no_valid#, uniqueness: {scope: :entity_id, message: "Mobile Money Number has already been set up." }, :if => :assigned_no_valid
  validates :contact_number, presence: {message: " cannot be empty."}, numericality: {message: " accepts only positive numbers."}
  validates :email, presence: {message: " cannot be empty."}
  validates :role_id, presence: {message: "Please choose a role"}

  validate :validate_division_code #, :if => :skip_update_validation
  validate :validate_entity_code #, :if => :skip_update_validation



  def validate_division_code
    if self.role_id == 4 || self.role_id == 5
      unless self.division_code.present?
        errors.add :division_code, " cannot be empty."
      end
    end
  end


  def validate_entity_code
    if self.role_id == 3 || self.role_id == 4 || self.role_id == 5
      unless self.entity_code.present?
        errors.add :entity_code, " cannot be empty."
      end
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


  def super_admin?
    self.role.id == 1
  end

  def super_user?
    self.role.id == 2
  end

  def merchant_admin?
    self.role.id == 3
  end

  def merchant_service?
    self.role.id == 4
  end

  def validator?
    self.role.id == 5
  end


  #def merchant_user?
  #  self.role.id == 3
  #end
  #
  #def service_user?
  #  self.role.id == 4
  #end



end
