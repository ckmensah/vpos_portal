class PaymentDetailsMatv < ApplicationRecord
  self.table_name="payment_details_matv"
  self.primary_key = "id"

  #has_many :payment_requests, class_name: 'PaymentRequest', foreign_key: :payment_info_id
  #belongs_to :entity_division, class_name: 'EntityDivision', foreign_key: :entity_div_code

end
