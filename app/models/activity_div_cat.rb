class ActivityDivCat < ApplicationRecord
  self.table_name="activity_div_cat"
  self.primary_key = :id

  has_many :activity_category_div, class_name: 'ActivityCategoryDiv', foreign_key: :activity_cat_div_id
  belongs_to :entity_division, class_name: 'EntityDivision', foreign_key: :division_code

  validates :division_code, presence: {message: " cannot be empty."}
  validates :div_cat_desc, presence: {message: " cannot be empty."}

end
