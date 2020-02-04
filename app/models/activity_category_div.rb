class ActivityCategoryDiv < ApplicationRecord
  self.table_name="activity_category_div"
  self.primary_key = :id

  has_many :activity_fixtures, class_name: 'ActivityFixture', foreign_key: :activity_category_div_id
  belongs_to :entity_division, class_name: 'EntityDivision', foreign_key: :division_code
  belongs_to :activity_category, class_name: 'ActivityCategory', foreign_key: :activity_category_id
  belongs_to :activity_div_cat, class_name: 'ActivityDivCat', foreign_key: :activity_div_cat_id

  validates :division_code, presence: {message: " cannot be empty."}
  validates :activity_category_id, presence: {message: " cannot be empty."}
  validates :activity_div_cat_id, presence: {message: " cannot be empty."}
  validates :category_div_desc, presence: {message: " cannot be empty."}

end
