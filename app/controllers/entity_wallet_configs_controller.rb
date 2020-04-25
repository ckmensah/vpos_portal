class EntityWalletConfigsController < ApplicationController
  before_action :set_entity_wallet_config, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :load_permissions
  # GET /entity_wallet_configs
  # GET /entity_wallet_configs.json
  def index
    @entity_wallet_configs = EntityWalletConfig.all
  end

  # GET /entity_wallet_configs/1
  # GET /entity_wallet_configs/1.json
  def show
  end

  # GET /entity_wallet_configs/new
  def new
    @entity_wallet_config = EntityWalletConfig.new
  end

  # GET /entity_wallet_configs/1/edit
  def edit
  end

  # POST /entity_wallet_configs
  # POST /entity_wallet_configs.json
  def create
    @entity_wallet_config = EntityWalletConfig.new(entity_wallet_config_params)

    respond_to do |format|
      if @entity_wallet_config.save
        format.html { redirect_to @entity_wallet_config, notice: 'Entity wallet config was successfully created.' }
        format.json { render :show, status: :created, location: @entity_wallet_config }
      else
        format.html { render :new }
        format.json { render json: @entity_wallet_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entity_wallet_configs/1
  # PATCH/PUT /entity_wallet_configs/1.json
  def update
    respond_to do |format|
      if @entity_wallet_config.update(entity_wallet_config_params)
        format.html { redirect_to @entity_wallet_config, notice: 'Entity wallet config was successfully updated.' }
        format.json { render :show, status: :ok, location: @entity_wallet_config }
      else
        format.html { render :edit }
        format.json { render json: @entity_wallet_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entity_wallet_configs/1
  # DELETE /entity_wallet_configs/1.json
  def destroy
    @entity_wallet_config.destroy
    respond_to do |format|
      format.html { redirect_to entity_wallet_configs_url, notice: 'Entity wallet config was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy
    @entity_info = EntityInfo.where(assigned_code: @entity_wallet_config.entity_code).order('created_at desc').first
    if @entity_wallet_config.active_status
      @entity_wallet_config.active_status = false
      #@entity_wallet_config.del_status = true
      @entity_wallet_config.save(validate: false)
      # EntityInfo.disable_by_update_onef("entity_info","assigned_code",@entity_info.assigned_code)
      # @entity_infos = EntityInfo.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to entity_infos_url, notice: 'Occupation master was successfully disabled.' }
        flash.now[:note] = 'Entity information was successfully disabled.'
        format.js { render :layout => false}
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end
    else
      @entity_wallet_config.active_status = true
      #@entity_wallet_config.del_status = false
      @entity_wallet_config.save(validate: false)
      # EntityInfo.enable_by_update_onet("entity_info","assigned_code",@entity_info.assigned_code)
      # @entity_infos = EntityInfo.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
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
    def set_entity_wallet_config
      @entity_wallet_config = EntityWalletConfig.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entity_wallet_config_params
      params.require(:entity_wallet_config).permit(:entity_code, :division_code, :activity_type_code, :service_id, :secret_key, :client_key, :comment, :active_status, :del_status, :user_id)
    end
end
