class PaymentReport < ApplicationRecord
  self.table_name="payment_reports"
  self.primary_key = "id"
  has_many :payment_requests, class_name: 'PaymentRequest', foreign_key: :payment_info_id
  belongs_to :entity_division, class_name: 'EntityDivision', foreign_key: :entity_div_code
  belongs_to :division_activity_lov, class_name: 'DivisionActivityLov', foreign_key: :activity_lov_id


  def self.to_csv(general_report)
    CSV.generate do |csv|
      headers = %w{Merchant Service Reference Selected_Option Activity_Type Mobile_No Network Tranx_ID Amount Source Status Date}
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
        transction_id = summary.processing_id
        amount = summary.amount
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
        csv << [merchant, service, reference, lov_name, activity_type, mobile_num, network, transction_id, amount, source, status, date] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, summary.date]
      end
    end
  end


end
