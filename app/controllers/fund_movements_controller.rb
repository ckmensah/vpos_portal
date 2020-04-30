class FundMovementsController < ApplicationController
  before_action :set_fund_movement, only: [:show]

  # GET /fund_movements
  # GET /fund_movements.json
  def index
    #@fund_movements = FundMovement.all
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1
    params[:page].present? ? page = params[:page].to_i : page = 1

    params[:count1] ? params[:count1] : params[:count1] = 50
    params[:page1] ? params[:page1] : params[:page1] = 1
    if current_user.merchant_admin?
      params[:entity_code] = current_user.entity_code

      @entity_info = EntityInfo.where(assigned_code: params[:entity_code], active_status: true).order(created_at: :desc).first
      @entity_name = @entity_info ? @entity_info.entity_name : ""
      @entity_divisions = EntityDivision.where(entity_code: params[:entity_code], active_status: true, del_status: false).paginate(:page => params[:page1], :per_page => params[:count1]).order(created_at: :desc)

    elsif current_user.merchant_service?
      params[:entity_code] = current_user.entity_code
      params[:division_code] = current_user.division_code

      @entity_info = EntityInfo.where(assigned_code: params[:entity_code], active_status: true).order(created_at: :desc).first
      @entity_name = @entity_info ? @entity_info.entity_name : ""
      @entity_div = EntityDivision.where(assigned_code: params[:division_code], active_status: true).order(created_at: :desc).first
      @division_name = @entity_div ? "(#{@entity_div.division_name})" : ""
      @fund_movements = FundMovement.where(entity_div_code: params[:division_code]).paginate(:page => params[:page2], :per_page => params[:count2]).order(created_at: :desc)

    end

    @entity_infos = EntityInfo.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order(created_at: :desc)

  end

  def settlement_entity_info_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    @entity_infos = EntityInfo.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order(created_at: :desc)

  end

  def settlement_entity_division_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    params[:count1] ? params[:count1] : params[:count1] = 50
    params[:page1] ? params[:page1] : params[:page1] = 1
    @entity_info = EntityInfo.where(assigned_code: params[:entity_code], active_status: true).order(created_at: :desc).first
    @entity_name = @entity_info ? @entity_info.entity_name : ""
    @entity_divisions = EntityDivision.where(entity_code: params[:entity_code], active_status: true, del_status: false).paginate(:page => params[:page1], :per_page => params[:count1]).order(created_at: :desc)
  end

  def fund_movement_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    params[:count1] ? params[:count1] : params[:count1] = 50
    params[:page1] ? params[:page1] : params[:page1] = 1

    params[:count2] ? params[:count2] : params[:count2] = 50
    params[:page2] ? params[:page2] : params[:page2] = 1

    @entity_info = EntityInfo.where(assigned_code: params[:entity_code], active_status: true).order(created_at: :desc).first
    @entity_name = @entity_info ? @entity_info.entity_name : ""
    @entity_div = EntityDivision.where(assigned_code: params[:division_code], active_status: true).order(created_at: :desc).first
    @division_name = @entity_div ? "(#{@entity_div.division_name})" : ""
    @fund_movements = FundMovement.where(entity_div_code: params[:division_code]).paginate(:page => params[:page2], :per_page => params[:count2]).order(created_at: :desc)

    respond_to do |format|
      format.js
      format.csv { send_data @fund_movements.to_csv(@fund_movements, current_user), :filename => "settlement_report.csv" }
      format.xls { send_data @fund_movements.to_csv(@fund_movements, current_user, col_sep: "\t"), :filename => "settlement_report.xls" }
    end

  end

  # GET /fund_movements/1
  # GET /fund_movements/1.json
  def show
  end

  # GET /fund_movements/new
  def new
    @fund_movement = FundMovement.new
  end

  # GET /fund_movements/1/edit
  def edit
  end

  # POST /fund_movements
  # POST /fund_movements.json
  def create
    @fund_movement = FundMovement.new(fund_movement_params)

    #respond_to do |format|
    #  if @fund_movement.save
    #    format.html { redirect_to @fund_movement, notice: 'Fund movement was successfully created.' }
    #    format.json { render :show, status: :created, location: @fund_movement }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @fund_movement.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /fund_movements/1
  # PATCH/PUT /fund_movements/1.json
  def update
    respond_to do |format|
      #if @fund_movement.update(fund_movement_params)
      #  format.html { redirect_to @fund_movement, notice: 'Fund movement was successfully updated.' }
      #  format.json { render :show, status: :ok, location: @fund_movement }
      #else
      #  format.html { render :edit }
      #  format.json { render json: @fund_movement.errors, status: :unprocessable_entity }
      #end
    end
  end

  # DELETE /fund_movements/1
  # DELETE /fund_movements/1.json
  def destroy
    #@fund_movement.destroy
    #respond_to do |format|
    #  format.html { redirect_to fund_movements_url, notice: 'Fund movement was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fund_movement
      @fund_movement = FundMovement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fund_movement_params
      params.require(:fund_movement).permit(:entity_div_code, :service_id, :ref_id, :amount, :narration, :trans_type, :trans_status, :trans_desc, :processed)
    end
end
