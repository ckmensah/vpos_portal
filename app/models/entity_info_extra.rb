class EntityInfoExtra < ApplicationRecord
  self.table_name="entity_info_extra"
  belongs_to :entity_info, class_name: 'EntityInfo', foreign_key: :entity_code, primary_key: :assigned_code

  validates :contact_number, presence: {message: " cannot be empty"}, format: { with: /\A\d+\z/, message: "must be numbers only." }#, uniqueness: { message: "Momo Number has already been set up." } #numericality: { only_integer: {message: "Please enter only numbers"} }
  #validates :web_url, presence: {message: " cannot be empty."}
  validates :contact_email, presence: {message: " cannot be empty."}, format: { with: /(\A([a-z]*\s*)*\<*([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\>*\Z)/i, message: " format is invalid." }
  #validate :email_probably_valid
  validate :web_probably_valid

  def email_probably_valid
    valid = '[A-Za-z\d.+-]+' #Commonly encountered email address characters
    check1 = (self.contact_email =~ /#{valid}@#{valid}\.#{valid}/) == 0
    check2 = (self.contact_email =~ /#{valid}@#{valid}\.#{valid}\.#{valid}/) == 0
    if check1 || check2
    else
      errors.add :contact_email, " format is invalid."
    end

  end


  def web_probably_valid
    valid = '[A-Za-z\d.+-]+' #Commonly encountered email address characters
    check = (self.web_url =~ /#{valid}\.#{valid}/) == 0
    unless check
      errors.add :web_url, " format is invalid."
    end

  end


end
