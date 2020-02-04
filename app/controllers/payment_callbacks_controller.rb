class PaymentCallbacksController < ApplicationController
  before_action :set_payment_callback, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :load_permissions
  # GET /payment_callbacks
  # GET /payment_callbacks.json
  def index
    @payment_callbacks = PaymentCallback.all
  end

  # GET /payment_callbacks/1
  # GET /payment_callbacks/1.json
  def show
  end
  

  # GET /payment_callbacks/new
  def new
    @payment_callback = PaymentCallback.new
  end

  # GET /payment_callbacks/1/edit
  def edit
  end

  # POST /payment_callbacks
  # POST /payment_callbacks.json
  def create
    @payment_callback = PaymentCallback.new(payment_callback_params)

    respond_to do |format|
      if @payment_callback.save
        format.html { redirect_to @payment_callback, notice: 'Payment callback was successfully created.' }
        format.json { render :show, status: :created, location: @payment_callback }
      else
        format.html { render :new }
        format.json { render json: @payment_callback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payment_callbacks/1
  # PATCH/PUT /payment_callbacks/1.json
  def update
    respond_to do |format|
      if @payment_callback.update(payment_callback_params)
        format.html { redirect_to @payment_callback, notice: 'Payment callback was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment_callback }
      else
        format.html { render :edit }
        format.json { render json: @payment_callback.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_callbacks/1
  # DELETE /payment_callbacks/1.json
  def destroy
    @payment_callback.destroy
    respond_to do |format|
      format.html { redirect_to payment_callbacks_url, notice: 'Payment callback was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_callback
      @payment_callback = PaymentCallback.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_callback_params
      params.require(:payment_callback).permit(:trans_status, :nw_trans_id, :trans_ref, :trans_msg, :active_status, :del_status, :user_id)
    end
end
