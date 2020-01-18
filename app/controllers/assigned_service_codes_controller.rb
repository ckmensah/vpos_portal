class AssignedServiceCodesController < ApplicationController
  before_action :set_assigned_service_code, only: [:show, :edit, :update, :destroy]

  # GET /assigned_service_codes
  # GET /assigned_service_codes.json
  def index
    @assigned_service_codes = AssignedServiceCode.all
  end

  # GET /assigned_service_codes/1
  # GET /assigned_service_codes/1.json
  def show
  end

  # GET /assigned_service_codes/new
  def new
    @assigned_service_code = AssignedServiceCode.new
  end

  # GET /assigned_service_codes/1/edit
  def edit
  end

  # POST /assigned_service_codes
  # POST /assigned_service_codes.json
  def create
    @assigned_service_code = AssignedServiceCode.new(assigned_service_code_params)

    respond_to do |format|
      if @assigned_service_code.save
        format.html { redirect_to @assigned_service_code, notice: 'Assigned service code was successfully created.' }
        format.json { render :show, status: :created, location: @assigned_service_code }
      else
        format.html { render :new }
        format.json { render json: @assigned_service_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assigned_service_codes/1
  # PATCH/PUT /assigned_service_codes/1.json
  def update
    respond_to do |format|
      if @assigned_service_code.update(assigned_service_code_params)
        format.html { redirect_to @assigned_service_code, notice: 'Assigned service code was successfully updated.' }
        format.json { render :show, status: :ok, location: @assigned_service_code }
      else
        format.html { render :edit }
        format.json { render json: @assigned_service_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assigned_service_codes/1
  # DELETE /assigned_service_codes/1.json
  def destroy
    @assigned_service_code.destroy
    respond_to do |format|
      format.html { redirect_to assigned_service_codes_url, notice: 'Assigned service code was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assigned_service_code
      @assigned_service_code = AssignedServiceCode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assigned_service_code_params
      params.require(:assigned_service_code).permit(:entity_div_code, :service_code, :comment, :active_status, :del_status, :user_id)
    end
end
