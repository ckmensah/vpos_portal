class DashboardController < ApplicationController

  def performed_sql(time_range)
 #   "select date, division_code, total_count, total_amt from (select sum(amount) total_amt, count(entity_div_code) total_count,
 #entity_div_code division_code, to_char(created_at, 'YYYY-MM-DD') date from payment_reports where created_at #{time_range} GROUP BY entity_div_code,
 #to_char(created_at, 'YYYY-MM-DD')) AS payment_details order by total_amt desc;"
 #   "select division_code, total_count, total_amt from (select sum(amount) total_amt, count(entity_div_code) total_count,
 #entity_div_code division_code from payment_reports where processed = #{status} AND created_at #{time_range} GROUP BY entity_div_code) AS payment_details
 #order by total_amt desc;"
    "select division_code, total_count, total_amt from (select sum(amount) total_amt, count(entity_div_code) total_count,
 entity_div_code division_code from payment_reports where created_at #{time_range} GROUP BY entity_div_code) AS payment_details
 order by total_amt desc;"
  end

  def index
    if current_user.super_admin? || current_user.super_user?
      @payment_merchant = EntityInfo.where(active_status: true)
      @payment_service = EntityDivision.where(active_status: true)
      @payment_reports = PaymentReport.where("created_at BETWEEN '#{Time.now.strftime('%Y-%m-%d')} 00:00:00' AND '#{Time.now.strftime('%Y-%m-%d')} 23:59:59' AND nw IS NOT NULL")
      #"select distinct * from entity_info where"
      #performance_sql = "select total_amt, entity_name, date from (select sum(amount) total_amt, entity_code, to_char(created_at, 'YYYY-MM-DD') date from payment_reports LEFT JOIN entity_division ON payment_reports.entity_div_code = entity_division.assigned_code LEFT JOIN entity_info ON entity_division.entity_code = entity_info.assigned_code where entity_division.active_status = true entity_info.active_status = true"

      #@payment_success_count = PaymentReport.where("split_part(trans_status, '/', 1) = '000'").count
      @pay_success = @payment_reports.where("processed = true")
      @pay_fail = @payment_reports.where("processed = false")
      @service_account = EntityServiceAccount.where(entity_div_code: "0").order(created_at: :desc).first
      @service_account_details = EntityServiceAccountTrxn.where(entity_div_code: "0").order(created_at: :desc)

    elsif current_user.merchant_admin?
      #@payment_service = EntityDivision.where(active_status: true, assigned_code: current_user.division_code)
      division_str = "'0'"
      entity_str = "'0'"
      #@merchant = EntityInfo.where("LOWER(entity_name) LIKE '%#{@entity_name.downcase}%'")
      #@merchant.each { |entity_div| entity_str << ",'#{entity_div.assigned_code}'" } if @merchant.exists?
      #final_info_str = "(#{entity_str})"
      @entity_divis = EntityDivision.where("active_status = true AND entity_code = '#{current_user.entity_code}'")
      @entity_divis.each { |entity_div| division_str << ",'#{entity_div.assigned_code}'" } if @entity_divis.exists?
      final_div_str = "(#{division_str})"
      logger.info "Final Div Str :: #{final_div_str.inspect}"
      @payment_service = EntityDivision.where("active_status = true AND assigned_code IN #{final_div_str}")


      @service_account_gross = EntityServiceAccount.where("entity_div_code IN #{final_div_str}").order(created_at: :desc).sum(:gross_bal)
      @service_account_net = EntityServiceAccount.where("entity_div_code IN #{final_div_str}").order(created_at: :desc).sum(:net_bal)
      @service_account = EntityServiceAccount.where("entity_div_code IN #{final_div_str}").order(created_at: :desc)
      @service_account_details = EntityServiceAccountTrxn.where("entity_div_code IN #{final_div_str}").order(created_at: :desc).limit(5)

      @payment_reports = PaymentReport.where("created_at BETWEEN '#{Time.now.strftime('%Y-%m-%d')} 00:00:00' AND '#{Time.now.strftime('%Y-%m-%d')} 23:59:59' AND entity_div_code IN #{final_div_str} AND nw IS NOT NULL")
      #@payment_success_count = PaymentReport.where("split_part(trans_status, '/', 1) = '000' AND entity_div_code IN #{final_info_str}").count
      @pay_success = @payment_reports.where("processed = true")
      @pay_fail = @payment_reports.where("processed = false")
    elsif current_user.merchant_service?
      @service_account = EntityServiceAccount.where(entity_div_code: current_user.division_code).order(created_at: :desc).first
      @service_account_details = EntityServiceAccountTrxn.where(entity_div_code: current_user.division_code).order(created_at: :desc).limit(5)

      @payment_reports = PaymentReport.where("created_at BETWEEN '#{Time.now.strftime('%Y-%m-%d')} 00:00:00' AND '#{Time.now.strftime('%Y-%m-%d')} 23:59:59' AND entity_div_code = '#{current_user.division_code}' AND nw IS NOT NULL")
      #@payment_success_count = PaymentReport.where("split_part(trans_status, '/', 1) = '000' AND entity_div_code = #{current_user.division_code}").count
      @pay_success = @payment_reports.where("processed = true")
      @pay_fail = @payment_reports.where("processed = false")
    else
    end

    report_logic(@pay_success, @pay_fail)
    # =============================  Logic for Best Performance Chart ===========================================

    time_t = Time.now
    week_begin = time_t.beginning_of_week.strftime('%Y-%m-%d')
    month_begin = time_t.beginning_of_month.strftime('%Y-%m-%d')
    year_begin = time_t.strftime('%Y')
    logger.info "Week beginning :: #{week_begin.inspect}"
    logger.info "Month beginning :: #{month_begin.inspect}"
    daily = "BETWEEN '#{time_t.strftime('%Y-%m-%d')} 00:00:00' AND '#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}'"
    weekly = "between '#{time_t.beginning_of_week.strftime('%Y-%m-%d')} 00:00:00' AND '#{time_t.yesterday.strftime('%Y-%m-%d')} 23:59:59'"
    monthly = "between '#{time_t.beginning_of_month.strftime('%Y-%m-%d')} 00:00:00' AND '#{time_t.yesterday.strftime('%Y-%m-%d')} 23:59:59'"
    yearly = "between '#{year_begin}-01-01 00:00:00' AND '#{time_t.yesterday.strftime('%Y-%m-%d')} 23:59:59'"

    nth_category = 10
    series_name = "Best Performers"
    params_type = "service"
    opt = {chart_type: "bar_chart", center_label: "", default_center_label: "",
           sub_caption: "Service Rankings", bg_color: "", actual_chart_type: "mscolumn3d"}
    pie_opt = {chart_type: "pie_chart", center_label: "Revenue from $label: $value", default_center_label: "Total Revenue is ",
               sub_caption: "Service Rankings", bg_color: "#ffffff", actual_chart_type: "pie2d"}
    active_status = true
    @daily_report = PaymentReport.find_by_sql(performed_sql(daily))
    @weekly_report = PaymentReport.find_by_sql(performed_sql(weekly))
    @monthly_report = PaymentReport.find_by_sql(performed_sql(monthly))
    @yearly_report = PaymentReport.find_by_sql(performed_sql(yearly))

    #@daily_report = PaymentReport.find_by_sql(performed_sql(daily, active_status))
    #@weekly_report = PaymentReport.find_by_sql(performed_sql(weekly, active_status))
    #@monthly_report = PaymentReport.find_by_sql(performed_sql(monthly, active_status))
    #@yearly_report = PaymentReport.find_by_sql(performed_sql(yearly, active_status))

    final_daily_category, final_daily_dataset  = category_dataset(@daily_report, nth_category, series_name, params_type, opt)
    final_weekly_category, final_weekly_dataset = category_dataset(@weekly_report, nth_category, series_name, params_type, opt)
    final_monthly_category, final_monthly_dataset = category_dataset(@monthly_report, nth_category, series_name, params_type, opt)
    final_yearly_category, final_yearly_dataset = category_dataset(@yearly_report, nth_category, series_name, params_type, opt)
    pie_yearly_category, pie_yearly_dataset = category_dataset(@yearly_report, nth_category, series_name, params_type, pie_opt)
    pie_monthly_category, pie_monthly_dataset = category_dataset(@monthly_report, nth_category, series_name, params_type, pie_opt)
    logger.info "============= #{opt.inspect}"
    dataset = chart_dataset("amount")
    dataset_cnt = chart_dataset("count")
    chart_cnt = chart_configuration("ocean", "chart-container1", "chart1", "Network", "Number", "", "Count per Network", network_category, dataset_cnt, opt)
    chart_amt = chart_configuration("ocean", "chart-container2", "chart2", "Network", "Amount", "GHS ", "Amount per Network", network_category, dataset, opt)
    pie_chart_cnt = chart_configuration("carbon", "chart-container7", "chart7", "", "", "GHS", "Best #{nth_category} Services this Year", pie_yearly_category, pie_yearly_dataset, pie_opt)
    pie_chart_amt = chart_configuration("umber", "chart-container8", "chart8", "", "", "GHS ", "Best #{nth_category} Services this Month", pie_monthly_category, pie_monthly_dataset, pie_opt)
    final_daily_report = chart_configuration("carbon", "chart-container3", "chart3", "Services", "Amount", "GHS ", "Best #{nth_category} Services this Day", final_daily_category, final_daily_dataset, opt)
    final_weekly_report = chart_configuration("ocean", "chart-container4", "chart4", "Services", "Amount", "GHS ", "Best #{nth_category} Services this Week", final_weekly_category, final_weekly_dataset, opt)
    final_monthly_report = chart_configuration("zune", "chart-container5", "chart5", "Services", "Amount", "GHS ", "Best #{nth_category} Services this Month", final_monthly_category, final_monthly_dataset, opt)
    final_yearly_report = chart_configuration("gammel", "chart-container6", "chart6", "Services", "Amount", "GHS ", "Best #{nth_category} Services this Year", final_yearly_category, final_yearly_dataset, opt)

    @chart_cnt = Fusioncharts::Chart.new(chart_cnt)
    @chart_amt = Fusioncharts::Chart.new(chart_amt)
    @pie_chart_cnt = Fusioncharts::Chart.new(pie_chart_cnt)
    @pie_chart_amt = Fusioncharts::Chart.new(pie_chart_amt)
    @final_daily_report = Fusioncharts::Chart.new(final_daily_report)
    @final_weekly_report = Fusioncharts::Chart.new(final_weekly_report)
    @final_monthly_report = Fusioncharts::Chart.new(final_monthly_report)
    @final_yearly_report = Fusioncharts::Chart.new(final_yearly_report)
  end


  def report_index
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
      #@payment_service = EntityDivision.where(active_status: true, assigned_code: current_user.division_code)
      division_str = "'0'"
      @entity_divis = EntityDivision.where("active_status = true AND entity_code = '#{current_user.entity_code}'")
      @entity_divis.each { |entity_div| division_str << ",'#{entity_div.assigned_code}'" } if @entity_divis.exists?
      final_div_str = "(#{division_str})"
      logger.info "Final Div Str  :: #{final_div_str.inspect}"
      @payment_service = EntityDivision.where("active_status = true AND assigned_code IN #{final_div_str}")

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

    if current_user.super_admin? || current_user.super_user?
      @service_account = EntityServiceAccount.where(entity_div_code: "0").order(created_at: :desc).first
      @service_account_details = EntityServiceAccountTrxn.where(entity_div_code: "0").order(created_at: :desc)

      @payment_reports = PaymentReport.where("nw IS NOT NULL").where(the_search)
      #@pay_success_count = @payment_reports.where("split_part(trans_status, '/', 1) = '000'")
      @pay_success = @payment_reports.where("processed = true")
      @pay_fail = @payment_reports.where("processed = false")
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
      @pay_success = @payment_reports.where("processed = true")
      @pay_fail = @payment_reports.where("processed = false")

      if @division_name.present?
        logger.info "I WAS HERE .............."
        @service_account = EntityServiceAccount.where("entity_div_code = '#{@division_name}'").order(created_at: :desc).first
        @service_account_details = EntityServiceAccountTrxn.where(entity_div_code: @division_name).order(created_at: :desc).limit(5)
      else
        @service_account_gross = EntityServiceAccount.where("entity_div_code IN #{final_div_str}").order(created_at: :desc).sum(:gross_bal)
        @service_account_net = EntityServiceAccount.where("entity_div_code IN #{final_div_str}").order(created_at: :desc).sum(:net_bal)
        @service_account = EntityServiceAccount.where("entity_div_code IN #{final_div_str}").order(created_at: :desc).first
        @service_account_details = EntityServiceAccountTrxn.where("entity_div_code IN #{final_div_str}").order(created_at: :desc).limit(5)
      end

    elsif current_user.merchant_service?
      #if params[:filtered] == "filtered"
      #  @payment_reports = PaymentReport.where("entity_div_code = #{current_user.division_code}").where(the_search)
      #else
      @payment_reports = PaymentReport.where("entity_div_code = '#{current_user.division_code}' AND nw IS NOT NULL").where(the_search)
      #end
      #  @pay_success_count = @payment_reports.where("split_part(trans_status, '/', 1) = '000'")
      @pay_success = @payment_reports.where("processed = true")
      @pay_fail = @payment_reports.where("processed = false")

      @service_account = EntityServiceAccount.where(entity_div_code: current_user.division_code).order(created_at: :desc).first
      @service_account_details = EntityServiceAccountTrxn.where(entity_div_code: current_user.division_code).order(created_at: :desc).limit(5)

    else
    end

    report_logic(@pay_success, @pay_fail)

    # =============================  Logic for Best Performance Chart ===========================================
    time_t = Time.now
    week_begin = time_t.beginning_of_week.strftime('%Y-%m-%d')
    month_begin = time_t.beginning_of_month.strftime('%Y-%m-%d')
    year_begin = time_t.strftime('%Y')
    logger.info "Week beginning :: #{week_begin.inspect}"
    logger.info "Month beginning :: #{month_begin.inspect}"
    daily = "BETWEEN '#{time_t.strftime('%Y-%m-%d')} 00:00:00' AND '#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}'"
    weekly = "between '#{time_t.beginning_of_week.strftime('%Y-%m-%d')} 00:00:00' AND '#{time_t.yesterday.strftime('%Y-%m-%d')} 23:59:59'"
    monthly = "between '#{time_t.beginning_of_month.strftime('%Y-%m-%d')} 00:00:00' AND '#{time_t.yesterday.strftime('%Y-%m-%d')} 23:59:59'"
    yearly = "between '#{year_begin}-01-01 00:00:00' AND '#{time_t.yesterday.strftime('%Y-%m-%d')} 23:59:59'"

    nth_category = 10
    series_name = "Best Performers"
    params_type = "service"
    opt = {chart_type: "bar_chart", center_label: "", default_center_label: "",
           sub_caption: "Service Rankings", bg_color: "", actual_chart_type: "mscolumn3d"}
    pie_opt = {chart_type: "pie_chart", center_label: "Revenue from $label: $value", default_center_label: "Total Revenue is ",
           sub_caption: "Service Rankings", bg_color: "#ffffff", actual_chart_type: "pie2d"}
    active_status = true
    @daily_report = PaymentReport.find_by_sql(performed_sql(daily))
    @weekly_report = PaymentReport.find_by_sql(performed_sql(weekly))
    @monthly_report = PaymentReport.find_by_sql(performed_sql(monthly))
    @yearly_report = PaymentReport.find_by_sql(performed_sql(yearly))

    final_daily_category, final_daily_dataset  = category_dataset(@daily_report, nth_category, series_name, params_type, opt)
    final_weekly_category, final_weekly_dataset = category_dataset(@weekly_report, nth_category, series_name, params_type, opt)
    final_monthly_category, final_monthly_dataset = category_dataset(@monthly_report, nth_category, series_name, params_type, opt)
    final_yearly_category, final_yearly_dataset = category_dataset(@yearly_report, nth_category, series_name, params_type, opt)
    pie_yearly_category, pie_yearly_dataset = category_dataset(@yearly_report, nth_category, series_name, params_type, pie_opt)
    pie_monthly_category, pie_monthly_dataset = category_dataset(@monthly_report, nth_category, series_name, params_type, pie_opt)
    logger.info "--------------------------"
    dataset = chart_dataset("amount")
    dataset_cnt = chart_dataset("count")
    chart_cnt = chart_configuration("ocean", "chart-container1", "chart1", "Network", "Number", "", "Count per Network", network_category, dataset_cnt, opt)
    chart_amt = chart_configuration("ocean", "chart-container2", "chart2", "Network", "Amount", "GHS ", "Amount per Network", network_category, dataset, opt)
    pie_chart_cnt = chart_configuration("carbon", "chart-container7", "chart7", "", "", "GHS", "Best #{nth_category} Services this Year ", pie_yearly_category, pie_yearly_dataset, pie_opt)
    pie_chart_amt = chart_configuration("umber", "chart-container8", "chart8", "", "", "GHS ", "Best #{nth_category} Services this Month ", pie_monthly_category, pie_monthly_dataset, pie_opt)
    final_daily_report = chart_configuration("ocean", "chart-container3", "chart3", "Services", "Amount", "GHS ", "Best #{nth_category} Services this Day", final_daily_category, final_daily_dataset, opt)
    final_weekly_report = chart_configuration("ocean", "chart-container4", "chart4", "Services", "Amount", "GHS ", "Best #{nth_category} Services this Week", final_weekly_category, final_weekly_dataset, opt)
    final_monthly_report = chart_configuration("ocean", "chart-container5", "chart5", "Services", "Amount", "GHS ", "Best #{nth_category} Services this Month", final_monthly_category, final_monthly_dataset, opt)
    final_yearly_report = chart_configuration("ocean", "chart-container6", "chart6", "Services", "Amount", "GHS ", "Best #{nth_category} Services this Year", final_yearly_category, final_yearly_dataset, opt)


    @chart_cnt = Fusioncharts::Chart.new(chart_cnt)
    @chart_amt = Fusioncharts::Chart.new(chart_amt)
    @pie_chart_cnt = Fusioncharts::Chart.new(pie_chart_cnt)
    @pie_chart_amt = Fusioncharts::Chart.new(pie_chart_amt)
    @final_daily_report = Fusioncharts::Chart.new(final_daily_report)
    @final_weekly_report = Fusioncharts::Chart.new(final_weekly_report)
    @final_monthly_report = Fusioncharts::Chart.new(final_monthly_report)
    @final_yearly_report = Fusioncharts::Chart.new(final_yearly_report)

  end



  def report_logic(pay_success, pay_fail)
    @mtn_success = pay_success.where("nw = 'MTN'")
    @airtel_success = pay_success.where("nw = 'AIR'")
    @vod_success = pay_success.where("nw = 'VOD'")
    @tigo_success = pay_success.where("nw = 'TIG'")
    @visa_success = pay_success.where("nw = 'VISA'")
    @master_success = pay_success.where("nw = 'MTC'")

    @mtn_fail = pay_fail.where("nw = 'MTN'")
    @airtel_fail = pay_fail.where("nw = 'AIR'")
    @vod_fail = pay_fail.where("nw = 'VOD'")
    @tigo_fail = pay_fail.where("nw = 'TIG'")
    @visa_fail = pay_fail.where("nw = 'VISA'")
    @master_fail = pay_fail.where("nw = 'MTC'")

    cnt_amt_summary(pay_success, pay_fail)

    #count_label = "Number"
    #amt_label = "Amount"
    #dataset_cnt = chart_dataset("count")
    #dataset_amt = chart_dataset("amount")
    #@network_chart_count = the_chart(dataset_cnt, count_label, "Count per Network", "chart_count")
    #@network_chart_amt = the_chart(dataset_amt, amt_label, "Amount per Network", "chart_amt")
  end

  def network_category
    [{
         category: [
             { label: "MTN" },
             { label: "AIR" },
             { label: "VOD" },
             { label: "TIG" }
         ]
     }]
  end

  def chart_configuration(theme, render_at, id, x_axis, y_axis, num_prefix, caption, category, dataset, **opt)
    data_source = {}
    logger.info "|||||||||||||||||||||||||||||||| #{opt[:chart_type].inspect}"
    if opt[:chart_type] == "bar_chart"
      data_source = {
          chart: {
              caption: caption,
              subCaption: opt[:sub_caption],
              xAxisname: x_axis,
              yAxisName: y_axis,
              numberPrefix: num_prefix,
              theme: theme,
              exportEnabled: "1",
          },
          categories: category,
          dataset: dataset
      }
    elsif opt[:chart_type] == "pie_chart"
      data_source = {
          chart: {
              caption: caption,
              subCaption: opt[:sub_caption],
              numberPrefix: num_prefix,
              bgColor: opt[:bg_color],
              startingAngle: "310",
              showLegend: "1",
              defaultCenterLabel: opt[:default_center_label],
              centerLabel: opt[:center_label],
              centerLabelBold: "1",
              showTooltip: "0",
              decimals: "0",
              theme: theme
          },
          data: dataset
      }
    end
    {width: "600",
                        height: "400",
                        type: opt[:actual_chart_type],
                        id: id,
                        renderAt: render_at,
                        dataSource: data_source
    }
  end

  def chart_dataset(data_kind)
    if data_kind == "amount"
      [
          {
              seriesname: "Successful",
              data: [
                  { value: @mtn_success.sum(:amount).to_s },
                  { value: @airtel_success.sum(:amount).to_s },
                  { value: @vod_success.sum(:amount).to_s },
                  { value: @tigo_success.sum(:amount).to_s }
              ]
          },
          {
              seriesname: "Failed",
              data: [
                  { value: @mtn_fail.sum(:amount).to_s },
                  { value: @airtel_fail.sum(:amount).to_s },
                  { value: @vod_fail.sum(:amount).to_s },
                  { value: @tigo_fail.sum(:amount).to_s }
              ]
          }
      ]
    else
      [
          {
              seriesname: "Successful",
              data: [
                  { value: @mtn_success.count.to_s },
                  { value: @airtel_success.count.to_s },
                  { value: @vod_success.count.to_s },
                  { value: @tigo_success.count.to_s }
              ]
          },
          {
              seriesname: "Failed",
              data: [
                  { value: @mtn_fail.count.to_s },
                  { value: @airtel_fail.count.to_s },
                  { value: @vod_fail.count.to_s },
                  { value: @tigo_fail.count.to_s }
              ]
          }
      ]
    end
  end


  def category_dataset(data, nth_cat, series_name, params_type, **opt)
    category = []
    data_amt_val = []
    data_cnt_val = []
    final_category = []
    final_amt_val = []
    final_cnt_val = []

    if data.size > 0
      data.each_with_index do |info, index|
        if index < nth_cat
          if opt[:chart_type] == "bar_chart"
            if params_type == "merchant"
              label = true
              category << {label: label ? label.entity_name : "N/A"}
            elsif params_type == "service"
              label = EntityDivision.where(assigned_code: info.division_code, active_status: true).order(created_at: :desc).first
              label_false = EntityDivision.where(assigned_code: info.division_code, active_status: false).order(created_at: :desc).first
              category << {label: label ? label.division_name : label_false ? label_false.division_name : "N/A"}
            else
              category << {label: "N/A"}
            end
            data_amt_val << {value: info.total_amt.to_s}
            data_cnt_val << {value: info.total_count.to_s}
            final_category = [{category: category}]
            final_amt_val = [{seriesname: series_name}, data: data_amt_val]
            final_cnt_val = [{seriesname: series_name}, data: data_cnt_val]
          elsif opt[:chart_type] == "pie_chart"
            if params_type == "merchant"
              label = true
              category << {label: label ? label.entity_name : "N/A"}
              data_amt_val << {label: "N/A", value: "N/A"}
              data_cnt_val << {label: "N/A", value: "N/A"}
            elsif params_type == "service"
              label = EntityDivision.where(assigned_code: info.division_code, active_status: true).order(created_at: :desc).first
              label_false = EntityDivision.where(assigned_code: info.division_code, active_status: false).order(created_at: :desc).first
              label_value = label ? label.division_name : label_false ? label_false.division_name : "N/A"
              data_amt_val << {label: label_value,
                               value: info.total_amt.to_s}
              data_cnt_val << {label: label_value,
                               value: info.total_count.to_s}
            else
              data_amt_val << {label: "N/A", value: "N/A"}
              data_cnt_val << {label: "N/A", value: "N/A"}
            end
            final_category = [{category: category}]
            final_amt_val = [{seriesname: series_name}, data: data_amt_val]
            final_cnt_val = [{seriesname: series_name}, data: data_cnt_val]
          end

        else
          break
        end
      end
    else
    end
    logger.info "================ Categories :: #{category.inspect}"
    logger.info "================ Data Amount Value :: #{data_amt_val.inspect}"
    logger.info "================ Data Count Value :: #{data_cnt_val.inspect}"
    logger.info "================ Final Categories :: #{final_category.inspect}"
    logger.info "================ Final Data Amount Value :: #{final_amt_val.inspect}"
    logger.info "================ Final Data Count Value :: #{final_cnt_val.inspect}"
    [final_category, final_amt_val, final_cnt_val]
  end


  def the_chart(dataset, y_axis, caption, render_id)
    num_prefix = y_axis == "Amount" ? "GHS " : ""

    Fusioncharts::Chart.new({
                                width: "600",
                                height: "400",
                                type: "mscolumn2d",
                                id: 'chart',
                                renderAt: "chart-container",
                                dataSource: {
                                    chart: {
                                        caption: caption,
                                        subCaption: "Merchant/Service",
                                        xAxisname: "Network",
                                        yAxisName: y_axis,
                                        numberPrefix: num_prefix,
                                        theme: "candy",
                                        exportEnabled: "1",
                                    },
                                    categories: [{
                                                     category: [
                                                         { label: "MTN" },
                                                         { label: "AIR" },
                                                         { label: "VOD" },
                                                         { label: "TIG" }
                                                     ]
                                                 }],
                                    dataset: dataset
                                }
                            })
  end

  def cnt_amt_summary(pay_success, pay_fail)
    if pay_success.exists?
      @payment_success_count = pay_success.count
      @payment_success_amount = pay_success.sum(:amount)
    else
      @payment_success_count = 0
      @payment_success_amount = 0.0
    end

    if pay_fail.exists?
      @payment_fail_count = pay_fail.count
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