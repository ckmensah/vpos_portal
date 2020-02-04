class ActivityParticipant < ApplicationRecord
  self.table_name="activity_participant"
  self.primary_key = :assigned_code
  #include ImageUploader[:image]

  has_many :activity_fixtures, class_name: 'ActivityFixture', foreign_key: :activity_participant_a
  has_many :activity_fixtures, class_name: 'ActivityFixture', foreign_key: :activity_participant_b
  belongs_to :entity_division, class_name: 'EntityDivision', foreign_key: :division_code

  validates :division_code, presence: {message: " cannot be empty."}
  validates :participant_name, presence: {message: " cannot be empty."}
  validates :participant_alias, presence: {message: " cannot be empty."}
  validates :image_data, presence: {message: " cannot be empty."}
  validates :image_path, presence: {message: " cannot be empty."}



end
