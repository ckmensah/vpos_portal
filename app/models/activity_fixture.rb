class ActivityFixture < ApplicationRecord
  self.table_name="activity_fixture"
  self.primary_key = :id

  belongs_to :entity_division, class_name: 'EntityDivision', foreign_key: :division_code
  belongs_to :activity_category_div, class_name: 'ActivityCategoryDiv', foreign_key: :activity_category_div_id
  belongs_to :activity_participanta, class_name: 'ActivityParticipant', foreign_key: :activity_participant_a
  belongs_to :activity_participantb, class_name: 'ActivityParticipant', foreign_key: :activity_participant_b

  validates :division_code, presence: {message: " cannot be empty."}
  validates :activity_participant_a, presence: {message: " cannot be empty."}
  validates :activity_participant_b, presence: {message: " cannot be empty."}
  validates :activity_category_div_id, presence: {message: " cannot be empty."}

end
