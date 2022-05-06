class LoanRequestsController < ApplicationController
  before_action :set_loan_request, only: [:show, :edit, :update, :destroy]

  # GET /loan_requests
  # GET /loan_requests.json
  def index
    @loan_requests = LoanRequest.all
  end

  # GET /loan_requests/1
  # GET /loan_requests/1.json
  def show
  end

  # GET /loan_requests/new
  def new
    @loan_request = LoanRequest.new
  end

  # GET /loan_requests/1/edit
  def edit
  end

  # POST /loan_requests
  # POST /loan_requests.json
  def create
    @loan_request = LoanRequest.new(loan_request_params)

    respond_to do |format|
      if @loan_request.save
        format.html { redirect_to @loan_request, notice: 'Loan request was successfully created.' }
        format.json { render :show, status: :created, location: @loan_request }
      else
        format.html { render :new }
        format.json { render json: @loan_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /loan_requests/1
  # PATCH/PUT /loan_requests/1.json
  def update
    respond_to do |format|
      if @loan_request.update(loan_request_params)
        format.html { redirect_to @loan_request, notice: 'Loan request was successfully updated.' }
        format.json { render :show, status: :ok, location: @loan_request }
      else
        format.html { render :edit }
        format.json { render json: @loan_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loan_requests/1
  # DELETE /loan_requests/1.json
  def destroy
    @loan_request.destroy
    respond_to do |format|
      format.html { redirect_to loan_requests_url, notice: 'Loan request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loan_request
      @loan_request = LoanRequest.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def loan_request_params
      params.require(:loan_request).permit(:full_name, :id_number, :ref_number, :location, :amount, :comment, :active_status, :del_status, :user_id)
    end
end
