class ExternalServicesParamsController < ApplicationController
  before_action :set_external_services_param, only: %i[ show edit update destroy ]

  # GET /external_services_params or /external_services_params.json
  def index
    @external_services_params = ExternalServicesParam.all
  end

  # GET /external_services_params/1 or /external_services_params/1.json
  def show
  end

  # GET /external_services_params/new
  def new
    @external_services_param = ExternalServicesParam.new
  end

  # GET /external_services_params/1/edit
  def edit
  end

  # POST /external_services_params or /external_services_params.json
  def create
    @external_services_param = ExternalServicesParam.new(external_services_param_params)

    respond_to do |format|
      if @external_services_param.save
        format.html { redirect_to external_services_param_url(@external_services_param), notice: "External services param was successfully created." }
        format.json { render :show, status: :created, location: @external_services_param }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @external_services_param.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /external_services_params/1 or /external_services_params/1.json
  def update
    respond_to do |format|
      if @external_services_param.update(external_services_param_params)
        format.html { redirect_to external_services_param_url(@external_services_param), notice: "External services param was successfully updated." }
        format.json { render :show, status: :ok, location: @external_services_param }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @external_services_param.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /external_services_params/1 or /external_services_params/1.json
  def destroy
    @external_services_param.destroy!

    respond_to do |format|
      format.html { redirect_to external_services_params_url, notice: "External services param was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_external_services_param
      @external_services_param = ExternalServicesParam.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def external_services_param_params
      params.require(:external_services_param).permit(:entity_div_code, :username, :password, :company_code, :company_url, :user_id, :active_status, :del_status,:mobile_number)
    end
end
