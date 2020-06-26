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


  def self.to_csv(general_report, current_user, options = {})
    CSV.generate(options) do |csv|
      #headers = %w{Merchant Service Reference Selected_Option Activity_Type Mobile_No Name/Reference Network Tranx_ID Gross_Amount Charge Actual_Amount Source Status Date}
      #headers = %w{Merchant Service Service_Alias Extra_Ref Reference Selected_Option Activity_Type Mobile_No Name/Reference Network Tranx_ID Gross_Amount M-Charge C-Charge Actual_Amount Source Status Date}
      if current_user.merchant_service?
        service_for_header = EntityDivision.where(active_status: true, assigned_code: current_user.division_code).order(created_at: :desc).first
        if service_for_header && service_for_header.activity_type_code == "OMC"
          headers = %w{Merchant Service Station_ID Reference Selected_Option Activity_Type Mobile_No Name/Reference Network Tranx_ID Gross_Amount M-Charge C-Charge Actual_Amount Source Status Date}
        else
          headers = %w{Merchant Service Reference Selected_Option Activity_Type Mobile_No Name/Reference Network Tranx_ID Gross_Amount M-Charge C-Charge Actual_Amount Source Status Date}
        end
      else
        headers = %w{Merchant Service Reference Selected_Option Activity_Type Mobile_No Name/Reference Extra_Ref Network Tranx_ID Gross_Amount M-Charge C-Charge Actual_Amount Source Status Date}
      end
      csv << headers
      actual_amt = 0.000
      for_gross_amt = 0.000
      general_report.each do |summary|
        # ------code comes here


        logger.info "General report :: #{summary.inspect}"
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
        activity_type = (summary.entity_division != nil && summary.entity_division.activity_type) ? summary.entity_division.activity_type.activity_type_desc : ""
        mobile_num = summary.customer_number
        customer_name = summary.customer_name
        network = summary.nw
        transaction_id = summary.processing_id
        amount = summary.amount
        charge = 0.000
        m_charge = 0.000
        c_charge = 0.000
        total_amt = 0.000
        @merchant_service_trxn = EntityServiceAccountTrxn.where(entity_div_code: summary.entity_div_code, processing_id: summary.processing_id).order(created_at: :desc).first
        @assigned_fee = AssignedFee.where(entity_div_code: summary.entity_div_code).order(created_at: :desc).first

        #if @assigned_fee && @assigned_fee.charged_to == "M"
        if summary.charge == 0.000
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
        status = summary.trans_status.present? ? summary.trans_status.split("/") : "nil"

        if status[0] == "000"
          status = "Success"
        elsif status == "nil"
          status = "Pending"
        else
          status = "Failed"
        end
        date = summary.created_at
        #csv << [merchant, service, reference, lov_name, activity_type, mobile_num, customer_name, network, transaction_id, total_amt, charge, amount, source, status, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, summary.date]
        #csv << [merchant, service, reference, lov_name, activity_type, mobile_num, customer_name, network, transaction_id, for_gross_amt, charge, actual_amt, source, status, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, summary.date]
        #csv << [merchant, service, service_alias, extra_ref, reference, lov_name, activity_type, mobile_num, customer_name, network, transaction_id, for_gross_amt, m_charge, c_charge, actual_amt, source, status, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, summary.date]
        if current_user.merchant_service?
          service_for_header = EntityDivision.where(active_status: true, assigned_code: current_user.division_code).order(created_at: :desc).first
          if service_for_header && service_for_header.activity_type_code == "OMC"
            csv << [merchant, service, extra_ref, reference, lov_name, activity_type, mobile_num, customer_name, network, transaction_id, for_gross_amt, m_charge, c_charge, actual_amt, source, status, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, summary.date]
          else
            csv << [merchant, service, reference, lov_name, activity_type, mobile_num, customer_name, network, transaction_id, for_gross_amt, m_charge, c_charge, actual_amt, source, status, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, summary.date]
          end
        else
          csv << [merchant, service, reference, lov_name, activity_type, mobile_num, customer_name, extra_ref, network, transaction_id, for_gross_amt, m_charge, c_charge, actual_amt, source, status, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, summary.date]
        end
      end
    end

  end




  def self.to_finance_csv(payment_report, fund_movements, options = {})
    CSV.generate(options) do |csv|
      headers = %w{Value_Date Description Sweeps/Debit Collections/Credit}

      csv << headers
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
                csv << [date, narration, debit_amt, credit_amt]
              end
            end
          else
            fund_movements.each_with_index do |fund_movement, index1|
              logger.info "Fund Movement report :: #{index1 + 1}. of #{index + 1}. #{fund_movement.inspect}"
              if fund_movement.date.to_date <= pay_report.date.to_date && fund_movement.date.to_date >= payment_report[index - 1].date.to_date
                date = fund_movement.date
                narration = fund_movement.narration
                debit_amt = fund_movement.amt
                credit_amt = ""
                csv << [date, narration, debit_amt, credit_amt]
              end
            end
          end
        end

        date = pay_report.date
        narration = "Collections for #{pay_report.date.to_date.strftime("%B %d, %Y")}"
        debit_amt = ""
        credit_amt = pay_report.actual_amt
        csv << [date, narration, debit_amt, credit_amt]
      end
    end

  end




end
