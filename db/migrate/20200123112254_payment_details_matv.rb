class PaymentDetailsMatv < ActiveRecord::Migration[5.2]

  def up
    self.connection.execute %Q( CREATE MATERIALIZED VIEW payment_details_matv AS
        SELECT
       payment_info.id,
       session_id,
       entity_div_code,
       activity_lov_id,
       payment_info.activity_div_id,
       activity_sub_div_id,
       activity_main_code,
       paid_by,
       payment_info.processed,
       src,
       payment_info.created_at AS date,
       payment_info.payment_mode,
       payment_info.amount,
       payment_info.customer_number,
       payment_info.recipient_number,
       payment_info.recipient_type,
       payment_info.trans_type,
       charge,
        entity_division.assigned_code,
        entity_division.division_name,
        entity_division.division_alias,
        entity_division.suburb_id,
        entity_division.activity_type_code,
        entity_division.service_label,
        entity_division.allow_qr,
        division_activity_lov.activity_code,
        division_activity_lov.lov_desc,
        activity_divs.activity_fixture_id,
        activity_divs.activity_date,
        activity_divs.activity_div_desc,
        activity_sub_divs.activity_time,
        activity_sub_divs.classification,
        activity_sub_divs.amount AS amt

       FROM payment_info


       LEFT JOIN entity_division ON payment_info.entity_div_code = entity_division.assigned_code and entity_division.active_status = true and entity_division.del_status = false
       LEFT JOIN division_activity_lov ON entity_division.assigned_code = division_activity_lov.division_code and division_activity_lov.active_status = true and division_activity_lov.del_status = false
       LEFT JOIN activity_divs ON activity_divs.division_code = entity_division.assigned_code and activity_divs.active_status = true and activity_divs.del_status = false
       LEFT JOIN activity_sub_divs ON activity_sub_divs.activity_div_id = activity_divs.id;
     )

    #(division_activity_lov.active_status = true and division_activity_lov.del_status = false)
    #and (activity_divs.active_status = true and activity_divs.del_status = false)
    #and (activity_sub_divs.active_status = true and activity_sub_divs.del_status = false)
    # LEFT JOIN entity_division ON payment_info.entity_div_code = entity_division.assigned_code and entity_division.active_status = true and entity_division.del_status = false
    #       LEFT JOIN division_activity_lov ON payment_info.activity_lov_id = division_activity_lov.id and division_activity_lov.active_status = true and division_activity_lov.del_status = false
    #       LEFT JOIN activity_divs ON payment_info.activity_div_id = activity_divs.id and activity_divs.active_status = true and activity_divs.del_status = false
    #       LEFT JOIN activity_sub_divs ON payment_info.activity_sub_div_id = activity_sub_divs.id and activity_sub_divs.active_status = true and activity_sub_divs.del_status = false;

  end


  def down
    self.connection.execute "DROP MATERIALIZED VIEW IF EXISTS payment_details_matv;"
  end

end
