class ActivityDivsController < ApplicationController
  before_action :set_activity_div, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :load_permissions
  require 'vpos_core'
  # GET /activity_divs
  # GET /activity_divs.json
  def activity_div_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1
    params[:page].present? ? page = params[:page].to_i : page = 1

    params[:count1] ? params[:count1] : params[:count1] = 50
    params[:page1] ? params[:page1] : params[:page1] = 1

    params[:count5] ? params[:count5] : params[:count5] = 50
    params[:page5] ? params[:page5] : params[:page5] = 1

    @activity_divs = ActivityDiv.where(division_code: params[:code], del_status: false).paginate(:page => params[:page], :per_page => params[:count5]).order(created_at: :desc)

  end

  # GET /activity_divs/1
  # GET /activity_divs/1.json
  def show
  end

  # GET /activity_divs/new
  def new
    @activity_div = ActivityDiv.new
  end

  # GET /activity_divs/1/edit
  def edit
    @networks = [["MTN", "MTN"], ["VODAFONE", "VOD"], ["TIGO", "TIG"], ["AIRTEL", "AIR"]]
    #@activity_sub_divs = ActivitySubDiv.where(activity_div_id: @activity_div.id, active_status: true).order(classification: :asc)
    @activity_classes = []
    @activity_sub_divs = []
    @activity_groups = ActivityGroup.where(active_status: true, del_status: false).order(activity_group_desc: :asc)

  end

  # POST /activity_divs
  # POST /activity_divs.json
  def create
    @activity_div = ActivityDiv.new(activity_div_params)

    respond_to do |format|
      if @activity_div.valid?
        format.html { redirect_to @activity_div, notice: 'Activity div was successfully created.' }
        format.json { render :show, status: :created, location: @activity_div }
      else
        format.html { render :new }
        format.json { render json: @activity_div.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activity_divs/1
  # PATCH/PUT /activity_divs/1.json
  def update
    @activity_div.ticket_valid = activity_div_params[:ticket_valid] == "true" ? true : false
    @activity_div.activity_sub_plan_id = activity_div_params[:activity_sub_plan_id]
    @activity_div.recipient_number = activity_div_params[:recipient_number]
    @activity_div.recipient_email = activity_div_params[:recipient_email]
    @activity_div.amt = activity_div_params[:amt]
    @activity_div.entity_div_code = activity_div_params[:entity_div_code]
    @activity_div.src = activity_div_params[:src]
    @activity_div.payment_mode = activity_div_params[:payment_mode]
    @activity_div.nw = activity_div_params[:nw]
    @activity_div.customer_name = activity_div_params[:customer_name]
    @activity_div.qty = activity_div_params[:qty]
    @activity_div.act_class = activity_div_params[:act_class]
    @activity_div.act_group = activity_div_params[:act_group]
    @networks = [["MTN", "MTN"], ["VODAFONE", "VOD"], ["TIGO", "TIG"], ["AIRTEL", "AIR"]]
    @activity_sub_divs = ActivitySubDiv.where(activity_div_id: @activity_div.id, active_status: true).order(classification: :asc)
    #@activity_sub_divs = ActivitySubDiv.where(activity_div_id: @activity_div.id, active_status: true).order(classification: :asc)
    #@activity_sub_divs = [["", ""]]
    @activity_groups = ActivityGroup.where(active_status: true, del_status: false).order(activity_group_desc: :asc)
    @activity_classes = activity_div_params[:act_group].present? ? ActivitySubDivClass.where(entity_div_code: params[:code], activity_group_code: activity_div_params[:act_group]).order(class_desc: :asc) : []
    @activity_sub_divs = activity_div_params[:act_class].present? ? ActivitySubDiv.where(activity_div_id: params[:id], classification: activity_div_params[:act_class]) : []

    respond_to do |format|
      if @activity_div.valid?
        @activity_divs = ActivityDiv.where(division_code: params[:code], del_status: false).order(created_at: :desc)
        reference = @activity_div.entity_division != nil ? @activity_div.entity_division.division_name : ""
        endpoint = '/process_payment_req'
        # endpoint = '/bulk_ticket_generate_req'
        @activity_classes = []
        @activity_sub_divs = []

        payload = {
            "activity_div_id": "#{@activity_div.id}", "activity_lov_id": "", "activity_main_code": "",
            "activity_sub_plan_id": activity_div_params[:activity_sub_plan_id], "amount": activity_div_params[:amt],
            "charge": activity_div_params[:amt], "customer_name": activity_div_params[:customer_name],
            "entity_div_code": @activity_div.division_code, "nw": activity_div_params[:nw],
            "pan": activity_div_params[:recipient_number], "payment_mode": "CSH", "qty": activity_div_params[:qty].to_s,
            "recipient_email": activity_div_params[:recipient_email], "recipient_number": activity_div_params[:recipient_number],
            "recipient_type": "", "reference": reference, "session_id": "", "src": "PTL"
        }
        json_payload=JSON.generate(payload)
        logger.info "JSON PAYLOAD :: #{json_payload.inspect}"
        core_connection = VposCore::CoreConnect.new
        connection = core_connection.connection
        #signature = core_connection.compute_signature(_secret_key, json_payload)
        logger.info "Core connection: #{core_connection.inspect}"
        begin
          result=connection.post do |req|
            req.url endpoint
            req.options.timeout = 90           # open/read timeout in seconds
            req.options.open_timeout = 90      # connection open timeout in seconds
            #req["Authorization"]="#{_client_key}:#{signature}"
            req.body = json_payload
          end

          logger.info "Response:: #{result.inspect}"
          json_valid_res = core_connection.json_validate(result.body)
          if json_valid_res
            logger.info "Valid JSON ================"
            the_resp = JSON.parse(result.body)

            resp_code = the_resp["resp_code"]
            resp_desc = the_resp["resp_desc"]
            logger.info "Response Description :: #{resp_desc.inspect}"
            if resp_code == "00"
              @activity_div = ActivityDiv.new(activity_div_params)
              flash.now[:notice] = resp_desc
              format.js { render :show }
            else
              flash.now[:danger] = resp_desc
              format.js { render :edit }
            end
          else
            logger.info "Not a Valid JSON ==============="
            flash.now[:danger] = "Sorry, There was an issue. Kindly check and try again."
            format.js { render :edit }
          end
        rescue Faraday::SSLError
          logger.info "SSL Error ==============="
          flash.now[:danger] = "Sorry, There was an issue. Kindly check and try again."
          format.js { render :edit }
        rescue Faraday::TimeoutError
          logger.info "Timeout Error ================="
          flash.now[:danger] = "Sorry, There was a timeout issue. Kindly check and try again."
          format.js { render :edit }
        # rescue Faraday::Error::ConnectionFailed => e
        rescue Faraday::Connection => e
          logger.info "Connection Failed ================"
          logger.info "Error message :: #{e} ==================="
          flash.now[:danger] = "Sorry, There was a connection issue. Kindly check and try again."
          format.js { render :edit }
        end
      else
        logger.info "Activity Div :: #{@activity_div.inspect}"
        logger.info "Error Messages :: #{@activity_div.errors.messages.inspect}"
        format.js { render :edit }
        format.html { render :edit }
        format.json { render json: @activity_div.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_divs/1
  # DELETE /activity_divs/1.json
  def destroy

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_div
      @activity_div = ActivityDiv.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_div_params
      params.require(:activity_div).permit(:division_code, :activity_div_desc, :activity_date, :activity_sub_plan_id, :recipient_number,
                                           :recipient_email, :entity_div_code, :src, :payment_mode, :nw, :amt, :qty, :customer_name, :ticket_valid,
                                           :comment, :active_status, :del_status, :user_id, :act_group, :act_class)
    end
end
