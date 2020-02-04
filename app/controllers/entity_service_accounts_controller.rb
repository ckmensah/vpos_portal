class EntityServiceAccountsController < ApplicationController
  before_action :set_entity_service_account, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :load_permissions
  # GET /entity_service_accounts
  # GET /entity_service_accounts.json
  def index
    @entity_service_accounts = EntityServiceAccount.all
  end

  # GET /entity_service_accounts/1
  # GET /entity_service_accounts/1.json
  def show
  end

  # GET /entity_service_accounts/new
  def new
    @entity_service_account = EntityServiceAccount.new
  end

  # GET /entity_service_accounts/1/edit
  def edit
  end

  # POST /entity_service_accounts
  # POST /entity_service_accounts.json
  def create
    @entity_service_account = EntityServiceAccount.new(entity_service_account_params)

    respond_to do |format|
      if @entity_service_account.save
        format.html { redirect_to @entity_service_account, notice: 'Entity service account was successfully created.' }
        format.json { render :show, status: :created, location: @entity_service_account }
      else
        format.html { render :new }
        format.json { render json: @entity_service_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entity_service_accounts/1
  # PATCH/PUT /entity_service_accounts/1.json
  def update
    respond_to do |format|
      if @entity_service_account.update(entity_service_account_params)
        format.html { redirect_to @entity_service_account, notice: 'Entity service account was successfully updated.' }
        format.json { render :show, status: :ok, location: @entity_service_account }
      else
        format.html { render :edit }
        format.json { render json: @entity_service_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entity_service_accounts/1
  # DELETE /entity_service_accounts/1.json
  def destroy
    @entity_service_account.destroy
    respond_to do |format|
      format.html { redirect_to entity_service_accounts_url, notice: 'Entity service account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entity_service_account
      @entity_service_account = EntityServiceAccount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entity_service_account_params
      params.require(:entity_service_account).permit(:entity_div_code, :gross_bal, :net_bal, :comment, :active_status, :del_status, :user_id)
    end
end
