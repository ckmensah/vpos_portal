class PaymentReport < ApplicationRecord
  self.table_name="payment_reports"
  self.primary_key = "id"
  has_many :payment_requests, class_name: 'PaymentRequest', foreign_key: :payment_info_id
  belongs_to :entity_division, -> { where active_status: true}, class_name: 'EntityDivision', foreign_key: :entity_div_code
  belongs_to :division_activity_lov, -> { where active_status: true}, class_name: 'DivisionActivityLov', foreign_key: :activity_lov_id


  def self.financial_join
    joins("LEFT JOIN entity_service_account_trxn ON entity_service_account_trxn.processing_id = payment_reports.processing_id").
        select("payment_reports.trans_type, to_char(payment_reports.created_at, 'YYYY-MM-DD') AS date,
 sum(CASE WHEN payment_reports.charge = 0.000 THEN payment_reports.amount - entity_service_account_trxn.charge
 ELSE payment_reports.amount - payment_reports.charge END) AS actual_amt, sum(amount) AS amount")
  end

  def self.wallet_join
    select"(trans_type, to_char(created_at, 'YYYY-MM-DD') AS date, sum((net_bal_aft - net_bal_bef)) AS amount) from entity_service_account_trxn"
  end


  def self.wallet_statement
    "select entity_div_code, coalesce(sum(case when trans_type in ('CTM','CNC') then net_bal_aft-net_bal_bef end), 0.00) credit_total,
coalesce(sum(case when trans_type in ('CTW', 'DNC', 'CTB') then net_bal_aft - net_bal_bef end), 0.00) debit_total,
to_char(created_at, 'YYYY-MM-DD') trans_date
from entity_service_account_trxn group by entity_div_code, trans_type, to_char(created_at, 'YYYY-MM-DD')
order by to_char(created_at, 'YYYY-MM-DD') asc"
  end

  def self.disbursement_join
    joins("UNION ALL SELECT id, session_id, entity_div_code, activity_lov_id, activity_div_id, activity_sub_div_id,
 activity_main_code, processed, src, created_at, payment_mode, amount, customer_number, customer_name, recipient_number,
 recipient_type, recipient_email, narration, qty, 'CSH' AS trans_type, NULL AS charge, NULL AS processing_id,
 NULL AS nw, NULL AS service_id, NULL AS reference, NULL AS trans_ref, NULL AS nw_trans_id, NULL AS trans_msg,
 NULL AS trans_status FROM payment_info")
  end

  def activity_main_code_narration
    narration.present? ? "#{activity_main_code} (#{narration})" : "#{activity_main_code}"
  end

  def act_main_code_narration_val
    narration.present? ? "#{activity_main_code} #{narration}" : "#{activity_main_code}"
  end



  def self.to_csv(general_report, current_user, for_activity_type, options = {})
    CSV.generate(options ='') do |csv|
      #headers = %w{Merchant Service Reference Selected_Option Activity_Type Mobile_No Name/Reference Network Tranx_ID Gross_Amount Charge Actual_Amount Source Status Payment_Description Date}
      #headers = %w{Merchant Service Service_Alias Extra_Ref Reference Selected_Option Activity_Type Mobile_No Name/Reference Network Tranx_ID Gross_Amount M-Charge C-Charge Actual_Amount Source Status Payment_Description Date}

      if current_user.super_admin? || current_user.super_user? || current_user.user_show_charge == true
        if current_user.merchant_service?
          service_for_header = EntityDivision.where(active_status: true, assigned_code: current_user.user_division_code).order(created_at: :desc).first
          if service_for_header && service_for_header.activity_type_code == "OMC"
            headers = %w{Merchant Service Station_Terminal_ID Attendant_ID/Reference Selected_Option Activity_Type Customer_No Network Tranx_ID Source Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date Time}
          elsif service_for_header && service_for_header.activity_type_code == "MOP"
            headers = %w{Merchant Service Selected_Option Activity_Type Payee Initiator Reference Network Tranx_ID Source Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date Time}
          elsif service_for_header && service_for_header.activity_type_code == "HSP"
            headers = %w{Merchant Service Selected_Option Activity_Type Payee Initiator Reference Network Trans_Type Payment_Mode Payment_Option Card_Option Tranx_ID Source Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date Time}
          elsif service_for_header && service_for_header.activity_type_code == "CHC"
            headers = %w{Merchant Service Reference Selected_Option Menu_Item Activity_Type Customer_No Name/Reference Network Tranx_ID Source Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date}
          elsif service_for_header && service_for_header.activity_type_code == "SHW" || service_for_header && service_for_header.activity_type_code == "SPO"
            headers = %w{Merchant Service Reference Selected_Option Customer_No Name/Reference Recipient_Email Ticket_Type Activity_Time Network Tranx_ID Source Quantity Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date}
          else
            headers = %w{Merchant Service Reference Selected_Option Customer_No Name/Reference Network Tranx_ID Source Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date}
          end
        else
          if for_activity_type == "OMC"
            headers = %w{Merchant Service Service_ID Station_Terminal_ID Attendant_ID/Reference Selected_Option Activity_Type Customer_No Network Tranx_ID Source Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date Time}
          elsif for_activity_type == "MOP"
            headers = %w{Merchant Service Service_ID Selected_Option Activity_Type Payee Initiator Reference Network Tranx_ID Source Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date Time}
          elsif for_activity_type == "HSP"
            headers = %w{Merchant Service Service_ID Selected_Option Activity_Type Payee Initiator Reference Network Trans_Type Payment_Mode Payment_Option Card_Option Tranx_ID Source Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date Time}
          elsif for_activity_type == "CHC"
            headers = %w{Merchant Service Service_ID Reference Selected_Option Menu_Item Activity_Type Customer_No Name/Reference Extra_Ref Network Tranx_ID Source Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date}
          elsif for_activity_type == "SHW" || for_activity_type == "SPO"
            headers = %w{Merchant Service Service_ID Reference Selected_Option Activity_Type Customer_No Name/Reference Recipient_Email Ticket_Type Activity_Time Extra_Ref Network Tranx_ID Source Quantity Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date}
          else
            headers = %w{Merchant Service Service_ID Reference Selected_Option Activity_Type Customer_No Name/Reference Extra_Ref Network Tranx_ID Source Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date}
          end
        end
      else
        if current_user.merchant_service?
          service_for_header = EntityDivision.where(active_status: true, assigned_code: current_user.user_division_code).order(created_at: :desc).first
          if service_for_header && service_for_header.activity_type_code == "OMC"
            headers = %w{Merchant Service Station_Terminal_ID Attendant_ID/Reference Selected_Option Activity_Type Customer_No Network Tranx_ID Source Net_Amount Status Payment_Description Date Time}
          elsif service_for_header && service_for_header.activity_type_code == "MOP"
            headers = %w{Merchant Service Selected_Option Activity_Type Payee Initiator Reference Network Tranx_ID Source Net_Amount Status Payment_Description Date Time}
          elsif service_for_header && service_for_header.activity_type_code == "HSP"
            headers = %w{Merchant Service Selected_Option Activity_Type Payee Initiator Reference Network Trans_Type Payment_Mode Payment_Option Card_Option Tranx_ID Source Net_Amount Status Payment_Description Date Time}
          elsif service_for_header && service_for_header.activity_type_code == "CHC"
            headers = %w{Merchant Service Reference Selected_Option Menu_Item Activity_Type Customer_No Name/Reference Network Tranx_ID Source Net_Amount Status Payment_Description Date}
          elsif service_for_header && service_for_header.activity_type_code == "SHW" || service_for_header && service_for_header.activity_type_code == "SPO"
            headers = %w{Merchant Service Reference Selected_Option Customer_No Name/Reference Recipient_Email Ticket_Type Activity_Time Network Tranx_ID Source Quantity Net_Amount Status Payment_Description Date}
          else
            headers = %w{Merchant Service Reference Selected_Option Customer_No Name/Reference Network Tranx_ID Source Net_Amount Status Payment_Description Date}
          end
        else
          if for_activity_type == "OMC"
            headers = %w{Merchant Service Station_Terminal_ID Attendant_ID/Reference Selected_Option Activity_Type Customer_No Network Tranx_ID Source Net_Amount Status Payment_Description Date Time}
          elsif for_activity_type == "MOP"
            headers = %w{Merchant Service Selected_Option Activity_Type Payee Initiator Reference Network Tranx_ID Source Net_Amount Status Payment_Description Date Time}
          elsif for_activity_type == "HSP"
            headers = %w{Merchant Service Selected_Option Activity_Type Payee Initiator Reference Network Trans_Type Payment_Mode Payment_Option Card_Option Tranx_ID Source Net_Amount Status Payment_Description Date Time}
          elsif for_activity_type == "CHC"
            headers = %w{Merchant Service Reference Selected_Option Menu_Item Activity_Type Customer_No Name/Reference Extra_Ref Network Tranx_ID Source Net_Amount Status Payment_Description Date}
          elsif for_activity_type == "SHW" || for_activity_type == "SPO"
            headers = %w{Merchant Service Reference Selected_Option Activity_Type Customer_No Name/Reference Recipient_Email Ticket_Type Activity_Time Extra_Ref Network Tranx_ID Source Quantity Net_Amount Status Payment_Description Date}
          else
            headers = %w{Merchant Service Reference Selected_Option Activity_Type Customer_No Name/Reference Extra_Ref Network Tranx_ID Source Net_Amount Status Payment_Description Date}
          end
        end
      end

      csv << headers
      actual_amt = 0.000
      for_gross_amt = 0.000
      general_report.each do |summary|
        # ------code comes here


        logger.info "General report :: #{summary.inspect}"
        ent_wallet_conf = EntityWalletConfig.where(active_status: true, division_code: summary.entity_div_code).order(created_at: :desc).first
        service_id = ent_wallet_conf ? ent_wallet_conf.service_id : ""

        entity_div = EntityDivision.where(active_status: true, assigned_code: summary.entity_div_code).order(created_at: :desc).first
        if entity_div
          service = entity_div.division_name
          service_alias = entity_div.division_alias
          extra_ref = entity_div.comment
          ent_info = EntityInfo.where(active_status: true, assigned_code: entity_div.entity_code).order(created_at: :desc).first
          if ent_info
            merchant = ent_info.entity_name
          else
            merchant = ""
          end
        else
          service = ""
          service_alias = ""
          extra_ref = ""
          merchant = ""
        end
        #merchant = (summary.entity_division != nil && summary.entity_division.where(active_status: true).entity_info != nil) ? summary.entity_division.entity_info.entity_name : ""
        #service = summary.entity_division ? summary.entity_division.division_name : ""
        reference = summary.reference.present? ? summary.reference : ""
        lov_name = summary.division_activity_lov ? summary.division_activity_lov.lov_desc : ""
        menu_item = summary.activity_main_code.present? && summary.narration.present? ? "#{summary.activity_main_code} (#{summary.narration})" : summary.activity_main_code
        if summary.entity_division != nil && summary.entity_division.activity_type
          activity_type = summary.entity_division.activity_type.assigned_code == "OMC" ? "Filling Station" : summary.entity_division.activity_type.activity_type_desc
        else
          activity_type = ""
        end
        mobile_num = summary.customer_number
        recipient_no = summary.recipient_number
        customer_name = summary.customer_name
        narration = summary.narration.present? ? summary.narration : ""
        qty = summary.qty.present? ? summary.qty : 0
        src = summary.src.present? ? summary.src : ""
        recipient_email = summary.recipient_email.present? ? summary.recipient_email : ""
        network = summary.nw
        trans_type = summary.trans_type
        act_sub_div_obj = ActivitySubDiv.where(id: summary.activity_sub_div_id).first
        if act_sub_div_obj
          activity_time = act_sub_div_obj.activity_time.present? ? act_sub_div_obj.activity_time.strftime('%H:%M') : ""
          classification = act_sub_div_obj.classification.present? ? ActivitySubDivClass.where(id: act_sub_div_obj.classification).first : false
          ticket_type = classification ? classification.class_desc : ""
        else
          ticket_type = ""
          activity_time = ""
        end

        payment_mode = summary.payment_mode == "CSH" ? "CASH" : summary.payment_mode == "MOM" ? "Mobile Money": ""
        payment_option = summary.payment_option ? "Active" : "Inactive"
        card_option = if summary.card_option == "C"
                        "Card Holder"
                      else
                        summary.card_option == "N" ? "Non Card Holder" : ""
                      end
        transaction_id = summary.processing_id
        amount = summary.amount
        charge = 0.000
        m_charge = 0.000
        c_charge = 0.000
        total_amt = 0.000
        @merchant_service_trxn = EntityServiceAccountTrxn.where(entity_div_code: summary.entity_div_code, processing_id: summary.processing_id).order(created_at: :desc).first
        @assigned_fee = AssignedFee.where(entity_div_code: summary.entity_div_code).order(created_at: :desc).first

        #if @assigned_fee && @assigned_fee.charged_to == "M"
        if summary.charge != nil && summary.charge > 0 && @merchant_service_trxn && @merchant_service_trxn.charge != nil && @merchant_service_trxn.charge > 0
          m_charge = @merchant_service_trxn.charge
          c_charge = summary.charge
          charge = m_charge + c_charge
          actual_amt = summary.amount.to_f - charge.to_f
          for_gross_amt = summary.amount.to_f
        elsif summary.charge == 0.000
          if @merchant_service_trxn && @merchant_service_trxn.charge != nil
            charge = @merchant_service_trxn.charge
            m_charge = charge
            c_charge = summary.charge
            total_amt = summary.amount.to_f + @merchant_service_trxn.charge.to_f
            actual_amt = summary.amount.to_f - @merchant_service_trxn.charge.to_f
            for_gross_amt = summary.amount.to_f
          else
            total_amt = summary.amount.to_f
            actual_amt = 0.000
            for_gross_amt = 0.000
          end
        #elsif @assigned_fee && @assigned_fee.charged_to == "C"
        else
          if summary.charge != nil
            charge = summary.charge
            m_charge = @merchant_service_trxn && @merchant_service_trxn.charge != nil ? @merchant_service_trxn.charge : 0.00
            c_charge = charge
            total_amt = summary.amount.to_f + summary.charge.to_f
            actual_amt = summary.amount.to_f - summary.charge.to_f
            for_gross_amt = summary.amount.to_f #+ summary.charge.to_f
          else
            total_amt = summary.amount.to_f
            actual_amt = 0.000
            for_gross_amt = 0.000
          end
        end

        actual_amt = actual_amt.round(3)
        for_gross_amt = for_gross_amt.round(3)

        charge = charge.round(3)
        total_amt = total_amt.round(3)

        source = summary.src

        if source == "USSD"
          source = "USS"
        end

        #status = summary.trans_status.present? ? summary.trans_status.split("/") : "nil"
        #
        #if status[0] == "000"
        #  status = "Success"
        #elsif status == "nil"
        #  status = "Pending"
        #else
        #  status = "Failed"
        #end

        if summary.processed == true
          status = "Success"
        elsif summary.processed == false
          status = "Failed"
        else
          status = "Pending"
        end
        
        trans_msg = summary.trans_msg.present? ? summary.trans_msg : ""

        date = summary.created_at
        for_date = summary.created_at.strftime('%Y-%m-%d')
        for_time = summary.created_at.strftime('%H:%M:%S')

        #csv << [merchant, service, reference, lov_name, activity_type, mobile_num, customer_name, network, transaction_id, src, total_amt, charge, amount, source, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
        #csv << [merchant, service, reference, lov_name, activity_type, mobile_num, customer_name, network, transaction_id, src, for_gross_amt, charge, actual_amt, source, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
        #csv << [merchant, service, service_alias, extra_ref, reference, lov_name, activity_type, mobile_num, customer_name, network, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, source, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]

        if current_user.super_admin? || current_user.super_user? || current_user.user_show_charge == true
          if current_user.merchant_service?
            service_for_header = EntityDivision.where(active_status: true, assigned_code: current_user.user_division_code).order(created_at: :desc).first
            if service_for_header && service_for_header.activity_type_code == "OMC"
              csv << [merchant, service, extra_ref, customer_name, lov_name, activity_type, mobile_num, network, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            elsif service_for_header && service_for_header.activity_type_code == "MOP"
              csv << [merchant, service, lov_name, activity_type, mobile_num, recipient_no, narration, network, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            elsif service_for_header && service_for_header.activity_type_code == "HSP"
              csv << [merchant, service, lov_name, activity_type, mobile_num, recipient_no, narration, network, trans_type, payment_mode, payment_option, card_option, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            elsif service_for_header && service_for_header.activity_type_code == "CHC"
              csv << [merchant, service, reference, lov_name, menu_item, activity_type, mobile_num, customer_name, network, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            elsif service_for_header && service_for_header.activity_type_code == "SHW" || service_for_header && service_for_header.activity_type_code == "SPO"
              csv << [merchant, service, reference, lov_name, mobile_num, customer_name, recipient_email, ticket_type, activity_time, network, transaction_id, src, qty, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            else
              csv << [merchant, service, reference, lov_name, mobile_num, customer_name, network, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            end
          else
            if for_activity_type == "OMC"
              csv << [merchant, service, service_id, extra_ref, customer_name, lov_name, activity_type, mobile_num, network, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            elsif for_activity_type == "MOP"
              csv << [merchant, service, service_id, lov_name, activity_type, mobile_num, recipient_no, narration, network, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            elsif for_activity_type == "HSP"
              csv << [merchant, service, service_id, lov_name, activity_type, mobile_num, recipient_no, narration, network, trans_type, payment_mode, payment_option, card_option, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            elsif for_activity_type == "CHC"
              csv << [merchant, service, service_id, reference, lov_name, menu_item, activity_type, mobile_num, customer_name, extra_ref, network, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            elsif for_activity_type == "SHW" || for_activity_type == "SPO"
              csv << [merchant, service, service_id, reference, lov_name, activity_type, mobile_num, customer_name, recipient_email, ticket_type, activity_time, extra_ref, network, transaction_id, src, qty, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            else
              csv << [merchant, service, service_id, reference, lov_name, activity_type, mobile_num, customer_name, extra_ref, network, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            end
          end
        else
          if current_user.merchant_service?
            service_for_header = EntityDivision.where(active_status: true, assigned_code: current_user.user_division_code).order(created_at: :desc).first
            if service_for_header && service_for_header.activity_type_code == "OMC"
              csv << [merchant, service, extra_ref, customer_name, lov_name, activity_type, mobile_num, network, transaction_id, src, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            elsif service_for_header && service_for_header.activity_type_code == "MOP"
              csv << [merchant, service, lov_name, activity_type, mobile_num, recipient_no, narration, network, transaction_id, src, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            elsif service_for_header && service_for_header.activity_type_code == "HSP"
              csv << [merchant, service, lov_name, activity_type, mobile_num, recipient_no, narration, network, trans_type, payment_mode, payment_option, card_option, transaction_id, src, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            elsif service_for_header && service_for_header.activity_type_code == "CHC"
              csv << [merchant, service, reference, lov_name, menu_item, activity_type, mobile_num, customer_name, network, transaction_id, src, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            elsif service_for_header && service_for_header.activity_type_code == "SHW" || service_for_header && service_for_header.activity_type_code == "SPO"
              csv << [merchant, service, reference, lov_name, mobile_num, customer_name, recipient_email, ticket_type, activity_time, network, transaction_id, src, qty, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            else
              csv << [merchant, service, reference, lov_name, mobile_num, customer_name, network, transaction_id, src, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            end
          else
            if for_activity_type == "OMC"
              csv << [merchant, service, extra_ref, customer_name, lov_name, activity_type, mobile_num, network, transaction_id, src, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            elsif for_activity_type == "MOP"
              csv << [merchant, service, lov_name, activity_type, mobile_num, recipient_no, narration, network, transaction_id, src, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            elsif for_activity_type == "HSP"
              csv << [merchant, service, lov_name, activity_type, mobile_num, recipient_no, narration, network, trans_type, payment_mode, payment_option, card_option, transaction_id, src, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            elsif for_activity_type == "CHC"
              csv << [merchant, service, reference, lov_name, menu_item, activity_type, mobile_num, customer_name, extra_ref, network, transaction_id, src, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            elsif for_activity_type == "SHW" || for_activity_type == "SPO"
              csv << [merchant, service, reference, lov_name, activity_type, mobile_num, customer_name, recipient_email, ticket_type, activity_time, extra_ref, network, transaction_id, src, qty, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            else
              csv << [merchant, service, reference, lov_name, activity_type, mobile_num, customer_name, extra_ref, network, transaction_id, src, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            end
          end
        end

      end
    end

  end




  def self.to_finance_csv(payment_report, fund_movements, balance_bf, options = {})
    CSV.generate(options ='') do |csv|
      headers = %w{Value_Date Description Debit Credit Balance}
      balance = balance_bf
      csv << headers
      if payment_report.first
        payment_report.each_with_index do |pay_report, index|
          # ------code comes here

          logger.info "Payment report :: #{index + 1}. #{pay_report.inspect}"
          if fund_movements.first
            if index == 0
              fund_movements.each_with_index do |fund_movement, index1|
                logger.info "Fund Movement report :: #{index1 + 1}. of #{index + 1}. #{fund_movement.inspect}"
                if fund_movement.date.to_date < pay_report.date.to_date
                  date = fund_movement.date
                  narration = fund_movement.narration
                  debit_amt = fund_movement.amt
                  credit_amt = ""
                  balance = balance - debit_amt
                  csv << [date, narration, debit_amt, credit_amt, balance]
                end
              end
            else
              fund_movements.each_with_index do |fund_movement, index1|
                logger.info "Fund Movement report :: #{index1 + 1}. of #{index + 1}. #{fund_movement.inspect}"
                if fund_movement.date.to_date < pay_report.date.to_date && fund_movement.date.to_date >= payment_report[index - 1].date.to_date
                  date = fund_movement.date
                  narration = fund_movement.narration
                  debit_amt = fund_movement.amt
                  credit_amt = ""
                  balance = balance - debit_amt
                  csv << [date, narration, debit_amt, credit_amt, balance]
                end
              end
            end
          end

          date = pay_report.date
          narration = "Collections for #{pay_report.date.to_date.strftime("%B %d, %Y")}"
          debit_amt = ""
          credit_amt = pay_report.actual_amt
          balance = balance + credit_amt
          csv << [date, narration, debit_amt, credit_amt, balance]

          if fund_movements.first
            fund_movements.each_with_index do |fund_movement, index1|
              logger.info "Fund Movement report :: #{index1 + 1}. of #{index + 1}. #{fund_movement.inspect}"
              if payment_report.size.to_i == index + 1 && fund_movement.date.to_date >= pay_report.date.to_date
                date = fund_movement.date
                narration = fund_movement.narration
                debit_amt = fund_movement.amt
                credit_amt = ""
                balance = balance - debit_amt
                csv << [date, narration, debit_amt, credit_amt, balance]
              end
            end
          end
        end
      else
        if fund_movements.first
          fund_movements.each_with_index do |fund_movement, index1|
            logger.info "Fund Movement report :: #{index1 + 1}. #{fund_movement.inspect}"
            date = fund_movement.date
            narration = fund_movement.narration
            debit_amt = fund_movement.amt
            credit_amt = ""
            balance = balance - debit_amt
            csv << [date, narration, debit_amt, credit_amt, balance]
          end
        end
      end

    end

  end



  def self.balance_bf(payment_report_bbf, fund_movements_bbf, bbf = 0.000)
    balance = bbf
    debit_total = 0.000
    credit_total = 0.000
    if payment_report_bbf.first
      payment_report_bbf.each_with_index do |pay_report_bbf, index|
        # ------code comes here

        logger.info "Payment report bbf :: #{index + 1}. #{pay_report_bbf.inspect}"
        if fund_movements_bbf.first
          if index == 0
            fund_movements_bbf.each_with_index do |fund_movement_bbf, index1|
              logger.info "Fund Movement report bbf :: #{index1 + 1}. of #{index + 1}. #{fund_movement_bbf.inspect}"
              if fund_movement_bbf.date.to_date < pay_report_bbf.date.to_date
                debit_amt = fund_movement_bbf.amt.to_f
                debit_total = debit_total + debit_amt.to_f
                balance = balance - debit_amt
                logger.info "#{index1 + 1}. Current Balance on debit is :: #{balance.inspect}"
              end
            end
          else
            fund_movements_bbf.each_with_index do |fund_movement_bbf, index1|
              logger.info "Fund Movement report bbf1 :: #{index1 + 1}. of #{index + 1}. #{fund_movement_bbf.inspect}"
              if fund_movement_bbf.date.to_date < pay_report_bbf.date.to_date && fund_movement_bbf.date.to_date >= payment_report_bbf[index - 1].date.to_date
                debit_amt = fund_movement_bbf.amt.to_f
                debit_total = debit_total + debit_amt.to_f
                balance = balance - debit_amt
                logger.info "#{index1 + 1}. Current Balance on debit 1 is :: #{balance.inspect}"
              end
            end
          end
        end

        credit_amt = pay_report_bbf.actual_amt
        credit_total = credit_total + credit_amt.to_f
        balance = balance + credit_amt
        logger.info "#{index + 1}. Current Balance on credit is :: #{balance.inspect}"

        if fund_movements_bbf.first
          fund_movements_bbf.each_with_index do |fund_movement_bbf, index1|
            logger.info "Fund Movement report bbf :: #{index1 + 1}. of #{index + 1}. #{fund_movement_bbf.inspect}"
            if payment_report_bbf.size.to_i == index + 1 && fund_movement_bbf.date.to_date >= pay_report_bbf.date.to_date
              debit_amt = fund_movement_bbf.amt.to_f
              debit_total = debit_total + debit_amt.to_f
              balance = balance - debit_amt
              logger.info "#{index1 + 1}. Current Balance on debit 2 is :: #{balance.inspect}"
            end
          end
        end


      end
    else
      if fund_movements_bbf.first
        fund_movements_bbf.each_with_index do |fund_movement_bbf, index1|
          logger.info "Fund Movement report bbf 3 :: #{index1 + 1}. #{fund_movement_bbf.inspect}"
          debit_amt = fund_movement_bbf.amt.to_f
          debit_total = debit_total + debit_amt.to_f
          balance = balance - debit_amt
          logger.info "#{index1 + 1}. Current Balance on debit 3 is :: #{balance.inspect}"
        end
      end

    end

    logger.info "Balance :: #{balance.inspect}, Debit Total :: #{debit_total.inspect}, Credit Total :: #{credit_total.inspect}"
    return balance, debit_total, credit_total
  end




end
