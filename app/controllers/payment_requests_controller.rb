class PaymentRequestsController < ApplicationController
  before_action :set_payment_request, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :load_permissions
  # GET /payment_requests
  # GET /payment_requests.json
  def index
    @payment_requests = PaymentRequest.all

  end

  # GET /payment_requests/1
  # GET /payment_requests/1.json
  def show
  end

  # GET /payment_requests/new
  def new
    @payment_request = PaymentRequest.new
  end

  # GET /payment_requests/1/edit
  def edit
  end

  # POST /payment_requests
  # POST /payment_requests.json
  def create
    @payment_request = PaymentRequest.new(payment_request_params)

    respond_to do |format|
      if @payment_request.save
        format.html { redirect_to @payment_request, notice: 'Payment request was successfully created.' }
        format.json { render :show, status: :created, location: @payment_request }
      else
        format.html { render :new }
        format.json { render json: @payment_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payment_requests/1
  # PATCH/PUT /payment_requests/1.json
  def update
    respond_to do |format|
      if @payment_request.update(payment_request_params)
        format.html { redirect_to @payment_request, notice: 'Payment request was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment_request }
      else
        format.html { render :edit }
        format.json { render json: @payment_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_requests/1
  # DELETE /payment_requests/1.json
  def destroy
    @payment_request.destroy
    respond_to do |format|
      format.html { redirect_to payment_requests_url, notice: 'Payment request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_request
      @payment_request = PaymentRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_request_params
      params.require(:payment_request).permit(:payment_info_id, :processing_id, :customer_number, :nw, :trans_type, :amount, :service_id, :payment_mode, :reference, :processed, :active_status, :del_status, :user_id)
    end
end
