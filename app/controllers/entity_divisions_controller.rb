class EntityDivisionsController < ApplicationController
  before_action :set_entity_division, only: [:show, :edit, :update, :destroy, :division_setup, :create_division_setup]

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


  def division_setup
    @entity_division = EntityDivision.new
    @entity_div = EntityDivision.where(assigned_code: params[:code], active_status: true).order(created_at: :desc).first
    @div_activity_type = @entity_div.activity_type.assigned_code
    @entity_info = EntityInfo.where(assigned_code: params[:entity_code], active_status: true, del_status: false).order(created_at: :desc).first
    @entity_name = @entity_info ? "#{@entity_info.entity_name} (#{@entity_info.entity_alias})" : ""
    @display_num = 3
    @display_div_num = 1
    @display_act_sub_num = 1
    @activity_codes = [["Donations (DON)", "DON"], ["Levy (LVY)", "LVY"], ["Project (PRJ)", "PRJ"]]
    @activity_sub_div_class = [['Select a class', ""], ["Double", 4], ["Single", 3], ["VIP", 1],  ["Standard", 2]]
    @activity_sub_div_cl = [["Double", 4], ["Single", 3], ["VIP", 1],  ["Standard", 2]]
    @activity_sub_div_classes = ActivitySubDivClass.where(entity_div_code: params[:code], active_status: true, del_status: false).order(class_desc: :asc)
    @act_sub_div_classes = @activity_sub_div_classes.map { |a| [a.class_desc, a.id] }.insert(0,['Select a class', ""])

    logger.info "Activity Sub Division Classes: #{@activity_sub_div_classes.inspect} \n and Act Sub Division Classes: #{@act_sub_div_classes.inspect}"
      #region_update_city = region_id_record.cities.where(active_status: true).order(city_town_name: :asc).map { |a| [a.city_town_name, a.id] }.insert(0,['Please select a city', ""])

  end



  def create_division_setup
    @entity_division = EntityDivision.new(entity_division_params)
    @entity_div = EntityDivision.where(assigned_code: params[:code], active_status: true).order(created_at: :desc).first
    @div_activity_type = @entity_div.activity_type.assigned_code
    @the_div_lov = params[:the_div_acts_lov]
    @the_div_lov_num = @the_div_lov.nil? ? 0 : @the_div_lov.keys.size
    @main_params = EntityDivision.hsh_key_validator(params)
    @display_num = 3
    @display_div_num = @main_params.any? ? @main_params.size : 0
    @display_act_sub_num = 1

    params[:count] ? params[:count] : params[:count] = 10
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
    @activity_codes = [["Donations (DON)", "DON"], ["Levy (LVY)", "LVY"], ["Project (PRJ)", "PRJ"]]
    @activity_sub_div_class = [['Select a class', ""], ["Double", 4], ["Single", 3], ["VIP", 1],  ["Standard", 2]]
    @activity_sub_div_cl = [["Double", 4], ["Single", 3], ["VIP", 1],  ["Standard", 2]]
    @activity_sub_div_classes = ActivitySubDivClass.where(entity_div_code: params[:code], active_status: true, del_status: false).order(class_desc: :asc)
    @act_sub_div_classes = @activity_sub_div_classes.map { |a| [a.class_desc, a.id] }.insert(0,['Select a class', ""])

    valid_result, error_num, div_num, row_num = EntityDivision.division_setup_validation(params, @main_params, @div_activity_type, entity_division_params)
    lov_validate_result, lov_error_num, lov_row_num = EntityDivision.division_lov_validation(@the_div_lov, params[:code], entity_division_params)
    respond_to do |format|

      logger.info "Couldn't pass. Validate result:: #{valid_result}, error number :: #{error_num}, Activity number :: #{div_num}, Time number :: #{row_num}"
      logger.info " LOV:: Validate result:: #{lov_validate_result}, Error number :: #{lov_error_num}, Row number #{lov_row_num}"
      if valid_result && lov_validate_result
        logger.info "=================== SAVING ==================="
        EntityDivision.division_lov_save(@the_div_lov, params[:code], entity_division_params)
        EntityDivision.division_setup_save(params, @main_params, @div_activity_type, entity_division_params)
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
    @entity_division = EntityDivision.new
    @entity_div = EntityDivision.where(assigned_code: params[:code], active_status: true).order(created_at: :desc).first
    @div_activity_type = @entity_div.activity_type.assigned_code
    @entity_info = EntityInfo.where(assigned_code: params[:entity_code], active_status: true, del_status: false).order(created_at: :desc).first
    @entity_name = @entity_info ? "#{@entity_info.entity_name} (#{@entity_info.entity_alias})" : ""
    @activity_divs = ActivityDiv.where(division_code: params[:code], active_status: true).order(created_at: :desc)
    @activity_sub_divs = ActivitySubDiv.where(active_status: true).order(created_at: :desc)
    @division_activity_lovs = DivisionActivityLov.where(division_code: params[:code], active_status: true).order(created_at: :desc)

    @activity_codes = [["Donations (DON)", "DON"], ["Levy (LVY)", "LVY"], ["Project (PRJ)", "PRJ"]]
    @activity_sub_div_class = [['Select a class', ""], ["Double", 4], ["Single", 3], ["VIP", 1],  ["Standard", 2]]
    @activity_sub_div_cl = [["Double", 4], ["Single", 3], ["VIP", 1],  ["Standard", 2]]
    @activity_sub_div_classes = ActivitySubDivClass.where(entity_div_code: params[:code], active_status: true, del_status: false).order(class_desc: :asc)
    @act_sub_div_classes = @activity_sub_div_classes.map { |a| [a.class_desc, a.id] }.insert(0,['Select a class', ""])

    logger.info "Activity Sub Division Classes: #{@activity_sub_div_classes.inspect} \n and Act Sub Division Classes: #{@act_sub_div_classes.inspect}"
    #region_update_city = region_id_record.cities.where(active_status: true).order(city_town_name: :asc).map { |a| [a.city_town_name, a.id] }.insert(0,['Please select a city', ""])

  end

  def update_division_setup
    @entity_division = EntityDivision.new(entity_division_params)
    logger.info "==================== I WAS HIT HERE ====================="
    params[:count] ? params[:count] : params[:count] = 10
    params[:page] ? params[:page] : params[:page] = 1
    @entity_div = EntityDivision.where(assigned_code: params[:code], active_status: true).order(created_at: :desc).first
    @div_activity_type = @entity_div.activity_type.assigned_code
    @activity_divs = ActivityDiv.where(division_code: params[:code], active_status: true).order(created_at: :desc)
    @activity_sub_divs = ActivitySubDiv.where(active_status: true).order(created_at: :desc)
    @division_activity_lovs = DivisionActivityLov.where(division_code: params[:code], active_status: true).order(created_at: :desc)

    @the_div_lov = params[:the_div_acts_lov]
    @main_params = EntityDivision.hsh_key_validator(params)
    @display_div_num = @main_params.any? ? @main_params.size : 0
    @entity_info = EntityInfo.where(assigned_code: params[:entity_code], active_status: true, del_status: false).order(created_at: :desc).first
    @entity_name = @entity_info ? "#{@entity_info.entity_name} (#{@entity_info.entity_alias})" : ""
    @entity_divisions = EntityDivision.where(entity_code: params[:entity_code], del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
    #@the_activity_sub = params[:the_div_acts_lov]
    logger.info "== The div_acts_lov params size :: #{@the_div_lov_num.inspect}"
    logger.info "All Keys :: #{params.keys.inspect}"
    logger.info "Main Keys :: #{@main_params.inspect}"
    @main_params.each do |prm|
      logger.info "Keys for #{prm} are :: #{params["#{prm}"].keys.inspect}"
    end


    @activity_codes = [["Donations (DON)", "DON"], ["Levy (LVY)", "LVY"], ["Project (PRJ)", "PRJ"]]
    @activity_sub_div_class = [['Select a class', ""], ["Double", 4], ["Single", 3], ["VIP", 1],  ["Standard", 2]]
    @activity_sub_div_cl = [["Double", 4], ["Single", 3], ["VIP", 1],  ["Standard", 2]]
    @activity_sub_div_classes = ActivitySubDivClass.where(entity_div_code: params[:code], active_status: true, del_status: false).order(class_desc: :asc)
    @act_sub_div_classes = @activity_sub_div_classes.map { |a| [a.class_desc, a.id] }.insert(0,['Select a class', ""])
    @division_activity_lov = DivisionActivityLov.where(division_code: params[:code], active_status: true)
    valid_result, error_num, div_num, row_num = EntityDivision.division_setup_validation(params, @main_params, @div_activity_type, entity_division_params)
    lov_validate_result, lov_error_num, lov_row_num = EntityDivision.division_lov_validation(@the_div_lov, params[:code], entity_division_params)

    respond_to do |format|
      logger.info "Couldn't pass. Validate result:: #{valid_result}, error number :: #{error_num}, Activity number :: #{div_num}, Time number :: #{row_num}"
      logger.info " LOV:: Validate result:: #{lov_validate_result}, Error number :: #{lov_error_num}, Row number #{lov_row_num}"
      if valid_result && lov_validate_result
        logger.info "=================== UPDATING... ==================="
        #EntityDivision.division_lov_update(@the_div_lov, params[:code], entity_division_params)
        #EntityDivision.division_setup_update(params, @main_params, @div_activity_type, entity_division_params)
        flash.now[:notice] = "Setup update was successful."
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
  end


  # GET /entity_divisions/1/edit
  def edit
    @new_record = EntityDivision.new
    # @new_record.activity_divs.build
    # @entity_division.entity_wallet_configs.build
    # @new_record.entity_wallet_configs.build
    # @entity_wallet_config = EntityWalletConfig.where(division_code: @entity_division.assigned_code, active_status: true, del_status: false).order(created_at: :desc).first
    # if @entity_wallet_config
    #   @service_id = @entity_division.service_id
    #   @secret_key = @entity_division.secret_key
    #   @client_key = @entity_division.client_key
    # else
      @service_id = ""
      @secret_key = ""
      @client_key = ""
    # end

    @region_masters = RegionMaster.where(active_status: true).order(region_name: :asc)
    @activity_types = ActivityType.where(active_status: true, del_status: false).order(assigned_code: :asc)
    @assigned_service_codes = @entity_division.assigned_service_codes.where(active_status: true, del_status: false).order(created_at: :desc)
    @service_code = @assigned_service_codes.exists? ? @assigned_service_codes.first.service_code : ""
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


  def create
    @entity_division = EntityDivision.new(entity_division_params)
    @display = params[:divisions]
    @display_length = params[:display_cnt]
    @activity_types = ActivityType.where(active_status: true, del_status: false).order(assigned_code: :asc)
    @region_masters = RegionMaster.where(active_status: true).order(region_name: :asc)
    entity_division_params[:region_name].present? ? @city_town_masters = CityTownMaster.where(active_status: true, region_id: entity_division_params[:region_name]).order(city_town_name: :asc).insert(0,['Please select a city', ""]) : @city_town_masters = [["", ""]].insert(0,['Please select a city', ""])# CityTownMaster.where(id: 0)
    entity_division_params[:city_town_name].present? ? @suburb_masters = SuburbMaster.where(active_status: true, city_town_id: entity_division_params[:city_town_name]).order(suburb_name: :asc).insert(0,['Please select a suburb', ""]) : @suburb_masters = [["", ""]].insert(0,['Please select a suburb', ""])# SuburbMaster.where(id: 0)

    logger.info "Display :: #{@display.inspect} and Display Length :: #{@display_length.inspect}"
    validity_result, div_num, service_code_exist, same_incoming_service_code = EntityDivision.validate_entity_divisions(@display, entity_division_params)
    logger.info "Validity result is :: #{validity_result.inspect} and division number is :: #{div_num.inspect} and service code existence :: #{service_code_exist.inspect} and same incoming service code :: #{same_incoming_service_code.inspect}"
    respond_to do |format|
      if validity_result
        logger.info "I WAS HERE SOME...."
        EntityDivision.save_entity_divisions(@display, entity_division_params)
        format.html { redirect_to @entity_division, notice: 'Entity division was successfully updated.' }
        flash.now[:notice] = "Entity division was successfully updated."
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
              flash.now[:danger] = div_num == 0 ? "You haven't entered anything yet. Please try again." : "Please ensure that every field has been filled at number #{div_num}."
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

    @suburb_id = entity_division_params[:suburb_id]
        if @suburb_id.present?
          logger.info "Long chain :: #{@entity_division.suburb_master.a_city.a_region.inspect}"
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

    respond_to do |format|
      if @new_record.valid?#.update(entity_division_params)
        logger.info "LOGGER 1 ====================================================="
        @new_record.assigned_code = @entity_division.assigned_code
        @new_record.save
        @assigned_service_code = AssignedServiceCode.where(del_status: false, entity_div_code: @entity_division.assigned_code).order(created_at: :desc)
        @active_service_code = @assigned_service_code.where(active_status: true).first
        unless entity_division_params[:service_code] == @active_service_code.service_code
        logger.info "LOGGER 2 ========================================================"
          @active_service_code.update(service_code: entity_division_params[:service_code])
        end
        update_last_but_one("entity_division", "assigned_code", @entity_division.assigned_code)
        format.html { redirect_to @entity_division, notice: 'Entity division was successfully updated.' }
        flash.now[:danger] = "Entity division was successfully updated."
        format.js { render :show}
        format.json { render :show, status: :ok, location: @entity_division }
      else
        logger.info "LOGGER 3 =============================================================="
        logger.info "Error message 1 :: #{@new_record.errors.messages.inspect}"
        # @entity_division = @new_record
        # @entity_division.for_update = true
        #@entity_division.entity_code = ""
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
    @entity_division = EntityDivision.where(assigned_code: params[:id], del_status: false).order('id desc').first

    if @entity_division.active_status && @entity_division.del_status == false
      EntityDivision.disable_by_update_onef("entity_division","assigned_code",@entity_division.assigned_code)
      @entity_divisions = EntityDivision.where(entity_code: params[:entity_code], del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to entity_divisions_url, notice: 'Occupation master was successfully disabled.' }
        flash.now[:note] = 'Merchant division was successfully disabled.'
        format.js { render :layout => false}
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end

    elsif @entity_division.active_status == false && @entity_division.del_status == false
      EntityInfo.enable_by_update_onet("entity_division","assigned_code",@entity_division.assigned_code)
      @entity_divisions = EntityDivision.where(entity_code: params[:entity_code], del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
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
      params.require(:entity_division).permit(:entity_code, :assigned_code, :division_name, :division_alias, :action_type, :suburb_id,
                                              :activity_type_code, :service_label, :region_name, :city_town_name, :comment,
                                              :div_lov_query, :activity_query, :sub_activity_query,
                                              :active_status, :del_status, :user_id, :service_code, :for_update, divisions: [], :the_div_acts_lov => {})
                                              # entity_wallet_configs_attributes: [:id, :division_code, :service_id, :secret_key, :client_key, :comment, :active_status, :del_status, :user_id]
                                              #activity_divs_attributes: [:id, :division_code, :activity_div_desc, :activity_date, :comment, :active_status, :del_status, :user_id],

    end
end
