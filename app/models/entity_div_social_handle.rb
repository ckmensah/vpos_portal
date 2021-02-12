class EntityDivSocialHandle < ApplicationRecord
  self.table_name = "entity_div_social_handle"
  self.primary_key = :id
  belongs_to :entity_division, class_name: 'EntityDivision', foreign_key: :entity_div_code

  validates :assigned_code, presence: {message: " cannot be empty."}
  validates :handle, presence: {message: " cannot be empty."}
  validates :entity_div_code, presence: true
  def self.media_handle_desc(social_media_code)
    if social_media_code == "TWT"
      "Twitter"
    elsif social_media_code == "YTU"
      "Youtube"
    elsif social_media_code == "FBK"
      "Facebook"
    else
      ""
    end
  end



end
