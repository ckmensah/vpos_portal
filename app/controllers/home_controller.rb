class HomeController < ApplicationController

  def index
    if params[:home_notice] == "authorization"
      flash.now[:note] = "You are not authorized to manage roles."
    end

    #@payment_reports = PaymentReport.all
    if current_user.super_admin? || current_user.super_user?
      @payment_merchant = EntityInfo.where(active_status: true)
      @payment_service = EntityDivision.where(active_status: true)
      @payment_reports = PaymentReport.where("created_at BETWEEN '#{Time.now.strftime('%Y-%m-%d')} 00:00:00' AND '#{Time.now.strftime('%Y-%m-%d')} 23:59:59' AND nw IS NOT NULL")
      #@payment_success_count = PaymentReport.where("split_part(trans_status, '/', 1) = '000'").count
      @pay_success = @payment_reports.where("split_part(trans_status, '/', 1) = '000'")
      @pay_fail = @payment_reports.where("split_part(trans_status, '/', 1) != '000' AND trans_status IS NOT NULL")
      @service_account = EntityServiceAccount.where(entity_div_code: "0").order(created_at: :desc).first
      @service_account_details = EntityServiceAccountTrxn.where(entity_div_code: "0").order(created_at: :desc)

    elsif current_user.merchant_admin?
      @payment_service = EntityDivision.where(active_status: true, assigned_code: current_user.division_code)
      division_str = "'0'"
      entity_str = "'0'"
      #@merchant = EntityInfo.where("LOWER(entity_name) LIKE '%#{@entity_name.downcase}%'")
      #@merchant.each { |entity_div| entity_str << ",'#{entity_div.assigned_code}'" } if @merchant.exists?
      #final_info_str = "(#{entity_str})"
      @entity_divis = EntityDivision.where("active_status = true AND entity_code = '#{current_user.entity_code}'")
      @entity_divis.each { |entity_div| division_str << ",'#{entity_div.assigned_code}'" } if @entity_divis.exists?
      final_div_str = "(#{division_str})"
      logger.info "Final Div Str :: #{final_div_str.inspect}"

      @service_account = EntityServiceAccount.where("entity_div_code IN #{final_div_str}").order(created_at: :desc).first
      @service_account_details = EntityServiceAccountTrxn.where("entity_div_code IN #{final_div_str}").order(created_at: :desc)

      @payment_reports = PaymentReport.where("created_at BETWEEN '#{Time.now.strftime('%Y-%m-%d')} 00:00:00' AND '#{Time.now.strftime('%Y-%m-%d')} 23:59:59' AND entity_div_code IN #{final_div_str} AND nw IS NOT NULL")
      #@payment_success_count = PaymentReport.where("split_part(trans_status, '/', 1) = '000' AND entity_div_code IN #{final_info_str}").count
      @pay_success = @payment_reports.where("split_part(trans_status, '/', 1) = '000'")
      @pay_fail = @payment_reports.where("split_part(trans_status, '/', 1) != '000' AND trans_status IS NOT NULL")
    elsif current_user.merchant_service?
      @service_account = EntityServiceAccount.where(entity_div_code: current_user.division_code).order(created_at: :desc).first
      @service_account_details = EntityServiceAccountTrxn.where(entity_div_code: current_user.division_code).order(created_at: :desc).limit(5)

      @payment_reports = PaymentReport.where("created_at BETWEEN '#{Time.now.strftime('%Y-%m-%d')} 00:00:00' AND '#{Time.now.strftime('%Y-%m-%d')} 23:59:59' AND entity_div_code = '#{current_user.division_code}' AND nw IS NOT NULL")
      #@payment_success_count = PaymentReport.where("split_part(trans_status, '/', 1) = '000' AND entity_div_code = #{current_user.division_code}").count
      @pay_success = @payment_reports.where("split_part(trans_status, '/', 1) = '000'")
      @pay_fail = @payment_reports.where("split_part(trans_status, '/', 1) != '000' AND trans_status IS NOT NULL")
    else
    end

    unless current_user.validator?
      if @pay_success.exists?
        @payment_success_count = @pay_success.count
        @payment_success_amount = @pay_success.sum(:amount)
      else
        @payment_success_count = 0
        @payment_success_amount = 0.0
      end

      if @pay_fail.exists?
        @payment_fail_count = @pay_fail.count
      else
        @payment_fail_count = 0
      end

      @payment_success_amount = number_to_currency(@payment_success_amount, unit: "GHS ")
      logger.info "Payment Report: #{@payment_reports.inspect}"
      logger.info "Success count:: #{@payment_success_count.inspect}"
      logger.info "Success amount:: #{@payment_success_amount.inspect}"
      logger.info "Failed count:: #{@payment_fail_count.inspect}"

    end

  end




  def home_index
    if params[:home_notice] == "authorization"
      flash.now[:note] = "You are not authorized to manage roles."
    end

    the_search = ""
    search_arr = []
    if params[:filter_main].present? || params[:entity_name].present? || params[:division_name].present? || params[:start_date].present? || params[:end_date].present?

      filter_params = params[:filter_main]
      if params[:filter_main].present?
        @entity_name = filter_params[:entity_name]
        @division_name = filter_params[:division_name]
        @start_date = filter_params[:start_date]
        @end_date = filter_params[:end_date]
        params[:entity_name] = filter_params[:entity_name]
        params[:division_name] = filter_params[:division_name]
        params[:start_date] = filter_params[:start_date]
        params[:end_date] = filter_params[:end_date]
      else
        if  params[:entity_name].present? || params[:division_name].present? || params[:start_date].present? || params[:end_date].present?

          @entity_name = params[:entity_name]
          @division_name = params[:division_name]
          @start_date = params[:start_date]
          @end_date = params[:end_date]
          params[:entity_name] = @entity_name
          params[:division_name] = @division_name
          params[:start_date] = @start_date
          params[:end_date] = @end_date
        else
          params[:entity_name] = filter_params[:entity_name]
          params[:division_name] = filter_params[:division_name]
          params[:start_date] = filter_params[:start_date]
          params[:end_date] = filter_params[:end_date]
        end
      end
    end

    if current_user.super_admin? || current_user.super_user?
      @payment_merchant = EntityInfo.where(active_status: true)
      @payment_service = EntityDivision.where(active_status: true)


      if @entity_name.present?
        division_str = "'0'"
        entity_str = "'0'"
        @merchant = EntityInfo.where("active_status = true AND assigned_code = '#{@entity_name}'")
        @merchant.each { |entity_div| entity_str << ",'#{entity_div.assigned_code}'" } if @merchant.exists?
        final_info_str = "(#{entity_str})"
        @entity_divis = EntityDivision.where("active_status = true AND entity_code IN #{final_info_str}")
        @entity_divis.each { |entity_div| division_str << ",'#{entity_div.assigned_code}'" } if @entity_divis.exists?
        final_div_str = "(#{division_str})"
        logger.info "Final Div Str :: #{final_div_str.inspect} and Final INfo Str :: #{final_info_str}"
        search_arr << "entity_div_code IN #{final_div_str}"
      end


      if @division_name.present?
        #division_str = "'0'"
        #@entity_divis = EntityDivision.where("active_status = true AND entity_code = '#{@division_name}'")
        #
        #@entity_divis.each { |entity_div| division_str << ",'#{entity_div.assigned_code}'" } if @entity_divis.exists?
        #final_div_str = "(#{division_str})"
        #logger.info "Final Div Str :: #{final_div_str.inspect}"
        #search_arr << "entity_div_code IN #{final_div_str}"
        search_arr << "entity_div_code = '#{@division_name}'"
      end
    elsif current_user.merchant_admin?
      @payment_service = EntityDivision.where(active_status: true, assigned_code: current_user.division_code)

      if @division_name.present?
        search_arr << "entity_div_code = '#{@division_name}'"
      end
    end

    if @start_date.present? && @end_date.present?
      f_start_date =  @start_date.to_date.strftime('%Y-%m-%d') # Date.strptime(@start_date, '%m/%d/%Y') # @start_date.to_date.strftime('%Y-%m-%d')
      f_end_date = @end_date.to_date.strftime('%Y-%m-%d') # Date.strptime(@end_date, '%m/%d/%Y') # @end_date.to_date.strftime('%Y-%m-%d')
      if f_start_date <= f_end_date
        search_arr << "created_at BETWEEN '#{f_start_date} 00:00:00' AND '#{f_end_date} 23:59:59'"
      end
    end

    the_search = search_arr.join(" AND ")
    unless the_search.present?
      the_search << "created_at BETWEEN '#{Time.now.strftime('%Y-%m-%d')} 00:00:00' AND '#{Time.now.strftime('%Y-%m-%d')} 23:59:59'"
    end


    #@payment_reports = PaymentReport.all
    if current_user.super_admin? || current_user.super_user?
      @service_account = EntityServiceAccount.where(entity_div_code: "0").order(created_at: :desc).first
      @service_account_details = EntityServiceAccountTrxn.where(entity_div_code: "0").order(created_at: :desc)

      @payment_reports = PaymentReport.where("nw IS NOT NULL").where(the_search)
      #@pay_success_count = @payment_reports.where("split_part(trans_status, '/', 1) = '000'")
      @pay_success = @payment_reports.where("split_part(trans_status, '/', 1) = '000'")
      @pay_fail = @payment_reports.where("split_part(trans_status, '/', 1) != '000' AND trans_status IS NOT NULL")
    elsif current_user.merchant_admin?
      division_str = "'0'"
      entity_str = "'0'"
      #@merchant = EntityInfo.where("LOWER(entity_name) LIKE '%#{@entity_name.downcase}%'")
      #@merchant.each { |entity_div| entity_str << ",'#{entity_div.assigned_code}'" } if @merchant.exists?
      #final_info_str = "(#{entity_str})"
      @entity_divis = EntityDivision.where("entity_code = '#{current_user.entity_code}'")
      @entity_divis.each { |entity_div| division_str << ",'#{entity_div.assigned_code}'" } if @entity_divis.exists?
      final_div_str = "(#{division_str})"
      logger.info "Final Div Str :: #{final_div_str.inspect}"

      @payment_reports = PaymentReport.where("entity_div_code IN #{final_div_str} AND nw IS NOT NULL").where(the_search)
      #@pay_success_count = @payment_reports.where("split_part(trans_status, '/', 1) = '000'")
      @pay_success = @payment_reports.where("split_part(trans_status, '/', 1) = '000'")
      @pay_fail = @payment_reports.where("split_part(trans_status, '/', 1) != '000' AND trans_status IS NOT NULL")

      @service_account = EntityServiceAccount.where("entity_div_code IN #{final_div_str}").order(created_at: :desc).first
      @service_account_details = EntityServiceAccountTrxn.where("entity_div_code IN #{final_div_str}").order(created_at: :desc)

    elsif current_user.merchant_service?
      #if params[:filtered] == "filtered"
      #  @payment_reports = PaymentReport.where("entity_div_code = #{current_user.division_code}").where(the_search)
      #else
        @payment_reports = PaymentReport.where("entity_div_code = '#{current_user.division_code}' AND nw IS NOT NULL").where(the_search)
      #end
      #  @pay_success_count = @payment_reports.where("split_part(trans_status, '/', 1) = '000'")
        @pay_success = @payment_reports.where("split_part(trans_status, '/', 1) = '000'")
        @pay_fail = @payment_reports.where("split_part(trans_status, '/', 1) != '000' AND trans_status IS NOT NULL")

        @service_account = EntityServiceAccount.where(entity_div_code: current_user.division_code).order(created_at: :desc).first
        @service_account_details = EntityServiceAccountTrxn.where(entity_div_code: current_user.division_code).order(created_at: :desc).limit(5)

    else
    end
    if @pay_success.exists?
      @payment_success_count = @pay_success.count
      @payment_success_amount = @pay_success.sum(:amount)
    else
      @payment_success_count = 0
      @payment_success_amount = 0.0
    end

    if @pay_fail.exists?
      @payment_fail_count = @pay_fail.count
    else
      @payment_fail_count = 0
    end

    @payment_success_amount = number_to_currency(@payment_success_amount, unit: "GHS ")
    logger.info "Payment Report: #{@payment_reports.inspect}"
    logger.info "Success count:: #{@payment_success_count.inspect}"
    logger.info "Success amount:: #{@payment_success_amount.inspect}"
    logger.info "Failed count:: #{@payment_fail_count.inspect}"
  end

end

