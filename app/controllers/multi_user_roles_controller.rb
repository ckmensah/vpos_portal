class MultiUserRolesController < ApplicationController
  before_action :set_multi_user_role, only: [:show, :edit, :update, :destroy]

  # GET /multi_user_roles
  # GET /multi_user_roles.json
  def index
    @multi_user_roles = MultiUserRole.all
  end

  # GET /multi_user_roles/1
  # GET /multi_user_roles/1.json
  def show
  end

  # GET /multi_user_roles/new
  def new
    @multi_user_role = MultiUserRole.new
  end

  # GET /multi_user_roles/1/edit
  def edit
  end

  # POST /multi_user_roles
  # POST /multi_user_roles.json
  def create
    @multi_user_role = MultiUserRole.new(multi_user_role_params)

    respond_to do |format|
      if @multi_user_role.save
        format.html { redirect_to @multi_user_role, notice: 'Multi user role was successfully created.' }
        format.json { render :show, status: :created, location: @multi_user_role }
      else
        format.html { render :new }
        format.json { render json: @multi_user_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /multi_user_roles/1
  # PATCH/PUT /multi_user_roles/1.json
  def update
    respond_to do |format|
      if @multi_user_role.update(multi_user_role_params)
        format.html { redirect_to @multi_user_role, notice: 'Multi user role was successfully updated.' }
        format.json { render :show, status: :ok, location: @multi_user_role }
      else
        format.html { render :edit }
        format.json { render json: @multi_user_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /multi_user_roles/1
  # DELETE /multi_user_roles/1.json
  def destroy
    @multi_user_role.destroy
    respond_to do |format|
      format.html { redirect_to multi_user_roles_url, notice: 'Multi user role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_multi_user_role
      @multi_user_role = MultiUserRole.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def multi_user_role_params
      params.require(:multi_user_role).permit(:user_id, :entity_code, :role_code, :division_code, :creator_id, :comment, :active_status, :del_status)
    end
end
