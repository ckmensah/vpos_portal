class EntityDivisionsController < ApplicationController
  before_action :set_entity_division, only: [:show, :edit, :update, :destroy, :division_setup, :create_division_setup]
  load_and_authorize_resource
  before_action :load_permissions
  # GET /entity_divisions
  # GET /entity_divisions.json
  require 'vpos_core'

  def index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    if current_user.merchant_admin?
      params[:entity_code] = current_user.user_entity_code
    end

    @entity_divisions = EntityDivision.where(active_status: true).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

  end

  def entity_division_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    params[:count1] ? params[:count1] : params[:count1] = 50
    params[:page1] ? params[:page1] : params[:page1] = 1
    $entity_division_page = params[:page]
    session[:loan_req_filter] = nil
    if current_user.super_admin? || current_user.super_user?
      @entity_info = EntityInfo.where(assigned_code: params[:entity_code], active_status: true, del_status: false).order(created_at: :desc).first
      @entity_info ? @entity_name = "#{@entity_info.entity_name} (#{@entity_info.entity_alias})" : ""

      the_search = ""
      search_arr = ["entity_code = '#{params[:entity_code]}' AND del_status = false"]

      if params[:service_filter].present? || params[:div_name].present? || params[:div_alias].present? || params[:assign_code].present? || params[:activity_code].present? || params[:serv_label].present? || params[:start_date].present? || params[:end_date].present? #|| params[:nw].present? || params[:status].present? || params[:start_date].present? || params[:end_date].present?

        session[:service_filter] = params[:service_filter]
        #session[:service_filter] = params[:service_filter]
        filter_params = params[:service_filter]
        if params[:service_filter].present?
          @div_name = filter_params[:div_name]
          @div_alias = filter_params[:div_alias]
          @assign_code = filter_params[:assign_code]
          @activity_code = filter_params[:activity_code]
          @serv_label = filter_params[:serv_label]
          @start_date = filter_params[:start_date]
          @end_date = filter_params[:end_date]

          params[:div_name] = filter_params[:div_name]
          params[:div_alias] = filter_params[:div_alias]
          params[:assign_code] = filter_params[:assign_code]
          params[:activity_code] = filter_params[:activity_code]
          params[:serv_label] = filter_params[:serv_label]
          params[:start_date] = filter_params[:start_date]
          params[:end_date] = filter_params[:end_date]

        else

          if  params[:div_name].present?  || params[:div_alias].present? || params[:assign_code].present? || params[:activity_code].present? || params[:serv_code].present? || params[:start_date].present? || params[:end_date].present? # || params[:trans_id].present? || params[:nw].present? || params[:status].present? || params[:start_date].present? || params[:end_date].present?

            @div_name = params[:div_name]
            @div_alias = params[:div_alias]
            @assign_code = params[:assign_code]
            @activity_code = params[:activity_code]
            @start_date = params[:start_date]
            @end_date = params[:end_date]

            params[:div_name] = @div_name
            params[:div_alias] = @div_alias
            params[:assign_code] = @assign_code
            params[:activity_code] = @activity_code
            params[:serv_label] = @serv_label
            params[:start_date] = @start_date
            params[:end_date] = @end_date

          else
            params[:div_name] = filter_params[:div_name]
            params[:div_alias] = filter_params[:div_alias]
            params[:assign_code] = filter_params[:assign_code]
            params[:activity_code] = filter_params[:activity_code]
            params[:serv_label] = filter_params[:service_label]
            params[:start_date] = filter_params[:start_date]
            params[:end_date] = filter_params[:end_date]

          end
        end

        if @div_name.present?
          #search_arr << "customer_number LIKE '%#{@cust_num}%'"
          search_arr << "assigned_code = '#{@div_name}'"
        end

        if @div_alias.present?
          #search_arr << "customer_number LIKE '%#{@cust_num}%'"
          search_arr << "assigned_code = '#{@div_alias}'"
        end

        if @assign_code.present?
          search_arr << "assigned_code = '#{@assign_code}'"
        end

        if @activity_code.present?
          search_arr << "activity_type_code = '#{@activity_code}'"
        end

        if @serv_label.present?
          #search_arr << "service_label = '#{@serv_label}'"
          search_arr << "service_label LIKE '%#{@serv_label}%'"
        end

        if @start_date.present? && @end_date.present?
          f_start_date =  @start_date.to_date.strftime('%Y-%m-%d') # Date.strptime(@start_date, '%m/%d/%Y') # @start_date.to_date.strftime('%Y-%m-%d')
          f_end_date = @end_date.to_date.strftime('%Y-%m-%d') # Date.strptime(@end_date, '%m/%d/%Y') # @end_date.to_date.strftime('%Y-%m-%d')
          if f_start_date <= f_end_date
            search_arr << "created_at BETWEEN '#{f_start_date} 00:00:00' AND '#{f_end_date} 23:59:59'"
          end
        end

      else
        session[:service_filter] = nil
      end


      the_search = search_arr.join(" AND ")
      logger.info "The search array :: #{search_arr.inspect}"
      logger.info "The Search :: #{the_search.inspect}"

      dropdown_condition = "entity_code = '#{params[:entity_code]}' AND del_status = false"
      the_activity_type = "'0'"
      activity_type_arr = []
      @service_division_names = EntityDivision.where(dropdown_condition).order(division_name: :asc)
      @service_division_alias = EntityDivision.where(dropdown_condition).order(division_alias: :asc)
      @service_assigned_codes = EntityDivision.where(dropdown_condition).order(assigned_code: :asc)
      @service_division_names.each do |service|
        unless activity_type_arr.include?(service.activity_type_code)
          the_activity_type << ",'#{service.activity_type_code}'"
          activity_type_arr << service.activity_type_code
        end
      end

      if params[:code].present? && params[:event_type] == "EVENT"
        @entity_div_obj = EntityDivision.where(assigned_code: params[:code], active_status: true).order(created_at: :desc).first
        if @entity_div_obj
          event_feedback = EntityDivision.event_state(@entity_div_obj, current_user)
          if event_feedback != nil && event_feedback == "start_event"
            flash.now[:notice] = "Event has started successfully."
          elsif event_feedback != nil && event_feedback == "end_event"
            flash.now[:notice] = "Setup has ended successfully."
          end
        end
      end

      @activity_type_codes = ActivityType.where("assigned_code IN (#{the_activity_type})").order(assigned_code: :asc)
      @entity_divisions = EntityDivision.where(the_search).paginate(:page => params[:page], :per_page => params[:count1]).order('created_at desc')
      #@entity_divisions = EntityDivision.where(entity_code: params[:entity_code], del_status: false).paginate(:page => params[:page], :per_page => params[:count1]).order('created_at desc')

    elsif current_user.merchant_admin?
      if current_user.merchant_admin?
        params[:entity_code] = current_user.user_entity_code
      end
      @entity_info = EntityInfo.where(assigned_code: current_user.user_entity_code, active_status: true, del_status: false).order(created_at: :desc).first
      @entity_info ? @entity_name = "#{@entity_info.entity_name} (#{@entity_info.entity_alias})" : ""
      @entity_divisions = EntityDivision.where(entity_code: current_user.user_entity_code, del_status: false).paginate(:page => params[:page1], :per_page => params[:count1]).order('created_at desc')

    elsif current_user.merchant_service?
      @entity_name = ""
      @entity_divisions = EntityDivision.where(assigned_code: current_user.user_division_code, del_status: false).paginate(:page => params[:page1], :per_page => params[:count1]).order('created_at desc')

    end
  end




  def main_sports_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    if current_user.super_admin? || current_user.super_user?
      @entity_info = EntityInfo.where(assigned_code: params[:entity_code], active_status: true, del_status: false).order(created_at: :desc).first
      @entity_info ? @entity_name = "#{@entity_info.entity_name} (#{@entity_info.entity_alias})" : ""
      @entity_div_sports = EntityDivision.where(entity_code: params[:entity_code], del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

    elsif current_user.merchant_admin?
      if current_user.merchant_admin?
        params[:entity_code] = current_user.user_entity_code
      end
      @entity_info = EntityInfo.where(assigned_code: current_user.user_entity_code, active_status: true, del_status: false).order(created_at: :desc).first
      @entity_info ? @entity_name = "#{@entity_info.entity_name} (#{@entity_info.entity_alias})" : ""
      @entity_div_sports = EntityDivision.where(entity_code: current_user.user_entity_code, del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

    elsif current_user.merchant_service?
      #@entity_info = EntityInfo.where(assigned_code: current_user.user_entity_code, active_status: true, del_status: false).order(created_at: :desc).first
      #@entity_info ? @entity_name = "#{@entity_info.entity_name} (#{@entity_info.entity_alias})" : ""
      @entity_name = ""
      @entity_div_sports = EntityDivision.where(assigned_code: current_user.user_division_code, del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

    end

  end


  def division_update
    # converted_params = ActiveSupport::JSON.decode( params[:s] )
    logger.info "Params:: #{params[:id_for_entity_info].inspect}"
    if params[:id_for_entity_info].empty?
      # @region_update_city = [["", ""]]
      @info_update_division = [["", ""]].insert(0,['Please select a service', ""])
      @merchant_update_ref = [["", ""]].insert(0,['Please select a menu item', ""])
    else
      info_id_record = EntityInfo.find(params[:id_for_entity_info])
      info_update_division = info_id_record.entity_divisions.where(active_status: true).order(division_name: :asc).map { |a| [a.division_name, a.assigned_code] }.insert(0,['Please select a service', ""])
      menu_items = PaymentReport.joins("INNER JOIN entity_division ON payment_reports.entity_div_code = entity_division.assigned_code")
                       .select(:activity_main_code, :narration).where("entity_code = '#{params[:id_for_entity_info]}' AND active_status = true AND activity_type_code = 'CHC'")
                       .group(:activity_main_code, :narration).order(activity_main_code: :asc).map { |a| a.narration.present? ? ["#{a.activity_main_code} (#{a.narration})", "#{a.activity_main_code} #{a.narration}"] : [a.activity_main_code, a.activity_main_code] }.insert(0,['Please select a menu item', ""])

      @info_update_division = info_update_division.empty? ? [["", ""]].insert(0,['Please select a service', ""]) : info_update_division
      @merchant_update_ref = menu_items.empty? ? [["", ""]].insert(0,['Please select a menu item', ""]) : menu_items
    end
    logger.info "For Suburbs :: #{@info_update_division.inspect}"
    logger.info "For Activity main code (Menu Items) :: #{@merchant_update_ref.inspect}"
  end
  # def multi_division_update
  #   # converted_params = ActiveSupport::JSON.decode( params[:s] )
  #   logger.info "Params:: #{params[:id_for_entity_info].inspect}"
  #   if params[:id_for_entity_info].empty?
  #     # @region_update_city = [["", ""]]
  #     @info_update_division = [["", ""]].insert(0,['Please select a service', ""])
  #     @merchant_update_ref = [["", ""]].insert(0,['Please select a menu item', ""])
  #   else
  #     info_id_record = EntityInfo.find(params[:id_for_entity_info])
  #     info_update_division = info_id_record.entity_divisions.where(active_status: true).order(division_name: :asc).map { |a| [a.division_name, a.assigned_code] }.insert(0,['Please select a service', ""])
  #     menu_items = PaymentReport.joins("INNER JOIN entity_division ON payment_reports.entity_div_code = entity_division.assigned_code")
  #                      .select(:activity_main_code, :narration).where("entity_code = '#{params[:id_for_entity_info]}' AND active_status = true AND activity_type_code = 'CHC'")
  #                      .group(:activity_main_code, :narration).order(activity_main_code: :asc).map { |a| a.narration.present? ? ["#{a.activity_main_code} (#{a.narration})", "#{a.activity_main_code} #{a.narration}"] : [a.activity_main_code, a.activity_main_code] }.insert(0,['Please select a menu item', ""])
  #
  #     @info_update_division = info_update_division.empty? ? [["", ""]].insert(0,['Please select a service', ""]) : info_update_division
  #     @merchant_update_ref = menu_items.empty? ? [["", ""]].insert(0,['Please select a menu item', ""]) : menu_items
  #   end
  #   logger.info "For Suburbs :: #{@info_update_division.inspect}"
  #   logger.info "For Activity main code (Menu Items) :: #{@merchant_update_ref.inspect}"
  # end


  def lov_update
    # converted_params = ActiveSupport::JSON.decode( params[:s] )
    logger.info "Params:: #{params[:id_for_entity_service].inspect}"
    if params[:id_for_entity_service].empty?
      # @region_update_city = [["", ""]]
      @info_update_div_lov = [["", ""]].insert(0,['Please select a service option', ""])
      @service_update_ref = [["", ""]].insert(0,['Please select a menu item', ""])
      #@service_update_reference = [["", ""]].insert(0,['Please select a reference', ""])
    else
      info_id_record = EntityDivision.find(params[:id_for_entity_service])
      #info_update_div_lov = info_id_record.division_activity_lovs.where(active_status: true).order(lov_desc: :asc).map { |a| [a.lov_desc, a.id] }.insert(0,['Please select a service option', ""])
      info_update_div_lov = info_id_record.division_activity_lovs.select(:lov_desc).where(active_status: true).group(:lov_desc).order(lov_desc: :asc).map { |a| [a.lov_desc, a.lov_desc] }.insert(0,['Please select a service option', ""])
      #@division_lovs = DivisionActivityLov.select(:lov_desc).where(active_status: true).group(:lov_desc).order(lov_desc: :asc)
      menu_items = PaymentReport.joins("INNER JOIN entity_division ON payment_reports.entity_div_code = entity_division.assigned_code")
                        .select(:activity_main_code, :narration).where("entity_div_code = '#{params[:id_for_entity_service]}' AND active_status = true AND activity_type_code = 'CHC'")
                        .group(:activity_main_code, :narration).order(activity_main_code: :asc).map { |a| a.narration.present? ? ["#{a.activity_main_code} (#{a.narration})", "#{a.activity_main_code} #{a.narration}"] : [a.activity_main_code, a.activity_main_code] }.insert(0,['Please select a menu item', ""])

      #references = PaymentReport.select(:reference).group(:reference).order(references: :asc).map { |a| [a.reference, a.reference]}.insert(0,['Please select a reference', ""])

      info_update_div_lov.empty? ? @info_update_div_lov = [["", ""]].insert(0,['Please select a service option', ""]) : @info_update_div_lov = info_update_div_lov
      @service_update_ref = menu_items.empty? ? [["", ""]].insert(0,['Please select a menu item', ""]) : menu_items
      #@service_update_reference = references.empty? ? [["", ""]].insert(0,['Please select a menu item', ""]) : references
    end
    logger.info "For LOV :: #{@info_update_div_lov.inspect}"
    logger.info "For Activity main code (Menu Items) :: #{@service_update_ref.inspect}"
    #logger.info "For Reference :: #{@service_update_reference.inspect}"
  end


  # def entity_division_index
  #   params[:count] ? params[:count] : params[:count] = 10
  #   params[:page] ? params[:page] : params[:page] = 1
  #
  #   @entity_divisions = EntityDivision.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
  #
  # end

  def entity_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1
    $entity_index_page = params[:page]

    the_search = ""
    search_arr = []

    if params[:filter_main1].present? || params[:entity_name].present? || params[:assigned_code].present? || params[:entity_cat].present? || params[:start_date].present? || params[:end_date].present? #|| params[:cust_num].present? || params[:trans_id].present? || params[:nw].present? || params[:status].present? || params[:start_date].present? || params[:end_date].present?

      #$merchant_filter = params[:filter_main1]
      session[:merchant_filter] = params[:filter_main1]
      filter_params = params[:filter_main1]
      if params[:filter_main1].present?
        @entity_name = filter_params[:entity_name]
        @assigned_code = filter_params[:assigned_code]
        @entity_cat = filter_params[:entity_cat]
        @start_date = filter_params[:start_date]
        @end_date = filter_params[:end_date]

        params[:entity_name] = filter_params[:entity_name]
        params[:assigned_code] = filter_params[:assigned_code]
        params[:entity_cat] = filter_params[:entity_cat]
        params[:start_date] = filter_params[:start_date]
        params[:end_date] = filter_params[:end_date]

      else

        if  params[:entity_name].present? || params[:assigned_code].present? || params[:entity_cat].present? || params[:start_date].present? || params[:end_date].present? #|| params[:lov_name].present? || params[:cust_num].present? || params[:trans_id].present? || params[:nw].present? || params[:status].present? || params[:start_date].present? || params[:end_date].present?

          @entity_name = params[:entity_name]
          @assigned_code = params[:assigned_code]
          @entity_cat = params[:entity_cat]
          @start_date = params[:start_date]
          @end_date = params[:end_date]

          params[:entity_name] = @entity_name
          params[:assigned_code] = @assigned_code
          params[:entity_cat] = @entity_cat
          params[:start_date] = @start_date
          params[:end_date] = @end_date

        else
          params[:entity_name] = filter_params[:entity_name]
          params[:assigned_code] = filter_params[:assigned_code]
          params[:entity_cat] = filter_params[:entity_cat]
          params[:start_date] = filter_params[:start_date]
          params[:end_date] = filter_params[:end_date]

        end
      end

      if @entity_name.present?
        #search_arr << "customer_number LIKE '%#{@cust_num}%'"
        search_arr << "assigned_code = '#{@entity_name}'"
      end

      if @assigned_code.present?
        search_arr << "assigned_code = '#{@assigned_code}'"
      end

      if @entity_cat.present?
        search_arr << "entity_cat_id = '#{@entity_cat}'"
      end

      if @start_date.present? && @end_date.present?
        f_start_date =  @start_date.to_date.strftime('%Y-%m-%d') # Date.strptime(@start_date, '%m/%d/%Y') # @start_date.to_date.strftime('%Y-%m-%d')
        f_end_date = @end_date.to_date.strftime('%Y-%m-%d') # Date.strptime(@end_date, '%m/%d/%Y') # @end_date.to_date.strftime('%Y-%m-%d')
        if f_start_date <= f_end_date
          search_arr << "created_at BETWEEN '#{f_start_date} 00:00:00' AND '#{f_end_date} 23:59:59'"
        end
      end

    else
      #$merchant_filter = ""
      session[:merchant_filter] = nil
    end


    the_search = search_arr.join(" AND ")
    logger.info "The search array :: #{search_arr.inspect}"
    logger.info "The Search :: #{the_search.inspect}"


    @merchant_search = EntityInfo.where(active_status: true).order(entity_name: :asc)
    @merchant_code_search = EntityInfo.where(active_status: true).order(entity_name: :asc)
    @merchant_cat_search = EntityCategory.where(active_status: true).order(category_name: :asc)


    #@entity_infos = EntityInfo.where(the_search).where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
    @entity_info_divs = EntityInfo.where(active_status: true).where(the_search).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
  end

  def sport_setup
    @entity_div_name = EntityDivision.where(assigned_code: params[:code], active_status: true).order(created_at: :desc).first
    @entity_div_name = @entity_div_name ? "#{@entity_div_name.division_name} (#{@entity_div_name.division_alias})" : ""
    @activity_divs = ActivityDiv.where(division_code: params[:code], del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

  end


  def fixture_new
    @activity_categories = ActivityCategory.where(active_status: true).order(activity_cat_desc: :asc)
    @activity_div_cats = ActivityDivCat.where(active_status: true, division_code: params[:code]).order(div_cat_desc: :asc)
    @activity_category_divs = ActivityCategoryDiv.where(id: 0, active_status: true, division_code: params[:code]).order(category_div_desc: :desc) # ActivityCategoryDiv.where(active_status: true, division_code: params[:code]).order(category_div_desc: :desc)
    @activity_fixtures = ActivityFixture.where(id: 0, active_status: true, division_code: params[:code])

  end

  def fixture_edit
    @activity_div = ActivityDiv.where(id: params[:act_div_id], active_status: true, division_code: params[:code]).order(created_at: :desc).first
    @activity_categories = ActivityCategory.where(active_status: true).order(activity_cat_desc: :asc)

    logger.info "Activity Division:: #{@activity_div.inspect}"

    if @activity_div
      if @activity_div.activity_fixture_id.present?
        logger.info "===================================== PRESENT "
        @sport_type = @activity_div.activity_fixture.activity_category_div.activity_category_id
        @sport_category = @activity_div.activity_fixture.activity_category_div.activity_div_cat_id
        @category_type = @activity_div.activity_fixture.activity_category_div_id
        #@fixtures = @activity_div.activity_fixture_id


        @activity_div_cats = ActivityDivCat.where(id: @sport_category, active_status: true, division_code: params[:code]).order(div_cat_desc: :asc)
        @activity_category_divs = ActivityCategoryDiv.where(id: @category_type, active_status: true, division_code: params[:code]).order(category_div_desc: :desc) # ActivityCategoryDiv.where(active_status: true, division_code: params[:code]).order(category_div_desc: :desc)
        @activity_fixtures = ActivityFixture.where(id: @activity_div.activity_fixture_id, active_status: true, division_code: params[:code])

      else
        logger.info "=============================== NOT PRESENT "
        @sport_type = ""
        @sport_category = ""
        @category_type = ""
        #@fixtures = ""

        @activity_div_cats = ActivityDivCat.where(active_status: true, division_code: params[:code]).order(div_cat_desc: :asc)
        @activity_category_divs = ActivityCategoryDiv.where(id: 0, active_status: true, division_code: params[:code]).order(category_div_desc: :desc) # ActivityCategoryDiv.where(active_status: true, division_code: params[:code]).order(category_div_desc: :desc)
        @activity_fixtures = ActivityFixture.where(id: 0, active_status: true, division_code: params[:code])

      end
    else
      logger.info "================================== NOT PRESENT OUT"
      @sport_type = ""
      @sport_category = ""
      @category_type = ""
    end

  end

  def create_fixture

  end


  def update_fixture
    @activity_div = ActivityDiv.where(id: params[:act_div_id], active_status: true).first

    respond_to do |format|
      logger.info "================== INSIDE RESPOND TO ======================"
      if @activity_div
        @activity_div = ActivityDiv.find(params[:act_div_id])
        #@activity_div.activity_fixture_id = params[:activity_div][:activity_fixture_id]
        #@activity_div.sport_type = ""
        if @activity_div.update(division_code: @activity_div.division_code, activity_div_desc: @activity_div.activity_div_desc,
                                activity_date: @activity_div.activity_date, sport_type: params[:activity_div][:sport_type],
                                sport_category: params[:activity_div][:sport_category], for_fixture: true,
                                category_type: params[:activity_div][:category_type], activity_fixture_id: params[:activity_div][:activity_fixture_id])
          logger.info "=========================== I AM VALID ========================"
          flash.now[:notice] = "Fixture was successfully created."
          format.js { render :sport_setup }
        else
          logger.info "============================= I AM NOT VALID =========================="
          logger.info "Error Messages:: #{@activity_div.errors.messages.inspect}"
          format.js { render :fixture_edit }
        end
      end
    end

  end


  def division_setup
    if current_user.merchant_admin?
      params[:entity_code] = current_user.user_entity_code
    elsif current_user.merchant_service?
      params[:entity_code] = current_user.user_entity_code
      params[:code] = current_user.user_division_code
    end
    @entity_division = EntityDivision.new
    @entity_div = EntityDivision.where(assigned_code: params[:code], active_status: true).order(created_at: :desc).first
    @div_activity_type = @entity_div.activity_type.assigned_code
    @entity_info = EntityInfo.where(assigned_code: params[:entity_code], active_status: true, del_status: false).order(created_at: :desc).first
    @entity_name = @entity_info ? "#{@entity_info.entity_name} (#{@entity_info.entity_alias})" : ""
    @display_num = 3
    @display_div_num = 1
    @display_act_sub_num = 1
    @entity_division_sub = EntityDivision.where(assigned_code: params[:code], active_status: true).order(created_at: :desc).first

    if @entity_division_sub && @entity_division_sub.activity_type_code == "DON"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (DON)", "DON"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "PDD"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (PDD)", "PDD"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "SPC"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (SPC)", "SPC"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "GEN"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (GEN)", "GEN"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "OMC"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (OMC)", "OMC"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "MOP"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (MOP)", "MOP"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "HSP"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (HSP)", "HSP"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "GBC"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (GBC)", "GBC"]]
    else
      @entity_div_sub_activities = EntityDivSubActivity.where(entity_div_code: params[:code], active_status: true, del_status: false).order(div_sub_activity_desc: :asc)
      @activity_codes = @entity_div_sub_activities.map { |a| ["#{a.div_sub_activity_desc} (#{a.sub_activity_code})", "#{a.sub_activity_code}"] }.insert(0,['Select an Activity Code', ""])
    end

    
    #@activity_codes = [["Donations (DON)", "DON"], ["Levy (LVY)", "LVY"], ["Project (PRJ)", "PRJ"], ["Pledges (PLG)", "PLG"]]
    @activity_sub_div_class = [['Select a class', ""], ["Double", 4], ["Single", 3], ["VIP", 1],  ["Standard", 2]]
    @activity_sub_div_cl = [["Double", 4], ["Single", 3], ["VIP", 1],  ["Standard", 2]]
    @activity_sub_div_classes = ActivitySubDivClass.where(entity_div_code: params[:code], active_status: true, del_status: false).order(class_desc: :asc)
    @act_sub_div_classes = @activity_sub_div_classes.map { |a| [a.class_desc, a.id] }.insert(0,['Select a class', ""])
    @activity_div_fixtures = ActivityFixture.where(division_code: params[:code], active_status: true).order(created_at: :desc)
    @activity_fixtures = @activity_div_fixtures.map { |a| ["#{a.activity_participanta.participant_name} VS #{a.activity_participantb.participant_name}", a.id] }.insert(0,['Select a fixtures', ""])

    logger.info "Activity Sub Division Classes: #{@activity_sub_div_classes.inspect} \n and Act Sub Division Classes: #{@act_sub_div_classes.inspect}"
      #region_update_city = region_id_record.cities.where(active_status: true).order(city_town_name: :asc).map { |a| [a.city_town_name, a.id] }.insert(0,['Please select a city', ""])

  end



  def create_division_setup
    if current_user.merchant_admin?
      params[:entity_code] = current_user.user_entity_code
    elsif current_user.merchant_service?
      params[:entity_code] = current_user.user_entity_code
      params[:code] = current_user.user_division_code
    end
    @entity_division = EntityDivision.new(entity_division_params)
    @entity_div = EntityDivision.where(assigned_code: params[:code], active_status: true).order(created_at: :desc).first
    @div_activity_type = @entity_div.activity_type.assigned_code
    @the_div_lov = params[:the_div_acts_lov]
    @the_div_lov_num = @the_div_lov.nil? ? 0 : @the_div_lov.keys.size
    @main_params = EntityDivision.hsh_key_validator(params)
    @display_num = 3
    @display_div_num = @main_params.any? ? @main_params.size : 0
    @display_act_sub_num = 1

    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    @entity_info = EntityInfo.where(assigned_code: params[:entity_code], active_status: true, del_status: false).order(created_at: :desc).first
    @entity_name = @entity_info ? "#{@entity_info.entity_name} (#{@entity_info.entity_alias})" : ""
    @entity_divisions = EntityDivision.where(entity_code: params[:entity_code], del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')



    #@the_activity_sub = params[:the_div_acts_lov]
    logger.info "The div_acts_lov params size :: #{@the_div_lov_num.inspect}"
    logger.info "All Keys :: #{params.keys.inspect}"
    logger.info "Main Keys :: #{@main_params.inspect}"
    @main_params.each do |prm|
      logger.info "Keys for #{prm} are :: #{params["#{prm}"].keys.inspect}"
    end
    @entity_division_sub = EntityDivision.where(assigned_code: params[:code], active_status: true).order(created_at: :desc).first
    if @entity_division_sub && @entity_division_sub.activity_type_code == "DON"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (DON)", "DON"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "PDD"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (PDD)", "PDD"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "SPC"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (SPC)", "SPC"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "GEN"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (GEN)", "GEN"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "OMC"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (OMC)", "OMC"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "MOP"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (MOP)", "MOP"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "HSP"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (HSP)", "HSP"]]
    else
      @entity_div_sub_activities = EntityDivSubActivity.where(entity_div_code: params[:code], active_status: true, del_status: false).order(div_sub_activity_desc: :asc)
      @activity_codes = @entity_div_sub_activities.map { |a| ["#{a.div_sub_activity_desc} (#{a.sub_activity_code})", "#{a.sub_activity_code}"] }.insert(0,['Select an Activity Code', ""])
    end
    #@activity_codes = [["Donations (DON)", "DON"], ["Levy (LVY)", "LVY"], ["Project (PRJ)", "PRJ"], ["Pledges (PLG)", "PLG"]]
    @activity_sub_div_class = [['Select a class', ""], ["Double", 4], ["Single", 3], ["VIP", 1],  ["Standard", 2]]
    @activity_sub_div_cl = [["Double", 4], ["Single", 3], ["VIP", 1],  ["Standard", 2]]
    @activity_sub_div_classes = ActivitySubDivClass.where(entity_div_code: params[:code], active_status: true, del_status: false).order(class_desc: :asc)
    @act_sub_div_classes = @activity_sub_div_classes.map { |a| [a.class_desc, a.id] }.insert(0,['Select a class', ""])

    valid_result, error_num, div_num, row_num = EntityDivision.division_setup_validation(params, @main_params, @div_activity_type, entity_division_params)
    lov_validate_result, lov_error_num, lov_row_num = EntityDivision.division_lov_validation(@the_div_lov, params[:code], entity_division_params, @div_activity_type, "CREATE")
    respond_to do |format|

      logger.info "Couldn't pass. Validate result:: #{valid_result}, error number :: #{error_num}, Activity number :: #{div_num}, Time number :: #{row_num}"
      logger.info " LOV:: Validate result:: #{lov_validate_result}, Error number :: #{lov_error_num}, Row number #{lov_row_num}"
      if valid_result && lov_validate_result
        logger.info "=================== SAVING ==================="
        EntityDivision.division_lov_save(@the_div_lov, params[:code], entity_division_params, current_user)
        EntityDivision.division_setup_save(params, @main_params, @div_activity_type, entity_division_params, current_user)
        entity_division_index
        flash.now[:notice] = "Setup creation was successful."
        format.js { render :entity_division_index }
      else
        if lov_validate_result != true
          if lov_error_num == "1"
            flash.now[:danger] = "No input has been made for the list of values. Kindly list some values."
            format.js { render :division_setup }
          elsif lov_error_num == "2"
            flash.now[:danger] = "No input has been entered for the list of values. Kindly add a row."
            format.js { render :division_setup }
          elsif lov_error_num == "3"
            flash.now[:danger] = "Row number #{lov_row_num} is incomplete. Kindly complete and submit."
            format.js { render :division_setup }
          elsif lov_error_num == "4"
            flash.now[:danger] = "Kindly choose an option for the list of values setup."
            format.js { render :division_setup }
          else
            flash.now[:danger] = "============= 2 OUT OF SCOPE ==============."
            format.js { render :division_setup }
          end


        elsif valid_result != true
          logger.info ""
          if error_num == "1"
            flash.now[:danger] = "Activity inputs for activity #{div_num} is incomplete."
            format.js { render :division_setup }
          elsif error_num == "2"
            flash.now[:danger] = "Kindly setup time schedule for activity #{div_num}."
            format.js { render :division_setup }
          elsif error_num == "3"
            flash.now[:danger] = "No data has been entered for time schedule at activity #{div_num}."
            format.js { render :division_setup }
          elsif error_num == "4"
            flash.now[:danger] = "Time schedule is incomplete for activity #{div_num} at row number #{row_num}." #"Kindly choose an option for the division activities setup."
            format.js { render :division_setup }
          elsif error_num == "5"
            flash.now[:danger] = "Kindly choose an option to setup the division activities."
            format.js { render :division_setup }
          elsif error_num == "6"
            flash.now[:danger] = "No activity has been added. Kindly setup an activity."
            format.js { render :division_setup }
          else
            flash.now[:danger] = "Kindly add time schedules for activity #{div_num}." #"============= 1 OUT OF SCOPE ==============."
            format.js { render :division_setup }
          end
        else
          flash.now[:danger] = "============= OUT OF SCOPE ==============."
          format.js { render :division_setup }
        end

      end

    end

  end



  def division_edit_setup
    if current_user.merchant_admin?
      params[:entity_code] = current_user.user_entity_code
    elsif current_user.merchant_service?
      params[:entity_code] = current_user.user_entity_code
      params[:code] = current_user.user_division_code
    end
    @entity_division = EntityDivision.new
    @entity_div = EntityDivision.where(assigned_code: params[:code], active_status: true).order(created_at: :desc).first
    @div_activity_type = @entity_div.activity_type.assigned_code
    @entity_info = EntityInfo.where(assigned_code: params[:entity_code], active_status: true, del_status: false).order(created_at: :desc).first
    @entity_name = @entity_info ? "#{@entity_info.entity_name} (#{@entity_info.entity_alias})" : ""
    @activity_divs = ActivityDiv.where(division_code: params[:code], active_status: true).order(created_at: :desc)
    @activity_sub_divs = ActivitySubDiv.where(active_status: true).order(created_at: :desc)
    @division_activity_lovs = DivisionActivityLov.where(division_code: params[:code], active_status: true).order(created_at: :desc)

    @display_div_num = @activity_divs.size
    @entity_division_sub = EntityDivision.where(assigned_code: params[:code], active_status: true).order(created_at: :desc).first
    if @entity_division_sub && @entity_division_sub.activity_type_code == "DON"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (DON)", "DON"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "PDD"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (PDD)", "PDD"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "SPC"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (SPC)", "SPC"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "GEN"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (GEN)", "GEN"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "OMC"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (OMC)", "OMC"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "MOP"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (MOP)", "MOP"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "HSP"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (HSP)", "HSP"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "GBC"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (GBC)", "GBC"]]
    else
      @entity_div_sub_activities = EntityDivSubActivity.where(entity_div_code: params[:code], active_status: true, del_status: false).order(div_sub_activity_desc: :asc)
      @activity_codes = @entity_div_sub_activities.map { |a| ["#{a.div_sub_activity_desc} (#{a.sub_activity_code})", "#{a.sub_activity_code}"] }.insert(0,['Select an Activity Code', ""])
    end

    #@activity_codes = [["Donations (DON)", "DON"], ["Levy (LVY)", "LVY"], ["Project (PRJ)", "PRJ"], ["Pledges (PLG)", "PLG"]]
    @activity_sub_div_class = [['Select a class', ""], ["Double", 4], ["Single", 3], ["VIP", 1],  ["Standard", 2]]
    @activity_sub_div_cl = [["Double", 4], ["Single", 3], ["VIP", 1],  ["Standard", 2]]
    @activity_sub_div_classes = ActivitySubDivClass.where(entity_div_code: params[:code], active_status: true, del_status: false).order(class_desc: :asc)
    @act_sub_div_classes = @activity_sub_div_classes.map { |a| [a.class_desc, a.id] }.insert(0,['Select a class', ""])
    @activity_div_fixtures = ActivityFixture.where(division_code: params[:code], active_status: true).order(created_at: :desc)
    @activity_fixtures = @activity_div_fixtures.map { |a| ["#{a.activity_participanta.participant_name} VS #{a.activity_participantb.participant_name}", a.id] }.insert(0,['Select a fixtures', ""])

    logger.info "Activity Sub Division Classes: #{@activity_sub_div_classes.inspect} \n and Act Sub Division Classes: #{@act_sub_div_classes.inspect}"
    #region_update_city = region_id_record.cities.where(active_status: true).order(city_town_name: :asc).map { |a| [a.city_town_name, a.id] }.insert(0,['Please select a city', ""])

  end



  def update_division_setup
    if current_user.merchant_admin?
      params[:entity_code] = current_user.user_entity_code
    elsif current_user.merchant_service?
      params[:entity_code] = current_user.user_entity_code
      params[:code] = current_user.user_division_code
    end
    @entity_division = EntityDivision.new(entity_division_params)
    logger.info "==================== I WAS HIT HERE ====================="
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1
    @entity_div = EntityDivision.where(assigned_code: params[:code], active_status: true).order(created_at: :desc).first
    @div_activity_type = @entity_div.activity_type.assigned_code
    @activity_divs = ActivityDiv.where(division_code: params[:code], active_status: true).order(created_at: :desc)
    @activity_sub_divs = ActivitySubDiv.where(active_status: true).order(created_at: :desc)
    @division_activity_lovs = DivisionActivityLov.where(division_code: params[:code], active_status: true).order(created_at: :desc)

    @the_div_lov = params[:the_div_acts_lov]
    @main_params = EntityDivision.hsh_key_validator(params)
    @display_div_num = @main_params.any? ? @main_params.size : 1
    @entity_info = EntityInfo.where(assigned_code: params[:entity_code], active_status: true, del_status: false).order(created_at: :desc).first
    @entity_name = @entity_info ? "#{@entity_info.entity_name} (#{@entity_info.entity_alias})" : ""
    #@entity_divisions = EntityDivision.where(entity_code: params[:entity_code], del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
    #@the_activity_sub = params[:the_div_acts_lov]
    logger.info "== The div_acts_lov params size :: #{@the_div_lov_num.inspect}"
    logger.info "All Keys :: #{params.keys.inspect}"
    logger.info "Main Keys :: #{@main_params.inspect}"
    @main_params.each do |prm|
      logger.info "Keys for #{prm} are :: #{params["#{prm}"].keys.inspect}"
    end


    @entity_division_sub = EntityDivision.where(assigned_code: params[:code], active_status: true).order(created_at: :desc).first
    if @entity_division_sub && @entity_division_sub.activity_type_code == "DON"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (DON)", "DON"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "PDD"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (PDD)", "PDD"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "SPC"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (SPC)", "SPC"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "GEN"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (GEN)", "GEN"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "OMC"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (OMC)", "OMC"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "MOP"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (MOP)", "MOP"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "HSP"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (HSP)", "HSP"]]
    elsif @entity_division_sub && @entity_division_sub.activity_type_code == "GBC"
      @activity_type_desc = ActivityType.where(assigned_code: @entity_division_sub.activity_type_code).first
      @activity_codes = [["#{@activity_type_desc.activity_type_desc} (GBC)", "GBC"]]
    else
      @entity_div_sub_activities = EntityDivSubActivity.where(entity_div_code: params[:code], active_status: true, del_status: false).order(div_sub_activity_desc: :asc)
      @activity_codes = @entity_div_sub_activities.map { |a| ["#{a.div_sub_activity_desc} (#{a.sub_activity_code})", "#{a.sub_activity_code}"] }.insert(0,['Select an Activity Code', ""])
    end
    #@activity_codes = [["Donations (DON)", "DON"], ["Levy (LVY)", "LVY"], ["Project (PRJ)", "PRJ"], ["Pledges (PLG)", "PLG"]]
    @activity_sub_div_class = [['Select a class', ""], ["Double", 4], ["Single", 3], ["VIP", 1],  ["Standard", 2]]
    @activity_sub_div_cl = [["Double", 4], ["Single", 3], ["VIP", 1],  ["Standard", 2]]
    @activity_sub_div_classes = ActivitySubDivClass.where(entity_div_code: params[:code], active_status: true, del_status: false).order(class_desc: :asc)
    @act_sub_div_classes = @activity_sub_div_classes.map { |a| [a.class_desc, a.id] }.insert(0,['Select a class', ""])
    @division_activity_lov = DivisionActivityLov.where(division_code: params[:code], active_status: true)
    valid_result, error_num, div_num, row_num = EntityDivision.division_setup_validation(params, @main_params, @div_activity_type, entity_division_params)
    lov_validate_result, lov_error_num, lov_row_num = EntityDivision.division_lov_validation(@the_div_lov, params[:code], entity_division_params, @div_activity_type, "UPDATE")


    respond_to do |format|
      logger.info "Couldn't pass. Validate result:: #{valid_result}, error number :: #{error_num}, Activity number :: #{div_num}, Time number :: #{row_num}"
      logger.info " LOV:: Validate result:: #{lov_validate_result}, Error number :: #{lov_error_num}, Row number #{lov_row_num}"
      if valid_result && lov_validate_result
        logger.info "=================== UPDATING... ==================="
        EntityDivision.division_lov_update(@the_div_lov, params[:code], entity_division_params, current_user)
        EntityDivision.division_setup_update(params, @main_params, @div_activity_type, entity_division_params, current_user)
        entity_division_index
        if lov_error_num == "2"
          flash.now[:notice] = "Deletion of all list of values was successful."
        else
          flash.now[:notice] = "Setup update was successful."
        end
        format.js { render :entity_division_index }
      else
        if lov_validate_result != true
          if lov_error_num == "1"
            flash.now[:danger] = "No input has been made for the list of values. Kindly list some values."
            format.js { render :division_edit_setup }
          elsif lov_error_num == "2"
            flash.now[:danger] = "No input has been entered for the list of values. Kindly add a row."
            format.js { render :division_edit_setup }
          elsif lov_error_num == "3"
            flash.now[:danger] = "Row number #{lov_row_num} of the list of values is incomplete. Kindly complete and submit."
            format.js { render :division_edit_setup }
          elsif lov_error_num == "4"
            flash.now[:danger] = "Kindly choose an option for the list of values setup."
            format.js { render :division_edit_setup }
          else
            flash.now[:danger] = "============= 2 OUT OF SCOPE ==============."
            format.js { render :division_edit_setup }
          end


        elsif valid_result != true
          logger.info ""
          if error_num == "1"
            flash.now[:danger] = "Activity inputs for activity #{div_num} is incomplete."
            format.js { render :division_edit_setup }
          elsif error_num == "2"
            flash.now[:danger] = "Kindly setup time schedule for activity #{div_num}."
            format.js { render :division_edit_setup }
          elsif error_num == "3"
            flash.now[:danger] = "No data has been entered for time schedule at activity #{div_num}."
            format.js { render :division_edit_setup }
          elsif error_num == "4"
            flash.now[:danger] = "Time schedule is incomplete for activity #{div_num} at row number #{row_num}." #"Kindly choose an option for the division activities setup."
            format.js { render :division_edit_setup }
          elsif error_num == "5"
            flash.now[:danger] = "Kindly choose an option to setup the division activities."
            format.js { render :division_edit_setup }
          elsif error_num == "6"
            flash.now[:danger] = "No activity has been added. Kindly setup an activity."
            format.js { render :division_edit_setup }
          else
            flash.now[:danger] = "Kindly add time schedules for activity #{div_num}." #"============= 1 OUT OF SCOPE ==============."
            format.js { render :division_edit_setup }
          end
        else
          flash.now[:danger] = "============= OUT OF SCOPE ==============."
          format.js { render :division_edit_setup }
        end

      end

    end
  end

  # GET /entity_divisions/1
  # GET /entity_divisions/1.json
  def show
  end


  # GET /entity_divisions/new
  def new
    @entity_division = EntityDivision.new
    # @entity_division.activity_divs.build
    # @entity_division.entity_wallet_configs.build
    @display = @display.present? ? @display : params[:display_cnt].present? ? params[:display_cnt].to_i : 3
    params[:into_create] = params[:division].nil? ? "into_create" : ""
    @activity_types = ActivityType.where(active_status: true, del_status: false).order(assigned_code: :asc)
    @region_masters = RegionMaster.where(active_status: true).order(region_name: :asc)
    @city_town_masters = CityTownMaster.where(id: 0)
    @suburb_masters = SuburbMaster.where(id: 0)
    @city_masters = CityTownMaster.where(id: 0)
    @sub_masters = SuburbMaster.where(id: 0)
    @data_media = ""
  end


  # GET /entity_divisions/1/edit
  def edit
    @new_record = EntityDivision.new
    # @new_record.activity_divs.build
    # @entity_division.entity_wallet_configs.build
    # @new_record.entity_wallet_configs.build
     @entity_wallet_config = EntityWalletConfig.where(division_code: @entity_division.assigned_code, active_status: true, del_status: false).order(created_at: :desc).first
     if @entity_wallet_config
       @service_id = @entity_wallet_config.service_id
       @secret_key = @entity_wallet_config.secret_key
       @client_key = @entity_wallet_config.client_key
     else
      @service_id = ""
      @secret_key = ""
      @client_key = ""
     end

    @region_masters = RegionMaster.where(active_status: true).order(region_name: :asc)
    @activity_types = ActivityType.where(active_status: true, del_status: false).order(assigned_code: :asc)
    @assigned_service_codes = @entity_division.assigned_service_codes.where(active_status: true, del_status: false).order(created_at: :desc)
    @service_code = @assigned_service_codes.exists? ? @assigned_service_codes.first.service_code : ""
    @company_code = @assigned_service_codes.exists? ? @assigned_service_codes.first.company_code : ""
    @company_url = @assigned_service_codes.exists? ? @assigned_service_codes.first.company_url : ""
    @current_div_media = "https://res.cloudinary.com/appsnmob/#{@entity_division.media_data}"
    @suburb_id = @entity_division.suburb_id
    if @suburb_id.present?
      logger.info "Long chain is :: #{@entity_division.suburb_master.a_city.a_region.inspect}"

      logger.info "For suburb id :: #{@suburb_id.inspect}"
      @sub_masters = SuburbMaster.where(id: @suburb_id).last
      logger.info "Sub Master #{@sub_masters.inspect}"
      logger.info "City id :: #{@sub_masters.a_city.inspect}"
      @region_id = @sub_masters.a_city.region_id
      @city_id = @sub_masters.city_town_id
      @entity_division.region_name = @region_id
      @entity_division.city_town_name = @city_id
      @city_town_masters = CityTownMaster.where(region_id: @region_id)
      @suburb_masters = SuburbMaster.where(city_town_id: @sub_masters.city_town_id)
      logger.info "Region id is  :: #{@region_id.inspect}"
    else
      @region_id = []
      @city_id = []
      @suburb_id = []
      @city_town_masters = []
      @suburb_masters = []
    end

  end




  # POST /entity_divisions
  # POST /entity_divisions.json
  # def create
  #   @new_record = EntityDivision.new(entity_division_params)
  #   @entity_division = EntityDivision.new(entity_division_params)
  #   if entity_division_params[:action_type] == "for_update"
  #     @entity_wallet_config = EntityWalletConfig.where(division_code: params[:code], active_status: true, del_status: false).order(created_at: :desc).first
  #     @entity_wallet = EntityWalletConfig.where(division_code: params[:code]).first
  #
  #     if @entity_wallet_config
  #       @service_id = entity_division_params["entity_wallet_configs_attributes"]["0"]["service_id"] #@entity_division.service_id
  #       @secret_key = entity_division_params["entity_wallet_configs_attributes"]["0"]["secret_key"] #@entity_division.secret_key
  #       @client_key = entity_division_params["entity_wallet_configs_attributes"]["0"]["client_key"] #@entity_division.client_key
  #     else
  #       @service_id = ""
  #       @secret_key = ""
  #       @client_key = ""
  #     end
  #
  #     @region_masters = RegionMaster.where(active_status: true).order(region_name: :asc)
  #     @activity_types = ActivityType.where(active_status: true, del_status: false).order(assigned_code: :asc)
  #
  #     @suburb_id = @entity_division.suburb_id
  #     if @suburb_id.present?
  #       logger.info "Long chain :: #{@entity_division.suburb_master.a_city.a_region.inspect}"
  #       logger.info "For suburb id :: #{@suburb_id.inspect}"
  #       @sub_masters = SuburbMaster.where(id: @suburb_id).last
  #       logger.info "Sub Master #{@sub_masters.inspect}"
  #       logger.info "City id :: #{@sub_masters.a_city.inspect}"
  #       @region_id = @sub_masters.a_city.region_id
  #       @city_id = @sub_masters.city_town_id
  #       @entity_division.region_name = @region_id
  #       @entity_division.city_name = @city_id
  #       @city_town_masters = CityTownMaster.where(region_id: @region_id)
  #       @suburb_masters = SuburbMaster.where(city_id: @sub_masters.city_id)
  #       logger.info "Region id :: #{@region_id.inspect}"
  #     else
  #       @region_id = []
  #       @city_id = []
  #       @suburb_id = []
  #       @city_town_masters = []
  #       @suburb_masters = []
  #     end
  #   else
  #     @activity_types = ActivityType.where(active_status: true, del_status: false).order(assigned_code: :asc)
  #     @region_masters = RegionMaster.where(active_status: true).order(region_name: :asc)
  #     entity_division_params[:region_name].present? ? @city_town_masters = CityTownMaster.where(active_status: true, region_id: entity_division_params[:region_name]).order(city_town_name: :asc) : @city_town_masters = CityTownMaster.where(id: 0)
  #     entity_division_params[:city_town_name].present? ? @suburb_masters = SuburbMaster.where(active_status: true, city_town_id: entity_division_params[:city_town_name]).order(suburb_name: :asc) : @suburb_masters = SuburbMaster.where(id: 0)
  #
  #   end
  #
  #   respond_to do |format|
  #
  #     if @entity_division.valid?
  #
  #       unless params[:action_type] == "for_update"
  #         @entity_division.assigned_code = EntityDivision.gen_entity_div_code
  #         @entity_division.save
  #         logger.info "The Entity Division code is #{@entity_division.assigned_code.inspect}"
  #       end
  #
  #       if params[:action_type] == "for_update"
  #         if @entity_wallet
  #           division_params = entity_division_params
  #           # logger.info "OLD ENTITY DIVISION PARAMS IS #{division_params.inspect}"
  #           # logger.info "ENTITY WALLET CONFIG IS #{division_params["entity_wallet_configs_attributes"].inspect}"
  #           division_params[:assigned_code] = params[:code]
  #           wallet_params = division_params["entity_wallet_configs_attributes"]
  #           division_params = division_params.except("entity_wallet_configs_attributes")
  #           @entity_division = EntityDivision.new(division_params)
  #           @entity_division.save(validate: false)
  #           @entity_division.update(wallet_params)
  #           logger.info "NEW ENTITY DIVISION PARAMS IS #{division_params.inspect}"
  #         else
  #           @entity_division.assigned_code = params[:code]
  #           @entity_division.save
  #         end
  #       end
  #
  #       if params[:action_type] == "for_update"
  #         logger.info "UPDATING IN CREATE......... INTERESTING"
  #         EntityDivision.update_last_but_one('entity_division', 'assigned_code', params[:code])
  #       end
  #       format.html { redirect_to @entity_division, notice: 'Entity division was successfully created.' }
  #       flash.now[:danger] = "Entity division was successfully created."
  #       format.js { render :show}
  #       format.json { render :show, status: :created, location: @entity_division }
  #     else
  #       logger.info "Error messages:: #{@entity_division.errors.messages.inspect}"
  #       if params[:action_type] == "for_update"
  #         @new_record.valid?
  #         @service_id = entity_division_params["entity_wallet_configs_attributes"]["0"]["service_id"] #@entity_division.service_id
  #         @secret_key = entity_division_params["entity_wallet_configs_attributes"]["0"]["secret_key"] #@entity_division.secret_key
  #         @client_key = entity_division_params["entity_wallet_configs_attributes"]["0"]["client_key"] #@entity_division.client_key
  #         format.html { render :edit }
  #         format.js {render :edit }
  #       else
  #         format.html { render :new }
  #         format.js {render :new }
  #       end
  #       format.json { render json: @entity_division.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end




  #@entity_master = EntityWalletConfig.where("activity_type_code = '#{@entity_division.activity_type_code}' AND division_code IS NULL AND entity_code = #{@entity_division.entity_code} AND active_status = true")
  #if @entity_master
  #  @for_service_codes = AssignedServiceCode.new(entity_div_code: assigned_code, service_code: serv_code,
  #                                               active_status: true, del_status: false, user_id: current_user.id)
  #  @for_service_codes.save(validate: false)
  #
  #  @entity_division.assigned_code = assigned_code
  #  @entity_division.save(validate: false)
  #
  #  @entity_wallet_conf = EntityWalletConfig.new(entity_code: params[:entity_code], division_code: assigned_code,
  #                                               service_id: @entity_division.serv_id, secret_key: @entity_division.s_key,
  #                                               client_key: @entity_division.c_key, active_status: true, del_status: false,
  #                                               user_id: current_user.id)
  #  @entity_wallet_conf.save(validate: false)
  #
  #  flash.now[:notice] == "Merchant Service has been created successfully."
  #  format.js { render :show }



  def entity_div_create
    @entity_division = EntityDivision.new(entity_division_params)
    @display = @display.present? ? @display : params[:display_cnt].present? ? params[:display_cnt].to_i : 3
    #@display = nil
    params[:into_create] = params[:division].nil? ? "into_create" : ""
    @activity_types = ActivityType.where(active_status: true, del_status: false).order(assigned_code: :asc)
    @region_masters = RegionMaster.where(active_status: true).order(region_name: :asc)
    @city_town_masters = CityTownMaster.where(id: 0)
    @suburb_masters = SuburbMaster.where(id: 0)
    @data_media = !params[:entity_division].nil? && !params[:entity_division][:media_data].nil? ? params[:entity_division][:media_data] : ""

    media_uploader = VposCore::MediaDataUploader.new
    respond_to do |format|

      assigned_code = EntityDivision.gen_entity_div_code
      serv_code = @entity_division.service_code
      logger.info "Assigned Code :: #{assigned_code.inspect} and Short Code :: #{@entity_division.service_code.inspect}"
      valid_image, selected = EntityDivision.media_upload_validity(params[:entity_division], assigned_code)
      logger.info "the result of the validity ==== #{valid_image.inspect} and the selection ==== #{selected.inspect}########################"
      if @entity_division.valid? && assigned_code.present?
        @entity_division.min_amount = entity_division_params[:activity_type_code] == "DON" && entity_division_params[:min_amount].present? ? entity_division_params[:min_amount] : nil
        @entity_division.assigned_code = assigned_code
        @entity_division.reference = entity_division_params[:reference] ? true : false
        logger.info "the reference status I'm saving #{@entity_division.reference}"
        if selected && valid_image
         EntityDivision.media_upload_save(params[:entity_division], media_uploader, assigned_code, current_user.id)
        else
          @entity_division.save(validate: false)
        end

        # @entity_division.save(validate: false)

        @for_service_codes = AssignedServiceCode.new(entity_div_code: assigned_code, service_code: serv_code,
                                                     active_status: true, del_status: false, user_id: current_user.id,
                                                     company_code: entity_division_params[:company_code] ,
                                                     company_url: entity_division_params[:company_url], rate_status: false )
        @for_service_codes.save(validate: false)

        @entity_wallet_conf = EntityWalletConfig.new(entity_code: params[:entity_code], division_code: assigned_code,
                                                     service_id: @entity_division.serv_id, secret_key: @entity_division.s_key,
                                                     client_key: @entity_division.c_key, active_status: true, del_status: false,
                                                     user_id: current_user.id)
        @entity_wallet_conf.save(validate: false)
        @core_connect = VposCore::CoreConnect.new
        begin
          res=@core_connect.connection.post do |req|
            req.url '/get_qr_code'
            req.body = JSON.generate(
          { "merchants": [
                code: "#{serv_code}",
                url: "#{ENV['VPOS_QR_URL']}"
              ]
              }
            )
          end
          logger.info "Result from API main: #{res.inspect}"
          json_valid_res = @core_connect.json_validate(res.body)

          if json_valid_res
           # @result = JSON.parse(res.body)
           # resp_code = the_resp["resp_code"]
           # resp_desc = the_resp["resp_desc"]
           # if resp_code == "00"
             flash.now[:notice] == "Merchant Service has been created successfully."
             format.js { render :show }
           else
             flash.now[:notice] == "There was a problem generating QR code for the service."
             format.js { render :new }
           # end
          # else
          #   flash.now[:danger] = "Sorry, There was an issue. Kindly check and try again."
          #   format.js { render :new }
          end
        rescue Faraday::TimeoutError
          flash.now[:alert] = "Connection timed out. Please try again."
          format.js { render :new }
        rescue Faraday::SSLError
          logger.info "SSL Error ==============="
          flash.now[:danger] = "Sorry, There was an issue. Kindly check and try again."
          format.js { render :new }
        rescue Faraday::ConnectionFailed => e
          flash.now[:alert] = "Connection failed. Please try again shortly."
          format.js { render :new }
        end
      else
        @city_masters = @entity_division.region_name.present? ? CityTownMaster.where(active_status: true, region_id: @entity_division.region_name) : CityTownMaster.where(id: 0)
        @sub_masters = @entity_division.city_town_name.present? ? SuburbMaster.where(active_status: true, city_town_id: @entity_division.city_town_name) : SuburbMaster.where(id: 0)
        @service_code = @entity_division.service_code.present? ? @entity_division.service_code : nil
        logger.info "Alternative creation Error message:: #{@entity_division.errors.messages.inspect}"
        format.js { render :new }
      end

    end

  end

  def reset_qr_code
    if current_user.merchant_admin?
      params[:entity_code] = current_user.user_entity_code
    elsif current_user.merchant_service?
      params[:entity_code] = current_user.user_entity_code
      params[:code] = current_user.user_division_code
    end
    @assigned_code = params[:code]
    @find_service_code = AssignedServiceCode.where(entity_div_code: @assigned_code, active_status: true, del_status: false).order(created_at: :desc).first
    if @find_service_code
      AssignedServiceCode.update_last_but_one("assigned_service_code", "entity_div_code", @find_service_code.entity_div_code)

      @service_code = AssignedServiceCode.new(entity_div_code: @assigned_code, service_code: @find_service_code.service_code,
                                              active_status: true, del_status: false, user_id: current_user.id)
      @service_code.save(validate: false)
    end
    begin
      @core_connect = VposCore::CoreConnect.new
      res=@core_connect.connection.post do |req|
        req.url '/get_qr_code'
        req.body = JSON.generate(
          { "merchants": [
            code: "#{@service_code.service_code}",
            url: "#{ENV['VPOS_QR_URL']}"
          ]
          }
        )
      end
      logger.info "Result from API main: #{res.inspect}"
      json_valid_res = @core_connect.json_validate(res.body)

      if json_valid_res
          flash.now[:notice] == "QR code has been reset/regenerated successfully."
          format.js { render :index }
        else
          flash.now[:notice] == "There was a problem regenerating the QR code for the service. Kindly try again"
          format.js { render :request.referer }
      end
    rescue Faraday::TimeoutError
      flash.now[:alert] = "Connection timed out. Please try again."
      format.js { render :request.referer}
    rescue Faraday::SSLError
      logger.info "SSL Error ==============="
      flash.now[:danger] = "Sorry, There was an issue. Kindly check and try again."
      format.js { render :request.referer }
    rescue Faraday::ConnectionFailed => e
      flash.now[:alert] = "Connection failed. Please try again shortly."
      format.js { render :request.referer }
    end

  end


  def create
    @entity_division = EntityDivision.new(entity_division_params)
    @display = params[:divisions]
    @display_length = params[:display_cnt]
    @activity_types = ActivityType.where(active_status: true, del_status: false).order(assigned_code: :asc)
    @region_masters = RegionMaster.where(active_status: true).order(region_name: :asc)

    @city_masters = @entity_division.region_name.present? ? CityTownMaster.where(active_status: true, region_id: @entity_division.region_name) : CityTownMaster.where(id: 0)
    @sub_masters = @entity_division.city_town_name.present? ? SuburbMaster.where(active_status: true, city_town_id: @entity_division.city_town_name) : SuburbMaster.where(id: 0)

    entity_division_params[:region_name].present? ? @city_town_masters = CityTownMaster.where(active_status: true, region_id: entity_division_params[:region_name]).order(city_town_name: :asc).insert(0,['Please select a city', ""]) : @city_town_masters = [["", ""]].insert(0,['Please select a city', ""])# CityTownMaster.where(id: 0)
    entity_division_params[:city_town_name].present? ? @suburb_masters = SuburbMaster.where(active_status: true, city_town_id: entity_division_params[:city_town_name]).order(suburb_name: :asc).insert(0,['Please select a suburb', ""]) : @suburb_masters = [["", ""]].insert(0,['Please select a suburb', ""])# SuburbMaster.where(id: 0)

    logger.info "Display :: #{@display.inspect} and Display Length :: #{@display_length.inspect}"
    validity_result, div_num, service_code_exist, same_incoming_service_code, incorrect_sender_id, master_wallet_exist = EntityDivision.validate_entity_divisions(@display, entity_division_params)
    logger.info "Validity result is :: #{validity_result.inspect} and division number is :: #{div_num.inspect} and service code existence :: #{service_code_exist.inspect} and same incoming service code :: #{same_incoming_service_code.inspect}"
    respond_to do |format|
      if validity_result
        logger.info "I WAS HERE SOME...."
        EntityDivision.save_entity_divisions(@display, entity_division_params, current_user)
        format.html { redirect_to @entity_division, notice: 'Entity division was successfully created.' }
        flash.now[:notice] = "Merchant Service was successfully created."
        format.js { render :show}
        format.json { render :show, status: :ok, location: @entity_division }
      else
        if service_code_exist
          flash.now[:danger] = "Sorry, the service code extension at number #{div_num} already exist. Try again."
        else

          if same_incoming_service_code
            flash.now[:danger] = "Sorry, the service code extension at number #{div_num} is a repetition. Please check and try again."
          else
            if params[:display_cnt] == nil || params[:display_cnt] == 0
              flash.now[:danger] = div_num == 0 ? "Kindly select the number of divisions." : "Please ensure that every field has been filled at number #{div_num}."
            else
              if incorrect_sender_id
                flash.now[:danger] = "Sorry, minimum characters for SMS sender ID is 3 and maximum is 9. Check number #{div_num} and try again."
              else
                if master_wallet_exist
                  flash.now[:danger] = div_num == 0 ? "You haven't entered anything yet. Please try again." : "Please ensure that every field has been filled at number #{div_num}."
                else
                  flash.now[:danger] = "Sorry, Kindly setup merchant wallet for the activity type at number #{div_num}."
                end
              end
            end
          end
        end

        format.html { render :new }
        format.js {render :new }
        format.json { render json: @entity_division.errors, status: :unprocessable_entity }
      end
    end
  end



  # PATCH/PUT /entity_divisions/1
  # PATCH/PUT /entity_divisions/1.json
  def update
    # entity_division_params[:assigned_code] = @entity_division.assigned_code
    # entity_division_params[:assigned_code] = @entity_division.assigned_code
    @new_record = EntityDivision.new(entity_division_params)
    @activity_types = ActivityType.where(active_status: true, del_status: false).order(assigned_code: :asc)
    @region_masters = RegionMaster.where(active_status: true).order(region_name: :asc)
    entity_division_params[:region_name].present? ? @city_town_masters = CityTownMaster.where(active_status: true, region_id: entity_division_params[:region_name]).order(city_town_name: :asc) : @city_town_masters = [["", ""]].insert(0,['Please select a city', ""])
    entity_division_params[:city_town_name].present? ? @suburb_masters = SuburbMaster.where(active_status: true, city_town_id: entity_division_params[:city_town_name]).order(suburb_name: :asc) : @suburb_masters = [["", ""]].insert(0,['Please select a suburb', ""])
    @data_media = !params[:entity_division].nil? && !params[:entity_division][:media_data].nil? ? params[:entity_division][:media_data] : ""
    @current_div_media = "https://res.cloudinary.com/appsnmob/#{@entity_division.media_data}"

    @suburb_id = entity_division_params[:suburb_id]
    if @suburb_id.present?
      #logger.info "Long chain :: #{@entity_division.suburb_master.a_city.a_region.inspect}"
      logger.info "For suburb id :: #{@suburb_id.inspect}"
      @sub_masters = SuburbMaster.where(id: @suburb_id).last
      logger.info "Sub Master #{@sub_masters.inspect}"
      logger.info "City id :: #{@sub_masters.a_city.inspect}"
      @region_id = @sub_masters.a_city.region_id
      @city_id = @sub_masters.city_town_id
      @entity_division.region_name = @region_id
      @entity_division.city_town_name = @city_id
      @city_town_masters = CityTownMaster.where(region_id: @region_id)
      @suburb_masters = SuburbMaster.where(city_town_id: @sub_masters.city_town_id)
      logger.info "Region id :: #{@region_id.inspect}"
    else
      @region_id = entity_division_params[:region_name].present? ? entity_division_params[:region_name] : []
      @city_id = entity_division_params[:city_town_name].present? ? entity_division_params[:city_town_name] : []
      @suburb_id = []
      entity_division_params[:region_name].present? ? @city_town_masters = CityTownMaster.where(active_status: true, region_id: entity_division_params[:region_name]).order(city_town_name: :asc) : @city_town_masters = CityTownMaster.where(id: 0)
      entity_division_params[:city_town_name].present? ? @suburb_masters = SuburbMaster.where(active_status: true, city_town_id: entity_division_params[:city_town_name]).order(suburb_name: :asc) : @suburb_masters = SuburbMaster.where(id: 0)

    end
    media_uploader = VposCore::MediaDataUploader.new
    respond_to do |format|
      # @new_record.assigned_code = @entity_division.assigned_code
      if @new_record.valid?#.update(entity_division_params)
        logger.info "LOGGER 1 ====================================================="
        @new_record.assigned_code = @entity_division.assigned_code
        @new_record.min_amount = entity_division_params[:activity_type_code] == "DON" && entity_division_params[:min_amount].present? ? entity_division_params[:min_amount] : nil
        valid_image, selected = EntityDivision.media_upload_validity(params[:entity_division], @new_record.assigned_code)
        if valid_image && selected
          EntityDivision.media_upload_save(params[:entity_division], media_uploader, @new_record.assigned_code, current_user.id)
        else
          @new_record.save(validate: false)
        end
        # @new_record.save(validate: false)
        @assigned_service_code = AssignedServiceCode.where(del_status: false, entity_div_code: @entity_division.assigned_code).order(created_at: :desc)
        @active_service_code = @assigned_service_code.where(active_status: true).first
        if @active_service_code
          unless entity_division_params[:service_code] == @active_service_code.service_code
            logger.info "LOGGER 2 ========================================================"
            #@active_service_code.update(service_code: entity_division_params[:service_code], user_id: current_user.id)
            @service_code = AssignedServiceCode.new(entity_div_code: @entity_division.assigned_code, service_code: entity_division_params[:service_code],
                                                    active_status: true, del_status: false, user_id: current_user.id, assigned_qr_code: @active_service_code.assigned_qr_code,
                                                    url: @active_service_code.url, rate_status: @active_service_code.rate_status, company_code: entity_division_params[:company_code] , company_url: entity_division_params[:company_url])
            @service_code.save(validate: false)

            AssignedServiceCode.update_last_but_one("assigned_service_code", "entity_div_code", @active_service_code.entity_div_code)

          end
        else
          @service_code = AssignedServiceCode.new(entity_div_code: @entity_division.assigned_code, service_code: entity_division_params[:service_code],
                                                  active_status: true, del_status: false, user_id: current_user.id, rate_status: true, company_code: entity_division_params[:company_code] , company_url: entity_division_params[:company_url])
          @service_code.save(validate: false)
          @core_connect = VposCore::CoreConnect.new
          begin
            res=@core_connect.connection.post do |req|
              req.url '/get_qr_code'
              req.body = JSON.generate(
                { "merchants": [
                  code: "#{@service_code.service_code}",
                  url: "#{ENV['VPOS_QR_URL']}"
                ]
                }
              )
            end
            logger.info "Result from API main: #{res.inspect}"
            json_valid_res = @core_connect.json_validate(res.body)
            if json_valid_res
              logger.info " Hurray The QR was generated"
            end
          rescue Faraday::TimeoutError
            flash.now[:alert] = "Connection timed out. Please try again."
          rescue Faraday::SSLError
            logger.info "SSL Error ==============="
            flash.now[:danger] = "Sorry, There was an issue. Kindly check and try again."
          rescue Faraday::ConnectionFailed => e
            flash.now[:alert] = "Connection failed. Please try again shortly."
          end
        end

        EntityDivision.update_last_but_one("entity_division", "assigned_code", @entity_division.assigned_code)

        @for_wallet_config = EntityWalletConfig.where(entity_code: params[:entity_code], division_code: @entity_division.assigned_code,
                                                      active_status: true, del_status: false).order(created_at: :desc).first

        if @new_record.link_master
          if @for_wallet_config
            EntityWalletConfig.update_last_but_one("entity_wallet_configs", "division_code", @for_wallet_config.division_code)
          end
        else
          @wallet_config = EntityWalletConfig.new(entity_code: @new_record.entity_code, service_id: @new_record.serv_id, secret_key: @new_record.s_key,
                                                  client_key: @new_record.c_key, division_code: @entity_division.assigned_code,
                                                  active_status: true, del_status: false, user_id: current_user.id)
          @wallet_config.save(validate: false)
          if @for_wallet_config
            EntityWalletConfig.update_last_but_one("entity_wallet_configs", "division_code", @for_wallet_config.division_code)
          end
        end


        #@for_wallet_config = EntityWalletConfig.where(entity_code: params[:entity_code], division_code: @entity_division.assigned_code,
        #                                              active_status: true, del_status: false).order(created_at: :desc).first
        #if @entity_division.link_master == false && @for_wallet_config
        #  unless entity_division_params[:serv_id] == @for_wallet_config.service_id && entity_division_params[:c_key] == @for_wallet_config.client_key && entity_division_params[:s_key] == @for_wallet_config.secret_key
        #    #@for_wallet_config.update(entity_code: params[:entity_code], service_id: entity_division_params[:serv_id], client_key: entity_division_params[:c_key],
        #    #                          secret_key: entity_division_params[:s_key], user_id: current_user.id)
        #    logger.info "I PASSED FOR WALLET PER SERVICE SAVING =============================="
        #    @for_wallet_config.service_id = entity_division_params[:serv_id]
        #    @for_wallet_config.client_key = entity_division_params[:c_key]
        #    @for_wallet_config.secret_key = entity_division_params[:s_key]
        #    @for_wallet_config.save(validate: false)
        #  end
        #end

        @entity_division.sms_sender_id = @new_record.sms_sender_id
        format.html { redirect_to @entity_division, notice: 'Entity division was successfully updated.' }
        flash.now[:notice] = "Merchant Service was successfully updated."
        format.js { render :show}
        format.json { render :show, status: :ok, location: @entity_division }
      else

        logger.info "LOGGER 3 =============================================================="
        logger.info "Error message 1 :: #{@new_record.errors.messages.inspect}"
        # @entity_division = @new_record
        # @entity_division.for_update = true
        #@entity_division.entity_code = ""

        @entity_wallet_config = EntityWalletConfig.where(division_code: @entity_division.assigned_code, active_status: true, del_status: false).order(created_at: :desc).first
        if @entity_wallet_config
          @service_id = entity_division_params[:serv_id].present? ? entity_division_params[:serv_id] : ""
          @secret_key = entity_division_params[:s_key].present? ? entity_division_params[:s_key] : ""
          @client_key = entity_division_params[:c_key].present? ? entity_division_params[:c_key] : ""
        else
          @service_id = ""
          @secret_key = ""
          @client_key = ""
        end

        entity_division_params[:entity_code] = ""
        @entity_division.update(entity_division_params)
        logger.info "Error message 2 :: #{@entity_division.errors.messages.inspect}"
        @service_code = entity_division_params[:service_code].present? ? entity_division_params[:service_code] : ""
        format.html { render :edit }
        format.js {render :edit }
        format.json { render json: @entity_division.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entity_divisions/1
  # DELETE /entity_divisions/1.json
  def destroy
    if current_user.merchant_admin?
      params[:entity_code] = current_user.user_entity_code
    end
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    params[:count1] ? params[:count1] : params[:count1] = 50
    params[:page1] ? params[:page1] : params[:page1] = 1

    @entity_division = EntityDivision.where(assigned_code: params[:id], del_status: false).order('id desc').first

    if @entity_division.active_status && @entity_division.del_status == false
      EntityDivision.disable_by_update_onef("entity_division","assigned_code",@entity_division.assigned_code)
      EntityDivision.disable_by_update_onef("assigned_service_code","entity_div_code",@entity_division.assigned_code)
      EntityDivision.disable_by_update_onef("entity_wallet_configs","division_code",@entity_division.assigned_code)

      @entity_divisions = EntityDivision.where(entity_code: params[:entity_code], del_status: false).paginate(:page => params[:page1], :per_page => params[:count1]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to entity_divisions_url, notice: 'Occupation master was successfully disabled.' }
        flash.now[:note] = 'Merchant division was successfully disabled.'
        format.js { render :layout => false}
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end

    elsif @entity_division.active_status == false && @entity_division.del_status == false
      EntityDivision.enable_by_update_onet("entity_division","assigned_code",@entity_division.assigned_code)
      EntityDivision.enable_by_update_onet("assigned_service_code","entity_div_code", @entity_division.assigned_code)
      EntityDivision.enable_by_update_onet("entity_wallet_configs", "division_code", @entity_division.assigned_code)

      @entity_divisions = EntityDivision.where(entity_code: params[:entity_code], del_status: false).paginate(:page => params[:page1], :per_page => params[:count1]).order('created_at desc')

      respond_to do |format|
        format.html { redirect_to entity_infos_url, notice: 'Allergy master was successfully enabled.' }
        flash.now[:notice] = 'Merchant division was successfully enabled.'
        format.js { render :layout => false }
        format.json { head :no_content }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_entity_division
    # @entity_division = EntityDivision.find(params[:id])
    @entity_division = EntityDivision.where(assigned_code: params[:id], active_status: true, del_status: false).order('id desc').first
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def entity_division_params
    params.require(:entity_division).permit(:entity_code, :assigned_code, :division_name, :division_alias, :action_type, :suburb_id, :event_progress,
                                            :activity_type_code, :service_label, :region_name, :city_town_name, :comment, :link_master, :card_option_status,
                                            :div_lov_query, :activity_query, :sub_activity_query, :serv_id, :s_key, :c_key, :created_at, :payment_type,
                                            :sport_type, :sport_category, :category_type, :sms_sender_id, :allow_qr, :min_amount, :activity_loc, :extra_desc,
                                            :active_status, :del_status, :user_id, :service_code, :for_update, :media_data, :media_path, :media_type, :ref_label,
                                            :company_code, :company_url, :reference,:attendant_prefix, divisions: [], :the_div_acts_lov => {})
    # entity_wallet_configs_attributes: [:id, :division_code, :service_id, :secret_key, :client_key, :comment, :active_status, :del_status, :user_id]
    #activity_divs_attributes: [:id, :division_code, :activity_div_desc, :activity_date, :comment, :active_status, :del_status, :user_id],


  end
end