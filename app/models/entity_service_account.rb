class EntityServiceAccount < ApplicationRecord
  self.table_name="entity_service_account"
  self.primary_key = "id"

  belongs_to :entity_division, class_name: "EntityDivision", foreign_key: :entity_div_code



end
