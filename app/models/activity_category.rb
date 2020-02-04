class ActivityCategory < ApplicationRecord
  self.table_name="activity_category"
  self.primary_key = :id
  include ImageUploader[:image]

  has_many :activity_category_div, class_name: 'ActivityCategoryDiv', foreign_key: :activity_div_cat_id

  validates :assigned_code, presence: {message: " cannot be empty."}
  validates :activity_cat_desc, presence: {message: " cannot be empty."}
  validates :image_data, presence: {message: " cannot be empty."}
  validates :image_path, presence: {message: " cannot be empty."}

end
