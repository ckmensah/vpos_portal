class PaymentInfosController < ApplicationController
  before_action :set_payment_info, only: [:show, :transaction_resend, :resend_form]
  load_and_authorize_resource
  before_action :load_permissions
  require 'vpos_core'

  # GET /payment_infos
  # GET /payment_infos.json
  def index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    if params[:count].present?
      if params[:count] == "All"
        params[:count] = 10000000000000000
      else
       params[:count]
      end
    end

    @success_status = "000"
    #@payment_infos = PaymentReport.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
    if current_user.super_admin? || current_user.super_user?
      @activity_types = ActivityType.where(active_status: true).load_async
      @merchant_search = EntityInfo.where(active_status: true).order(entity_name: :asc).load_async
      @merchant_service_search = EntityDivision.where(active_status: true).order(division_name: :asc).load_async
      #@division_lovs = DivisionActivityLov.where(active_status: true).order(lov_desc: :asc)
      @division_lovs = DivisionActivityLov.select(:lov_desc).where(active_status: true).group(:lov_desc).order(lov_desc: :asc).load_async
      @menu_items = PaymentReport.joins("INNER JOIN entity_division ON payment_reports.entity_div_code = entity_division.assigned_code")
                        .select(:activity_main_code, :narration).where("active_status = true AND activity_type_code = 'CHC'")
                        .group(:activity_main_code, :narration).order(activity_main_code: :asc).load_async
      #@payment_infos = PaymentReport.where("split_part(trans_status, '/', 1) = '000'").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      @payment_infos = PaymentReport.where("processed = true").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc').load_async
      # @payment_infos = PaymentInfo.joins("left join payment_request on payment_info.id = payment_request.payment_info_id left join payment_callback on payment_request.processing_id = payment_callback.trans_ref left join division_activity_lov on payment_info.activity_lov_id = division_activity_lov.id")
      #                             .select("payment_info.id, payment_info.session_id, payment_info.entity_div_code, payment_info.activity_lov_id, payment_info.activity_div_id, payment_info.activity_sub_div_id, payment_info.activity_main_code, payment_info.processed as processed, payment_info.src,
      #                                      payment_info.created_at,payment_info.payment_mode,payment_info.amount,payment_info.customer_number,payment_info.customer_name,payment_info.recipient_number,
      #                                      payment_info.recipient_type,payment_info.recipient_email,payment_info.narration,payment_info.qty,payment_info.trans_type, payment_info.charge,
      #                                      payment_info.payment_option,payment_info.card_option, payment_info.nw, payment_request.processing_id, payment_request.service_id, payment_request.reference,
      #                                      payment_callback.trans_ref, payment_callback.nw_trans_id, payment_callback.trans_msg, payment_callback.trans_status, division_activity_lov.lov_desc")
      #                             .where("payment_info.processed = true").paginate(:page => params[:page], :per_page => params[:count]).order('payment_info.created_at desc').load_async
    elsif current_user.merchant_admin?
      @merchant_service_search = EntityDivision.where(active_status: true, entity_code: current_user.user_entity_code).order(division_name: :asc).load_async
      entity_div_id_str = "'0'"
      ref_div_id_str = "'0'"
      activity_type_str = "'0'"
      activity_type_arr = []
      @entity_divs = EntityDivision.where(entity_code: current_user.user_entity_code, active_status: true).load_async
      @entity_divs.each do |entity_div|
        entity_div_id_str << ",'#{entity_div.assigned_code}'"
        unless activity_type_arr.include?("'#{entity_div.activity_type_code}'")
          activity_type_arr << "'#{entity_div.activity_type_code}'"
          activity_type_str << ",'#{entity_div.activity_type_code}'"
        end
        if entity_div.activity_type_code == "CHC"
          ref_div_id_str << ",'#{entity_div.assigned_code}'"
        end
      end
      final_div_ids = "(#{entity_div_id_str})"
      final_ref_div_ids = "(#{ref_div_id_str})"
      final_activity_types = "(#{activity_type_str})"

      @activity_types = ActivityType.where("active_status = true AND assigned_code IN #{final_activity_types}").load_async
      #@references = PaymentReport.select(:reference).where("entity_div_code IN #{final_ref_div_ids}").group(:reference).order(reference: :asc)
      @menu_items = PaymentReport.joins("INNER JOIN entity_division ON payment_reports.entity_div_code = entity_division.assigned_code")
                        .select(:activity_main_code, :narration).where("entity_code = '#{current_user.user_entity_code}' AND active_status = true AND activity_type_code = 'CHC'")
                        .group(:activity_main_code, :narration).order(activity_main_code: :asc).load_async
      @division_lovs = DivisionActivityLov.select(:lov_desc).where("active_status = true AND division_code IN #{final_div_ids}").group(:lov_desc).order(lov_desc: :asc).load_async
      #@payment_infos = PaymentReport.where("split_part(trans_status, '/', 1) = '000' AND entity_div_code IN #{final_div_ids} ").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      @payment_infos = PaymentReport.where("processed = true AND entity_div_code IN #{final_div_ids} ").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc').load_async
      # @payment_infos = PaymentInfo.joins("left join payment_request on payment_info.id = payment_request.payment_info_id left join payment_callback on payment_request.processing_id = payment_callback.trans_ref left join division_activity_lov on payment_info.activity_lov_id = division_activity_lov.id")
      #                             .select("payment_info.id, payment_info.session_id, payment_info.entity_div_code, payment_info.activity_lov_id, payment_info.activity_div_id, payment_info.activity_sub_div_id, payment_info.activity_main_code, payment_info.processed, payment_info.src,
      #                                      payment_info.created_at,payment_info.payment_mode,payment_info.amount,payment_info.customer_number,payment_info.customer_name,payment_info.recipient_number,
      #                                      payment_info.recipient_type,payment_info.recipient_email,payment_info.narration,payment_info.qty,payment_info.trans_type, payment_info.charge,
      #                                      payment_info.payment_option,payment_info.card_option, payment_info.nw, payment_request.processing_id, payment_request.service_id, payment_request.reference,
      #                                      payment_callback.trans_ref, payment_callback.nw_trans_id, payment_callback.trans_msg, payment_callback.trans_status, division_activity_lov.lov_desc")
      #                             .where("payment_info.processed = true AND payment_info.entity_div_code IN #{final_div_ids}").paginate(:page => params[:page], :per_page => params[:count]).order('payment_info.created_at desc').load_async

    elsif current_user.merchant_service?
        entity_div_id_str = "'0'"
        @entity_divs = EntityDivision.where("entity_code = '#{current_user.user_entity_code}' and active_status = true")
        if @entity_divs.exists?
          @entity_divs.each do |entity_div|
            entity_div_id_str << ",'#{entity_div.assigned_code}'"
          end
        end
        final_div_ids = "(#{entity_div_id_str})"
        @division_lovs = DivisionActivityLov.select(:lov_desc).where("division_code IN #{final_div_ids}").group(:lov_desc).order(lov_desc: :asc).load_async
        #@references = PaymentReport.select(:reference).where("entity_div_code IN #{final_div_ids}").group(:reference).order(reference: :asc)
        @menu_items = PaymentReport.joins("INNER JOIN entity_division ON payment_reports.entity_div_code = entity_division.assigned_code")
                          .select(:activity_main_code, :narration).where("entity_div_code = '#{current_user.user_division_code}' AND active_status = true AND activity_type_code = 'CHC'")
                          .group(:activity_main_code, :narration).order(activity_main_code: :asc).load_async
        #@payment_infos = PaymentReport.where("split_part(trans_status, '/', 1) = '000' AND entity_div_code = '#{current_user.user_division_code}'").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
        @payment_infos = PaymentReport.where("processed = true AND entity_div_code = '#{current_user.user_division_code}'").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc').load_async
        # @payment_infos = PaymentInfo.joins("left join payment_request on payment_info.id = payment_request.payment_info_id left join payment_callback on payment_request.processing_id = payment_callback.trans_ref left join division_activity_lov on payment_info.activity_lov_id = division_activity_lov.id")
        #                             .select("payment_info.id, payment_info.session_id, payment_info.entity_div_code, payment_info.activity_lov_id, payment_info.activity_div_id, payment_info.activity_sub_div_id, payment_info.activity_main_code, payment_info.processed, payment_info.src,
        #                                      payment_info.created_at,payment_info.payment_mode,payment_info.amount,payment_info.customer_number,payment_info.customer_name,payment_info.recipient_number,
        #                                      payment_info.recipient_type,payment_info.recipient_email,payment_info.narration,payment_info.qty,payment_info.trans_type, payment_info.charge,
        #                                      payment_info.payment_option,payment_info.card_option, payment_info.nw, payment_request.processing_id, payment_request.service_id, payment_request.reference,
        #                                      payment_callback.trans_ref, payment_callback.nw_trans_id, payment_callback.trans_msg, payment_callback.trans_status, division_activity_lov.lov_desc")
        #                             .where("payment_info.processed = true AND payment_info.entity_div_code = '#{current_user.user_division_code}'").paginate(:page => params[:page], :per_page => params[:count]).order('payment_info.created_at desc').load_async


    elsif current_user.multi_merchant_admin?
      @merchant_service_search = EntityDivision.where(active_status: true, entity_code: current_user.multi_user_entity_code).order(division_name: :asc).load_async
      entity_div_id_str = "'0'"
      ref_div_id_str = "'0'"
      activity_type_str = "'0'"
      activity_type_arr = []
      @entity_divs = EntityDivision.where(entity_code: current_user.multi_user_entity_code, active_status: true).load_async
      @entity_divs.each do |entity_div|
        entity_div_id_str << ",'#{entity_div.assigned_code}'"
        unless activity_type_arr.include?("'#{entity_div.activity_type_code}'")
          activity_type_arr << "'#{entity_div.activity_type_code}'"
          activity_type_str << ",'#{entity_div.activity_type_code}'"
        end
        if entity_div.activity_type_code == "CHC"
          ref_div_id_str << ",'#{entity_div.assigned_code}'"
        end
      end
      final_div_ids = "(#{entity_div_id_str})"
      final_ref_div_ids = "(#{ref_div_id_str})"
      final_activity_types = "(#{activity_type_str})"

      @activity_types = ActivityType.where("active_status = true AND assigned_code IN #{final_activity_types}").load_async
      #@references = PaymentReport.select(:reference).where("entity_div_code IN #{final_ref_div_ids}").group(:reference).order(reference: :asc)
      @menu_items = PaymentReport.joins("INNER JOIN entity_division ON payment_reports.entity_div_code = entity_division.assigned_code")
                                 .select(:activity_main_code, :narration).where("entity_code = '#{current_user.user_entity_code}' AND active_status = true AND activity_type_code = 'CHC'")
                                 .group(:activity_main_code, :narration).order(activity_main_code: :asc).load_async
      @division_lovs = DivisionActivityLov.select(:lov_desc).where("active_status = true AND division_code IN #{final_div_ids}").group(:lov_desc).order(lov_desc: :asc).load_async
      #@payment_infos = PaymentReport.where("split_part(trans_status, '/', 1) = '000' AND entity_div_code IN #{final_div_ids} ").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      @payment_infos = PaymentReport.where("processed = true AND entity_div_code IN #{final_div_ids} ").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc').load_async


    end
    #logger.info "Report #{@payment_infos.inspect}"
  end



  def payment_info_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1
    if params[:count].present?
      if params[:count] == "All"
        params[:count] = 10000000000000000
      else
        params[:count]
      end
    end
    the_search = ""
    search_arr = []
    @entity_code = params[:entity_code]
    @code = params[:code]

    if params[:filter_main].present? || params[:source].present? || params[:entity_name].present? || params[:division_name].present? || params[:act_main_code].present? || params[:activity_type].present? || params[:lov_name].present? || params[:cust_num].present? || params[:trans_id].present? || params[:trans_type].present? || params[:nw].present? || params[:status].present? || params[:start_date].present? || params[:end_date].present?

      filter_params = params[:filter_main]
      if params[:filter_main].present?
        @entity_name = filter_params[:entity_name]
        @division_name = filter_params[:division_name]
        @act_main_code = filter_params[:act_main_code]
        @activity_type = filter_params[:activity_type]
        @lov_name = filter_params[:lov_name]
        @ref = filter_params[:ref]
        @cust_num = filter_params[:cust_num]
        @trans_id = filter_params[:trans_id]
        @trans_type = filter_params[:trans_type]
        @nw = filter_params[:nw]
        @status = filter_params[:status]
        @source = filter_params[:source]
        @start_date = filter_params[:start_date]
        @end_date = filter_params[:end_date]
        @s_time = filter_params[:s_time]
        @e_time = filter_params[:e_time]
        @a_download = filter_params[:a_download]
        params[:entity_name] = filter_params[:entity_name]
        params[:division_name] = filter_params[:division_name]
        params[:act_main_code] = filter_params[:act_main_code]
        params[:activity_type] = filter_params[:activity_type]
        params[:lov_name] = filter_params[:lov_name]
        params[:ref] = filter_params[:ref]
        params[:cust_num] = filter_params[:cust_num]
        params[:trans_id] = filter_params[:trans_id]
        params[:trans_type] = filter_params[:trans_type]
        params[:nw] = filter_params[:nw]
        params[:status] = filter_params[:status]
        params[:source] = filter_params[:source]
        params[:start_date] = filter_params[:start_date]
        params[:end_date] = filter_params[:end_date]
        params[:s_time] = filter_params[:s_time]
        params[:e_time] = filter_params[:e_time]
        params[:a_download] = filter_params[:a_download]
      else

        if  params[:entity_name].present? || params[:source].present? || params[:division_name].present? || params[:act_main_code].present? || params[:activity_type].present? || params[:lov_name].present? || params[:cust_num].present? || params[:trans_id].present? || params[:trans_type].present? || params[:nw].present? || params[:status].present? || params[:start_date].present? || params[:end_date].present?

          @entity_name = params[:entity_name]
          @division_name = params[:division_name]
          @act_main_code = params[:act_main_code]
          @activity_type = params[:activity_type]
          @lov_name = params[:lov_name]
          @ref = params[:ref]
          @cust_num = params[:cust_num]
          @trans_id = params[:trans_id]
          @trans_type = params[:trans_type]
          @nw = params[:nw]
          @status = params[:status]
          @source = params[:source]
          @start_date = params[:start_date]
          @end_date = params[:end_date]
          @s_time = filter_params[:s_time]
          @e_time = filter_params[:e_time]
          @a_download = params[:a_download]
          params[:entity_name] = @entity_name
          params[:division_name] = @division_name
          params[:act_main_code] = @act_main_code
          params[:activity_type] = @activity_type
          params[:lov_name] = @lov_name
          params[:ref] = @ref
          params[:cust_num] = @cust_num
          params[:trans_id] = @trans_id
          params[:trans_type] = @trans_type
          params[:nw] = @nw
          params[:status] = @status
          params[:source] = @source
          params[:start_date] = @start_date
          params[:end_date] = @end_date
          params[:s_time] = filter_params[:s_time]
          params[:e_time] = filter_params[:e_time]
          params[:a_download] = @a_download
        else
          params[:entity_name] = filter_params[:entity_name]
          params[:division_name] = filter_params[:division_name]
          params[:act_main_code] = filter_params[:act_main_code]
          params[:activity_type] = filter_params[:activity_type]
          params[:lov_name] = filter_params[:lov_name]
          params[:ref] = filter_params[:ref]
          params[:cust_num] = filter_params[:cust_num]
          params[:trans_id] = filter_params[:trans_id]
          params[:trans_type] = filter_params[:trans_type]
          params[:nw] = filter_params[:nw]
          params[:status] = filter_params[:status]
          params[:source] = filter_params[:source]
          params[:start_date] = filter_params[:start_date]
          params[:end_date] = filter_params[:end_date]
          params[:s_time] = filter_params[:s_time]
          params[:e_time] = filter_params[:e_time]
          params[:a_download] = filter_params[:a_download]
        end
      end

      if @entity_name.present?
        division_str = "'0'"
        #entity_str = "'0'"
        #@merchant = EntityInfo.where("LOWER(entity_name) LIKE '%#{@entity_name.downcase}%'")
        #@merchant.each { |entity_div| entity_str << ",'#{entity_div.assigned_code}'" } if @merchant.exists?
        #final_info_str = "(#{entity_str})"
        #@entity_divis = EntityDivision.where("entity_code IN #{final_info_str}")
        @entity_divis = EntityDivision.where("entity_code = '#{@entity_name}'")
        @entity_divis.each { |entity_div| division_str << ",'#{entity_div.assigned_code}'" } if @entity_divis.exists?
        final_div_str = "(#{division_str})"
        #logger.info "Final Div Str :: #{final_div_str.inspect} and Final INfo Str :: #{final_info_str}"
        search_arr << "entity_div_code IN #{final_div_str}"
      end

      if @division_name.present?
        #division_str = "'0'"
        #@entity_divis = EntityDivision.where("LOWER(division_name) LIKE '%#{@division_name.downcase}%'")
        #@entity_divis.each { |entity_div| division_str << ",'#{entity_div.assigned_code}'" } if @entity_divis.exists?
        #final_div_str = "(#{division_str})"
        #logger.info "Final Div Str :: #{final_div_str.inspect}"
        #search_arr << "entity_div_code IN #{final_div_str}"
        search_arr << "entity_div_code = '#{@division_name}'"
      end

      if @act_main_code.present?
        search_arr << "CASE WHEN narration IS NOT NULL THEN LOWER(activity_main_code) || ' ' || LOWER(narration) ELSE LOWER(activity_main_code) END = '#{@act_main_code.downcase}'"
      end

      if @activity_type.present?
        #activity_str = "'0'"
        div_str = "'0'"
        div_arr = []
        #@act_type = ActivityType.where("LOWER(assigned_code) LIKE '%#{@activity_type.downcase}%'")
        #@act_type.each { |act_type| activity_str << ",'#{act_type.assigned_code}'" } if @act_type.exists?
        #final_act_str = "(#{activity_str})"
        #@entity_divisi = EntityDivision.where("activity_type_code IN #{final_act_str}")
        #@entity_divisi.each { |entity_div| div_str << ",'#{entity_div.assigned_code}'" } if @entity_divisi.exists?

        if current_user.super_admin? || current_user.super_user?
          @entity_divisi = EntityDivision.where(active_status: true, activity_type_code: @activity_type).load_async
        elsif current_user.merchant_admin?
          @entity_divisi = EntityDivision.where(active_status: true, activity_type_code: @activity_type, entity_code: current_user.user_entity_code).load_async
        end
        logger.info "=======================&&&&&&&&&&&&&&&&&&&&&&&=============================="
        logger.info "Entity service object :: #{@entity_divisi.inspect}"
        if @entity_divisi.exists?
          @entity_divisi.each do |entity_div|
            unless div_arr.include?("'#{entity_div.assigned_code}'")
              div_arr << "'#{entity_div.assigned_code}'"
              div_str << ",'#{entity_div.assigned_code}'"
            end
          end
        end

        f_div_str = "(#{div_str})"
        logger.info "Final Act Str :: #{f_div_str.inspect}"
        search_arr << "entity_div_code IN #{f_div_str}"
      end


      if @lov_name.present?
        lov_str = "'0'"
        #pay_lov_str = "'0'"
        @div_lov = DivisionActivityLov.where("LOWER(lov_desc) LIKE '%#{@lov_name.downcase}%'")
        @div_lov.each { |div_lov| lov_str << ",'#{div_lov.id}'" } if @div_lov.exists?
        final_lov_str = "(#{lov_str})"
        #@entity_divisi = EntityDivision.where("activity_type_code IN #{final_lov_str}")
        #@entity_divisi.each { |entity_div| pay_lov_str << ",'#{entity_div.assigned_code}'" } if @entity_divisi.exists?
        #f_lov_str = "(#{pay_lov_str})"
        logger.info "Final Lov Str :: #{final_lov_str.inspect}"
        search_arr << "activity_lov_id IN #{final_lov_str}"
        #search_arr << "activity_lov_id = #{@lov_name}"
      end


      if @ref.present?
        search_arr << "LOWER(reference) LIKE '%#{@ref.downcase}%'"
      end


      if @cust_num.present?
        search_arr << "customer_number LIKE '%#{@cust_num}%'"
      end

      if @trans_id.present?
        search_arr << "processing_id LIKE '%#{@trans_id}%'"
      end

      if @nw.present?
        search_arr << "LOWER(nw) LIKE '%#{@nw.downcase}%'"
      end

      if @trans_type.present?
        search_arr << "trans_type = '#{@trans_type}'"
      end

      if @source.present?
        search_arr << "src = '#{@source}'"
      end

      if @status.present?
        if @status == "000"
          search_arr << "processed = true"
          #search_arr << "processed IS NULL"
        elsif @status == "001"
          search_arr << "processed = false"
        else
          #search_arr << "split_part(trans_status, '/', 1) = '#{@status}'"
          search_arr << "processed IS NULL"
        end
      else
        #search_arr << "split_part(trans_status, '/', 1) = '000'"
      end

      if (@start_date.present? && @end_date.present?)
        # f_start_date =  @start_date.to_time.strftime("%Y-%m-%dT%H:%M") # Date.strptime(@start_date, '%m/%d/%Y') # @start_date.to_date.strftime('%Y-%m-%d')
        # f_end_date = @end_date.to_time.strftime("%Y-%m-%dT%H:%M")
        # f_start_date =  @start_date.to_date.strftime("%Y-%m-%d") # Date.strptime(@start_date, '%m/%d/%Y') # @start_date.to_date.strftime('%Y-%m-%d')
        # f_end_date = @end_date.to_date.strftime("%Y-%m-%d") # Date.strptime(@end_date, '%m/%d/%Y') # @end_date.to_date.strftime('%Y-%m-%d')
        f_start_date = Date.parse(@start_date).beginning_of_day
        f_end_date = Date.parse(@end_date).end_of_day
        if f_start_date <= f_end_date
          # search_arr << "created_at BETWEEN '#{f_start_date} ' AND '#{f_end_date}'"
          search_arr << "created_at BETWEEN '#{f_start_date}' AND '#{f_end_date}'"
        else
          search_arr << "created_at IS NULL"
        end
      end

      if @start_date.present?
        start_datetime = Time.zone.parse("#{@start_date}").beginning_of_day
        search_arr << "created_at >= '#{start_datetime}'"
      end

      if @end_date.present?.present?
        end_datetime = Time.zone.parse("#{@end_date}").end_of_day
        search_arr << "created_at <= '#{end_datetime}'"
      end

      if @s_time.present?
        start_time = Time.zone.parse("#{Date.today} #{@s_time}")
        search_arr << "created_at::time >= '#{start_time.strftime("%H:%M:%S")}'"
      end

      if @e_time.present?
        end_time = Time.zone.parse("#{Date.today} #{@e_time}")
        search_arr << "created_at::time <= '#{end_time.strftime("%H:%M:%S")}'"
      end

      if (@start_date.present? && (@s_time.present? || @etime.present?))
         f_start_date =  @start_date.to_date.strftime("%Y-%m-%d")
          if (f_start_date && @s_time.present?)
            search_arr << "created_at >= '#{f_start_date} #{@s_time}'"
          elsif (f_start_date && @e_time.present?)
            search_arr << "created_at >= '#{f_start_date} #{@e_time}'"
          end
      end

      if (@start_date.present? && (@s_time.present? && @etime.present?))
        f_start_date =  @start_date.to_date.strftime("%Y-%m-%d")
        if f_start_date && (@s_time <= @e_time)
            search_arr << "created_at BETWEEN '#{f_start_date} #{@s_time}' AND '#{f_start_date} #{@e_time}'"
        end
      end

      if (@end_date.present? && (@s_time.present? || @etime.present?))
       f_end_date =  @end_date.to_date.strftime("%Y-%m-%d")
        if (f_end_date && @s_time.present?)
          search_arr << "created_at <= '#{f_end_date} #{@s_time}'"
        elsif (f_end_date && @e_time.present?)
          search_arr << "created_at <= '#{f_end_date} #{@e_time}'"
        end
      end

      if (@end_date.present? && (@s_time.present? && @etime.present?))
      f_end_date =  @end_date.to_date.strftime("%Y-%m-%d")
        if f_end_date && (@s_time <= @e_time)
          search_arr << "created_at BETWEEN '#{f_end_date} #{@s_time}' AND '#{f_end_date} #{@e_time}'"
        end
      end

      if (@start_date.present? && @end_date.present? && @s_time.present? && @etime.present?)
        f_start_date =  @start_date.to_date.strftime("%Y-%m-%d")
        f_end_date = @end_date.to_date.strftime("%Y-%m-%d")
        if (f_start_date <= f_end_date) && (@s_time <= @e_time)
          search_arr << "created_at BETWEEN '#{f_start_date} #{@s_time}' AND '#{f_end_date} #{@e_time}'"
        end
      end

      if (@start_date.present? && @end_date.present? && (@s_time.present? || @etime.present?))
        f_start_date =  @start_date.to_date.strftime("%Y-%m-%d")
        f_end_date = @end_date.to_date.strftime("%Y-%m-%d")
        if f_start_date <= f_end_date && @s_time.present?
          search_arr << "created_at BETWEEN '#{f_start_date} #{@s_time}' AND '#{f_end_date} 23:59:59'"
        elsif f_start_date <= f_end_date && @e_time.present?
          search_arr << "created_at BETWEEN '#{f_start_date} 00:00:00' AND '#{f_end_date} #{@e_time}'"
        end
      end

      # if @start_date.present?
      #   f_start_date =  @start_date.to_date.strftime("%Y-%m-%d") # Date.strptime(@start_date, '%m/%d/%Y') # @start_date.to_date.strftime('%Y-%m-%d')
      #   if f_start_date
      #     search_arr << "created_at >= '#{f_start_date} 00:00:00'"
      #   else
      #     search_arr << "created_at IS NULL"
      #   end
      #
      # elsif (@start_date.present? && @end_date.present?)
      #   f_start_date =  @start_date.to_date.strftime("%Y-%m-%d") # Date.strptime(@start_date, '%m/%d/%Y') # @start_date.to_date.strftime('%Y-%m-%d')
      #   f_end_date = @end_date.to_date.strftime("%Y-%m-%d") # Date.strptime(@end_date, '%m/%d/%Y') # @end_date.to_date.strftime('%Y-%m-%d')
      #
      #   if f_start_date <= f_end_date
      #     search_arr << "created_at BETWEEN '#{f_start_date} 00:00:00' AND '#{f_end_date} 23:59:59'"
      #   else
      #     search_arr << "created_at IS NULL"
      #   end
      #
      #
      # elsif @start_date.present? && (@s_time.present? || @etime.present?)
      #    f_start_date =  @start_date.to_date.strftime("%Y-%m-%d")
      #     if f_start_date && @s_time.present?
      #       search_arr << "created_at >= '#{f_start_date} #{@s_time}'"
      #     elsif f_start_date && @e_time.present?
      #       search_arr << "created_at >= '#{f_start_date} #{@e_time}'"
      #     elsif f_start_date && (@s_time <= @e_time)
      #       search_arr << "created_at BETWEEN '#{f_start_date} #{@s_time}' AND '#{f_start_date} #{@e_time}'"
      #     end
      # elsif @end_date.present?
      #   f_end_date = @end_date.to_date.strftime("%Y-%m-%d") # Date.strptime(@end_date, '%m/%d/%Y') # @end_date.to_date.strftime('%Y-%m-%d')
      #   if f_end_date
      #     search_arr << "created_at <= '#{f_end_date} 23:59:59'"
      #   else
      #     search_arr << "created_at IS NULL"
      #   end
      # elsif @end_date.present? && (@s_time.present? || @etime.present?)
      #   if f_end_date && @s_time.present?
      #     search_arr << "created_at <= '#{f_end_date} #{@s_time}'"
      #   elsif f_end_date && @e_time.present?
      #     search_arr << "created_at <= '#{f_end_date} #{@e_time}'"
      #   elsif f_end_date && (@s_time <= @e_time)
      #     search_arr << "created_at BETWEEN '#{f_end_date} #{@s_time}' AND '#{f_end_date} #{@e_time}'"
      #   end
      #
      # elsif  @start_date.present? && @end_date.present? && (@s_time.present? || @etime.present?)
      #   if f_start_date <= f_end_date && @s_time.present?
      #     search_arr << "created_at BETWEEN '#{f_start_date} #{@s_time}' AND '#{f_end_date} 23:59:59'"
      #   elsif f_start_date <= f_end_date && @e_time.present?
      #     search_arr << "created_at BETWEEN '#{f_start_date} 00:00:00' AND '#{f_end_date} #{@e_time}'"
      #   elsif f_start_date <= f_end_date && (@s_time <= @e_time)
      #     search_arr << "created_at BETWEEN '#{f_start_date} #{@s_time}' AND '#{f_end_date} #{@e_time}'"
      #   end
      # end
      logger.info "Values :: #{filter_params.inspect}"
    else
      #logger.info "====================================================================="
      #logger.info "ALL SHALL PASS......"
      #search_arr << "split_part(trans_status, '/', 1) = '000'"
    end
    logger.info "====================================================================="
    logger.info "A DOWNLOAD DISPLAY string :: #{params["a_download"].inspect} and symbol :: #{params[:a_download].inspect}"
    if params[:filter_main].present?
      logger.info "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
      logger.info "WHEN THERE IS FILTER, THE RESULT SHOULD BE ALL STATUSES UNLESS STATED OTHERWISE......"
    else

      logger.info "====================================================================="
      logger.info "WHEN THERE IS NO FILTER, THE RESULT SHOULD BE ONLY SUCCESSES......"
      if params["a_download"] == "a_download"
        logger.info "====================================================================="
        logger.info "There is a download after filtering. ==============================="
      else
        logger.info "====================================================================="
        logger.info "There is a download without any filtering. =========================="
        #search_arr << "split_part(trans_status, '/', 1) = '000'"
        search_arr << "processed = true"
      end
    end

    the_search = search_arr.join(" AND ")

    #@reports = Report.where(the_search).paginate(:page => page, :per_page => params[:count]).order(date: :desc)

    logger.info "The search array :: #{search_arr.inspect}"
    logger.info "The Search :: #{the_search.inspect}"

    if current_user.super_admin? || current_user.super_user?
      @activity_types = ActivityType.where(active_status: true).load_async
      @merchant_search = EntityInfo.where(active_status: true).order(entity_name: :asc).load_async
      @merchant_service_search = EntityDivision.where(active_status: true).order(division_name: :asc).load_async
      @division_lovs = DivisionActivityLov.select(:lov_desc).where(active_status: true).group(:lov_desc).order(lov_desc: :asc).load_async
      #@references = PaymentReport.select(:reference).group(:reference).order(reference: :asc)
      @menu_items = PaymentReport.joins("INNER JOIN entity_division ON payment_reports.entity_div_code = entity_division.assigned_code")
                        .select(:activity_main_code, :narration).where("active_status = true AND activity_type_code = 'CHC'")
                        .group(:activity_main_code, :narration).order(activity_main_code: :asc).load_async
      if params[:count] == "All"
        @payment_infos = PaymentReport.where(the_search).paginate(:page => params[:page], :per_page => 10000000000000000).order('created_at desc').load_async
        # @payment_infos = PaymentInfo.payments_join_2.where(the_search).paginate(:page => params[:page], :per_page => 10000000000000000).order('created_at desc').load_async
        # @payment_infos = PaymentInfo.payments_join_3.where(the_search).paginate(:page => params[:page], :per_page => 10000000000000000).order('created_at desc').load_async
      else
        @payment_infos = PaymentReport.where(the_search).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc').load_async
        # @payment_infos = PaymentInfo.payments_join_2.where(the_search).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc').load_async
        # @payment_infos = PaymentInfo.payments_join_3.where(the_search).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc').load_async

      end

    elsif current_user.merchant_admin?
      @merchant_service_search = EntityDivision.where(active_status: true, entity_code: current_user.user_entity_code).order(division_name: :asc).load_async.load_async
      entity_div_id_str = "'0'"
      activity_type_str = "'0'"
      activity_type_arr = []
      @entity_divs = EntityDivision.where(entity_code: current_user.user_entity_code, active_status: true).load_async.load_async
      @entity_divs.each do |entity_div|
        entity_div_id_str << ",'#{entity_div.assigned_code}'"
        unless activity_type_arr.include?("'#{entity_div.activity_type_code}'")
          activity_type_arr << "'#{entity_div.activity_type_code}'"
          activity_type_str << ",'#{entity_div.activity_type_code}'"
        end
      end
      final_div_ids = "(#{entity_div_id_str})"
      final_activity_types = "(#{activity_type_str})"

      @division_lovs = DivisionActivityLov.select(:lov_desc).where("active_status = true AND division_code IN #{final_div_ids}").group(:lov_desc).order(lov_desc: :asc).load_async
      @references = PaymentReport.select(:reference).where("division_code IN #{final_div_ids}").group(:reference).order(reference: :asc).load_async
      @activity_types = ActivityType.where("active_status = true AND assigned_code IN #{final_activity_types}").load_async
      #@references = PaymentReport.select(:reference).where("entity_div_code IN #{final_div_ids}").group(:reference).order(reference: :asc)
      @main_items = PaymentReport.joins("INNER JOIN entity_division ON payment_reports.entity_div_code = entity_division.assigned_code")
                        .select(:activity_main_code, :narration).where("entity_code = '#{current_user.user_entity_code}' AND active_status = true AND activity_type_code = 'CHC'")
                        .group(:activity_main_code, :narration).order(activity_main_code: :asc).load_async
      if params[:count] == "All"
        @payment_infos = PaymentReport.where("entity_div_code IN #{final_div_ids}").where(the_search).paginate(:page => params[:page], :per_page => 10000000000000000).order('created_at desc').load_async
        # @payment_infos = PaymentInfo.payments_join_2.where("entity_div_code IN #{final_div_ids}").where(the_search).paginate(:page => params[:page], :per_page => 10000000000000000).order('created_at desc').load_async
        # @payment_infos = PaymentInfo.payments_join_3.where("entity_div_code IN #{final_div_ids}").where(the_search).paginate(:page => params[:page], :per_page => 10000000000000000).order('created_at desc').load_async

      else
        @payment_infos = PaymentReport.where("entity_div_code IN #{final_div_ids}").where(the_search).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc').load_async
        # @payment_infos = PaymentInfo.payments_join_2.where("entity_div_code IN #{final_div_ids}").where(the_search).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc').load_async
        # @payment_infos = PaymentInfo.payments_join_3.where("entity_div_code IN #{final_div_ids}").where(the_search).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc').load_async

      end
    elsif current_user.merchant_service?
      @division_lovs = DivisionActivityLov.select(:lov_desc).where("active_status = true AND division_code = '#{current_user.user_division_code}'").group(:lov_desc).order(lov_desc: :asc).load_async
      #@references = PaymentReport.select(:reference).where("division_code = '#{current_user.user_division_code}'").group(:reference).order(reference: :asc)
      #@references = PaymentReport.select(:reference).where("entity_div_code = '#{current_user.user_division_code}'").group(:reference).order(reference: :asc)
      @main_items = PaymentReport.joins("INNER JOIN entity_division ON payment_reports.entity_div_code = entity_division.assigned_code")
                        .select(:activity_main_code, :narration).where("entity_div_code = '#{current_user.user_division_code}' AND active_status = true AND activity_type_code = 'CHC'")
                        .group(:activity_main_code, :narration).order(activity_main_code: :asc).load_async
      if params[:count] == "All"
        @payment_infos = PaymentReport.where(entity_div_code: current_user.user_division_code).where(the_search).paginate(:page => params[:page], :per_page => 10000000000000000).order('created_at desc').load_async
        # @payment_infos = PaymentInfo.payments_join_2.where(entity_div_code: current_user.user_division_code).where(the_search).paginate(:page => params[:page], :per_page => 10000000000000000).order('created_at desc').load_async
        # @payment_infos = PaymentInfo.payments_join_3.where(entity_div_code: current_user.user_division_code).where(the_search).paginate(:page => params[:page], :per_page => 10000000000000000).order('created_at desc').load_async

      else
        @payment_infos = PaymentReport.where(entity_div_code: current_user.user_division_code).where(the_search).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc').load_async
        # @payment_infos = PaymentInfo.payments_join_2.where(entity_div_code: current_user.user_division_code).where(the_search).paginate(:page => params[:page], :per_page => 10000000000000000).order('created_at desc').load_async
        # @payment_infos = PaymentInfo.payments_join_3.where(entity_div_code: current_user.user_division_code).where(the_search).paginate(:page => params[:page], :per_page => 10000000000000000).order('created_at desc').load_async

      end
    elsif current_user.multi_merchant_admin?
      @merchant_service_search = EntityDivision.where("active_status = true and entity_code IN #{current_user.multi_user_entity_code}").order(division_name: :asc).load_async
      entity_div_id_str = "'0'"
      ref_div_id_str = "'0'"
      activity_type_str = "'0'"
      activity_type_arr = []
      @entity_divs = EntityDivision.where("entity_code IN #{current_user.multi_user_entity_code} and active_status = true").load_async
      @entity_divs.each do |entity_div|
        entity_div_id_str << ",'#{entity_div.assigned_code}'"
        unless activity_type_arr.include?("'#{entity_div.activity_type_code}'")
          activity_type_arr << "'#{entity_div.activity_type_code}'"
          activity_type_str << ",'#{entity_div.activity_type_code}'"
        end
        if entity_div.activity_type_code == "CHC"
          ref_div_id_str << ",'#{entity_div.assigned_code}'"
        end
      end
      final_div_ids = "(#{entity_div_id_str})"
      final_ref_div_ids = "(#{ref_div_id_str})"
      final_activity_types = "(#{activity_type_str})"

      @activity_types = ActivityType.where("active_status = true AND assigned_code IN #{final_activity_types}").load_async
      #@references = PaymentReport.select(:reference).where("entity_div_code IN #{final_ref_div_ids}").group(:reference).order(reference: :asc)
      @menu_items = PaymentReport.joins("INNER JOIN entity_division ON payment_reports.entity_div_code = entity_division.assigned_code")
                                 .select(:activity_main_code, :narration).where("entity_code IN '#{current_user.multi_user_entity_code}' AND active_status = true AND activity_type_code = 'CHC'")
                                 .group(:activity_main_code, :narration).order(activity_main_code: :asc).load_async
      @division_lovs = DivisionActivityLov.select(:lov_desc).where("active_status = true AND division_code IN #{final_div_ids}").group(:lov_desc).order(lov_desc: :asc).load_async
      #@payment_infos = PaymentReport.where("split_part(trans_status, '/', 1) = '000' AND entity_div_code IN #{final_div_ids} ").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      @payment_infos = PaymentReport.where("processed = true AND entity_div_code IN #{final_div_ids} ").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc').load_async

    end

    respond_to do |format|
      format.js
      logger.info "===================================================="
      logger.info "Activity type is :: #{@activity_type.inspect}"
      if @activity_type.present?
        format.html {render status: :ok, json: @payment_infos.organize()}
        format.csv { send_data @payment_infos.to_csv(@payment_infos, current_user, @activity_type), :filename => "transaction_report.csv" }
        format.xls { send_data @payment_infos.to_csv(@payment_infos, current_user, @activity_type, col_sep: "\t"), :filename => "transaction_report.xls" }
      else
        @activity_type = ""
        format.html {render status: :ok, json: @payment_infos.organize()}
        format.csv { send_data @payment_infos.to_csv(@payment_infos, current_user, @activity_type), :filename => "transaction_report.csv" }
        format.xls { send_data @payment_infos.to_csv(@payment_infos, current_user, @activity_type, col_sep: "\t"), :filename => "transaction_report.xls" }
      end

    end

    #logger.info "Report #{@payment_infos.inspect}"
  end






  def financial_index
    @finance_stat = PaymentInfo.new

    if current_user.super_admin? || current_user.super_user?
      @entity_infos = EntityInfo.where(active_status: true).order(entity_name: :asc)
      @entity_divisions = EntityDivision.where(active_status: true).order(division_name: :asc)
    elsif current_user.merchant_admin?
      @entity_divisions = EntityDivision.where(entity_code: current_user.user_entity_code, active_status: true).order(division_name: :asc)
    elsif current_user.merchant_service?
      #@financial_statement = PaymentReport.select("trans_type, narration, date, sum(amount) AS amount").where("entity_div_code = '#{current_user.user_division_code}'").group("trans_type, narration, date").order(date: :asc)
    end

  end




  def financial_statement_index
    #@finance_stat = PaymentInfo.new(payment_info_params)
    @entity_name = params[:the_merchant] # @finance_stat.the_merchant
    @division_name = params[:the_service] # @finance_stat.the_service
    @start_date = params[:the_start_date] # @finance_stat.the_start_date
    @end_date = params[:the_end_date] # @finance_stat.the_end_date

    the_search = ""
    search_arr = ["trans_type in ('CTM','CNC','CNP','CNE','CNL','CAN','CNS','BTP','BTE','BTS','BTA','BTL')"] #["processed = true"] # ["split_part(trans_status, '/', 1) = '000'"]
    search_fund_arr = ["trans_type in ('CTB','DNC','CTW','DNP','DNE','DNL','DNA','DNS','PTB','PTW','ETW','ETB','MTC') AND processed = true"]

    if @entity_name.present?
      division_str = "'0'"
      division_arr = []
      @entity_divis = EntityDivision.where("entity_code = '#{@entity_name}'")
      if @entity_divis.exists?
        @entity_divis.each do |entity_div|
          unless division_arr.include?("'#{entity_div.assigned_code}'")
            division_str << ",'#{entity_div.assigned_code}'"
            division_arr << "'#{entity_div.assigned_code}'"
          end
        end
      end
      final_div_str = "(#{division_str})"
      #logger.info "Final Div Str :: #{final_div_str.inspect} and Final INfo Str :: #{final_info_str}"
      search_arr << "entity_div_code IN #{final_div_str}"
      search_fund_arr << "entity_div_code IN #{final_div_str}"
    end

    if @division_name.present?
      search_arr << "entity_div_code = '#{@division_name}'"
      search_fund_arr << "entity_div_code = '#{@division_name}'"
    end

    if @start_date.present? && @end_date.present?
      f_start_date =  @start_date.to_date.strftime('%Y-%m-%d') # Date.strptime(@start_date, '%m/%d/%Y') # @start_date.to_date.strftime('%Y-%m-%d')
      f_end_date = @end_date.to_date.strftime('%Y-%m-%d') # Date.strptime(@end_date, '%m/%d/%Y') # @end_date.to_date.strftime('%Y-%m-%d')
      if f_start_date <= f_end_date
        search_arr << "created_at BETWEEN '#{f_start_date} 00:00:00' AND '#{f_end_date} 23:59:59'"
        search_fund_arr << "created_at BETWEEN '#{f_start_date} 00:00:00' AND '#{f_end_date} 23:59:59'"
      end
    end

    the_search = search_arr.join(" AND ")
    the_search_fund = search_fund_arr.join(" AND ")

    logger.info "The search array :: #{search_arr.inspect}"
    logger.info "The Search :: #{the_search.inspect}"

    if current_user.super_admin? || current_user.super_user?

      @entity_infos = EntityInfo.where(active_status: true).order(entity_name: :asc)
      @entity_divisions = EntityDivision.where(active_status: true).order(division_name: :asc)

      @financial_statement = EntityServiceAccountTrxn.wallet_join.where(the_search).group("trans_type, date").order(date: :asc)
      #@credit_obj = EntityServiceAccountTrxn.find_by_sql("select actual_amt from (select sum(net_bal_aft - net_bal_bef) actual_amt from entity_service_account_trxn where #{the_search}) AS service_acc_amt")
      @credit_obj = EntityServiceAccountTrxn.find_by_sql("select sum(net_bal_aft - net_bal_bef) actual_amt from entity_service_account_trxn where #{the_search}")[0]
      @credit_total = @credit_obj.actual_amt
      @fund_moves = FundMovement.select("trans_type, narration, to_char(created_at, 'YYYY-MM-DD') AS date, sum(amount) AS amt")
      @fund_movements = @fund_moves.where(the_search_fund).group("trans_type, narration, date").order(date: :asc)
      @service_name = @division_name.present? ? "('#{@division_name}')" : "('0')"
      @debit_obj = FundMovement.select("amount").where(the_search_fund)
      @debit_total = @debit_obj.sum(:amount)
      @balance_bf, @closing_bal = EntityServiceAccountTrxn.closing_bal_n_bbf(@start_date, @end_date, @division_name)
      logger.info "================== 1st BALANCE B/F :: #{number_to_currency(@balance_bf, unit: "GHS ", precision: 3)}"
      logger.info "================== 1st CLOSING BAL :: #{number_to_currency(@closing_bal, unit: "GHS ", precision: 3)}"
      logger.info "================== Credit Total :: #{number_to_currency(@credit_total, unit: "GHS ", precision: 3)} and Debit Total :: #{number_to_currency(@debit_total, unit: "GHS ", precision: 3)}"
    elsif current_user.merchant_admin?
      entity_div_id_str = "'0'"
      entity_div_id_arr = []
      @entity_divs = EntityDivision.where(entity_code: current_user.user_entity_code, active_status: true)
      @entity_divs.each do |entity_div|
        unless entity_div_id_arr.include?("'#{entity_div.assigned_code}'")
          entity_div_id_str << ",'#{entity_div.assigned_code}'"
          entity_div_id_arr << "'#{entity_div.assigned_code}'"
        end
      end
      final_div_ids = "(#{entity_div_id_str})"
      logger.info "Final Div IDs :: #{final_div_ids.inspect}"

      @entity_divisions = EntityDivision.where(entity_code: current_user.user_entity_code, active_status: true).order(division_name: :asc)
      @financial_statement = EntityServiceAccountTrxn.wallet_join.where("entity_div_code IN #{final_div_ids}").where(the_search).group("trans_type, date").order(date: :asc)
      @credit_obj = EntityServiceAccountTrxn.find_by_sql("select sum(net_bal_aft - net_bal_bef) actual_amt from entity_service_account_trxn where #{the_search}")[0]
      @credit_total = @credit_obj.actual_amt
      @fund_moves = FundMovement.select("trans_type, narration, to_char(created_at, 'YYYY-MM-DD') AS date, sum(amount) AS amt")
      @fund_movements = @fund_moves.where("entity_div_code IN #{final_div_ids}").where(the_search_fund).group("trans_type, narration, date").order(date: :asc)
      @service_name = @division_name.present? ? "('#{@division_name}')" : final_div_ids
      @debit_obj = FundMovement.select("amount").where("entity_div_code IN #{final_div_ids}").where(the_search_fund)
      @debit_total = @debit_obj.sum(:amount)
      @balance_bf, @closing_bal = EntityServiceAccountTrxn.closing_bal_n_bbf(@start_date, @end_date, @division_name)
      logger.info "================== MERCHANT 1st BALANCE B/F :: #{number_to_currency(@balance_bf, unit: "GHS ", precision: 3)}"
      logger.info "================== MERCHANT 1st CLOSING BAL :: #{number_to_currency(@closing_bal, unit: "GHS ", precision: 3)}"
      logger.info "================== MERCHANT Credit Total :: #{number_to_currency(@credit_total, unit: "GHS ", precision: 3)} and Debit Total :: #{number_to_currency(@debit_total, unit: "GHS ", precision: 3)}"

    elsif current_user.merchant_service?
      @division_name = current_user.user_division_code
      @financial_statement = EntityServiceAccountTrxn.wallet_join.where("entity_div_code = '#{current_user.user_division_code}'").where(the_search).group("trans_type, date").order(date: :asc)
      @credit_obj = EntityServiceAccountTrxn.find_by_sql("select sum(net_bal_aft - net_bal_bef) actual_amt from entity_service_account_trxn where #{the_search}")[0]
      @credit_total = @credit_obj.actual_amt
      @fund_moves = FundMovement.select("trans_type, narration, to_char(created_at, 'YYYY-MM-DD') AS date, sum(amount) AS amt")
      @fund_movements = @fund_moves.where("entity_div_code = '#{current_user.user_division_code}'").where(the_search_fund).group("trans_type, narration, date").order(date: :asc)
      @service_name = "('#{current_user.user_division_code}')"
      @debit_obj = FundMovement.select("amount").where("entity_div_code = '#{current_user.user_division_code}'").where(the_search_fund)
      @debit_total = @debit_obj.sum(:amount)
      @balance_bf, @closing_bal = EntityServiceAccountTrxn.closing_bal_n_bbf(@start_date, @end_date, current_user.user_division_code)
      logger.info "================== SERVICE 1st BALANCE B/F :: #{number_to_currency(@balance_bf, unit: "GHS ", precision: 3)}"
      logger.info "================== SERVICE 1st CLOSING BAL :: #{number_to_currency(@closing_bal, unit: "GHS ", precision: 3)}"
      logger.info "================== SERVICE Credit Total :: #{number_to_currency(@credit_total, unit: "GHS ", precision: 3)} and Debit Total :: #{number_to_currency(@debit_total, unit: "GHS ", precision: 3)}"
    end

    respond_to do |format|
      if current_user.merchant_service?
        if @start_date.present? && @end_date.present?
          @div_obj = EntityDivision.where(assigned_code: current_user.user_division_code, active_status: true).order(created_at: :desc).first
          @div_name = @div_obj ? @div_obj.division_name : ""
          format.js { render :financial_statement_index }
          format.csv { send_data @financial_statement.to_finance_csv(@financial_statement, @fund_movements, @fund_moves, @service_name, @balance_bf), :filename => "financial_statement.csv" }
          format.xls { send_data @financial_statement.to_finance_csv(@financial_statement, @fund_movements, @fund_moves, @service_name, @balance_bf, col_sep: "\t"), :filename => "financial_statement.xls" }
          format.pdf do
            pdf = FinancialStatementPdf.new(@financial_statement, @fund_movements, @fund_moves, @service_name, @balance_bf, @closing_bal, @debit_total, @credit_total, @div_name, @start_date, @end_date, logger, :page_size => "A4", :page_layout => :landscape, top_margin: 30, bottom_margin: 70)
            send_data pdf.render, filename: 'financial_statement.pdf', type: 'application/pdf'
          end
        end
      else
        if (@entity_name.present? || @division_name.present?) && (@start_date.present? && @end_date.present?)
          @div_obj = EntityDivision.where(assigned_code: @division_name, active_status: true).order(created_at: :desc).first
          @div_name = @div_obj ? @div_obj.division_name : ""
          format.js { render :financial_statement_index }
          format.csv { send_data @financial_statement.to_finance_csv(@financial_statement, @fund_movements, @fund_moves, @service_name, @balance_bf), :filename => "financial_statement.csv" }
          format.xls { send_data @financial_statement.to_finance_csv(@financial_statement, @fund_movements, @fund_moves, @service_name, @balance_bf, col_sep: "\t"), :filename => "financial_statement.xls" }
          format.pdf do
            pdf = FinancialStatementPdf.new(@financial_statement, @fund_movements, @fund_moves, @service_name, @balance_bf, @closing_bal, @debit_total, @credit_total, @div_name, @start_date, @end_date, logger, :page_size => "A4", :page_layout => :landscape, top_margin: 30, bottom_margin: 70)
            send_data pdf.render, filename: 'financial_statement.pdf', type: 'application/pdf'
          end

        end
      end

    end
  end


  def financial_form
    @finance_stat = PaymentInfo.new
    if current_user.super_admin? || current_user.super_user?
      @entity_infos = EntityInfo.where(active_status: true).order(entity_name: :asc)
      @entity_divisions = EntityDivision.where(active_status: true).order(division_name: :asc)
    elsif current_user.merchant_admin?
      @entity_divisions = EntityDivision.where(entity_code: current_user.user_entity_code, active_status: true).order(division_name: :asc)
    elsif current_user.merchant_service?
      #@financial_statement = PaymentReport.select("trans_type, narration, date, sum(amount) AS amount").where("entity_div_code = '#{current_user.user_division_code}'").group("trans_type, narration, date").order(date: :asc)
    end
  end


  def financial_search
    @finance_stat = PaymentInfo.new(payment_info_params)
    @entity_name = @finance_stat.the_merchant
    @division_name = @finance_stat.the_service
    @start_date = @finance_stat.the_start_date
    @end_date = @finance_stat.the_end_date
    the_search = ""
    search_arr = ["processed = true"] # ["split_part(trans_status, '/', 1) = '000'"]
    search_fund_arr = ["processed = true"]
    search_arr_bbf = ["processed = true"] # ["split_part(trans_status, '/', 1) = '000'"]
    search_fund_arr_bbf = ["processed = true"]

    if @entity_name.present?
      division_str = "'0'"
      division_arr = []
      @entity_divis = EntityDivision.where("entity_code = '#{@entity_name}'")
      if @entity_divis.exists?
        @entity_divis.each do |entity_div|
          unless division_arr.include?("'#{entity_div.assigned_code}'")
            division_str << ",'#{entity_div.assigned_code}'"
            division_arr << "'#{entity_div.assigned_code}'"
          end
        end
      end
      final_div_str = "(#{division_str})"
      #logger.info "Final Div Str :: #{final_div_str.inspect} and Final INfo Str :: #{final_info_str}"
      search_arr << "payment_reports.entity_div_code IN #{final_div_str}"
      search_fund_arr << "entity_div_code IN #{final_div_str}"
      search_arr_bbf << "payment_reports.entity_div_code IN #{final_div_str}"
      search_fund_arr_bbf << "entity_div_code IN #{final_div_str}"
    end

    if @division_name.present?
      search_arr << "payment_reports.entity_div_code = '#{@division_name}'"
      search_fund_arr << "entity_div_code = '#{@division_name}'"
      search_arr_bbf << "payment_reports.entity_div_code = '#{@division_name}'"
      search_fund_arr_bbf << "entity_div_code = '#{@division_name}'"
    end

    if @start_date.present? && @end_date.present?
      f_start_date =  @start_date.to_date.strftime('%Y-%m-%d') # Date.strptime(@start_date, '%m/%d/%Y') # @start_date.to_date.strftime('%Y-%m-%d')
      f_end_date = @end_date.to_date.strftime('%Y-%m-%d') # Date.strptime(@end_date, '%m/%d/%Y') # @end_date.to_date.strftime('%Y-%m-%d')
      if f_start_date <= f_end_date
        search_arr << "payment_reports.created_at BETWEEN '#{f_start_date} 00:00:00' AND '#{f_end_date} 23:59:59'"
        search_fund_arr << "created_at BETWEEN '#{f_start_date} 00:00:00' AND '#{f_end_date} 23:59:59'"
        search_arr_bbf << "payment_reports.created_at < '#{f_start_date} 00:00:00'"
        search_fund_arr_bbf << "created_at < '#{f_start_date} 00:00:00'"
      end
    end

    the_search = search_arr.join(" AND ")
    the_search_fund = search_fund_arr.join(" AND ")
    the_search_bbf = search_arr_bbf.join(" AND ")
    the_search_fund_bbf = search_fund_arr_bbf.join(" AND ")
    logger.info "The search array :: #{search_arr.inspect}"
    logger.info "The Search :: #{the_search.inspect}"
    logger.info "The search fund array :: #{search_fund_arr.inspect}"
    logger.info "The Search Fund :: #{the_search_fund.inspect}"

    if current_user.super_admin? || current_user.super_user?

      @entity_infos = EntityInfo.where(active_status: true).order(entity_name: :asc)
      @entity_divisions = EntityDivision.where(active_status: true).order(division_name: :asc)

      @financial_statement = PaymentReport.financial_join.where(the_search).group("payment_reports.trans_type, date").order(date: :asc)
      @fund_movements = FundMovement.select("trans_type, narration, to_char(created_at, 'YYYY-MM-DD') AS date, sum(amount) AS amt")
                            .where(the_search_fund).group("trans_type, narration, date").order(date: :asc)
      @payment_reports_bbf = PaymentReport.financial_join.where(the_search_bbf).group("payment_reports.trans_type, date").order(date: :asc)
      @fund_movements_bbf = FundMovement.select("trans_type, narration, to_char(created_at, 'YYYY-MM-DD') AS date, sum(amount) AS amt")
                                .where(the_search_fund_bbf).group("trans_type, narration, date").order(date: :asc)
      @balance_bf = PaymentReport.balance_bf(@payment_reports_bbf, @fund_movements_bbf)[0]
      logger.info "================== 1st BALANCE B/F :: #{number_to_currency(@balance_bf, unit: "GHS ", precision: 3)}"
    elsif current_user.merchant_admin?
      entity_div_id_str = "'0'"
      entity_div_id_arr = []
      @entity_divs = EntityDivision.where(entity_code: current_user.user_entity_code, active_status: true)
      @entity_divs.each do |entity_div|
        unless entity_div_id_arr.include?("'#{entity_div.assigned_code}'")
          entity_div_id_str << ",'#{entity_div.assigned_code}'"
          entity_div_id_arr << "'#{entity_div.assigned_code}'"
        end
      end
      final_div_ids = "(#{entity_div_id_str})"
      logger.info "Final Div IDs :: #{final_div_ids.inspect}"

      @entity_divisions = EntityDivision.where(entity_code: current_user.user_entity_code, active_status: true).order(division_name: :asc)
      @financial_statement = PaymentReport.financial_join.where("payment_reports.entity_div_code IN #{final_div_ids}").where(the_search).group("payment_reports.trans_type, date").order(date: :asc)
      @fund_movements = FundMovement.select("trans_type, narration, to_char(created_at, 'YYYY-MM-DD') AS date, sum(amount) AS amt")
                            .where("entity_div_code IN #{final_div_ids}").where(the_search_fund).group("trans_type, narration, date").order(date: :asc)
      @payment_reports_bbf = PaymentReport.financial_join.where("payment_reports.entity_div_code IN #{final_div_ids}").where(the_search_bbf).group("payment_reports.trans_type, date").order(date: :asc)
      @fund_movements_bbf = FundMovement.select("trans_type, narration, to_char(created_at, 'YYYY-MM-DD') AS date, sum(amount) AS amt")
                                .where("entity_div_code IN #{final_div_ids}").where(the_search_fund_bbf).group("trans_type, narration, date").order(date: :asc)
      @balance_bf = PaymentReport.balance_bf(@payment_reports_bbf, @fund_movements_bbf)[0]
      logger.info "================== 1st MERCHANT BALANCE B/F :: #{number_to_currency(@balance_bf, unit: "GHS ", precision: 3)}"
    elsif current_user.merchant_service?
      @division_name = current_user.user_division_code
      @financial_statement = PaymentReport.financial_join.where("payment_reports.entity_div_code = '#{current_user.user_division_code}'").where(the_search).group("payment_reports.trans_type, date").order(date: :asc)
      @fund_movements = FundMovement.select("trans_type, narration, to_char(created_at, 'YYYY-MM-DD') AS date, sum(amount) AS amt")
                            .where("entity_div_code = '#{current_user.user_division_code}'").where(the_search_fund).group("trans_type, narration, date").order(date: :asc)
      @payment_reports_bbf = PaymentReport.financial_join.where("payment_reports.entity_div_code = '#{current_user.user_division_code}'").where(the_search_bbf).group("payment_reports.trans_type, date").order(date: :asc)
      @fund_movements_bbf = FundMovement.select("trans_type, narration, to_char(created_at, 'YYYY-MM-DD') AS date, sum(amount) AS amt")
                                .where("entity_div_code = '#{current_user.user_division_code}'").where(the_search_fund_bbf).group("trans_type, narration, date").order(date: :asc)
      @balance_bf = PaymentReport.balance_bf(@payment_reports_bbf, @fund_movements_bbf)[0]
      logger.info "================== 1st SERVICE BALANCE B/F :: #{number_to_currency(@balance_bf, unit: "GHS ", precision: 3)}"
    end

    respond_to do |format|

      if current_user.merchant_service?
        if @start_date.present? && @end_date.present?
          format.js { render :financial_statement_index }
          params[:the_start_date] = @start_date
          params[:the_end_date] = @end_date
        else
          @finance_stat.valid?
          @finance_stat.the_start_date = @finance_stat.the_start_date.to_date if @finance_stat.the_start_date.present?
          @finance_stat.the_end_date = @finance_stat.the_end_date.to_date if @finance_stat.the_end_date.present?
          format.js { render :financial_form }
        end
      else
        if (@entity_name.present? || @division_name.present?) && (@start_date.present? && @end_date.present?)
          params[:the_merchant] = @entity_name
          params[:the_service] = @division_name
          params[:the_start_date] = @start_date
          params[:the_end_date] = @end_date
          format.js { render :financial_statement_index }
        else
          @finance_stat.valid?
          @finance_stat.the_start_date = @finance_stat.the_start_date.to_date if @finance_stat.the_start_date.present?
          @finance_stat.the_end_date = @finance_stat.the_end_date.to_date if @finance_stat.the_end_date.present?
          format.js { render :financial_form }
        end
      end
    end

  end


  def wallet_search
    @finance_stat = PaymentInfo.new(payment_info_params)
    @entity_name = @finance_stat.the_merchant
    @division_name = @finance_stat.the_service
    @start_date = @finance_stat.the_start_date
    @end_date = @finance_stat.the_end_date
    the_search = ""
    search_arr = ["trans_type in ('CTM','CNC','CNP','CNE','CNL','CAN','CNS','BTP','BTE','BTS','BTA','BTL')"] #["processed = true"] # ["split_part(trans_status, '/', 1) = '000'"]
    search_fund_arr = ["trans_type in ('CTB','DNC','CTW','DNP','DNE','DNL','DNA','DNS','PTB','PTW','ETW','ETB','MTC') AND processed = true"]

    if @entity_name.present?
      division_str = "'0'"
      division_arr = []
      @entity_divis = EntityDivision.where("entity_code = '#{@entity_name}'")
      if @entity_divis.exists?
        @entity_divis.each do |entity_div|
          unless division_arr.include?("'#{entity_div.assigned_code}'")
            division_str << ",'#{entity_div.assigned_code}'"
            division_arr << "'#{entity_div.assigned_code}'"
          end
        end
      end
      final_div_str = "(#{division_str})"
      #logger.info "Final Div Str :: #{final_div_str.inspect} and Final INfo Str :: #{final_info_str}"
      search_arr << "entity_div_code IN #{final_div_str}"
      search_fund_arr << "entity_div_code IN #{final_div_str}"
    end

    if @division_name.present?
      search_arr << "entity_div_code = '#{@division_name}'"
      search_fund_arr << "entity_div_code = '#{@division_name}'"
    end

    if @start_date.present? && @end_date.present?
      f_start_date =  @start_date.to_date.strftime('%Y-%m-%d') # Date.strptime(@start_date, '%m/%d/%Y') # @start_date.to_date.strftime('%Y-%m-%d')
      f_end_date = @end_date.to_date.strftime('%Y-%m-%d') # Date.strptime(@end_date, '%m/%d/%Y') # @end_date.to_date.strftime('%Y-%m-%d')
      if f_start_date <= f_end_date
        search_arr << "created_at BETWEEN '#{f_start_date} 00:00:00' AND '#{f_end_date} 23:59:59'"
        search_fund_arr << "created_at BETWEEN '#{f_start_date} 00:00:00' AND '#{f_end_date} 23:59:59'"
      end
    end

    the_search = search_arr.join(" AND ")
    the_search_fund = search_fund_arr.join(" AND ")

    logger.info "The search array :: #{search_arr.inspect}"
    logger.info "The Search :: #{the_search.inspect}"

    if current_user.super_admin? || current_user.super_user?

      @entity_infos = EntityInfo.where(active_status: true).order(entity_name: :asc)
      @entity_divisions = EntityDivision.where(active_status: true).order(division_name: :asc)

      @financial_statement = EntityServiceAccountTrxn.wallet_join.where(the_search).group("trans_type, date").order(date: :asc)
      #@credit_obj = EntityServiceAccountTrxn.find_by_sql("select actual_amt from (select sum(net_bal_aft - net_bal_bef) actual_amt from entity_service_account_trxn where #{the_search}) AS service_acc_amt")
      @credit_obj = EntityServiceAccountTrxn.find_by_sql("select sum(net_bal_aft - net_bal_bef) actual_amt from entity_service_account_trxn where #{the_search}")[0]
      @credit_total = @credit_obj.actual_amt
      @fund_moves = FundMovement.select("trans_type, narration, to_char(created_at, 'YYYY-MM-DD') AS date, sum(amount) AS amt")
      @fund_movements = @fund_moves.where(the_search_fund).group("trans_type, narration, date").order(date: :asc)
      @service_name = @division_name.present? ? "('#{@division_name}')" : "('0')"
      @debit_obj = FundMovement.select("amount").where(the_search_fund)
      @debit_total = @debit_obj.sum(:amount)
      @balance_bf, @closing_bal = EntityServiceAccountTrxn.closing_bal_n_bbf(@start_date, @end_date, @division_name)
      logger.info "================== 1st BALANCE B/F :: #{number_to_currency(@balance_bf, unit: "GHS ", precision: 3)}"
      logger.info "================== 1st CLOSING BAL :: #{number_to_currency(@closing_bal, unit: "GHS ", precision: 3)}"
      logger.info "================== Credit Total :: #{number_to_currency(@credit_total, unit: "GHS ", precision: 3)} and Debit Total :: #{number_to_currency(@debit_total, unit: "GHS ", precision: 3)}"
    elsif current_user.merchant_admin?
      entity_div_id_str = "'0'"
      entity_div_id_arr = []
      @entity_divs = EntityDivision.where(entity_code: current_user.user_entity_code, active_status: true)
      @entity_divs.each do |entity_div|
        unless entity_div_id_arr.include?("'#{entity_div.assigned_code}'")
          entity_div_id_str << ",'#{entity_div.assigned_code}'"
          entity_div_id_arr << "'#{entity_div.assigned_code}'"
        end
      end
      final_div_ids = "(#{entity_div_id_str})"
      logger.info "Final Div IDs :: #{final_div_ids.inspect}"

      @entity_divisions = EntityDivision.where(entity_code: current_user.user_entity_code, active_status: true).order(division_name: :asc)
      @financial_statement = EntityServiceAccountTrxn.wallet_join.where("entity_div_code IN #{final_div_ids}").where(the_search).group("trans_type, date").order(date: :asc)
      @credit_obj = EntityServiceAccountTrxn.find_by_sql("select sum(net_bal_aft - net_bal_bef) actual_amt from entity_service_account_trxn where #{the_search}")[0]
      @credit_total = @credit_obj.actual_amt
      @fund_moves = FundMovement.select("trans_type, narration, to_char(created_at, 'YYYY-MM-DD') AS date, sum(amount) AS amt")
      @fund_movements = @fund_moves.where("entity_div_code IN #{final_div_ids}").where(the_search_fund).group("trans_type, narration, date").order(date: :asc)
      @service_name = @division_name.present? ? "('#{@division_name}')" : final_div_ids
      @debit_obj = FundMovement.select("amount").where("entity_div_code IN #{final_div_ids}").where(the_search_fund)
      @debit_total = @debit_obj.sum(:amount)
      @balance_bf, @closing_bal = EntityServiceAccountTrxn.closing_bal_n_bbf(@start_date, @end_date, @division_name)
      logger.info "================== MERCHANT 1st BALANCE B/F :: #{number_to_currency(@balance_bf, unit: "GHS ", precision: 3)}"
      logger.info "================== MERCHANT 1st CLOSING BAL :: #{number_to_currency(@closing_bal, unit: "GHS ", precision: 3)}"
      logger.info "================== MERCHANT Credit Total :: #{number_to_currency(@credit_total, unit: "GHS ", precision: 3)} and Debit Total :: #{number_to_currency(@debit_total, unit: "GHS ", precision: 3)}"

    elsif current_user.merchant_service?
      @division_name = current_user.user_division_code
      @financial_statement = EntityServiceAccountTrxn.wallet_join.where("entity_div_code = '#{current_user.user_division_code}'").where(the_search).group("trans_type, date").order(date: :asc)
      @credit_obj = EntityServiceAccountTrxn.find_by_sql("select sum(net_bal_aft - net_bal_bef) actual_amt from entity_service_account_trxn where #{the_search}")[0]
      @credit_total = @credit_obj.actual_amt
      @fund_moves = FundMovement.select("trans_type, narration, to_char(created_at, 'YYYY-MM-DD') AS date, sum(amount) AS amt")
      @fund_movements = @fund_moves.where("entity_div_code = '#{current_user.user_division_code}'").where(the_search_fund).group("trans_type, narration, date").order(date: :asc)
      @service_name = "('#{current_user.user_division_code}')"
      @debit_obj = FundMovement.select("amount").where("entity_div_code = '#{current_user.user_division_code}'").where(the_search_fund)
      @debit_total = @debit_obj.sum(:amount)
      @balance_bf, @closing_bal = EntityServiceAccountTrxn.closing_bal_n_bbf(@start_date, @end_date, current_user.user_division_code)
      logger.info "================== SERVICE 1st BALANCE B/F :: #{number_to_currency(@balance_bf, unit: "GHS ", precision: 3)}"
      logger.info "================== SERVICE 1st CLOSING BAL :: #{number_to_currency(@closing_bal, unit: "GHS ", precision: 3)}"
      logger.info "================== SERVICE Credit Total :: #{number_to_currency(@credit_total, unit: "GHS ", precision: 3)} and Debit Total :: #{number_to_currency(@debit_total, unit: "GHS ", precision: 3)}"
    end

    respond_to do |format|

      if current_user.merchant_service?
        if @start_date.present? && @end_date.present?
          format.js { render :financial_statement_index }
          params[:the_start_date] = @start_date
          params[:the_end_date] = @end_date
        else
          @finance_stat.valid?
          @finance_stat.the_start_date = @finance_stat.the_start_date.to_date if @finance_stat.the_start_date.present?
          @finance_stat.the_end_date = @finance_stat.the_end_date.to_date if @finance_stat.the_end_date.present?
          format.js { render :financial_form }
        end
      else
        if (@entity_name.present? || @division_name.present?) && (@start_date.present? && @end_date.present?)
          params[:the_merchant] = @entity_name
          params[:the_service] = @division_name
          params[:the_start_date] = @start_date
          params[:the_end_date] = @end_date
          format.js { render :financial_statement_index }
        else
          @finance_stat.valid?
          @finance_stat.the_start_date = @finance_stat.the_start_date.to_date if @finance_stat.the_start_date.present?
          @finance_stat.the_end_date = @finance_stat.the_end_date.to_date if @finance_stat.the_end_date.present?
          format.js { render :financial_form }
        end
      end
    end

  end



  def resend_form
    @pay_info = PaymentReport.where(id: @payment_report.id).order(created_at: :desc).first
    @payment_info = PaymentInfo.where(id: @payment_report.id).order(created_at: :desc).first
    @recipient_mail = ""
    @copy_email = ""
    logger.info "Resend Payment Info :: #{@pay_info.inspect}"
    logger.info "Resend Cust number :: #{@pay_info.customer_number.inspect}"
  end



  def transaction_resend
    #if params != nil
    #  logger.info "Params object :: #{params.inspect}"
    #  params = params.permit([:payment_info]).to_h#.except(:payment_info)
    #end
    #logger.info "Params without payment_info key :: #{params.inspect}"


    @pay_info = PaymentReport.where(id: @payment_report.id).order(created_at: :desc).first
    @recipient_mail = payment_info_params[:recipient_mail]
    @copy_email = payment_info_params[:copy_email]
    #logger.info "Pay parameters:: recipient mail:: #{@recipient_mail.inspect} and Copy email :: #{@copy_email.inspect}"
    logger.info "Payment ID :: #{@payment_report.id.inspect}"
    endpoint = '/resend_cust_code'

    #@merchant_service = EntityDivision.where(active_status: true, assigned_code: @payment_report.entity_div_code).order(created_at: :desc).first
    #logger.info "Merchant Service :: #{@merchant_service.inspect}"
    #if @merchant_service
    #  entity_wallet_config = EntityWalletConfig.where(entity_code: @merchant_service.entity_code, service_id: @payment_report.service_id,
    #                                                  activity_type_code: @merchant_service.activity_type_code, active_status: true)
    #                             .order(created_at: :desc).first
    #  logger.info "Wallet Config:: #{entity_wallet_config.inspect}"
    #  if entity_wallet_config
    #    logger.info "Passed ============="
    #    _secret_key = entity_wallet_config.secret_key
    #    _client_key = entity_wallet_config.client_key
    #  else
    #    logger.info "Wallet Failed =============="
    #    _secret_key = ""
    #    _client_key = ""
    #  end
    #else
    #  logger.info "Failed ================="
    #  _secret_key = ""
    #  _client_key = ""
    #end

    @payment_info = PaymentInfo.new(id: @payment_report.id)
    if @payment_info.valid?
      payload = {:payment_info_id => @payment_report.id}
      json_payload=JSON.generate(payload)
      core_connection = VposCore::CoreConnect.new
      connection = core_connection.connection
      #signature = core_connection.compute_signature(_secret_key, json_payload)

      logger.info "PayLoad === :: #{json_payload.inspect}"
      logger.info "Core connection: #{core_connection.inspect}"
      begin
        result=connection.post do |req|
          req.url endpoint
          req.options.timeout = 90           # open/read timeout in seconds
          req.options.open_timeout = 90      # connection open timeout in seconds
          #req["Authorization"]="#{_client_key}:#{signature}"
          req.body = json_payload
        end


        logger.info "Response:: #{result.inspect}"
        json_valid_res = core_connection.json_validate(result.body)

        if json_valid_res
          logger.info "Valid JSON ================"
          the_resp = JSON.parse(result.body)

          resp_code = the_resp["resp_code"]
          resp_desc = the_resp["resp_desc"]
          logger.info "Response Description :: #{resp_desc.inspect}"
          if resp_code == "00"
            payment_info_index
            flash.now[:notice] = "Resend was successful."
            respond_to do |format|
              format.js { render :payment_info_index }
            end
          else
            #payment_info_index
            flash.now[:danger] = "Sorry, resend failed. Kindly try again."
            respond_to do |format|
              format.js { render :resend_form }
            end
          end
        else
          #payment_info_index
          logger.info "Not a Valid JSON ==============="
          flash.now[:danger] = "Sorry, There was an issue. Kindly check and try again."
          respond_to do |format|
            format.js { render :resend_form }
          end
        end
      rescue Faraday::SSLError
        #payment_info_index
        logger.info "SSL Error ==============="
        flash.now[:danger] = "Sorry, There was an issue. Kindly check and try again."
        respond_to do |format|
          format.js { render :resend_form }
        end
      rescue Faraday::TimeoutError
        #payment_info_index
        logger.info "Timeout Error ================="
        flash.now[:danger] = "Sorry, There was a timeout issue. Kindly check and try again."
        respond_to do |format|
          format.js { render :resend_form }
        end
      rescue Faraday::ConnectionFailed => e
        #payment_info_index
        logger.info "Connection Failed ================"
        logger.info "Error message :: #{e} ==================="
        flash.now[:danger] = "Sorry, There was a connection issue. Kindly check and try again."
        respond_to do |format|
          format.js { render :resend_form }
        end
      end
    else

      #payment_info_index
      if @payment_info.errors.messages.key?(:recipient_mail) && @payment_info.errors.messages.key?(:copy_email)
        logger.info "First Phase"
        if @payment_info.errors.messages[:recipient_mail][0].present? && @payment_info.errors.messages[:copy_email][0].present?
          flash.now[:danger] = "Failed Validation: Recipient email #{@payment_info.errors.messages[:recipient_mail][0]} and Copy email #{@payment_info.errors.messages[:copy_email][0]}"
        else
          flash.now[:danger] = "Failed Validation."
        end

      else
        logger.info "Second Phase"
        if @payment_info.errors.messages.key?(:recipient_mail)
          flash.now[:danger] = "Failed Validation: Recipient email #{@payment_info.errors.messages[:recipient_mail][0]}"
        elsif @payment_info.errors.messages.key?(:copy_email)
          flash.now[:danger] = "Failed Validation: Copy email #{@payment_info.errors.messages[:copy_email][0]}"
        else
          flash.now[:danger] = "Failed Validation.."
        end
      end
      logger.info "Error messages :: #{@payment_info.errors.messages.inspect}"
      @pay_info = PaymentReport.where(id: @payment_report.id).order(created_at: :desc).first
      #@payment_info = PaymentInfo.new(id: @payment_report.id, recipient_mail: payment_info_params[:recipient_mail], copy_email: payment_info_params[:copy_email])
      @payment_info = PaymentInfo.new(id: @payment_report.id)
      #@payment_info.valid?
      respond_to do |format|
        format.js { render :resend_form }
      end
    end
  end


  # GET /payment_infos/1
  # GET /payment_infos/1.json
  def show
    @pay_info = PaymentReport.where(id: @payment_report.id).order(created_at: :desc).first
    logger.info "Payment Info :: #{@pay_info.inspect}"
    logger.info "Cust number :: #{@pay_info.customer_number.inspect}"
  end

  def resend_show
    @pay_info = PaymentReport.where(id: @payment_report.id).order(created_at: :desc).first
    logger.info "Payment Info :: #{@pay_info.inspect}"
    logger.info "Cust number :: #{@pay_info.customer_number.inspect}"
  end

  # GET /payment_infos/new
  def new
    @payment_info = PaymentInfo.new
  end

  # GET /payment_infos/1/edit
  def edit
  end

  # POST /payment_infos
  # POST /payment_infos.json
  def create
    @payment_info = PaymentInfo.new(payment_info_params)

    respond_to do |format|
      if @payment_info.valid?
        format.html { redirect_to @payment_info, notice: 'Payment info was successfully created.' }
        format.json { render :show, status: :created, location: @payment_info }
      else
        format.html { render :new }
        format.json { render json: @payment_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payment_infos/1
  # PATCH/PUT /payment_infos/1.json
  def update
    respond_to do |format|
      if @payment_info.valid? #update(payment_info_params)
        format.html { redirect_to @payment_info, notice: 'Payment info was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment_info }
      else
        format.html { render :edit }
        format.json { render json: @payment_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_infos/1
  # DELETE /payment_infos/1.json
  def destroy
    #@payment_info.destroy
    respond_to do |format|
      format.html { redirect_to payment_infos_url, notice: 'Payment info was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_info
      @payment_info = PaymentInfo.find(params[:id])
      @payment_report = PaymentReport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_info_params
      params.require(:payment_info).permit(:session_id, :entity_div_code, :activity_lov_id, :activity_div_id, :pay_id,
                                           :activity_sub_div_id, :processed, :src, :payment_mode, :amount,
                                           :customer_number, :trans_type, :charge, :active_status, :del_status,
                                           :the_merchant, :the_service, :the_start_date, :the_end_date, :finance_valid,
                                           :user_id, :copy_email, :recipient_mail)
    end

end
