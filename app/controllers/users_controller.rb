class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
   load_and_authorize_resource
  before_action :load_permissions

  # GET /users
  # GET /users.json
  def index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page].present? ? page = params[:page].to_i : page = 1


    if current_user.super_admin?
      @validators = User.unscoped.where(for_portal: false).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
      @users = User.unscoped.where(for_portal: true).paginate(:page => page, :per_page => params[:count]).order('created_at desc')

    elsif current_user.super_user?
      @validators = User.unscoped.where("for_portal = false").paginate(:page => page, :per_page => params[:count]).order('created_at desc')
      @users = User.unscoped.where("role_id != 1 AND id != #{current_user.id} AND for_portal = true").paginate(:page => page, :per_page => params[:count]).order('created_at desc')

    elsif current_user.merchant_admin?
      @validators = User.unscoped.where(entity_code: current_user.entity_code, for_portal: false).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
      @users = User.unscoped.where(entity_code: current_user.entity_code, for_portal: true).paginate(:page => page, :per_page => params[:count]).order('created_at desc')

    elsif current_user.merchant_service?
      #@validators = User.unscoped.where(entity_code: current_user.entity_code, division_code: current_user.division_code, for_portal: false).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
      #@users = User.unscoped.where(entity_code: current_user.entity_code, division_code: current_user.division_code, for_portal: true).paginate(:page => page, :per_page => params[:count]).order('created_at desc')

    end



  end


  def user_index

    params[:count] ? params[:count] : params[:count] = 50
    params[:page].present? ? page = params[:page].to_i : page = 1
    #if params[:validator] == "validator"
    #  @validators = User.unscoped.where(creator_id: current_user.id, for_portal: false).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
    #else
    #  @users = User.unscoped.where(creator_id: current_user.id, for_portal: true).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
    #end
    if current_user.super_admin?
      @validators = User.unscoped.where(for_portal: false).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
      @users = User.unscoped.where(for_portal: true).paginate(:page => page, :per_page => params[:count]).order('created_at desc')

    elsif current_user.super_user?
      @validators = User.unscoped.where("for_portal = false").paginate(:page => page, :per_page => params[:count]).order('created_at desc')
      @users = User.unscoped.where("role_id != 1 AND id != #{current_user.id} AND for_portal = true").paginate(:page => page, :per_page => params[:count]).order('created_at desc')

    elsif current_user.merchant_admin?
      @validators = User.unscoped.where(entity_code: current_user.entity_code, for_portal: false).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
      @users = User.unscoped.where(entity_code: current_user.entity_code, for_portal: true).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
    else

    end

  end


  def validator_index

    params[:count] ? params[:count] : params[:count] = 50
    params[:page].present? ? page = params[:page].to_i : page = 1
    #if params[:validator] == "validator"
    @validators = User.unscoped.where(creator_id: current_user.id, for_portal: false).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
    #else
    #  @users = User.unscoped.where(creator_id: current_user.id, for_portal: true).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
    #end
    #
    if current_user.super_admin?
      @validators = User.unscoped.where(for_portal: false).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
    elsif current_user.super_user?
      @validators = User.unscoped.where("for_portal = false").paginate(:page => page, :per_page => params[:count]).order('created_at desc')
    elsif current_user.merchant_admin?
      @validators = User.unscoped.where(entity_code: current_user.entity_code, for_portal: false).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
    else
    end
  end



  # GET /users/1
  # GET /users/1.json
  def show

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
    if current_user.super_admin? || current_user.super_user?
      @entity_infos = EntityInfo.where(active_status: true).order(entity_name: :asc)
      @entity_divisions = EntityDivision.where(id: 0, active_status: true).order(division_name: :asc)
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if current_user.super_admin? || current_user.super_user?
      @entity_infos = EntityInfo.where(active_status: true).order(entity_name: :asc)
    end
    @user.for_portal = user_params[:role_id] == "5" ? false : true

    unless user_params[:role_id] == "1" || user_params[:role_id] == "2"
      if user_params[:role_id] == "3"
        @user.access_type = "M"
      elsif user_params[:role_id] == "4"
        @user.access_type = "S"
      end
    end
    respond_to do |format|

      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        flash.now[:notice] = "#{@user.user_name.capitalize} was successfully created."
        format.js { render :show }
        format.json { render :show, status: :created, location: @user }
      else
        @entity_divisions = EntityDivision.where(entity_code: user_params[:entity_code], active_status: true).order(division_name: :asc)
        logger.info "Error Messages for create:: #{@user.errors.messages.inspect}"
        # format.html { render :new }
        format.js { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

  end


  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if current_user.super_admin? || current_user.super_user?
      @entity_infos = EntityInfo.where(active_status: true).order(entity_name: :asc)
    end

    #@user.for_portal = user_params[:role_id] == "5" ? false : true
    #unless user_params[:role_id] == "1" || user_params[:role_id] == "2"
      if user_params[:role_id] == "3"
        @user.access_type = "M"
      elsif user_params[:role_id] == "4"
        @user.access_type = "S"
      else
        @user.access_type = nil
      end
    #end

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        flash.now[:notice] = "#{user_params[:user_name].capitalize} was successfully updated."
        format.js { render :show }
        format.json { render :show, status: :ok, location: @user }
      else
        @entity_divisions = EntityDivision.where(entity_code: user_params[:entity_code], active_status: true).order(division_name: :asc)
        logger.info "Error Messages:: #{@user.errors.messages.inspect}"
        format.html { render :edit }
        format.js { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
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
        #@validators = User.unscoped.where(creator_id: current_user.id, for_portal: false).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
        if current_user.super_admin?
          @validators = User.unscoped.where(for_portal: false).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
        elsif current_user.super_user?
          @validators = User.unscoped.where("for_portal = false").paginate(:page => page, :per_page => params[:count]).order('created_at desc')
        elsif current_user.merchant_admin?
          @validators = User.unscoped.where(entity_code: current_user.entity_code, for_portal: false).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
        else
        end
      else
        flash.now[:note] = 'User was successfully disabled.'
        #@users = User.unscoped.where(creator_id: current_user.id, for_portal: true).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
        if current_user.super_admin?
          @users = User.unscoped.where(for_portal: true).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
        elsif current_user.super_user?
          @users = User.unscoped.where("role_id != 1 AND id != #{current_user.id} AND for_portal = true").paginate(:page => page, :per_page => params[:count]).order('created_at desc')
        elsif current_user.merchant_admin?
          @users = User.unscoped.where(entity_code: current_user.entity_code, for_portal: true).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
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
        #@validators = User.unscoped.where(creator_id: current_user.id, for_portal: false).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
        if current_user.super_admin?
          @validators = User.unscoped.where(for_portal: false).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
        elsif current_user.super_user?
          @validators = User.unscoped.where("for_portal = false").paginate(:page => page, :per_page => params[:count]).order('created_at desc')
        elsif current_user.merchant_admin?
          @validators = User.unscoped.where(entity_code: current_user.entity_code, for_portal: false).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
        else
        end
      else
        flash.now[:notice] = 'User was successfully enabled.'
        #@users = User.unscoped.where(creator_id: current_user.id, for_portal: true).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
        if current_user.super_admin?
          @users = User.unscoped.where(for_portal: true).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
        elsif current_user.super_user?
          @users = User.unscoped.where("role_id != 1 AND id != #{current_user.id} AND for_portal = true").paginate(:page => page, :per_page => params[:count]).order('created_at desc')
        elsif current_user.merchant_admin?
          @users = User.unscoped.where(entity_code: current_user.entity_code, for_portal: true).paginate(:page => page, :per_page => params[:count]).order('created_at desc')
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
    params.require(:user).permit(:user_name, :last_name, :first_name, :email, :access_type, :entity_code, :division_code, :contact_number, :password, :password_confirmation, :for_portal, :free_id, :role_id, :creator_id, :active_status, :del_status)
  end

end
