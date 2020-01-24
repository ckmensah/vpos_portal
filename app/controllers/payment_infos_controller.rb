class PaymentInfosController < ApplicationController
  before_action :set_payment_info, only: [:show, :edit, :update, :destroy]

  # GET /payment_infos
  # GET /payment_infos.json
  def index
    params[:count] ? params[:count] : params[:count] = 10
    params[:page] ? params[:page] : params[:page] = 1

    #@payment_infos = PaymentInfo.payments_join.paginate(:page => params[:page], :per_page => params[:count]).order('payment_info.created_at desc')
    @payment_infos = PaymentReport.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
  end


  def payment_info_index
    params[:count] ? params[:count] : params[:count] = 10
    params[:page] ? params[:page] : params[:page] = 1

    #@payment_infos = PaymentInfo.payments_join.paginate(:page => params[:page], :per_page => params[:count]).order('payment_info.created_at desc')
    @payment_infos = PaymentReport.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
  end

  # GET /payment_infos/1
  # GET /payment_infos/1.json
  def show
    @pay_info = PaymentReport.where(id: @payment_report.id).order(created_at: :desc).first
    logger.info "Payment Info :: #{@pay_info.inspect}"
    logger.info "Cust number :: #{@pay_info.customer_number.inspect}"
  end

  # GET /payment_infos/new
  def new
    @payment_info = PaymentInfo.new
  end

  # GET /payment_infos/1/edit
  def edit
  end

  # POST /payment_infos
  # POST /payment_infos.json
  def create
    @payment_info = PaymentInfo.new(payment_info_params)

    respond_to do |format|
      if @payment_info.save
        format.html { redirect_to @payment_info, notice: 'Payment info was successfully created.' }
        format.json { render :show, status: :created, location: @payment_info }
      else
        format.html { render :new }
        format.json { render json: @payment_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payment_infos/1
  # PATCH/PUT /payment_infos/1.json
  def update
    respond_to do |format|
      if @payment_info.update(payment_info_params)
        format.html { redirect_to @payment_info, notice: 'Payment info was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment_info }
      else
        format.html { render :edit }
        format.json { render json: @payment_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_infos/1
  # DELETE /payment_infos/1.json
  def destroy
    @payment_info.destroy
    respond_to do |format|
      format.html { redirect_to payment_infos_url, notice: 'Payment info was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_info
      #@payment_info = PaymentInfo.find(params[:id])
      @payment_report = PaymentReport.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_info_params
      params.require(:payment_info).permit(:session_id, :entity_div_code, :activity_lov_id, :activity_div_id, :activity_sub_div_id, :processed, :src, :payment_mode, :amount, :customer_number, :trans_type, :charge, :active_status, :del_status, :user_id)
    end
end
