class EntityInfosController < ApplicationController
  before_action :set_entity_info, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :load_permissions
  # GET /entity_infos
  # GET /entity_infos.json
  def index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1
    params[:pager] ? params[:pager] = params[:page] : params[:pager] = 1
    $entity_index_page = params[:page]
    $entity_division_page = params[:page]


    if current_user.super_admin? || current_user.super_user?
      #all_merchants = EntityDivision.all
      #EntityDivision.same_created_at(all_merchants)
      $merchant_filter = ""
      $service_filter = ""
      @merchant_search = EntityInfo.where(active_status: true).order(entity_name: :asc)
      @merchant_code_search = EntityInfo.where(active_status: true).order(entity_name: :asc)
      @merchant_cat_search = EntityCategory.where(active_status: true).order(category_name: :asc)

      @entity_infos = EntityInfo.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      @entity_info_divs = EntityInfo.where(active_status: true).paginate(:page => params[:pager], :per_page => params[:count]).order('created_at desc')
      @entity_divisions = EntityDivision.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      @entity_info_sports = EntityInfo.where(active_status: true, entity_cat_id: "SPO").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      @entity_div_sports = EntityDivision.where(active_status: true, activity_type_code: "SPO").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

    elsif current_user.merchant_admin?
      @entity_infos = EntityInfo.where(assigned_code: current_user.entity_code, del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      @entity_divisions = EntityDivision.where(entity_code: current_user.entity_code, del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      @entity_info_sports = EntityInfo.where( assigned_code: current_user.entity_code, active_status: true, entity_cat_id: "SPO").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      @entity_div_sports = EntityDivision.where( assigned_code: current_user.entity_code, active_status: true, activity_type_code: "SPO").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

    elsif current_user.merchant_service?
      @entity_divs = EntityDivision.where(active_status: true, assigned_code: current_user.division_code).first
      @entity_infos = EntityInfo.where(assigned_code: @entity_divs.entity_code, del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      @entity_divisions = EntityDivision.where(assigned_code: current_user.division_code, del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      @entity_info_sports = EntityInfo.where(assigned_code: @entity_divs.entity_code, active_status: true, entity_cat_id: "SPO").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      @entity_div_sports = EntityDivision.where(assigned_code: @entity_divs.entity_code, active_status: true, activity_type_code: "SPO").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

    end

  end



  def entity_info_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    #@entity_infos = EntityInfo.where(active_status: true).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
    if current_user.super_admin? || current_user.super_user?

      the_search = ""
      search_arr = []

      if params[:filter_main].present? || params[:ent_name].present? || params[:ass_code].present? || params[:ent_cat].present? || params[:start_date].present? || params[:end_date].present?  #|| params[:cust_num].present? || params[:trans_id].present? || params[:nw].present? || params[:status].present? || params[:start_date].present? || params[:end_date].present?

        filter_params = params[:filter_main]
        if params[:filter_main].present?
          @ent_name = filter_params[:ent_name]
          @ass_code = filter_params[:ass_code]
          @ent_cat = filter_params[:ent_cat]
          @start_date = filter_params[:start_date]
          @end_date = filter_params[:end_date]

          params[:ent_name] = filter_params[:ent_name]
          params[:ass_code] = filter_params[:ass_code]
          params[:ent_cat] = filter_params[:ent_cat]
          params[:start_date] = filter_params[:start_date]
          params[:end_date] = filter_params[:end_date]

        else

          if  params[:ent_name].present? || params[:ass_code].present? || params[:ent_cat].present? || params[:start_date].present? || params[:end_date].present?  #|| params[:lov_name].present? || params[:cust_num].present? || params[:trans_id].present? || params[:nw].present? || params[:status].present? || params[:start_date].present? || params[:end_date].present?

            @ent_name = params[:ent_name]
            @ass_code = params[:ass_code]
            @ent_cat = params[:ent_cat]
            @start_date = params[:start_date]
            @end_date = params[:end_date]

            params[:ent_name] = @ent_name
            params[:ass_code] = @ass_code
            params[:ent_cat] = @ent_cat
            params[:start_date] = @start_date
            params[:end_date] = @end_date

          else
            params[:ent_name] = filter_params[:ent_name]
            params[:ass_code] = filter_params[:ass_code]
            params[:ent_cat] = filter_params[:ent_cat]
            params[:start_date] = filter_params[:start_date]
            params[:end_date] = filter_params[:end_date]

          end
        end

        if @ent_name.present?
          #search_arr << "customer_number LIKE '%#{@cust_num}%'"
          search_arr << "assigned_code = '#{@ent_name}'"
        end

        if @ass_code.present?
          search_arr << "assigned_code = '#{@ass_code}'"
        end

        if @ent_cat.present?
          search_arr << "entity_cat_id = '#{@ent_cat}'"
        end

        if @start_date.present? && @end_date.present?
          f_start_date =  @start_date.to_date.strftime('%Y-%m-%d') # Date.strptime(@start_date, '%m/%d/%Y') # @start_date.to_date.strftime('%Y-%m-%d')
          f_end_date = @end_date.to_date.strftime('%Y-%m-%d') # Date.strptime(@end_date, '%m/%d/%Y') # @end_date.to_date.strftime('%Y-%m-%d')
          if f_start_date <= f_end_date
            search_arr << "created_at BETWEEN '#{f_start_date} 00:00:00' AND '#{f_end_date} 23:59:59'"
          end
        end

      else
      end


      the_search = search_arr.join(" AND ")
      logger.info "The search array :: #{search_arr.inspect}"
      logger.info "The Search :: #{the_search.inspect}"


      @merchant_search = EntityInfo.where(active_status: true).order(entity_name: :asc)
      @merchant_code_search = EntityInfo.where(active_status: true).order(entity_name: :asc)
      @merchant_cat_search = EntityCategory.where(active_status: true).order(category_name: :asc)


      @entity_infos = EntityInfo.where(the_search).where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      #@entity_divisions = EntityDivision.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      #@entity_info_sports = EntityInfo.where(active_status: true, entity_cat_id: "SPO").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

    elsif current_user.merchant_admin?
      @entity_infos = EntityInfo.where(assigned_code: current_user.entity_code, del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      #@entity_divisions = EntityDivision.where(entity_code: current_user.entity_code, del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      #@entity_info_sports = EntityInfo.where( assigned_code: current_user.entity_code, active_status: true, entity_cat_id: "SPO").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

    elsif current_user.merchant_service?
      @entity_divs = EntityDivision.where(active_status: true, assigned_code: current_user.division_code).first
      if @entity_divs
        @entity_infos = EntityInfo.where(assigned_code: @entity_divs.entity_code, del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      end
      #@entity_divisions = EntityDivision.where(assigned_code: current_user.division_code, del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      #@entity_info_sports = EntityInfo.where(assigned_code: @entity_divs.entity_code, active_status: true, entity_cat_id: "SPO").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
    end
  end



  def sports_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    #@entity_info_sports = EntityInfo.where(active_status: true, entity_cat_id: "SPO").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
    @entity_infos = EntityInfo.where(active_status: true).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
    if current_user.super_admin? || current_user.super_user?
      #@entity_infos = EntityInfo.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      #@entity_divisions = EntityDivision.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      @entity_info_sports = EntityInfo.where(active_status: true, entity_cat_id: "SPO").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

    elsif current_user.merchant_admin?
      #@entity_infos = EntityInfo.where(assigned_code: current_user.entity_code, del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      #@entity_divisions = EntityDivision.where(entity_code: current_user.entity_code, del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      @entity_info_sports = EntityInfo.where( assigned_code: current_user.entity_code, active_status: true, entity_cat_id: "SPO").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

    elsif current_user.merchant_service?
      @entity_divs = EntityDivision.where(active_status: true, assigned_code: current_user.division_code).first
      if @entity_divs
        #@entity_infos = EntityInfo.where(assigned_code: @entity_divs.entity_code, del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
        @entity_info_sports = EntityInfo.where(assigned_code: @entity_divs.entity_code, active_status: true, entity_cat_id: "SPO").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      end
      #@entity_divisions = EntityDivision.where(assigned_code: current_user.division_code, del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
    end

  end

  # GET /entity_infos/1
  # GET /entity_infos/1.json
  def show
  end

  # GET /entity_infos/new
  def new
    @entity_info = EntityInfo.new
    @entity_info.entity_info_extras.build
    @entity_categories = EntityCategory.where(active_status: true).order(assigned_code: :asc)
    @activity_types = ActivityType.where(active_status: true).order(assigned_code: :asc)
  end

  # GET /entity_infos/1/edit
  def edit
    # @entity_info.entity_info_extras.first
    # @entity_info_extra = @entity_info.entity_info_extras.build
    @new_record = EntityInfo.new
    @new_record.entity_info_extras.build
    @entity_info_extra = EntityInfoExtra.where(entity_code: @entity_info.assigned_code, active_status: true, del_status: false).order(created_at: :desc).first
    logger.info "Edit build 1 #{@entity_info_extra.inspect}"
    @entity_categories = EntityCategory.where(active_status: true).order(assigned_code: :asc)
    @activity_types = ActivityType.where(active_status: true).order(assigned_code: :asc)
  end

  # POST /entity_infos
  # POST /entity_infos.json

  def create
    @entity_info = EntityInfo.new(entity_info_params)
    @new_record = EntityInfo.new(entity_info_params)
    @the_wallet_params = params[:the_activity_wallets]
    if entity_info_params[:action_type] != "for_update"
      #@entity_info.assigned_code = EntityInfo.gen_entity_info_code
      #logger.info "The Entity Information code is #{@entity_info.assigned_code.inspect}"
    elsif entity_info_params[:action_type] == "for_update"
      @entity_info.assigned_code = params[:entity_code]
    end
    @entity_categories = EntityCategory.where(active_status: true).order(assigned_code: :asc)
    @activity_types = ActivityType.where(active_status: true).order(assigned_code: :asc)
    respond_to do |format|
      validity, activity_number = EntityInfo.validate_wallet_config(@the_wallet_params,@entity_info.assigned_code,entity_info_params[:wallet_query], entity_info_params[:action_type])
      logger.info "==================== wallet validity is #{validity.inspect} and activity number #{activity_number.inspect}"
      if @entity_info.valid?
        if validity && entity_info_params[:wallet_query].present?


          if entity_info_params[:action_type] == "for_update"
            logger.info "UPDATING IN CREATE......... INTERESTING"
            entity_info_params[:assigned_code] = params[:entity_code]
            @new_record.assigned_code = params[:entity_code]
            @new_record.save(validate: false)
            EntityInfo.update_last_but_one('entity_info', 'assigned_code', @entity_info.assigned_code)
            EntityInfo.update_last_but_one('entity_info_extra', 'entity_code', @entity_info.assigned_code)
            EntityInfo.update_wallet_config(@the_wallet_params,@entity_info.assigned_code)
          else
            @entity_info.assigned_code = EntityInfo.gen_entity_info_code
            logger.info "The Entity Information code is #{@entity_info.assigned_code.inspect}"
            @entity_info.save(validate: false)
            EntityInfo.save_wallet_config(@the_wallet_params,@entity_info.assigned_code, current_user) if entity_info_params[:wallet_query] == "yes"
          end
          @entity_info_divs = EntityInfo.where(active_status: true).paginate(:page => params[:pager], :per_page => params[:count]).order('created_at desc')
          @entity_infos = EntityInfo.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
          format.html { redirect_to @entity_info, notice: 'Entity info was successfully created.' }
          flash.now[:notice] = "Entity info was successfully created."
          format.js { render :show}
          format.json { render :show, status: :created, location: @entity_info }
        else
          unless entity_info_params[:wallet_query] == "no"
            if entity_info_params[:wallet_query] == "yes"
              flash.now[:note] = activity_number == 0? "You selected 'YES' for wallet configurations. Please setup wallets." : "Please ensure that your inputs at number #{activity_number} is complete and valid."
            else
              flash.now[:note] = activity_number == 0? "Please select 'NO' if you do not wish to setup wallet configurations" : "Please ensure that your inputs at number #{activity_number} is complete and valid."
            end
          end
          # flash.now[:note] = activity_number == 0? "Please select 'NO' if you do not wish to setup wallet configurations" : "Please ensure that your inputs at number #{activity_number} is complete and valid."
          format.html { render :new }
          if entity_info_params[:action_type] == "for_update"
            @entity_info_extra = EntityInfoExtra.where(entity_code: @entity_info.assigned_code, active_status: true, del_status: false).order(created_at: :desc).first
            logger.info "Edit build 2 #{@entity_info_extra.inspect}"
            format.js {render :edit }
          else
            format.js {render :new }
          end
          format.json { render json: @entity_info.errors, status: :unprocessable_entity }
        end

      else
        logger.info "Entity Error messages: #{@entity_info.errors.messages.inspect}"
        if validity && entity_info_params[:wallet_query].present? #|| entity_info_params[:wallet_query] == "no"
        else
          unless entity_info_params[:wallet_query] == "no"
            if entity_info_params[:wallet_query] == "yes"
              flash.now[:note] = activity_number == 0? "You selected 'YES' for wallet configurations. Please setup wallets." : "Please ensure that your inputs at number #{activity_number} is complete and valid."
            else
              flash.now[:note] = activity_number == 0? "Please select 'NO' if you do not wish to setup wallet configurations" : "Please ensure that your inputs at number #{activity_number} is complete and valid."
            end
          end
        end
        format.html { render :new }
        if entity_info_params[:action_type] == "for_update"
          logger.info "IN UPDATE ======================================="
          @entity_info.assigned_code = params[:entity_code]
          @entity_info_extra = EntityInfoExtra.where(entity_code: @entity_info.assigned_code, active_status: true, del_status: false).order(created_at: :desc).first
          logger.info "Edit build 3 #{@entity_info_extra.inspect}"
          format.js {render :edit }
        else
          format.js {render :new }
        end
        format.json { render json: @entity_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entity_infos/1
  # PATCH/PUT /entity_infos/1.json

  def update
    # @new_record = @entity_info
    @new_record = EntityInfo.new(entity_info_params)
    # @new_extra = EntityInfoExtra.new(entity_info_params[:entity_info_extra])
    # # @entity_info_extra = @entity_info.entity_info_extras.first
    # @entity_info_extra = @entity_info.entity_info_extras.where(active_status: true, del_status: false).order(created_at: :desc).first
    # logger.info "Edit build 2 #{@entity_info_extra.inspect}"
    # logger.info "#{@new_record.inspect}"
    # @entity_info = @new_record
    respond_to do |format|
      if @new_record.valid? #(validate: false) # @entity_info.update(entity_info_params)
      # @entity_info = @new_record
      # EntityInfo.update_last_but_one('entity_info', 'assigned_code', @entity_info.assigned_code)
        format.html { redirect_to @entity_info, notice: 'Entity info was successfully updated.' }
        flash.now[:danger] = "Entity info was successfully updated."
        format.js { render :show}
        format.json { render :show, status: :ok, location: @entity_info }
      else
        @new_extra.valid?
        @entity_info.valid?
        @entity_categories = EntityCategory.where(active_status: true).order(assigned_code: :asc)
        @activity_types = ActivityType.where(active_status: true).order(assigned_code: :asc)
        format.html { render :edit }
        format.js {render :edit }
        format.json { render json: @entity_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entity_infos/1
  # DELETE /entity_infos/1.json

  def destroy
    @entity_info = EntityInfo.where(assigned_code: params[:id], del_status: false).order('id desc').first

    if @entity_info.active_status && @entity_info.del_status == false
      EntityInfo.disable_by_update_onef("entity_info","assigned_code",@entity_info.assigned_code)
      @entity_infos = EntityInfo.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

      @entity_infos = EntityInfo.where(active_status: true).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      if current_user.super_admin? || current_user.super_user?
        @entity_infos = EntityInfo.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      elsif current_user.merchant_admin?
        @entity_infos = EntityInfo.where(assigned_code: current_user.entity_code, del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      elsif current_user.merchant_service?
        @entity_divs = EntityDivision.where(active_status: true, assigned_code: current_user.division_code).first
        if @entity_divs
          @entity_infos = EntityInfo.where(assigned_code: @entity_divs.entity_code, del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
        end
      end

      respond_to do |format|
        format.html { redirect_to entity_infos_url, notice: 'Occupation master was successfully disabled.' }
        flash.now[:note] = 'Entity information was successfully disabled.'
        format.js { render :layout => false}
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end

    elsif @entity_info.active_status == false && @entity_info.del_status == false
      EntityInfo.enable_by_update_onet("entity_info","assigned_code",@entity_info.assigned_code)
      @entity_infos = EntityInfo.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to entity_infos_url, notice: 'Allergy master was successfully enabled.' }
        flash.now[:notice] = 'Entity information was successfully enabled.'
        format.js { render :layout => false }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entity_info
      # @entity_info = EntityInfo.find(params[:id])
      @entity_info = EntityInfo.where(assigned_code: params[:id], active_status: true, del_status: false).order('id desc').first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entity_info_params
      params.require(:entity_info).permit(:assigned_code, :entity_name, :entity_alias, :entity_cat_id, :action_type, :wallet_query, :comment, :active_status, :del_status, :user_id, :created_at,
                                          entity_info_extras_attributes: [:id, :entity_code, :contact_number, :web_url, :contact_email, :location_address,
                                                                          :postal_address, :comment, :active_status, :del_status, :user_id])
    end
end
