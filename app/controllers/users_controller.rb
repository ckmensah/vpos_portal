class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :scanner_edit, :update, :destroy]
   load_and_authorize_resource
  before_action :load_permissions
  require 'vpos_core'

  # GET /users
  # GET /users.json
  def index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page].present? ? page = params[:page].to_i : page = 1
    session[:user_filter] = nil

    @entity_infos = EntityInfo.where(active_status: true).order(entity_name: :asc)
    @entity_divisions = EntityDivision.where(active_status: true).order(division_name: :asc)
    @roles = Role.where("active_status = true AND id NOT IN (1,5)").order(role_name: :asc)


    if current_user.super_admin?
      @validators = User.unscoped.user_roles_join.where("user_roles.for_portal = false AND user_roles.del_status = false").paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
      @users = User.unscoped.user_roles_join.where("user_roles.for_portal = true AND user_roles.del_status = false").paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')

    elsif current_user.super_user?
      @validators = User.unscoped.user_roles_join.where("user_roles.for_portal = false AND user_roles.del_status = false").paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
      @users = User.unscoped.user_roles_join.where("user_roles.role_code != 'SA' AND users.id NOT IN (#{current_user.id}, 1) AND user_roles.for_portal = true AND user_roles.del_status = false").paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')

    elsif current_user.merchant_admin?
      @validators = User.unscoped.user_roles_join.where("user_roles.entity_code = '#{current_user.user_entity_code}' AND user_roles.for_portal = false").paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
      @users = User.unscoped.user_roles_join.where("user_roles.entity_code = '#{current_user.user_entity_code}' AND user_roles.for_portal = true").paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')

    elsif current_user.merchant_service?
      #@validators = User.unscoped.user_roles_join.where(entity_code: current_user.user_entity_code, division_code: current_user.user_division_code, for_portal: false).paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
      #@users = User.unscoped.user_roles_join.where(entity_code: current_user.user_entity_code, division_code: current_user.user_division_code, for_portal: true).paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')

    end



  end


  def user_index

    params[:count] ? params[:count] : params[:count] = 50
    params[:page].present? ? page = params[:page].to_i : page = 1

    the_search = ""
    search_arr = []

    if params[:user_filter].present? || params[:div_name].present? || params[:entity_name].present? || params[:contact_num].present? || params[:username].present? || params[:role_name].present? || params[:start_date].present? || params[:end_date].present? #|| params[:nw].present? || params[:status].present? || params[:start_date].present? || params[:end_date].present?

      session[:user_filter] = params[:user_filter]
      filter_params = params[:user_filter]
      if params[:user_filter].present?
        @div_name = filter_params[:div_name]
        @entity_name = filter_params[:entity_name]
        @contact_num = filter_params[:contact_num]
        @username = filter_params[:username]
        @role_name = filter_params[:role_name]
        @start_date = filter_params[:start_date]
        @end_date = filter_params[:end_date]

        params[:div_name] = filter_params[:div_name]
        params[:entity_name] = filter_params[:entity_name]
        params[:contact_num] = filter_params[:contact_num]
        params[:username] = filter_params[:username]
        params[:role_name] = filter_params[:role_name]
        params[:start_date] = filter_params[:start_date]
        params[:end_date] = filter_params[:end_date]

      else

        if  params[:div_name].present? || params[:entity_name].present? || params[:contact_num].present? || params[:username].present? || params[:role_name].present? || params[:start_date].present? || params[:end_date].present? # || params[:trans_id].present? || params[:nw].present? || params[:status].present? || params[:start_date].present? || params[:end_date].present?

          @div_name = params[:div_name]
          @entity_name = params[:entity_name]
          @contact_num = params[:contact_num]
          @username = params[:username]
          @role_name = params[:role_name]
          @start_date = params[:start_date]
          @end_date = params[:end_date]

          params[:div_name] = @div_name
          params[:entity_name] = @entity_name
          params[:contact_num] = @contact_num
          params[:username] = @username
          params[:role_name] = @role_name
          params[:start_date] = @start_date
          params[:end_date] = @end_date

        else
          params[:div_name] = filter_params[:div_name]
          params[:entity_name] = filter_params[:entity_name]
          params[:contact_num] = filter_params[:contact_num]
          params[:username] = filter_params[:username]
          params[:role_name] = filter_params[:role_name]
          params[:start_date] = filter_params[:start_date]
          params[:end_date] = filter_params[:end_date]

        end
      end

      if @div_name.present?
        #search_arr << "customer_number LIKE '%#{@cust_num}%'"
        search_arr << "user_roles.division_code = '#{@div_name}'"
      end

      if @entity_name.present?
        #search_arr << "customer_number LIKE '%#{@cust_num}%'"
        search_arr << "user_roles.entity_code = '#{@entity_name}'"
      end

      if @contact_num.present?
        search_arr << "contact_number LIKE '%#{@contact_num}%'"
      end

      if @username.present?
        search_arr << "user_name LIKE '%#{@username}%'"
      end

      if @role_name.present?
        search_arr << "user_roles.role_code = #{@role_name}"
      end

      if @start_date.present? && @end_date.present?
        f_start_date =  @start_date.to_date.strftime('%Y-%m-%d') # Date.strptime(@start_date, '%m/%d/%Y') # @start_date.to_date.strftime('%Y-%m-%d')
        f_end_date = @end_date.to_date.strftime('%Y-%m-%d') # Date.strptime(@end_date, '%m/%d/%Y') # @end_date.to_date.strftime('%Y-%m-%d')
        if f_start_date <= f_end_date
          search_arr << "users.created_at BETWEEN '#{f_start_date} 00:00:00' AND '#{f_end_date} 23:59:59'"
        end
      end

    else
      session[:user_filter] = nil
    end


    the_search = search_arr.join(" AND ")
    logger.info "The search array :: #{search_arr.inspect}"
    logger.info "The Search :: #{the_search.inspect}"

    @entity_infos = EntityInfo.where(active_status: true).order(entity_name: :asc)
    @entity_divisions = EntityDivision.where(active_status: true).order(division_name: :asc)
    @roles = Role.where("active_status = true AND id NOT IN (1,5)").order(role_name: :asc)

    if current_user.super_admin?
      @validators = User.unscoped.user_roles_join.where("user_roles.for_portal = false AND user_roles.del_status = false").paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
      @users = User.unscoped.user_roles_join.where("user_roles.for_portal = true AND user_roles.del_status = false").where(the_search).paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')

    elsif current_user.super_user?
      @validators = User.unscoped.user_roles_join.where("user_roles.for_portal = false AND user_roles.del_status = false").paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
      @users = User.unscoped.user_roles_join.where("user_roles.role_code != 'SA' AND users.id != #{current_user.id} AND user_roles.for_portal = true AND user_roles.del_status = false").where(the_search).paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')

    elsif current_user.merchant_admin?
      #@validators = User.unscoped.user_roles_join.where(entity_code: current_user.user_entity_code, for_portal: false).paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
      #@users = User.unscoped.user_roles_join.where(entity_code: current_user.user_entity_code, for_portal: true).paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
    else

    end

  end


  def validator_index

    params[:count] ? params[:count] : params[:count] = 50
    params[:page].present? ? page = params[:page].to_i : page = 1
    #if params[:validator] == "validator"
    @validators = User.unscoped.user_roles_join.where(creator_id: current_user.id, for_portal: false).paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
    #else
    #  @users = User.unscoped.user_roles_join.where(creator_id: current_user.id, for_portal: true).paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
    #end
    #
    if current_user.super_admin?
      @validators = User.unscoped.user_roles_join.where("user_roles.for_portal = false").paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
    elsif current_user.super_user?
      @validators = User.unscoped.user_roles_join.where("user_roles.for_portal = false").paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
    elsif current_user.merchant_admin?
      @validators = User.unscoped.user_roles_join.where("user_roles.entity_code = '#{current_user.user_entity_code}' AND user_roles.for_portal = false").paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
    else
    end
  end



  # GET /users/1
  # GET /users/1.json
  def show

  end

  def new_validator
    @user = User.new
    if current_user.super_admin? || current_user.super_user?
      @entity_infos = EntityInfo.where(active_status: true).order(entity_name: :asc)
      @entity_divisions = EntityDivision.where(id: 0, active_status: true).order(division_name: :asc)
      @entity_info_id = ""
      @entity_div_id = ""
    elsif current_user.merchant_admin?
      #@entity_divisions = EntityDivision.where(active_status: true).order(division_name: :asc)
    end
  end

  def scanner_edit
    @user_role = UserRole.where(user_id: @user.id, active_status: true).order(created_at: :desc).first
    if @user_role
      @user.for_entity_code = @user_role.entity_code
      @user.for_division_code = @user_role.division_code
      @user.for_role_code = @user_role.role_code
      @user.for_show_charge = @user_role.show_charge
    end
    if current_user.super_admin? || current_user.super_user?
      @entity_infos = EntityInfo.where(active_status: true).order(entity_name: :asc)
      #@entity_divisions = EntityDivision.where(id: 0, active_status: true).order(division_name: :asc)
      @entity_divisions = @user.user_entity_code.present? ? EntityDivision.where(entity_code: @user.user_entity_code, active_status: true).order(division_name: :asc) : EntityDivision.where(id: 0, active_status: true).order(division_name: :asc)

    end
  end

  # GET /users/new
  def new
    @user = User.new
    if current_user.super_admin? || current_user.super_user?
      @entity_infos = EntityInfo.where(active_status: true).order(entity_name: :asc)
      @entity_divisions = EntityDivision.where(id: 0, active_status: true).order(division_name: :asc)
    elsif current_user.merchant_admin?
      #@entity_divisions = EntityDivision.where(active_status: true).order(division_name: :asc)
    end
  end

  # GET /users/1/edit
  def edit
    @user_role = UserRole.where(user_id: @user.id, active_status: true).order(created_at: :desc).first
    if @user_role
      @user.for_entity_code = @user_role.entity_code
      @user.for_division_code = @user_role.division_code
      @user.for_role_code = @user_role.role_code
      @user.for_show_charge = @user_role.show_charge
    end
    if current_user.super_admin? || current_user.super_user?
      @entity_infos = EntityInfo.where(active_status: true).order(entity_name: :asc)
      #@entity_divisions = EntityDivision.where(id: 0, active_status: true).order(division_name: :asc)
      @entity_divisions = @user.user_entity_code.present? ? EntityDivision.where(entity_code: @user.user_entity_code, active_status: true).order(division_name: :asc) : EntityDivision.where(id: 0, active_status: true).order(division_name: :asc)

    end
  end

  def user_role_save(user_id, user_params)
    user_role_save = UserRole.new(user_id: user_id, role_code: user_params[:for_role_code],
                                  entity_code: user_params[:for_entity_code],
                                  division_code: user_params[:for_division_code],
                                  for_portal: user_params[:for_the_portal],
                                  show_charge: user_params[:for_show_charge],
                                  creator_id: user_params[:for_creator_id],
                                  active_status: true, del_status: false)
    user_role_save.save(validate: false)
  end


  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if current_user.super_admin? || current_user.super_user?
      @entity_infos = EntityInfo.where(active_status: true).order(entity_name: :asc)
    end
    @user.for_portal = user_params[:for_role_code] == "TV" ? false : true

    unless user_params[:for_role_code] == "SA" || user_params[:for_role_code] == "SA"
      if user_params[:for_role_code] == "MA"
        @user.access_type = "M"
      elsif user_params[:for_role_code] == "MS"
        @user.access_type = "S"
      end
    end
    @user.show_charge = false if user_params[:for_role_code] == "SA" || user_params[:for_role_code] == "SU"
    respond_to do |format|
      @entity_divisions = EntityDivision.where(entity_code: user_params[:for_entity_code], active_status: true).order(division_name: :asc)
      logger.info "Validator Validation ======================================="
      @entity_info_id = user_params[:for_entity_code]
      @entity_div_id = user_params[:for_division_code]
      logger.info "=========================================================="
      logger.info "ID's are :: #{@entity_info_id.inspect}, #{@entity_div_id.inspect}"
      if @user.valid?
        if params[:validator] == "validator"
          @roles_id = Role.where(active_status: true, assigned_code: "TV").order(created_at: :desc).first
          @the_role_id = @roles_id ? @roles_id.id : nil
          endpoint = '/create_app_user_account_req'
          payload = {:email => user_params[:email], :password => user_params[:password], :username => user_params[:user_name],
                     :last_name => user_params[:last_name], :first_name => user_params[:first_name],
                     :contact_number => user_params[:contact_number], :entity_code => user_params[:for_entity_code],
                     :division_code => user_params[:for_division_code], :role_id => @the_role_id,
                     :creator_id => user_params[:for_creator_id].to_i}
          json_payload=JSON.generate(payload)
          core_connection = VposCore::CoreConnect.new
          connection = core_connection.connection
          #signature = core_connection.compute_signature(_secret_key, json_payload)
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
                user_id = the_resp["user_id"]
                user_role_save(user_id, user_params)
                flash.now[:notice] = "#{user_params[:user_name].capitalize} was successfully created."
                @user = User.where(id: user_id).first
                logger.info "User Object :: #{@user.inspect}"
                #respond_to do |format|
                  format.js { render :show }
                #end
              else
                flash.now[:danger] = "Sorry, #{user_params[:user_name].capitalize} could not be created. Kindly try again."
                #respond_to do |format|
                  format.js { render :new_validator }
                #end
              end
            else

              logger.info "Not a Valid JSON ==============="
              flash.now[:danger] = "Sorry, There was an issue. Kindly check and try again."
              #respond_to do |format|
                format.js { render :new_validator }
              #end
            end
          rescue Faraday::SSLError
            logger.info "SSL Error ==============="
            flash.now[:danger] = "Sorry, There was an issue. Kindly check and try again."
            #respond_to do |format|
              format.js { render :new_validator }
            #end
          rescue Faraday::TimeoutError
            logger.info "Timeout Error ================="
            flash.now[:danger] = "Sorry, There was a timeout issue. Kindly check and try again."
            #respond_to do |format|
              format.js { render :new_validator }
            #end
          rescue Faraday::Error::ConnectionFailed => e
            logger.info "Connection Failed ================"
            logger.info "Error message :: #{e} ==================="
            flash.now[:danger] = "Sorry, There was a connection issue. Kindly check and try again."
            #respond_to do |format|
              format.js { render :new_validator }
            #end
          end
          #format.json { render :show, status: :created, location: @user }
        else
          if @user.save
            user_role_save(@user.id, user_params)
          end
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          flash.now[:notice] = "#{@user.user_name.capitalize} was successfully created."
          format.js { render :show }
          format.json { render :show, status: :created, location: @user }
        end
      else
        logger.info "Error Messages for create:: #{@user.errors.messages.inspect}"
        # format.html { render :new }
        if params[:validator] == "validator"
          format.js { render :new_validator }
        else
          format.js { render :new }
        end
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

  end

  def user_role_update(user_obj, user_params)
    user_id = user_obj.id
    user_role_obj = UserRole.where(user_id: user_id, active_status: true).order(created_at: :desc).first
    if user_role_obj
      if user_role_obj.entity_code == user_params[:for_entity_code] && user_role_obj.division_code == user_params[:for_division_code] && user_role_obj.role_code == user_params[:for_role_code] && user_role_obj.for_portal == user_params[:for_the_portal] && user_role_obj.show_charge == user_params[:for_show_charge] && user_role_obj.creator_id == user_params[:for_creator_id].to_i
      else
        user_role_obj.active_status = false
        user_role_obj.del_status = true
        user_role_obj.save(validate: false)
        user_role_save(user_id, user_params)
      end
    else
      user_role_save(user_id, user_params)
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @new_record = User.new(user_params)
    with_password = params[:validator] == "validator" ? true : false
    if current_user.super_admin? || current_user.super_user?
      @entity_infos = EntityInfo.where(active_status: true).order(entity_name: :asc)
    end
    @user.for_entity_code = user_params[:for_entity_code]
    @user.for_division_code = user_params[:for_division_code]
    @user.for_role_code = user_params[:for_role_code]
    @user.for_show_charge = user_params[:for_show_charge]
    #@user.for_portal = user_params[:role_id] == "5" ? false : true
    #unless user_params[:role_id] == "1" || user_params[:role_id] == "2"
      if user_params[:for_role_code] == "MA"
        @user.access_type = "M"
      elsif user_params[:for_role_code] == "MS"
        @user.access_type = "S"
      else
        @user.access_type = nil
      end
    #end

    user_params[:show_charge] = false if user_params[:for_role_code] == "SA" || user_params[:for_role_code] == "SU"
    respond_to do |format|
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
        with_password = false
      end
      logger.info "User Name :: #{@new_record.user_name}"
      # if @new_record.user_name != @user.user_name && @new_record.email != @user.email && @new_record.valid?
      # if @new_record.valid?
        if params[:validator] == "validator"
          if with_password

            endpoint = '/edit_app_user_account_req'
            payload = {:user_id => @user.id, :new_pass => user_params[:password]}
            json_payload=JSON.generate(payload)
            core_connection = VposCore::CoreConnect.new
            connection = core_connection.connection
            #signature = core_connection.compute_signature(_secret_key, json_payload)
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
                  params[:user].delete(:password)
                  params[:user].delete(:password_confirmation)
                  if @user.update(user_params)
                    user_role_update(@user, user_params)
                    flash.now[:notice] = "#{user_params[:user_name].capitalize} was successfully updated."
                    format.js { render :show }
                  else
                    @entity_divisions = EntityDivision.where(entity_code: user_params[:for_entity_code], active_status: true).order(division_name: :asc)
                    logger.info "Error Messages:: #{@user.errors.messages.inspect}"
                    format.js { render :scanner_edit }
                  end
                  #format.js { render :show }
                  #end
                else
                  #logger.info "======== Password :: #{@user.encrypted_password}"
                  flash.now[:danger] = "Sorry, #{user_params[:user_name].capitalize} could not be updated. Kindly try again."
                  format.js { render :scanner_edit }
                end
              else
                logger.info "Not a Valid JSON ==============="
                flash.now[:danger] = "Sorry, There was an issue. Kindly check and try again."
                #respond_to do |format|
                format.js { render :scanner_edit }
                #end
              end
            rescue Faraday::SSLError
              logger.info "SSL Error ==============="
              flash.now[:danger] = "Sorry, There was an issue. Kindly check and try again."
              #respond_to do |format|
              format.js { render :scanner_edit }
                #end
            rescue Faraday::TimeoutError
              logger.info "Timeout Error ================="
              flash.now[:danger] = "Sorry, There was a timeout issue. Kindly check and try again."
              format.js { render :scanner_edit }
            rescue Faraday::Error::ConnectionFailed => e
              logger.info "Connection Failed ================"
              logger.info "Error message :: #{e} ==================="
              flash.now[:danger] = "Sorry, There was a connection issue. Kindly check and try again."
              format.js { render :scanner_edit }
            end

          else
            if @user.update(user_params)
              user_role_update(@user, user_params)
              flash.now[:notice] = "#{user_params[:user_name].capitalize} was successfully updated."
              format.js { render :show }
            else
              @entity_divisions = EntityDivision.where(entity_code: user_params[:for_entity_code], active_status: true).order(division_name: :asc)
              logger.info "Error Messages for validator :: #{@user.errors.messages.inspect}"
              format.js { render :scanner_edit }
            end
          end
        else
          if @user.update(user_params)
            user_role_update(@user, user_params)
            flash.now[:notice] = "#{user_params[:user_name].capitalize} was successfully updated."
            format.js { render :show }
          else
            @entity_divisions = EntityDivision.where(entity_code: user_params[:for_entity_code], active_status: true).order(division_name: :asc)
            logger.info "Error Messages for non validator:: #{@user.errors.messages.inspect}"
            format.js { render :edit }
          end
        end
      # else
      #   logger.info "Error Messages for new record :: #{@new_record.errors.messages.inspect}"
      #   @user.update(user_params)
      #   logger.info "Error Messages for old record :: #{@user.errors.messages.inspect}"
      #   @entity_divisions = EntityDivision.where(entity_code: user_params[:for_entity_code], active_status: true).order(division_name: :asc)
      #   format.js { render params[:validator] == "validator" ? "scanner_edit" : "edit" }
      # end

    end

  end


  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    puts page = params[:page]
    puts "JUST STARTING.................."

    if @user.active_status
      puts "HAS STARTED NOW..................."
      @user.active_status = 0
      @user.save(validate: false)
      if params[:validator] == "validator"
        flash.now[:note] = 'Validator was successfully disabled.'
        #@validators = User.unscoped.user_roles_join.where(creator_id: current_user.id, for_portal: false).paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
        if current_user.super_admin?
          @validators = User.unscoped.user_roles_join.where("user_roles.for_portal = false AND user_roles.del_status = false").paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
        elsif current_user.super_user?
          @validators = User.unscoped.user_roles_join.where("user_roles.for_portal = false AND user_roles.del_status = false").paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
        elsif current_user.merchant_admin?
          @validators = User.unscoped.user_roles_join.where("user_roles.entity_code = '#{current_user.user_entity_code}' AND user_roles.for_portal = false AND user_roles.del_status = false").paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
        else
        end
      else
        flash.now[:note] = 'User was successfully disabled.'
        #@users = User.unscoped.user_roles_join.where(creator_id: current_user.id, for_portal: true).paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
        if current_user.super_admin?
          @users = User.unscoped.user_roles_join.where("user_roles.for_portal = true AND user_roles.del_status = false").paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
        elsif current_user.super_user?
          @users = User.unscoped.user_roles_join.where("user_roles.role_code = 'SA' AND users.id != #{current_user.id} AND user_roles.for_portal = true AND user_roles.del_status = false").paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
        elsif current_user.merchant_admin?
          @users = User.unscoped.user_roles_join.where("user_roles.entity_code = '#{current_user.user_entity_code}' AND user_roles.for_portal = true AND user_roles.del_status = false").paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
        else
        end
      end
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'Occupation master was successfully disabled.' }
        format.js { render :layout => false, notice: 'Course was successfully disabled.' }
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end
    else
      @user.active_status = 1
      @user.save(validate: false)
      if params[:validator] == "validator"
        flash.now[:notice] = 'Validator was successfully enabled.'
        #@validators = User.unscoped.user_roles_join.where(creator_id: current_user.id, for_portal: false).paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
        if current_user.super_admin?
          @validators = User.unscoped.user_roles_join.where("user_roles.for_portal = false AND user_roles.del_status = false").paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
        elsif current_user.super_user?
          @validators = User.unscoped.user_roles_join.where("user_roles.for_portal = false AND user_roles.del_status = false").paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
        elsif current_user.merchant_admin?
          @validators = User.unscoped.user_roles_join.where("user_roles.entity_code = '#{current_user.user_entity_code}' AND user_roles.for_portal = false AND user_roles.del_status = false").paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
        else
        end
      else
        flash.now[:notice] = 'User was successfully enabled.'
        #@users = User.unscoped.user_roles_join.where(creator_id: current_user.id, for_portal: true).paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
        if current_user.super_admin?
          @users = User.unscoped.user_roles_join.where("user_roles.for_portal = true AND user_roles.del_status = false").paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
        elsif current_user.super_user?
          @users = User.unscoped.user_roles_join.where("user_roles.role_code = 'SA' AND users.id != #{current_user.id} AND user_roles.for_portal = true AND user_roles.del_status = false").paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
        elsif current_user.merchant_admin?
          @users = User.unscoped.user_roles_join.where("user_roles.entity_code = '#{current_user.user_entity_code}' AND user_roles.for_portal = true AND user_roles.del_status = false").paginate(:page => page, :per_page => params[:count]).order('users.created_at desc')
        else
        end
      end
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'Allergy master was successfully enabled.' }
        format.js { render :layout => false, notice: 'Course was successfully enabled.' }
        format.json { head :no_content }
      end
    end


  end


  private
  # Use callbacks to share common setup or constraints between actions.

  def set_user
    @user = User.unscoped.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:user_name, :last_name, :first_name, :email, :access_type, :entity_code,
                                 :division_code, :contact_number, :password, :password_confirmation,
                                 :for_portal, :show_charge, :free_id, :role_id, :creator_id, :for_show_charge,
                                 :for_role_code, :for_the_portal, :for_entity_code, :for_division_code, :for_creator_id,
                                 :active_status, :del_status)
  end


end


