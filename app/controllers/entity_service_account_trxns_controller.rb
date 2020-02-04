class EntityServiceAccountTrxnsController < ApplicationController
  before_action :set_entity_service_account_trxn, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_filter :load_permissions
  # GET /entity_service_account_trxns
  # GET /entity_service_account_trxns.json
  def index
    @entity_service_account_trxns = EntityServiceAccountTrxn.all
  end

  # GET /entity_service_account_trxns/1
  # GET /entity_service_account_trxns/1.json
  def show
  end

  # GET /entity_service_account_trxns/new
  def new
    @entity_service_account_trxn = EntityServiceAccountTrxn.new
  end

  # GET /entity_service_account_trxns/1/edit
  def edit
  end

  # POST /entity_service_account_trxns
  # POST /entity_service_account_trxns.json
  def create
    @entity_service_account_trxn = EntityServiceAccountTrxn.new(entity_service_account_trxn_params)

    respond_to do |format|
      if @entity_service_account_trxn.save
        format.html { redirect_to @entity_service_account_trxn, notice: 'Entity service account trxn was successfully created.' }
        format.json { render :show, status: :created, location: @entity_service_account_trxn }
      else
        format.html { render :new }
        format.json { render json: @entity_service_account_trxn.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entity_service_account_trxns/1
  # PATCH/PUT /entity_service_account_trxns/1.json
  def update
    respond_to do |format|
      if @entity_service_account_trxn.update(entity_service_account_trxn_params)
        format.html { redirect_to @entity_service_account_trxn, notice: 'Entity service account trxn was successfully updated.' }
        format.json { render :show, status: :ok, location: @entity_service_account_trxn }
      else
        format.html { render :edit }
        format.json { render json: @entity_service_account_trxn.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entity_service_account_trxns/1
  # DELETE /entity_service_account_trxns/1.json
  def destroy
    @entity_service_account_trxn.destroy
    respond_to do |format|
      format.html { redirect_to entity_service_account_trxns_url, notice: 'Entity service account trxn was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entity_service_account_trxn
      @entity_service_account_trxn = EntityServiceAccountTrxn.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entity_service_account_trxn_params
      params.require(:entity_service_account_trxn).permit(:entity_div_code, :gross_bal_bef, :gross_bal_aft, :net_bal_bef, :net_bal_aft, :processing_id, :charge, :trans_type, :comment, :active_status, :del_status, :user_id)
    end
end
