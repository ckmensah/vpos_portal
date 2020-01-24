class PaymentRequest < ApplicationRecord
  self.table_name="payment_request"
  has_many :payment_callbacks, class_name: 'PaymentCallback', foreign_key: :trans_ref, primary_key: :processing_id

  belongs_to :payment_info, class_name: 'PaymentInfo', foreign_key: :payment_info_id

end
