class FundMovementsController < ApplicationController
  before_action :set_fund_movement, only: [:show]
  load_and_authorize_resource
  before_action :load_permissions
  require 'vpos_core'

  # GET /fund_movements
  # GET /fund_movements.json
  def index
    #@fund_movements = FundMovement.all
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1
    params[:page].present? ? page = params[:page].to_i : page = 1

    params[:count1] ? params[:count1] : params[:count1] = 50
    params[:page1] ? params[:page1] : params[:page1] = 1

    params[:count2] ? params[:count2] : params[:count2] = 50
    params[:page2] ? params[:page2] : params[:page2] = 1

    #$merchant_filter = ""
    @core_encryptor = VposCore::VposEncryptor.new

    if current_user.super_admin? || current_user.super_user?
      @merchant_search = EntityInfo.where(active_status: true).order(entity_name: :asc)
      @merchant_code_search = EntityInfo.where(active_status: true).order(assigned_code: :asc)
      @merchant_cat_search = EntityCategory.where(active_status: true).order(category_name: :asc)
      @merchant_service_search = EntityDivision.where(active_status: true).order(division_name: :asc)


      @entity_infos = EntityInfo.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order(created_at: :desc)
      @fund_movements = FundMovement.paginate(:page => params[:page], :per_page => params[:count2]).order(created_at: :desc)

    elsif current_user.merchant_admin?
      params[:entity_code] = current_user.user_entity_code

      @entity_info = EntityInfo.where(assigned_code: params[:entity_code], active_status: true).order(created_at: :desc).first
      @entity_name = @entity_info ? @entity_info.entity_name : ""
      @entity_divisions = EntityDivision.where(entity_code: params[:entity_code], active_status: true, del_status: false).paginate(:page => params[:page1], :per_page => params[:count1]).order(created_at: :desc)

      @merchant_service_search = EntityDivision.where(active_status: true, entity_code: current_user.user_entity_code).order(division_name: :asc)
      entity_div_id_str = "'0'"
      @entity_divs = EntityDivision.where(entity_code: current_user.user_entity_code, active_status: true)
      @entity_divs.each do |entity_div|
        entity_div_id_str << ",'#{entity_div.assigned_code}'"
      end
      final_div_ids = "(#{entity_div_id_str})"
      @fund_movements = FundMovement.where("entity_div_code IN #{final_div_ids}").paginate(:page => params[:page], :per_page => params[:count2]).order(created_at: :desc)

    elsif current_user.merchant_service?
      params[:entity_code] = current_user.user_entity_code
      params[:division_code] = current_user.user_division_code

      @entity_info = EntityInfo.where(assigned_code: params[:entity_code], active_status: true).order(created_at: :desc).first
      @entity_name = @entity_info ? @entity_info.entity_name : ""
      @entity_div = EntityDivision.where(assigned_code: params[:division_code], active_status: true).order(created_at: :desc).first
      @division_name = @entity_div ? "(#{@entity_div.division_name})" : ""
      @fund_movements = FundMovement.where(entity_div_code: params[:division_code]).paginate(:page => params[:page], :per_page => params[:count2]).order(created_at: :desc)

    end

  end

  def settlement_entity_info_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    if params[:filter_main].present?
      logger.info "FILTER MAIN ============================="
      params[:filter_main] = params[:filter_main].to_unsafe_h
    else
      #params[:filter_main] = ""
    end

    the_search = ""
    search_arr = []
    #@entity_code = params[:entity_code]
    #@code = params[:code]

    if params[:filter_main].present? || params[:entity_name].present? || params[:assigned_code].present? || params[:entity_cat].present? #|| params[:cust_num].present? || params[:trans_id].present? || params[:nw].present? || params[:status].present? || params[:start_date].present? || params[:end_date].present?

      filter_params = params[:filter_main]
      if params[:filter_main].present?
        @entity_name = filter_params[:entity_name]
        @assigned_code = filter_params[:assigned_code]
        @entity_cat = filter_params[:entity_cat]

        params[:entity_name] = filter_params[:entity_name]
        params[:assigned_code] = filter_params[:assigned_code]
        params[:entity_cat] = filter_params[:entity_cat]

      else

        if  params[:entity_name].present? || params[:assigned_code].present? || params[:entity_cat].present? #|| params[:lov_name].present? || params[:cust_num].present? || params[:trans_id].present? || params[:nw].present? || params[:status].present? || params[:start_date].present? || params[:end_date].present?

          @entity_name = params[:entity_name]
          @assigned_code = params[:assigned_code]
          @entity_cat = params[:entity_cat]

          params[:entity_name] = @entity_name
          params[:assigned_code] = @assigned_code
          params[:entity_cat] = @entity_cat

        else
          params[:entity_name] = filter_params[:entity_name]
          params[:assigned_code] = filter_params[:assigned_code]
          params[:entity_cat] = filter_params[:entity_cat]

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


    else

    end


    the_search = search_arr.join(" AND ")

    #@reports = Report.where(the_search).paginate(:page => page, :per_page => params[:count]).order(date: :desc)

    logger.info "The search array :: #{search_arr.inspect}"
    logger.info "The Search :: #{the_search.inspect}"

    @merchant_search = EntityInfo.where(active_status: true).order(entity_name: :asc)
    @merchant_code_search = EntityInfo.where(active_status: true).order(assigned_code: :asc)
    @merchant_cat_search = EntityCategory.where(active_status: true).order(category_name: :asc)

    @entity_infos = EntityInfo.where(the_search).where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order(created_at: :desc)

  end

  def settlement_entity_division_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    params[:count1] ? params[:count1] : params[:count1] = 50
    params[:page1] ? params[:page1] : params[:page1] = 1
    @entity_info = EntityInfo.where(assigned_code: params[:entity_code], active_status: true).order(created_at: :desc).first
    @entity_name = @entity_info ? @entity_info.entity_name : ""
    @entity_divisions = EntityDivision.where(entity_code: params[:entity_code], active_status: true, del_status: false).paginate(:page => params[:page1], :per_page => params[:count1]).order(created_at: :desc)
  end


  def fund_movement_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    params[:count1] ? params[:count1] : params[:count1] = 50
    params[:page1] ? params[:page1] : params[:page1] = 1

    params[:count2] ? params[:count2] : params[:count2] = 50
    params[:page2] ? params[:page2] : params[:page2] = 1

    the_search = ""
    search_arr = []

    if params[:filter_main].present? || params[:entity_name].present? || params[:assigned_code].present? || params[:division_name].present? || params[:activity_type].present? || params[:status].present? || params[:start_date].present? || params[:end_date].present?

      filter_params = params[:filter_main]
      if params[:filter_main].present?
        logger.info "Filter params 1 :: #{filter_params.inspect}"
        logger.info "Filter params class 1 :: #{filter_params.class}"

        filter_params = filter_params.class == ActionController::Parameters ? filter_params : JSON.parse(filter_params.gsub('=>', ':')).symbolize_keys
        #filter_params = JSON.parse filter_params.gsub('=>', ':') # filter_params.to_unsafe_h
        logger.info "Filter params 1 :: #{filter_params.inspect}"
        logger.info "Filter params class 1 :: #{filter_params.class}"
        @entity_name = filter_params[:entity_name]
        @assigned_code = filter_params[:assigned_code]
        @division_name = filter_params[:division_name]
        @activity_type = filter_params[:activity_type]
        @service_id = filter_params[:service_id]
        @trans_type = filter_params[:trans_type]
        @ref_id = filter_params[:ref_id]
        @status = filter_params[:status]
        @start_date = filter_params[:start_date]
        @end_date = filter_params[:end_date]
        params[:entity_name] = filter_params[:entity_name]
        params[:assigned_code] = filter_params[:assigned_code]
        params[:division_name] = filter_params[:division_name]
        params[:activity_type] = filter_params[:activity_type]
        params[:status] = filter_params[:status]
        params[:start_date] = filter_params[:start_date]
        params[:end_date] = filter_params[:end_date]
      else

        if  params[:entity_name].present? || params[:division_name].present? || params[:assigned_code].present? || params[:activity_type].present? || params[:lov_name].present? || params[:cust_num].present? || params[:trans_id].present? || params[:nw].present? || params[:status].present? || params[:start_date].present? || params[:end_date].present?

          @entity_name = params[:entity_name]
          @assigned_code = params[:assigned_code]
          @division_name = params[:division_name]
          @activity_type = params[:activity_type]
          @status = params[:status]
          @start_date = params[:start_date]
          @end_date = params[:end_date]
          params[:entity_name] = @entity_name
          params[:assigned_code] = @assigned_code
          params[:division_name] = @division_name
          params[:activity_type] = @activity_type
          params[:status] = @status
          params[:start_date] = @start_date
          params[:end_date] = @end_date
        else
          filter_params = filter_params.class == ActionController::Parameters ? filter_params : JSON.parse(filter_params.gsub('=>', ':')).symbolize_keys
          #filter_params = JSON.parse filter_params.gsub('=>', ':') # filter_params.to_unsafe_h
          logger.info "Filter params 2 :: #{filter_params.inspect}"
          logger.info "Filter params class 2 :: #{filter_params.class}"
          params[:entity_name] = filter_params[:entity_name]
          params[:assigned_code] = filter_params[:assigned_code]
          params[:division_name] = filter_params[:division_name]
          params[:activity_type] = filter_params[:activity_type]
          params[:status] = filter_params[:status]
          params[:start_date] = filter_params[:start_date]
          params[:end_date] = filter_params[:end_date]
        end
      end



      if @entity_name.present?
        division_str = "'0'"
        @entity_divis = EntityDivision.where("entity_code = '#{@entity_name}'")
        @entity_divis.each { |entity_div| division_str << ",'#{entity_div.assigned_code}'" } if @entity_divis.exists?
        final_div_str = "(#{division_str})"
        logger.info "Final Div Str :: #{final_div_str.inspect}"
        search_arr << "entity_div_code IN #{final_div_str}"
      end

      if @assigned_code.present?
        division_str = "'0'"
        @entity_divis = EntityDivision.where("entity_code = '#{@assigned_code}'")
        @entity_divis.each { |entity_div| division_str << ",'#{entity_div.assigned_code}'" } if @entity_divis.exists?
        final_div_str = "(#{division_str})"
        logger.info "Final Div Str :: #{final_div_str.inspect}"
        search_arr << "entity_div_code IN #{final_div_str}"
      end



      if @service_id.present?
        search_arr << "service_id = #{@service_id.to_i}"
      end

      if @ref_id.present?
        search_arr << "ref_id LIKE '%#{@ref_id}%'"
      end

      if @trans_type.present?
        search_arr << "trans_type = '#{@trans_type}'"
      end

      if @division_name.present?
        search_arr << "entity_div_code = '#{@division_name}'"
      end


      if @activity_type.present?
        activity_str = "'0'"
        div_str = "'0'"
        @act_type = ActivityType.where("LOWER(assigned_code) LIKE '%#{@activity_type.downcase}%'")
        @act_type.each { |act_type| activity_str << ",'#{act_type.assigned_code}'" } if @act_type.exists?
        final_act_str = "(#{activity_str})"
        @entity_divisi = EntityDivision.where("activity_type_code IN #{final_act_str}")
        @entity_divisi.each { |entity_div| div_str << ",'#{entity_div.assigned_code}'" } if @entity_divisi.exists?
        f_div_str = "(#{div_str})"
        logger.info "Final Act Str :: #{f_div_str.inspect}"
        search_arr << "entity_div_code IN #{f_div_str}"
      end

      if @status.present?
        if @status == "TRUE"
          search_arr << "processed = true"
          #search_arr << "split_part(trans_status, '/', 1) = '000'"
        elsif @status == "FALSE"
          search_arr << "processed = false"
        elsif @status == "NIL"
          search_arr << "processed IS NULL"
        else
        end
      end


      if @start_date.present? && @end_date.present?
        f_start_date =  @start_date.to_date.strftime('%Y-%m-%d') # Date.strptime(@start_date, '%m/%d/%Y') # @start_date.to_date.strftime('%Y-%m-%d')
        f_end_date = @end_date.to_date.strftime('%Y-%m-%d') # Date.strptime(@end_date, '%m/%d/%Y') # @end_date.to_date.strftime('%Y-%m-%d')
        if f_start_date <= f_end_date
          search_arr << "created_at BETWEEN '#{f_start_date} 00:00:00' AND '#{f_end_date} 23:59:59'"
        end
      end
      logger.info "Values :: #{filter_params.inspect}"
    else
      logger.info "FILTER PARAMS NOT PRESENT ============================================"
    end

    the_search = search_arr.join(" AND ")
    logger.info "The search array :: #{search_arr.inspect}"
    logger.info "The Search :: #{the_search.inspect}"

    if current_user.super_admin? || current_user.super_user?
      @merchant_search = EntityInfo.where(active_status: true).order(entity_name: :asc)
      @merchant_code_search = EntityInfo.where(active_status: true).order(assigned_code: :asc)
      @merchant_service_search = EntityDivision.where(active_status: true).order(division_name: :asc)
      @entity_div = @division_name.present? ? EntityDivision.where(assigned_code: @division_name, active_status: true).order(created_at: :desc).first : false
      @division_name = @entity_div ? "(#{@entity_div.division_name})" : ""
      #if @entity_name.present?
      #  @entity_info = EntityInfo.where(assigned_code: @entity_name, active_status: true).order(created_at: :desc).first : EntityInfo.where(assigned_code: params[:entity_code], active_status: true).order(created_at: :desc).first
      #else
        @entity_info = @entity_div ? EntityInfo.where(assigned_code: @entity_div.entity_code, active_status: true).order(created_at: :desc).first : EntityInfo.where(assigned_code: params[:entity_name], active_status: true).order(created_at: :desc).first
      #end
      @entity_name = @entity_info ? @entity_info.entity_name : ""

      @entity_infos = EntityInfo.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order(created_at: :desc)
      if params[:count2] == "ALL"
        @fund_movements = FundMovement.where(the_search).paginate(:page => params[:page], :per_page => 10000000000).order(created_at: :desc)
      else
        @fund_movements = FundMovement.where(the_search).paginate(:page => params[:page], :per_page => params[:count2]).order(created_at: :desc)
      end
    elsif current_user.merchant_admin?
      params[:entity_code] = current_user.user_entity_code
      @merchant_service_search = EntityDivision.where(active_status: true, entity_code: current_user.user_entity_code).order(division_name: :asc)
      @entity_div = @division_name.present? ? EntityDivision.where(assigned_code: @division_name, active_status: true).order(created_at: :desc).first : EntityDivision.where(assigned_code: params[:division_code], active_status: true).order(created_at: :desc).first
      @division_name = @entity_div ? "(#{@entity_div.division_name})" : ""
      @entity_info = EntityInfo.where(assigned_code: params[:entity_code], active_status: true).order(created_at: :desc).first
      @entity_name = @entity_info ? @entity_info.entity_name : ""
      @entity_divisions = EntityDivision.where(entity_code: params[:entity_code], active_status: true, del_status: false).paginate(:page => params[:page1], :per_page => params[:count1]).order(created_at: :desc)

      entity_div_id_str = "'0'"
      @entity_divs = EntityDivision.where(entity_code: current_user.user_entity_code, active_status: true)
      @entity_divs.each do |entity_div|
        entity_div_id_str << ",'#{entity_div.assigned_code}'"
      end
      final_div_ids = "(#{entity_div_id_str})"
      if params[:count2] == "ALL"
        @fund_movements = FundMovement.where("entity_div_code IN #{final_div_ids}").where(the_search).paginate(:page => params[:page], :per_page => 100000000000).order(created_at: :desc)
      else
        @fund_movements = FundMovement.where("entity_div_code IN #{final_div_ids}").where(the_search).paginate(:page => params[:page], :per_page => params[:count2]).order(created_at: :desc)
      end
    elsif current_user.merchant_service?
      params[:entity_code] = current_user.user_entity_code
      params[:division_code] = current_user.user_division_code

      #@entity_info = EntityInfo.where(assigned_code: params[:entity_code], active_status: true).order(created_at: :desc).first
      #@entity_name = @entity_info ? @entity_info.entity_name : ""
      @entity_div = EntityDivision.where(assigned_code: params[:division_code], active_status: true).order(created_at: :desc).first
      @division_name = @entity_div ? "(#{@entity_div.division_name})" : ""
      @entity_info = @entity_div ? EntityInfo.where(assigned_code: @entity_div.entity_code, active_status: true).order(created_at: :desc).first : EntityInfo.where(assigned_code: params[:entity_code], active_status: true).order(created_at: :desc).first
      @entity_name = @entity_info ? @entity_info.entity_name : ""
      if params[:count2] == "ALL"
        @fund_movements = FundMovement.where(entity_div_code: params[:division_code]).where(the_search).paginate(:page => params[:page], :per_page => 100000000000).order(created_at: :desc)
      else
        @fund_movements = FundMovement.where(entity_div_code: params[:division_code]).where(the_search).paginate(:page => params[:page], :per_page => params[:count2]).order(created_at: :desc)
      end
    end

    respond_to do |format|
      format.js
      format.csv { send_data @fund_movements.to_csv(@fund_movements, current_user), :filename => "settlement_report.csv" }
      format.xls { send_data @fund_movements.to_csv(@fund_movements, current_user, col_sep: "\t"), :filename => "settlement_report.xls" }
    end

  end

  # GET /fund_movements/1
  # GET /fund_movements/1.json
  def show
  end

  # GET /fund_movements/new
  def new
    @fund_movement = FundMovement.new
  end

  # GET /fund_movements/1/edit
  def edit
  end

  # POST /fund_movements
  # POST /fund_movements.json
  def create
    @fund_movement = FundMovement.new(fund_movement_params)

    #respond_to do |format|
    #  if @fund_movement.save
    #    format.html { redirect_to @fund_movement, notice: 'Fund movement was successfully created.' }
    #    format.json { render :show, status: :created, location: @fund_movement }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @fund_movement.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /fund_movements/1
  # PATCH/PUT /fund_movements/1.json
  def update
    respond_to do |format|
      #if @fund_movement.update(fund_movement_params)
      #  format.html { redirect_to @fund_movement, notice: 'Fund movement was successfully updated.' }
      #  format.json { render :show, status: :ok, location: @fund_movement }
      #else
      #  format.html { render :edit }
      #  format.json { render json: @fund_movement.errors, status: :unprocessable_entity }
      #end
    end
  end

  # DELETE /fund_movements/1
  # DELETE /fund_movements/1.json
  def destroy
    #@fund_movement.destroy
    #respond_to do |format|
    #  format.html { redirect_to fund_movements_url, notice: 'Fund movement was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fund_movement
      @fund_movement = FundMovement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fund_movement_params
      params.require(:fund_movement).permit(:entity_div_code, :service_id, :ref_id, :amount, :narration, :trans_type, :trans_status, :trans_desc, :processed)
    end
end
