class LoanRequest < ApplicationRecord
  belongs_to :entity_division, class_name: "EntityDivision", foreign_key: :division_code


  def self.tuple_of_divs(entity_code)
    entity_div = EntityDivision.where(active_status: true, entity_code: entity_code).first
    div_arr = ['0']
    if entity_div
      entity_div.each_with_index do |div, ind|
        unless div_arr.include?("'#{div.assigned_code}'")
          div_arr << "'#{div.assigned_code}'"
        end
      end
    end
    div_arr.join(",")
  end

  def self.filter_activities(params, session)
    search_arr = []
    if params[:filter_exist].present? && params[:filter_exist] == "filter_exist"
      logger.info "Global Filter params #{session[:loan_req_filter].inspect}"
      params[:filter_main] = session[:loan_req_filter]
    end
    if params[:filter_main].present?
      session[:loan_req_filter] = params[:filter_main]
      filter_params = params[:filter_main]
      logger.info "Filter Params #{filter_params.inspect}"
      logger.info "Filter Params 2 #{session[:loan_req_filter].inspect}"
      @merch_name = filter_params[:merchant_name]
      @div_name = filter_params[:division_name]
      @fullname = filter_params[:fullname]
      @id_number = filter_params[:id_number]
      @ref_no = filter_params[:ref_no]



      if @merch_name.present?
        div_str = tuple_of_divs(@merch_name)
        search_arr << "division_code IN (#{div_str})"
      end

      if @div_name.present?
        search_arr << "division_code = '#{@div_name}'"
      end

      if @fullname.present?
        #search_arr << "id_type LIKE '%#{@id_type}%'"
        search_arr << "full_name ilike '%#{@fullname}%'"
      end

      if @id_number.present?
        search_arr << "id_number iLIKE '%#{@id_number}%'"
      end

      if @ref_no.present?
        search_arr << "ref_number ilike '%#{@ref_no}%'"
      end

      if @status.present?
        if @status == "P"
          search_arr << "active_status IS NULL"
        elsif @status == "TRUE"
          search_arr << "active_status = true"
        elsif @status == "FALSE"
          search_arr << "active_status = false"
        end
      end


      if @start_date.present? && @end_date.present?
        f_start_date =  @start_date.to_date.strftime('%Y-%m-%d') # Date Time.strptime(@start_date, '%m/%d/%Y') # @start_date.to_date.strftime('%Y-%m-%d')
        f_end_date = @end_date.to_date.strftime('%Y-%m-%d') # Date Time.strptime(@end_date, '%m/%d/%Y') # @end_date.to_date.strftime('%Y-%m-%d')
        if f_start_date <= f_end_date
          search_arr << "created_at BETWEEN '#{f_start_date} 00:00:00' AND '#{f_end_date} 23:59:59'"
        else
          search_arr << "created_at IS NULL"
        end
      end
      logger.info "Values :: #{filter_params.inspect}"
    end

    the_search = search_arr.join(" AND ")

    logger.info "The search array :: #{search_arr.inspect}"
    logger.info "The Search :: #{the_search.inspect}"
    the_search
  end

   def self.to_csv(general_report, current_user, options="")
    CSV.generate(options) do |csv|
      #headers = %w{Merchant Service Reference Selected_Option Activity_Type Mobile_No Name/Reference Network Tranx_ID Gross_Amount Charge Actual_Amount Source Status Date}
      if current_user.super_admin? || current_user.super_user?
        headers = %w{Merchant Service Service_ID Full_Name ID_Number Ref_ID Location Amount Comment Status Date Time}
      else
        headers = %w{Merchant Service Service_ID Full_Name ID_Number Ref_ID Location Amount Status Date Time}
      end
      csv << headers
      general_report.each do |summary|
        # ------code comes here
        logger.info "General report :: #{summary.inspect}"
        entity_div = EntityDivision.where(active_status: true, assigned_code: summary.division_code).order(created_at: :desc).first
        logger.info "General report to check if I was able to reach this point :: #{summary.inspect}"
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

        if summary.active_status
          status = "Active"
        elsif summary.active_status == false
          status = "Inactive"
        else
          status = "Inactive"
        end
        date = summary.created_at
        for_date = summary.created_at.strftime('%Y-%m-%d')
        for_time = summary.created_at.strftime('%H:%M:%S')
        if current_user.super_admin? || current_user.super_user?
          csv << [merchant, service, summary.division_code, summary.full_name, summary.id_number, summary.ref_number, summary.location, summary.amount, summary.comment, status, for_date, for_time]
        else
          csv << [merchant, service, summary.division_code, summary.full_name, summary.id_number, summary.ref_number, summary.location, summary.amount, status, for_date, for_time]
        end
      end

    end
  end
end
