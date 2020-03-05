class PaymentReports < ActiveRecord::Migration[5.2]
  def up
    self.connection.execute %Q( CREATE MATERIALIZED VIEW payment_reports AS
        SELECT
       payment_info.id,
       session_id,
       entity_div_code,
       activity_lov_id,
       activity_div_id,
       activity_sub_div_id,
       activity_main_code,
       payment_info.processed,
       src,
       payment_info.created_at,
       payment_info.payment_mode,
       payment_info.amount,
       payment_info.customer_number,
       payment_info.customer_name,
       payment_info.recipient_number,
       payment_info.recipient_type,
       payment_info.recipient_email,
       payment_info.narration,
       payment_info.trans_type,
       charge, processing_id,
       nw,
       service_id,
       reference,
       trans_ref,
       nw_trans_id,
       trans_msg,
       trans_status

       FROM payment_info

       LEFT JOIN payment_request ON payment_info.id = payment_request.payment_info_id
       LEFT JOIN payment_callback ON payment_request.processing_id = payment_callback.trans_ref;
     )


  end

  def down
    self.connection.execute "DROP MATERIALIZED VIEW IF EXISTS payment_reports;"
  end
end
