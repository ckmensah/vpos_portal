class EntityCategory < ApplicationRecord
  validates_uniqueness_of :category_name
  has_many :entity_infos, class_name: 'EntityInfo', foreign_key: :entity_cat_id

  validates :assigned_code, presence: {message: "Assigned code cannot be empty."}
  validates :category_name, presence: {message: "Category name cannot be empty."}


  def entity_cat_name_join
    "#{category_name} (#{assigned_code})"
  end

end
