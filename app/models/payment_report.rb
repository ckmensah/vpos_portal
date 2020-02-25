class PaymentReport < ApplicationRecord
  self.table_name="payment_reports"
  self.primary_key = "id"
  has_many :payment_requests, class_name: 'PaymentRequest', foreign_key: :payment_info_id
  belongs_to :entity_division, -> { where active_status: true}, class_name: 'EntityDivision', foreign_key: :entity_div_code
  belongs_to :division_activity_lov, -> { where active_status: true}, class_name: 'DivisionActivityLov', foreign_key: :activity_lov_id


  def self.to_csv(general_report, options = {})
    CSV.generate(options) do |csv|
      headers = %w{Merchant Service Reference Selected_Option Activity_Type Mobile_No Network Tranx_ID Actual_Amount Gross_Amount Charge Source Status Date}
      csv << headers
      general_report.each do |summary|
        # ------code comes here

        logger.info "General report :: #{summary.inspect}"
        merchant = summary.entity_division.entity_info ? summary.entity_division.entity_info.entity_name : ""
        service = summary.entity_division ? summary.entity_division.division_name : ""
        reference = summary.reference.present? ? summary.reference : ""
        lov_name = summary.division_activity_lov ? summary.division_activity_lov.lov_desc : ""
        activity_type = summary.entity_division.activity_type ? summary.entity_division.activity_type.activity_type_desc : ""
        mobile_num = summary.customer_number
        network = summary.nw
        transaction_id = summary.processing_id
        amount = summary.amount
        charge = 0.000
        total_amt = 0.000
        @merchant_service_trxn = EntityServiceAccountTrxn.where(entity_div_code: summary.entity_div_code, processing_id: summary.processing_id).order(created_at: :desc).first
        @assigned_fee = AssignedFee.where(entity_div_code: summary.entity_div_code).order(created_at: :desc).first

        if @assigned_fee.charged_to == "M"
          if @merchant_service_trxn && @merchant_service_trxn.charge != nil
          charge = @merchant_service_trxn.charge
            total_amt = summary.amount.to_f + @merchant_service_trxn.charge.to_f
          else
            total_amt = summary.amount.to_f
          end
        elsif @assigned_fee.charged_to == "C"
          if summary.charge != nil
          charge = summary.charge
            total_amt = summary.amount.to_f + summary.charge.to_f
          else
            total_amt = summary.amount.to_f
          end
        end
        


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
        csv << [merchant, service, reference, lov_name, activity_type, mobile_num, network, transaction_id, total_amt, charge, amount, source, status, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, summary.date]
      end
    end
  end


end
