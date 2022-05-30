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

end
