class LoanRequestsController < ApplicationController
  before_action :set_loan_request, only: [:show ]
  # load_and_authorize_resource
  # before_action :load_permissions

  # GET /loan_requests
  # GET /loan_requests.json
  def index
    unless current_user.super_admin? || current_user.super_user?
      session[:loan_req_filter] = nil
      loan_request_index
    end
  end

  def loan_request_index
    params[:count] ? params[:count] :params[:count] = 10
    params[:page].present? ? page = params[:page].to_i : page = 1

    the_search = LoanRequest.filter_activities(params, session)

    if current_user.super_admin? || current_user.super_user?
      @services = EntityDivision.where(active_status: true, assigned_code: params[:code]).order(created_at: :desc).first
      @service_names = @services ? @services.division_name : ""
      @loan_requests = LoanRequest.where(the_search).where(division_code: params[:code]).paginate(:page => page, :per_page => params[:count2]).order(created_at: :desc)
    elsif current_user.merchant_admin?
      dropdown_condition = "entity_code = '#{current_user.user_entity_code}' AND del_status = false"
      @service_division_names = EntityDivision.where(dropdown_condition).order(division_name: :asc)
      div_str = LoanRequest.tuple_of_divs(current_user.user_entity_code)
      @loan_requests = LoanRequest.where(the_search).where("division_code (#{div_str})").paginate(:page => page, :per_page => params[:count2]).order(created_at: :desc)
    elsif current_user.merchant_service?
      @loan_requests = LoanRequest.where(the_search).where(division_code: current_user.user_division_code).paginate(:page => page, :per_page => params[:count2]).order(created_at: :desc)
    # else
    #   @loan_requests = LoanRequest.where(the_search).where(del_status: false, entity_code: current_user.user_entity_code).paginate(:page => page, :per_page => params[:count1]).order(created_at: :desc)
    end

  end

  def show

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
