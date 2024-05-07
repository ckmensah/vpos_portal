class PaymentInfoReportJob < ApplicationJob
  queue_as :urgent
  require 'csv'

  def perform(general_report, current_user, for_activity_type, options = {})
    CSV.generate(options ='') do |csv|
      if current_user.super_admin? || current_user.super_user? || current_user.user_show_charge == true
        if current_user.merchant_service?
          service_for_header = EntityDivision.where(active_status: true, assigned_code: current_user.user_division_code).order(created_at: :desc).first
          if service_for_header.present?
            case service_for_header.activity_type_code
            when "OMC"
            headers = %w{Merchant Service Station_Terminal_ID Attendant_ID/Reference Selected_Option Activity_Type Customer_No Network Tranx_ID Source Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date Time}
            when "MOP"
              headers = %w{Merchant Service Selected_Option Activity_Type Payee Initiator Reference Network Tranx_ID Source Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date Time}
            when "HSP"
              headers = %w{Merchant Service Selected_Option Activity_Type Payee Initiator Reference Network Trans_Type Payment_Mode Payment_Option Card_Option Tranx_ID Source Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date Time}
            when "CHC"
              headers = %w{Merchant Service Reference Selected_Option Menu_Item Activity_Type Customer_No Name/Reference Network Tranx_ID Source Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date}
            when "SHW" || "SPO"
              headers = %w{Merchant Service Reference Selected_Option Customer_No Name/Reference Recipient_Email Ticket_Type Activity_Time Network Tranx_ID Source Quantity Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date}
            when "PDD"
              headers = %w{Merchant Service Location Selected_Option Customer_No Name/Reference Network Tranx_ID Source Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date}
            else
              headers = %w{Merchant Service Reference Selected_Option Customer_No Name/Reference Network Tranx_ID Source Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date}
            end
          else
            headers = %w{Merchant Service Reference Selected_Option Customer_No Name/Reference Network Tranx_ID Source Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date}
          end
        else
          case for_activity_type
          when "OMC"
            headers = %w{Merchant Service Service_ID Station_Terminal_ID Attendant_ID/Reference Selected_Option Activity_Type Customer_No Network Tranx_ID Source Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date Time}
          when "MOP"
            headers = %w{Merchant Service Service_ID Selected_Option Activity_Type Payee Initiator Reference Network Tranx_ID Source Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date Time}
          when  "HSP"
            headers = %w{Merchant Service Service_ID Selected_Option Activity_Type Payee Initiator Reference Network Trans_Type Payment_Mode Payment_Option Card_Option Tranx_ID Source Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date Time}
          when "CHC"
            headers = %w{Merchant Service Service_ID Reference Selected_Option Menu_Item Activity_Type Customer_No Name/Reference Extra_Ref Network Tranx_ID Source Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date}
          when "SHW" || "SPO"
            headers = %w{Merchant Service Service_ID Reference Selected_Option Activity_Type Customer_No Name/Reference Recipient_Email Ticket_Type Activity_Time Extra_Ref Network Tranx_ID Source Quantity Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date}
          when "PDD"
            headers = %w{Merchant Service Service_ID Location Selected_Option Activity_Type Customer_No Name/Reference Extra_Ref Network Tranx_ID Source Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date}
          else
            headers = %w{Merchant Service Service_ID Reference Selected_Option Activity_Type Customer_No Name/Reference Extra_Ref Network Tranx_ID Source Gross_Amount M-Charge C-Charge Net_Amount Status Payment_Description Date}
          end
        end
      else
        if current_user.merchant_service?
          service_for_header = EntityDivision.where(active_status: true, assigned_code: current_user.user_division_code).order(created_at: :desc).first
          if service_for_header.present?
            case service_for_header.activity_type_code
            when "OMC"
              headers = %w{Merchant Service Station_Terminal_ID Attendant_ID/Reference Selected_Option Activity_Type Customer_No Network Tranx_ID Source Net_Amount Status Payment_Description Date Time}
            when "MOP"
              headers = %w{Merchant Service Selected_Option Activity_Type Payee Initiator Reference Network Tranx_ID Source Net_Amount Status Payment_Description Date Time}
            when "HSP"
              headers = %w{Merchant Service Selected_Option Activity_Type Payee Initiator Reference Network Trans_Type Payment_Mode Payment_Option Card_Option Tranx_ID Source Net_Amount Status Payment_Description Date Time}
            when "CHC"
              headers = %w{Merchant Service Reference Selected_Option Menu_Item Activity_Type Customer_No Name/Reference Network Tranx_ID Source Net_Amount Status Payment_Description Date}
            when "SHW" || "SPO"
              headers = %w{Merchant Service Reference Selected_Option Customer_No Name/Reference Recipient_Email Ticket_Type Activity_Time Network Tranx_ID Source Quantity Net_Amount Status Payment_Description Date}
            when "PDD"
              headers = %w{Merchant Service Location Selected_Option Customer_No Name/Reference Network Tranx_ID Source Net_Amount Status Payment_Description Date}
            else
              headers = %w{Merchant Service Reference Selected_Option Customer_No Name/Reference Network Tranx_ID Source Net_Amount Status Payment_Description Date}
            end
          else
            headers = %w{Merchant Service Reference Selected_Option Customer_No Name/Reference Network Tranx_ID Source Net_Amount Status Payment_Description Date}
          end

        else
          case for_activity_type
          when "OMC"
            headers = %w{Merchant Service Station_Terminal_ID Attendant_ID/Reference Selected_Option Activity_Type Customer_No Network Tranx_ID Source Net_Amount Status Payment_Description Date Time}
          when "MOP"
            headers = %w{Merchant Service Selected_Option Activity_Type Payee Initiator Reference Network Tranx_ID Source Net_Amount Status Payment_Description Date Time}
          when "HSP"
            headers = %w{Merchant Service Selected_Option Activity_Type Payee Initiator Reference Network Trans_Type Payment_Mode Payment_Option Card_Option Tranx_ID Source Net_Amount Status Payment_Description Date Time}
          when "CHC"
            headers = %w{Merchant Service Reference Selected_Option Menu_Item Activity_Type Customer_No Name/Reference Extra_Ref Network Tranx_ID Source Net_Amount Status Payment_Description Date}
          when "SHW" || "SPO"
            headers = %w{Merchant Service Reference Selected_Option Activity_Type Customer_No Name/Reference Recipient_Email Ticket_Type Activity_Time Extra_Ref Network Tranx_ID Source Quantity Net_Amount Status Payment_Description Date}
          when "PDD"
            headers = %w{Merchant Service Location Selected_Option Activity_Type Customer_No Name/Reference Extra_Ref Network Tranx_ID Source Net_Amount Status Payment_Description Date}
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
        network = summary.nw == "VOD" ? "TLC" : "#{summary.nw}"
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
            if service_for_header.present?
              case service_for_header.activity_type_code
              when "OMC"
                csv << [merchant, service, extra_ref, reference, lov_name, activity_type, mobile_num, network, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
              when "MOP"
                csv << [merchant, service, lov_name, activity_type, mobile_num, recipient_no, narration, network, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
              when "HSP"
                csv << [merchant, service, lov_name, activity_type, mobile_num, recipient_no, narration, network, trans_type, payment_mode, payment_option, card_option, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
              when "CHC"
                csv << [merchant, service, reference, lov_name, menu_item, activity_type, mobile_num, customer_name, network, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
              when "SHW" || "SPO"
                csv << [merchant, service, reference, lov_name, mobile_num, customer_name, recipient_email, ticket_type, activity_time, network, transaction_id, src, qty, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
              when "PDD"
                csv << [merchant, service, reference, lov_name, mobile_num, customer_name, network, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
              else
                csv << [merchant, service, reference, lov_name, mobile_num, customer_name, network, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
              end
            else
              csv << [merchant, service, reference, lov_name, mobile_num, customer_name, network, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            end

          else
            case for_activity_type
            when "OMC"
              csv << [merchant, service, service_id, extra_ref, reference, lov_name, activity_type, mobile_num, network, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            when "MOP"
              csv << [merchant, service, service_id, lov_name, activity_type, mobile_num, recipient_no, narration, network, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            when "HSP"
              csv << [merchant, service, service_id, lov_name, activity_type, mobile_num, recipient_no, narration, network, trans_type, payment_mode, payment_option, card_option, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            when "CHC"
              csv << [merchant, service, service_id, reference, lov_name, menu_item, activity_type, mobile_num, customer_name, extra_ref, network, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            when "SHW" || "SPO"
              csv << [merchant, service, service_id, reference, lov_name, activity_type, mobile_num, customer_name, recipient_email, ticket_type, activity_time, extra_ref, network, transaction_id, src, qty, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            when "PDD"
              csv << [merchant, service, service_id, reference, lov_name, activity_type, mobile_num, customer_name, extra_ref, network, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            else
              csv << [merchant, service, service_id, reference, lov_name, activity_type, mobile_num, customer_name, extra_ref, network, transaction_id, src, for_gross_amt, m_charge, c_charge, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            end
          end
        else
          if current_user.merchant_service?
            service_for_header = EntityDivision.where(active_status: true, assigned_code: current_user.user_division_code).order(created_at: :desc).first
            if service_for_header.present?
              case service_for_header.activity_type_code
              when "OMC"
                csv << [merchant, service, extra_ref, reference, lov_name, activity_type, mobile_num, network, transaction_id, src, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
              when "MOP"
                csv << [merchant, service, lov_name, activity_type, mobile_num, recipient_no, narration, network, transaction_id, src, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
              when "HSP"
                csv << [merchant, service, lov_name, activity_type, mobile_num, recipient_no, narration, network, trans_type, payment_mode, payment_option, card_option, transaction_id, src, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
              when "CHC"
                csv << [merchant, service, reference, lov_name, menu_item, activity_type, mobile_num, customer_name, network, transaction_id, src, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
              when "SHW" || "SPO"
                csv << [merchant, service, reference, lov_name, mobile_num, customer_name, recipient_email, ticket_type, activity_time, network, transaction_id, src, qty, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
              when "PDD"
                csv << [merchant, service, reference, lov_name, mobile_num, customer_name, network, transaction_id, src, actual_amt, status, trans_msg, date]
              else
                csv << [merchant, service, reference, lov_name, mobile_num, customer_name, network, transaction_id, src, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
              end
            else
              csv << [merchant, service, reference, lov_name, mobile_num, customer_name, network, transaction_id, src, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            end

          else
            case for_activity_type
            when "OMC"
              csv << [merchant, service, extra_ref, reference, lov_name, activity_type, mobile_num, network, transaction_id, src, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            when "MOP"
              csv << [merchant, service, lov_name, activity_type, mobile_num, recipient_no, narration, network, transaction_id, src, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            when "HSP"
              csv << [merchant, service, lov_name, activity_type, mobile_num, recipient_no, narration, network, trans_type, payment_mode, payment_option, card_option, transaction_id, src, actual_amt, status, trans_msg, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            when "CHC"
              csv << [merchant, service, reference, lov_name, menu_item, activity_type, mobile_num, customer_name, extra_ref, network, transaction_id, src, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            when "SHW" || "SPO"
              csv << [merchant, service, reference, lov_name, activity_type, mobile_num, customer_name, recipient_email, ticket_type, activity_time, extra_ref, network, transaction_id, src, qty, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            when "PDD"
              csv << [merchant, service, reference, lov_name, activity_type, mobile_num, customer_name, extra_ref, network, transaction_id, src, actual_amt, status, trans_msg, date]
            else
              csv << [merchant, service, reference, lov_name, activity_type, mobile_num, customer_name, extra_ref, network, transaction_id, src, actual_amt, status, trans_msg, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, trans_msg, summary.date]
            end
          end
        end

      end
    end

  end

end
