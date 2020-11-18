class ActivitySubDiv < ApplicationRecord
  belongs_to :activity_div, class_name: 'ActivityDiv', foreign_key: :activity_div_id
   belongs_to :activity_sub_div_class, class_name: 'ActivitySubDivClass', foreign_key: :classification

  validates :activity_div_id, presence: {message: " cannot be empty."}
  validates :activity_time, presence: {message: " cannot be empty."}
  validates :amount, presence: {message: " cannot be empty."}
  validates :classification, presence: {message: " cannot be empty."}

  def sub_activity_div
    classify_sub_div = ActivitySubDivClass.where(id: classification).first.class_desc
    "#{classify_sub_div} (#{activity_time.strftime('%H:%M:%S')} - GHC #{amount})"
  end


end
