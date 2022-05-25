class LoanRequest < ApplicationRecord
  belongs_to :entity_division, class_name: "EntityDivision", foreign_key: :division_code


  def self.filter_activities(params, session)
    search_arr = []
    #@entity_code = params[:entity_code]
    if params[:filter_exist].present? && params[:filter_exist] == "filter_exist"
      logger.info "Global Filter params #{session[:bene_info_filter].inspect}"
      params[:filter_main] = session[:bene_info_filter]
    end
    if params[:filter_main].present?
      session[:bene_info_filter] = params[:filter_main]
      filter_params = params[:filter_main]
      logger.info "Filter Params #{filter_params.inspect}"
      logger.info "Filter Params 2 #{session[:bene_info_filter].inspect}"
      @merch_name = filter_params[:merchant_name]
      @benef_name = filter_params[:benef_name]
      @id_type = filter_params[:id_type]
      @id_number = filter_params[:id_number]
      @contact_no = filter_params[:contact_no]
      @status = filter_params[:status]
      @custom_id = filter_params[:custom_id]
      @start_date = filter_params[:start_date]
      @end_date = filter_params[:end_date]



      if @merch_name.present?
        search_arr << "(entity_code = '#{@merch_name}')"
      end

      if @benef_name.present?
        search_arr << "assigned_code = '#{@benef_name}'"
      end

      if @id_type.present?
        #search_arr << "id_type LIKE '%#{@id_type}%'"
        search_arr << "id_type = '#{@id_type}'"
      end

      if @id_number.present?
        search_arr << "id_no LIKE '%#{@id_number}%'"
      end

      if @contact_no.present?
        search_arr << "contact_number LIKE '%#{@contact_no}%'"
      end

      if @custom_id.present?
        search_arr << "custom_id LIKE '%#{@custom_id}%'"
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

end
