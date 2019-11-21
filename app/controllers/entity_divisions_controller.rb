class EntityDivisionsController < ApplicationController
  before_action :set_entity_division, only: [:show, :edit, :update, :destroy]

  # GET /entity_divisions
  # GET /entity_divisions.json
  def index
    params[:count] ? params[:count] : params[:count] = 10
    params[:page] ? params[:page] : params[:page] = 1

    @entity_divisions = EntityDivision.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

  end

  def entity_division_index
    params[:count] ? params[:count] : params[:count] = 10
    params[:page] ? params[:page] : params[:page] = 1

    @entity_info = EntityInfo.where(assigned_code: params[:entity_code], active_status: true, del_status: false).order(created_at: :desc).first
    @entity_info ? @entity_name = "#{@entity_info.entity_name} (#{@entity_info.entity_alias})" : ""
    @entity_divisions = EntityDivision.where(entity_code: params[:entity_code], del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

  end

  # def entity_division_index
  #   params[:count] ? params[:count] : params[:count] = 10
  #   params[:page] ? params[:page] : params[:page] = 1
  #
  #   @entity_divisions = EntityDivision.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
  #
  # end

  def entity_index
    params[:count] ? params[:count] : params[:count] = 10
    params[:page] ? params[:page] : params[:page] = 1

    @entity_infos = EntityInfo.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

  end

  # GET /entity_divisions/1
  # GET /entity_divisions/1.json
  def show
  end

  # GET /entity_divisions/new
  def new
    @entity_division = EntityDivision.new
    # @entity_division.activity_divs.build
    @entity_division.entity_wallet_configs.build
    @activity_types = ActivityType.where(active_status: true, del_status: false).order(assigned_code: :asc)
    @region_masters = RegionMaster.where(active_status: true).order(region_name: :asc)
    @city_town_masters = CityTownMaster.where(id: 0)
    @suburb_masters = SuburbMaster.where(id: 0)
  end

  # GET /entity_divisions/1/edit
  def edit
    @new_record = EntityDivision.new
    # @new_record.activity_divs.build
    # @entity_division.entity_wallet_configs.build
    @new_record.entity_wallet_configs.build
    @entity_wallet_config = EntityWalletConfig.where(division_code: @entity_division.assigned_code, active_status: true, del_status: false).order(created_at: :desc).first
    if @entity_wallet_config
      @service_id = @entity_division.service_id
      @secret_key = @entity_division.secret_key
      @client_key = @entity_division.client_key
    else
      @service_id = ""
      @secret_key = ""
      @client_key = ""
    end

    @region_masters = RegionMaster.where(active_status: true).order(region_name: :asc)
    @activity_types = ActivityType.where(active_status: true, del_status: false).order(assigned_code: :asc)

    @suburb_id = @entity_division.suburb_id
    if @suburb_id.present?
      logger.info "Long chain :: #{@entity_division.suburb_master.a_city.a_region.inspect}"
      logger.info "For suburb id :: #{@suburb_id.inspect}"
      @sub_masters = SuburbMaster.where(id: @suburb_id).last
      logger.info "Sub Master #{@sub_masters.inspect}"
      logger.info "City id :: #{@sub_masters.a_city.inspect}"
      @region_id = @sub_masters.a_city.region_id
      @city_id = @sub_masters.city_town_id
      @entity_division.region_name = @region_id
      @entity_division.city_name = @city_id
      @city_town_masters = CityTownMaster.where(region_id: @region_id)
      @suburb_masters = SuburbMaster.where(city_id: @sub_masters.city_id)
      logger.info "Region id :: #{@region_id.inspect}"
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
  def create
    @new_record = EntityDivision.new(entity_division_params)
    @entity_division = EntityDivision.new(entity_division_params)
    if entity_division_params[:action_type] == "for_update"
      @entity_wallet_config = EntityWalletConfig.where(division_code: params[:code], active_status: true, del_status: false).order(created_at: :desc).first
      @entity_wallet = EntityWalletConfig.where(division_code: params[:code]).first

      if @entity_wallet_config
        @service_id = entity_division_params["entity_wallet_configs_attributes"]["0"]["service_id"] #@entity_division.service_id
        @secret_key = entity_division_params["entity_wallet_configs_attributes"]["0"]["secret_key"] #@entity_division.secret_key
        @client_key = entity_division_params["entity_wallet_configs_attributes"]["0"]["client_key"] #@entity_division.client_key
      else
        @service_id = ""
        @secret_key = ""
        @client_key = ""
      end

      @region_masters = RegionMaster.where(active_status: true).order(region_name: :asc)
      @activity_types = ActivityType.where(active_status: true, del_status: false).order(assigned_code: :asc)

      @suburb_id = @entity_division.suburb_id
      if @suburb_id.present?
        logger.info "Long chain :: #{@entity_division.suburb_master.a_city.a_region.inspect}"
        logger.info "For suburb id :: #{@suburb_id.inspect}"
        @sub_masters = SuburbMaster.where(id: @suburb_id).last
        logger.info "Sub Master #{@sub_masters.inspect}"
        logger.info "City id :: #{@sub_masters.a_city.inspect}"
        @region_id = @sub_masters.a_city.region_id
        @city_id = @sub_masters.city_town_id
        @entity_division.region_name = @region_id
        @entity_division.city_name = @city_id
        @city_town_masters = CityTownMaster.where(region_id: @region_id)
        @suburb_masters = SuburbMaster.where(city_id: @sub_masters.city_id)
        logger.info "Region id :: #{@region_id.inspect}"
      else
        @region_id = []
        @city_id = []
        @suburb_id = []
        @city_town_masters = []
        @suburb_masters = []
      end
    else
      @activity_types = ActivityType.where(active_status: true, del_status: false).order(assigned_code: :asc)
      @region_masters = RegionMaster.where(active_status: true).order(region_name: :asc)
      entity_division_params[:region_name].present? ? @city_town_masters = CityTownMaster.where(active_status: true, region_id: entity_division_params[:region_name]).order(city_town_name: :asc) : @city_town_masters = CityTownMaster.where(id: 0)
      entity_division_params[:city_town_name].present? ? @suburb_masters = SuburbMaster.where(active_status: true, city_town_id: entity_division_params[:city_town_name]).order(suburb_name: :asc) : @suburb_masters = SuburbMaster.where(id: 0)

    end

    respond_to do |format|

      if @entity_division.valid?

        unless params[:action_type] == "for_update"
          @entity_division.assigned_code = EntityDivision.gen_entity_div_code
          @entity_division.save
          logger.info "The Entity Division code is #{@entity_division.assigned_code.inspect}"
        end

        if params[:action_type] == "for_update"
          if @entity_wallet
            division_params = entity_division_params
            # logger.info "OLD ENTITY DIVISION PARAMS IS #{division_params.inspect}"
            # logger.info "ENTITY WALLET CONFIG IS #{division_params["entity_wallet_configs_attributes"].inspect}"
            division_params[:assigned_code] = params[:code]
            wallet_params = division_params["entity_wallet_configs_attributes"]
            division_params = division_params.except("entity_wallet_configs_attributes")
            @entity_division = EntityDivision.new(division_params)
            @entity_division.save(validate: false)
            @entity_division.update(wallet_params)
            logger.info "NEW ENTITY DIVISION PARAMS IS #{division_params.inspect}"
          else
            @entity_division.assigned_code = params[:code]
            @entity_division.save
          end
        end

        if params[:action_type] == "for_update"
          logger.info "UPDATING IN CREATE......... INTERESTING"
          EntityDivision.update_last_but_one('entity_division', 'assigned_code', params[:code])
        end
        format.html { redirect_to @entity_division, notice: 'Entity division was successfully created.' }
        flash.now[:danger] = "Entity division was successfully created."
        format.js { render :show}
        format.json { render :show, status: :created, location: @entity_division }
      else
        logger.info "Error messages:: #{@entity_division.errors.messages.inspect}"
        if params[:action_type] == "for_update"
          @new_record.valid?
          @service_id = entity_division_params["entity_wallet_configs_attributes"]["0"]["service_id"] #@entity_division.service_id
          @secret_key = entity_division_params["entity_wallet_configs_attributes"]["0"]["secret_key"] #@entity_division.secret_key
          @client_key = entity_division_params["entity_wallet_configs_attributes"]["0"]["client_key"] #@entity_division.client_key
          format.html { render :edit }
          format.js {render :edit }
        else
          format.html { render :new }
          format.js {render :new }
        end
        format.json { render json: @entity_division.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entity_divisions/1
  # PATCH/PUT /entity_divisions/1.json
  def update
    @activity_types = ActivityType.where(active_status: true, del_status: false).order(assigned_code: :asc)
    @region_masters = RegionMaster.where(active_status: true).order(region_name: :asc)
    entity_division_params[:region_name].present? ? @city_town_masters = CityTownMaster.where(active_status: true, region_id: entity_division_params[:region_name]).order(city_town_name: :asc) : @city_town_masters = CityTownMaster.where(id: 0)
    entity_division_params[:city_town_name].present? ? @suburb_masters = SuburbMaster.where(active_status: true, city_town_id: entity_division_params[:city_town_name]).order(suburb_name: :asc) : @suburb_masters = SuburbMaster.where(id: 0)

    respond_to do |format|
      if @entity_division.update(entity_division_params)
        format.html { redirect_to @entity_division, notice: 'Entity division was successfully updated.' }
        flash.now[:danger] = "Entity division was successfully updated."
        format.js { render :show}
        format.json { render :show, status: :ok, location: @entity_division }
      else
        format.html { render :edit }
        format.js {render :edit }
        format.json { render json: @entity_division.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entity_divisions/1
  # DELETE /entity_divisions/1.json
  def destroy
    if @entity_division.active_status
      EntityDivision.disable_by_update_onef("entity_divisions","assigned_code",@entity_division.assigned_code)
      @entity_divisions = EntityDivision.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to entity_divisions_url, notice: 'Occupation master was successfully disabled.' }
        flash.now[:note] = 'Merchant division was successfully disabled.'
        format.js { render :layout => false}
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end

    else
      EntityInfo.enable_by_update_onet("entity_divisions","assigned_code",@entity_division.assigned_code)
      @entity_divisions = EntityDivision.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
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
      params.require(:entity_division).permit(:entity_code, :assigned_code, :division_name, :action_type, :suburb_id, :activity_type_code, :service_label, :region_name, :city_town_name, :comment, :active_status, :del_status, :user_id,
                                              entity_wallet_configs_attributes: [:id, :division_code, :service_id, :secret_key, :client_key, :comment, :active_status, :del_status, :user_id])
                                              #activity_divs_attributes: [:id, :division_code, :activity_div_desc, :activity_date, :comment, :active_status, :del_status, :user_id],

    end
end
