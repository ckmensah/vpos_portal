class EntityServiceAccountTrxn < ApplicationRecord
  self.table_name="entity_service_account_trxn"
  self.primary_key = "processing_id"

  belongs_to :entity_division, class_name: "EntityDivision", foreign_key: :entity_div_code

end
