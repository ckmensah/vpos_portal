class ActivitySubDiv < ApplicationRecord
  belongs_to :activity_div, class_name: 'ActivityDiv', foreign_key: :activity_div_id
  # belongs_to :activity_sub_div_class, class_name: 'ActivitySubDivClass', foreign_key: :classification

  validates :activity_div_id, presence: {message: "Activity division cannot be empty."}
  validates :activity_time, presence: {message: "Activity time cannot be empty."}
  validates :amount, presence: {message: "Amount cannot be empty."}
  validates :classification, presence: {message: "Classification cannot be empty."}


end
