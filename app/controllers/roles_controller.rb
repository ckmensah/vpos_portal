class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]
  before_action :is_super_admin?

  def index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page].present? ? page = params[:page].to_i : page = 1

    logger.info "Current User:: #{current_user.inspect}"
    current_user.super_admin? ? @roles = Role.paginate(:page => page, :per_page => params[:count]).order(created_at: :desc):@roles = Role.where("assigned_code != 'SA'").paginate(:page => page, :per_page => params[:count]).order(created_at: :desc)

  end


  def role_index

    params[:count] ? params[:count] : params[:count] = 50
    params[:page].present? ? page = params[:page].to_i : page = 1

    current_user.super_admin? ? @roles = Role.paginate(:page => page, :per_page => params[:count]).order(created_at: :desc):@roles = Role.where("assigned_code != 'SA'").paginate(:page => page, :per_page => params[:count]).order(created_at: :desc)

  end

  # GET /roles/1
  # GET /roles/1.json
  def show
    @permissions1 = @role.permissions
  end

  # GET /roles/new
  def new
    @role = Role.new
    @permissions = Permission.where("subject_class !='Role'").order(subject_class: :asc).compact
    @role_permissions = @role.permissions.collect{|p| p.id}
    logger.info "Role permissions:: #{@role_permissions.inspect}"
  end

  # GET /roles/1/edit
  def edit
    @permissions = Permission.where("subject_class !='Role'").order(subject_class: :asc).compact
    @role_permissions = @role.permissions.collect{|p| p.id.to_s}
  end


  # POST /roles
  # POST /roles.json
  def create
    @role = Role.new(role_params)

    respond_to do |format|
      if @role.valid? && params[:permissions] != nil && params[:permissions].length > 0
        @role.save
        @role.set_permissions(params[:permissions]) if params[:permissions]
        @permissions1 = @role.permissions
        format.js {render :show}
        format.json { render :show, status: :created, location: @role }
      else
        logger.info "================================================"
        logger.info "ERROR MESSAGES :: #{@role.errors.messages.inspect}"
        @permissions = Permission.where("subject_class !='Role'").order(subject_class: :asc).compact
        @role_permissions = @role.permissions.collect{|p| p.id}
        format.js {render :new}
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles/1
  # PATCH/PUT /roles/1.json
  def update
    respond_to do |format|
      if params[:permissions] != nil && params[:permissions].length > 0 && @role.update(role_params)
        @role.permissions = []
        @role.set_permissions(params[:permissions]) if params[:permissions]
        @permissions1 = @role.permissions

        format.js {render :show}
        format.json { render :show, status: :ok, location: @role }
      else
        @permissions = Permission.where("subject_class !='Role'").order(subject_class: :asc).compact
        @role_permissions = params[:permissions] != nil && params[:permissions].length > 0 ? params[:permissions] : []
        format.js {render :edit}
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy

    puts page = params[:page]
    if @role.active_status
      @role.active_status = false
      @role.save(validate: false)
      current_user.super_admin? ? @roles = Role.paginate(:page => page, :per_page => params[:count]).order(created_at: :desc):@roles = Role.where("assigned_code != 'SA'").paginate(:page => page, :per_page => params[:count]).order(created_at: :desc)
      respond_to do |format|
        flash.now[:note] = 'Role was successfully disabled.'
        format.js { render :layout => false, notice: 'Course was successfully disabled.' }
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end
    else
      @role.active_status = true
      @role.save(validate: false)
      current_user.super_admin? ? @roles = Role.paginate(:page => page, :per_page => params[:count]).order(created_at: :desc):@roles = Role.where("assigned_code != 'SA'").paginate(:page => page, :per_page => params[:count]).order(created_at: :desc)
      respond_to do |format|
        flash.now[:notice] = 'Role was successfully enabled.'
        format.js { render :layout => false, notice: 'Course was successfully enabled.' }
        format.json { head :no_content }
      end
    end

  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
      params.require(:role).permit(:assigned_code, :role_name, :active_status, :del_status, :user_id)
    end

    def is_super_admin?
      unless current_user.super_admin?
        flash[:note] = "You are not authorized to manage roles."
        redirect_to root_path(home_notice: "authorization")# and return
      end

      # redirect_to root_path(home_notice: "authorization") and return unless current_user.super_admin? #|| current_user.super_user?
      # flash[:note] = "You are not authorized to manage roles."
    end

end
