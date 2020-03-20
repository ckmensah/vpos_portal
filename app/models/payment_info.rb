class PaymentInfo < ApplicationRecord
  self.table_name="payment_info"
  self.primary_key = :id
  attr_accessor :copy_email, :recipient_mail, :pay_id

  has_many :payment_requests, class_name: 'PaymentRequest', foreign_key: :payment_info_id
  belongs_to :entity_division, class_name: 'EntityDivision', foreign_key: :entity_div_code

  validates :pay_id, presence: true
  validates :recipient_mail, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :copy_email, format: { with: URI::MailTo::EMAIL_REGEXP }



  def self.payments_join
    joins("LEFT JOIN payment_request ON payment_info.id = payment_request.payment_info_id
 LEFT JOIN payment_callback ON payment_request.processing_id = payment_callback.trans_ref")
        .select("payment_info.id, session_id, entity_div_code, activity_lov_id, activity_div_id, activity_sub_div_id, payment_info.processed, src,
 payment_info.created_at, payment_info.payment_mode, payment_info.amount, payment_info.customer_number, payment_info.trans_type,
 charge, processing_id, nw, service_id, reference, trans_ref, nw_trans_id, trans_msg, trans_status")
  end


end
