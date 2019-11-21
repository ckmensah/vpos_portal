class EntityInfoExtra < ApplicationRecord
  self.table_name="entity_info_extra"
  belongs_to :entity_info, class_name: 'EntityInfo', foreign_key: :entity_code, primary_key: :assigned_code

  validates :contact_number, presence: {message: "Contact number cannot be empty"}, format: { with: /\A\d+\z/, message: "Numbers only." }#, uniqueness: { message: "Momo Number has already been set up." } #numericality: { only_integer: {message: "Please enter only numbers"} }
  validates :web_url, presence: {message: "Web url cannot be empty."}
  validates :contact_email, presence: {message: "Email cannot be empty."}
  validate :probably_valid

  def probably_valid
    valid = '[A-Za-z\d.+-]+' #Commonly encountered email address characters
    check = (self.contact_email =~ /#{valid}@#{valid}\.#{valid}/) == 0
    unless check
      errors.add :contact_email, "Email format is invalid."
    end

  end
end
