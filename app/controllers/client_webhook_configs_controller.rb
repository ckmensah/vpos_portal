class ClientWebhookConfigsController < ApplicationController
  before_action :set_client_webhook_config, only: %i[ show edit update destroy ]

  # GET /client_webhook_configs or /client_webhook_configs.json
  def index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    @client_webhook_configs = ClientWebhookConfig.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
  end

  # GET /client_webhook_configs/1 or /client_webhook_configs/1.json
  def show
  end

  # GET /client_webhook_configs/new
  def new
    @client_webhook_config = ClientWebhookConfig.new
    # @trans_types = [%w[CTM CUSTOMER-TO-MERCHANT], %w[MTC MERCHANT-TO-CUSTOMER]]
  end

  def client_webhook_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    @client_webhook_configs = ClientWebhookConfig.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

  end

  # GET /client_webhook_configs/1/edit
  def edit
  end

  # POST /client_webhook_configs or /client_webhook_configs.json
  def create
    # @client_webhook_config = ClientWebhookConfig.new(client_webhook_config_params)
    # @trans_types = [%w[CTM CUSTOMER-TO-MERCHANT], %w[MTC MERCHANT-TO-CUSTOMER]]

    trans_type = client_webhook_config_params[:trans_type]
    # logger.info " these are the trans_types #{client_webhook_config_params}"
    done = false
    # trans_type.reject(&:empty?).map.each do |trans_type|
    # trans_type.reject!(&:blank?).map.each do |trans_type|
    trans_type.each do |trans_type|
      next if trans_type.empty?
      @client_webhook_config = ClientWebhookConfig.new(
        entity_div_code: client_webhook_config_params[:entity_div_code],
        url: client_webhook_config_params[:url],
        trans_type: trans_type,
        active_status: true,
        del_status: false,
        user_id: current_user.id
      )
      if @client_webhook_config.save
        done = true
      end

    end


    respond_to do |format|
      if done
        format.html { redirect_to @client_webhook_config, notice: 'Client webhook config was successfully created.' }
        flash.now[:danger] = "Client webhook config was successfully created."
        format.js { render :show}
        format.json { render :show, status: :created, location: @client_webhook_config }
      else
        format.html { render :new }
        format.js {render :new }
        format.json { render json: @client_webhook_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /client_webhook_configs/1 or /client_webhook_configs/1.json
  def update
    respond_to do |format|
      if @client_webhook_config.update(client_webhook_config_params)
        format.html { redirect_to  client_webhook_config_url(@client_webhook_config), notice: 'Client webhook config was successfully updated.' }
        flash.now[:danger] = "Client webhook config was successfully updated."
        format.js { render :show}
        format.json { render :show, status: :ok, location: @client_webhook_config }
      else
        format.html { render :edit }
        format.js {render :edit }
        format.json { render json: @client_webhook_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /client_webhook_configs/1 or /client_webhook_configs/1.json
  def destroy
    if @client_webhook_config.active_status
      @client_webhook_config.active_status = false
      @client_webhook_config.save(validate: false)
      @client_webhook_configs = ClientWebhookConfig.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to client_webhook_config_url, notice: 'Client webhook configuration updated.' }
        flash.now[:note] = 'Client webhook configuration successfully disabled'
        format.js { render :layout => false}
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end

    else
      @client_webhook_config.active_status = true
      @client_webhook_config.save(validate: false)
      @client_webhook_configs = ClientWebhookConfig.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to client_webhook_config_url, notice: 'Client webhook configuration enabled.' }
        flash.now[:notice] = 'Client webhook configuration was successfully enabled.'
        format.js { render :layout => false }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client_webhook_config
      @client_webhook_config = ClientWebhookConfig.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def client_webhook_config_params
      params.require(:client_webhook_config).permit(:entity_div_code,:url, :active_status, :del_status, :user_id, {:trans_type => []})
    end
end
