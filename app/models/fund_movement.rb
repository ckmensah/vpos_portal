class FundMovement < ApplicationRecord
  self.table_name="fund_movement"
  self.primary_key = "id"

  belongs_to :entity_division, class_name: "EntityDivision", foreign_key: :entity_div_code


  def self.to_csv(general_report, current_user, options = {})
    CSV.generate(options) do |csv|
      #headers = %w{Merchant Service Reference Selected_Option Activity_Type Mobile_No Name/Reference Network Tranx_ID Gross_Amount Charge Actual_Amount Source Status Date}
      if current_user.super_admin? || current_user.super_user?
        headers = %w{Merchant Service Service_ID Ref_ID Amount Narration Trans_Type Trans_Status Trans_Description Status Date Time}
      else
        headers = %w{Merchant Service Ref_ID Amount Narration Trans_Type Trans_Description Status Date Time}
      end
      csv << headers

      general_report.each do |summary|
        # ------code comes here

        logger.info "General report :: #{summary.inspect}"
        entity_div = EntityDivision.where(active_status: true, assigned_code: summary.entity_div_code).order(created_at: :desc).first
        if entity_div
          ent_info = EntityInfo.where(active_status: true, assigned_code: entity_div.entity_code).order(created_at: :desc).first
          if ent_info
            merchant = ent_info.entity_name
          else
            merchant = ""
          end
          service = entity_div.division_name
        else
          merchant = ""
          service = ""
        end

        #service = summary.entity_division ? summary.entity_division.division_name : ""


        if summary.processed
          status = "Processed"
        elsif summary.processed == false
          status = "Failed"
        else
          status = "Pending"
        end
        date = summary.created_at
        for_date = summary.created_at.strftime('%Y-%m-%d')
        for_time = summary.created_at.strftime('%H:%M:%S')
        if current_user.super_admin? || current_user.super_user?
          csv << [merchant, service, summary.service_id, summary.ref_id, summary.amount, summary.narration, summary.trans_type, summary.trans_status, summary.trans_desc, status, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, summary.date]
        else
          csv << [merchant, service, summary.ref_id, summary.amount, summary.narration, summary.trans_type, summary.trans_desc, status, for_date, for_time] #[merchant, rec_name, summary.pc_name, summary.momo_number, summary.product_name, bags, quantity, summary.amount, summary.exttrid, status, summary.date]
        end
      end

    end
  end


end
