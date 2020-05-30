class PaymentInfosController < ApplicationController
  before_action :set_payment_info, only: [:show, :transaction_resend, :resend_form]
  load_and_authorize_resource
  before_action :load_permissions
  require 'vpos_core'

  # GET /payment_infos
  # GET /payment_infos.json
  def index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    @success_status = "000"
    #@payment_infos = PaymentReport.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
    if current_user.super_admin? || current_user.super_user?
      @merchant_search = EntityInfo.where(active_status: true).order(entity_name: :asc)
      @merchant_service_search = EntityDivision.where(active_status: true).order(division_name: :asc)
      @division_lovs = DivisionActivityLov.where(active_status: true).order(lov_desc: :asc)
      @payment_infos = PaymentReport.where("split_part(trans_status, '/', 1) = '000'").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
    elsif current_user.merchant_admin?
      @merchant_service_search = EntityDivision.where(active_status: true, entity_code: current_user.entity_code).order(division_name: :asc)
      entity_div_id_str = "'0'"
      @entity_divs = EntityDivision.where(entity_code: current_user.entity_code, active_status: true)
      @entity_divs.each do |entity_div|
        entity_div_id_str << ",'#{entity_div.assigned_code}'"
      end
      final_div_ids = "(#{entity_div_id_str})"
      @payment_infos = PaymentReport.where("split_part(trans_status, '/', 1) = '000' AND entity_div_code IN #{final_div_ids} ").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      @division_lovs = DivisionActivityLov.where("active_status = true AND division_code IN #{final_div_ids}").order(lov_desc: :asc)
    elsif current_user.merchant_service?
      entity_div_id_str = "'0'"
      @entity_divs = EntityDivision.where("entity_code = '#{current_user.entity_code}' and active_status = true")
      if @entity_divs.exists?
        @entity_divs.each do |entity_div|
          entity_div_id_str << ",'#{entity_div.assigned_code}'"
        end
      end
      final_div_ids = "(#{entity_div_id_str})"
      @division_lovs = DivisionActivityLov.where("division_code IN #{final_div_ids}").order(lov_desc: :asc)
      @payment_infos = PaymentReport.where("split_part(trans_status, '/', 1) = '000' AND entity_div_code = '#{current_user.division_code}'").paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
    end
    #logger.info "Report #{@payment_infos.inspect}"
  end




  def payment_info_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    the_search = ""
    search_arr = []
    @entity_code = params[:entity_code]
    @code = params[:code]

    if params[:filter_main].present? || params[:entity_name].present? || params[:division_name].present? || params[:activity_type].present? || params[:cust_num].present? || params[:trans_id].present? || params[:nw].present? || params[:status].present? || params[:start_date].present? || params[:end_date].present?

      filter_params = params[:filter_main]
      if params[:filter_main].present?
        @entity_name = filter_params[:entity_name]
        @division_name = filter_params[:division_name]
        @activity_type = filter_params[:activity_type]
        @lov_name = filter_params[:lov_name]
        @cust_num = filter_params[:cust_num]
        @trans_id = filter_params[:trans_id]
        @nw = filter_params[:nw]
        @status = filter_params[:status]
        @start_date = filter_params[:start_date]
        @end_date = filter_params[:end_date]
        @a_download = filter_params[:a_download]
        params[:entity_name] = filter_params[:entity_name]
        params[:division_name] = filter_params[:division_name]
        params[:activity_type] = filter_params[:activity_type]
        params[:lov_name] = filter_params[:lov_name]
        params[:cust_num] = filter_params[:cust_num]
        params[:trans_id] = filter_params[:trans_id]
        params[:nw] = filter_params[:nw]
        params[:status] = filter_params[:status]
        params[:start_date] = filter_params[:start_date]
        params[:end_date] = filter_params[:end_date]
        params[:a_download] = filter_params[:a_download]
      else

        if  params[:entity_name].present? || params[:division_name].present? || params[:activity_type].present? || params[:lov_name].present? || params[:cust_num].present? || params[:trans_id].present? || params[:nw].present? || params[:status].present? || params[:start_date].present? || params[:end_date].present?

          @entity_name = params[:entity_name]
          @division_name = params[:division_name]
          @activity_type = params[:activity_type]
          @lov_name = params[:lov_name]
          @cust_num = params[:cust_num]
          @trans_id = params[:trans_id]
          @nw = params[:nw]
          @status = params[:status]
          @start_date = params[:start_date]
          @end_date = params[:end_date]
          @a_download = params[:a_download]
          params[:entity_name] = @entity_name
          params[:division_name] = @division_name
          params[:activity_type] = @activity_type
          params[:lov_name] = @lov_name
          params[:cust_num] = @cust_num
          params[:trans_id] = @trans_id
          params[:nw] = @nw
          params[:status] = @status
          params[:start_date] = @start_date
          params[:end_date] = @end_date
          params[:a_download] = @a_download
        else
          params[:entity_name] = filter_params[:entity_name]
          params[:division_name] = filter_params[:division_name]
          params[:activity_type] = filter_params[:activity_type]
          params[:lov_name] = filter_params[:lov_name]
          params[:cust_num] = filter_params[:cust_num]
          params[:trans_id] = filter_params[:trans_id]
          params[:nw] = filter_params[:nw]
          params[:status] = filter_params[:status]
          params[:start_date] = filter_params[:start_date]
          params[:end_date] = filter_params[:end_date]
          params[:a_download] = filter_params[:a_download]
        end
      end


      if @entity_name.present?
        division_str = "'0'"
        #entity_str = "'0'"
        #@merchant = EntityInfo.where("LOWER(entity_name) LIKE '%#{@entity_name.downcase}%'")
        #@merchant.each { |entity_div| entity_str << ",'#{entity_div.assigned_code}'" } if @merchant.exists?
        #final_info_str = "(#{entity_str})"
        #@entity_divis = EntityDivision.where("entity_code IN #{final_info_str}")
        @entity_divis = EntityDivision.where("entity_code = '#{@entity_name}'")
        @entity_divis.each { |entity_div| division_str << ",'#{entity_div.assigned_code}'" } if @entity_divis.exists?
        final_div_str = "(#{division_str})"
        #logger.info "Final Div Str :: #{final_div_str.inspect} and Final INfo Str :: #{final_info_str}"
        search_arr << "entity_div_code IN #{final_div_str}"
      end


      if @division_name.present?
        #division_str = "'0'"
        #@entity_divis = EntityDivision.where("LOWER(division_name) LIKE '%#{@division_name.downcase}%'")
        #@entity_divis.each { |entity_div| division_str << ",'#{entity_div.assigned_code}'" } if @entity_divis.exists?
        #final_div_str = "(#{division_str})"
        #logger.info "Final Div Str :: #{final_div_str.inspect}"
        #search_arr << "entity_div_code IN #{final_div_str}"
        search_arr << "entity_div_code = '#{@division_name}'"
      end



      if @activity_type.present?
        activity_str = "'0'"
        div_str = "'0'"
        @act_type = ActivityType.where("LOWER(assigned_code) LIKE '%#{@activity_type.downcase}%'")
        @act_type.each { |act_type| activity_str << ",'#{act_type.assigned_code}'" } if @act_type.exists?
        final_act_str = "(#{activity_str})"
        @entity_divisi = EntityDivision.where("activity_type_code IN #{final_act_str}")
        @entity_divisi.each { |entity_div| div_str << ",'#{entity_div.assigned_code}'" } if @entity_divisi.exists?
        f_div_str = "(#{div_str})"
        logger.info "Final Act Str :: #{f_div_str.inspect}"
        search_arr << "entity_div_code IN #{f_div_str}"
      end


      if @lov_name.present?
        #lov_str = "'0'"
        ##pay_lov_str = "'0'"
        #@div_lov = DivisionActivityLov.where("LOWER(lov_desc) LIKE '%#{@lov_name.downcase}%'")
        #@div_lov.each { |div_lov| lov_str << ",'#{div_lov.id}'" } if @div_lov.exists?
        #final_lov_str = "(#{lov_str})"
        ##@entity_divisi = EntityDivision.where("activity_type_code IN #{final_lov_str}")
        ##@entity_divisi.each { |entity_div| pay_lov_str << ",'#{entity_div.assigned_code}'" } if @entity_divisi.exists?
        ##f_lov_str = "(#{pay_lov_str})"
        #logger.info "Final Lov Str :: #{final_lov_str.inspect}"
        #search_arr << "activity_lov_id IN #{final_lov_str}"
        search_arr << "activity_lov_id = #{@lov_name}"
      end



      if @cust_num.present?
        search_arr << "customer_number LIKE '%#{@cust_num}%'"
      end

      if @trans_id.present?
        search_arr << "processing_id LIKE '%#{@trans_id}%'"
      end

      if @nw.present?
        search_arr << "LOWER(nw) LIKE '%#{@nw.downcase}%'"
      end

      if @status.present?
        if @status == "NIL"
          search_arr << "trans_status IS NULL"
          #search_arr << "split_part(trans_status, '/', 1) = '000'"
        else
          search_arr << "split_part(trans_status, '/', 1) = '#{@status}'"
        end
      else
        #search_arr << "split_part(trans_status, '/', 1) = '000'"
      end


      if @start_date.present? && @end_date.present?
        f_start_date =  @start_date.to_date.strftime('%Y-%m-%d') # Date.strptime(@start_date, '%m/%d/%Y') # @start_date.to_date.strftime('%Y-%m-%d')
        f_end_date = @end_date.to_date.strftime('%Y-%m-%d') # Date.strptime(@end_date, '%m/%d/%Y') # @end_date.to_date.strftime('%Y-%m-%d')
        if f_start_date <= f_end_date
          search_arr << "created_at BETWEEN '#{f_start_date} 00:00:00' AND '#{f_end_date} 23:59:59'"
        end
      end
      logger.info "Values :: #{filter_params.inspect}"
    else
      #logger.info "====================================================================="
      #logger.info "ALL SHALL PASS......"
      #search_arr << "split_part(trans_status, '/', 1) = '000'"
    end
    logger.info "====================================================================="
    logger.info "A DOWNLOAD DISPLAY string :: #{params["a_download"].inspect} and symbol :: #{params[:a_download].inspect}"
    if params[:filter_main].present?
      logger.info "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
      logger.info "WHEN THERE IS FILTER, THE RESULT SHOULD BE ALL STATUSES UNLESS STATED OTHERWISE......"
    else

      logger.info "====================================================================="
      logger.info "WHEN THERE IS NO FILTER, THE RESULT SHOULD BE ONLY SUCCESSES......"
      if params["a_download"] == "a_download"
        logger.info "====================================================================="
        logger.info "There is a download after filtering. ==============================="
      else
        logger.info "====================================================================="
        logger.info "There is a download without any filtering. =========================="
        search_arr << "split_part(trans_status, '/', 1) = '000'"
      end
    end

    the_search = search_arr.join(" AND ")

    #@reports = Report.where(the_search).paginate(:page => page, :per_page => params[:count]).order(date: :desc)

    logger.info "The search array :: #{search_arr.inspect}"
    logger.info "The Search :: #{the_search.inspect}"

    if current_user.super_admin? || current_user.super_user?
      @merchant_search = EntityInfo.where(active_status: true).order(entity_name: :asc)
      @merchant_service_search = EntityDivision.where(active_status: true).order(division_name: :asc)
      @division_lovs = DivisionActivityLov.where(active_status: true).order(lov_desc: :asc)
      if params[:count] == "All"
        @payment_infos = PaymentReport.where(the_search).paginate(:page => params[:page], :per_page => 100000000000).order('created_at desc')
      else
        @payment_infos = PaymentReport.where(the_search).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      end
    elsif current_user.merchant_admin?
      @merchant_service_search = EntityDivision.where(active_status: true, entity_code: current_user.entity_code).order(division_name: :asc)
      entity_div_id_str = "'0'"
      @entity_divs = EntityDivision.where(entity_code: current_user.entity_code)
      @entity_divs.each do |entity_div|
        entity_div_id_str << ",'#{entity_div.assigned_code}'"
      end
      final_div_ids = "(#{entity_div_id_str})"
      @division_lovs = DivisionActivityLov.where("active_status = true AND division_code IN #{final_div_ids}").order(lov_desc: :asc)

      if params[:count] == "All"
        @payment_infos = PaymentReport.where("entity_div_code IN #{final_div_ids}").where(the_search).paginate(:page => params[:page], :per_page => 100000000000).order('created_at desc')
      else
        @payment_infos = PaymentReport.where("entity_div_code IN #{final_div_ids}").where(the_search).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      end
    elsif current_user.merchant_service?
      @division_lovs = DivisionActivityLov.where("active_status = true AND division_code = '#{current_user.division_code}'").order(lov_desc: :asc)
      if params[:count] == "All"
        @payment_infos = PaymentReport.where(entity_div_code: current_user.division_code).where(the_search).paginate(:page => params[:page], :per_page => 100000000000).order('created_at desc')
      else
        @payment_infos = PaymentReport.where(entity_div_code: current_user.division_code).where(the_search).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      end
    end

    respond_to do |format|
      format.js
      format.csv { send_data @payment_infos.to_csv(@payment_infos), :filename => "transaction_report.csv" }
      format.xls { send_data @payment_infos.to_csv(@payment_infos, col_sep: "\t"), :filename => "transaction_report.xls" }
      #format.pdf do
      #  pdf = GeneralReportPdf.new(@payment_infos, @report_variable, logger, :page_size => "A4", :page_layout => :landscape, top_margin: 50)
      #  send_data pdf.render, filename: 'general_report.pdf', type: 'application/pdf'
      #end
    end

    #logger.info "Report #{@payment_infos.inspect}"
  end


  def resend_form
    @pay_info = PaymentReport.where(id: @payment_report.id).order(created_at: :desc).first
    @payment_info = PaymentInfo.where(id: @payment_report.id).order(created_at: :desc).first
    @recipient_mail = ""
    @copy_email = ""
    logger.info "Resend Payment Info :: #{@pay_info.inspect}"
    logger.info "Resend Cust number :: #{@pay_info.customer_number.inspect}"
  end



  def transaction_resend
    #if params != nil
    #  logger.info "Params object :: #{params.inspect}"
    #  params = params.permit([:payment_info]).to_h#.except(:payment_info)
    #end
    #logger.info "Params without payment_info key :: #{params.inspect}"


    @pay_info = PaymentReport.where(id: @payment_report.id).order(created_at: :desc).first
    @recipient_mail = payment_info_params[:recipient_mail]
    @copy_email = payment_info_params[:copy_email]
    logger.info "Pay parameters:: recipient mail:: #{@recipient_mail.inspect} and Copy email :: #{@copy_email.inspect}"
    logger.info "Payment ID :: #{params[:payment_id].inspect}"
    endpoint = '/resend_cust_code'

    #@merchant_service = EntityDivision.where(active_status: true, assigned_code: @payment_report.entity_div_code).order(created_at: :desc).first
    #logger.info "Merchant Service :: #{@merchant_service.inspect}"
    #if @merchant_service
    #  entity_wallet_config = EntityWalletConfig.where(entity_code: @merchant_service.entity_code, service_id: @payment_report.service_id,
    #                                                  activity_type_code: @merchant_service.activity_type_code, active_status: true)
    #                             .order(created_at: :desc).first
    #  logger.info "Wallet Config:: #{entity_wallet_config.inspect}"
    #  if entity_wallet_config
    #    logger.info "Passed ============="
    #    _secret_key = entity_wallet_config.secret_key
    #    _client_key = entity_wallet_config.client_key
    #  else
    #    logger.info "Wallet Failed =============="
    #    _secret_key = ""
    #    _client_key = ""
    #  end
    #else
    #  logger.info "Failed ================="
    #  _secret_key = ""
    #  _client_key = ""
    #end

    @payment_info = PaymentInfo.new(id: @payment_report.id, recipient_mail: payment_info_params[:recipient_mail], copy_email: payment_info_params[:copy_email])
    if @payment_info.valid?
      payload = {:payment_info_id => @payment_report.id, :recipient_email => payment_info_params[:recipient_mail],
                 :copy_email => payment_info_params[:copy_email]}
      json_payload=JSON.generate(payload)
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
            #payment_info_index
            flash.now[:notice] = "Resend was successful."
            respond_to do |format|
              format.js { render :resend_show }
            end
          else
            #payment_info_index
            flash.now[:danger] = "Sorry, resend failed. Kindly try again."
            respond_to do |format|
              format.js { render :resend_form }
            end
          end
        else
          #payment_info_index
          lgger.info "Not a Valid JSON ==============="
          flash.now[:danger] = "Sorry, There was an issue. Kindly check and try again."
          respond_to do |format|
            format.js { render :resend_form }
          end
        end
      rescue Faraday::SSLError
        #payment_info_index
        logger.info "SSL Error ==============="
        flash.now[:danger] = "Sorry, There was an issue. Kindly check and try again."
        respond_to do |format|
          format.js { render :resend_form }
        end
      rescue Faraday::TimeoutError
        #payment_info_index
        logger.info "Timeout Error ================="
        flash.now[:danger] = "Sorry, There was a timeout issue. Kindly check and try again."
        respond_to do |format|
          format.js { render :resend_form }
        end
      rescue Faraday::Error::ConnectionFailed => e
        #payment_info_index
        logger.info "Connection Failed ================"
        logger.info "Error message :: #{e} ==================="
        flash.now[:danger] = "Sorry, There was a connection issue. Kindly check and try again."
        respond_to do |format|
          format.js { render :resend_form }
        end
      end
    else

      #payment_info_index
      if @payment_info.errors.messages.key?(:recipient_mail) && @payment_info.errors.messages.key?(:copy_email)
        logger.info "First Phase"
        if @payment_info.errors.messages[:recipient_mail][0].present? && @payment_info.errors.messages[:copy_email][0].present?
          flash.now[:danger] = "Failed Validation: Recipient email #{@payment_info.errors.messages[:recipient_mail][0]} and Copy email #{@payment_info.errors.messages[:copy_email][0]}"
        else
          flash.now[:danger] = "Failed Validation."
        end

      else
        logger.info "Second Phase"
        if @payment_info.errors.messages.key?(:recipient_mail)
          flash.now[:danger] = "Failed Validation: Recipient email #{@payment_info.errors.messages[:recipient_mail][0]}"
        elsif @payment_info.errors.messages.key?(:copy_email)
          flash.now[:danger] = "Failed Validation: Copy email #{@payment_info.errors.messages[:copy_email][0]}"
        else
          flash.now[:danger] = "Failed Validation.."
        end
      end
      logger.info "Error messages :: #{@payment_info.errors.messages.inspect}"
      @pay_info = PaymentReport.where(id: @payment_report.id).order(created_at: :desc).first
      @payment_info = PaymentInfo.new(id: @payment_report.id, recipient_mail: payment_info_params[:recipient_mail], copy_email: payment_info_params[:copy_email])
      #@payment_info.valid?
      respond_to do |format|
        format.js { render :resend_form }
      end
    end



  end


  # GET /payment_infos/1
  # GET /payment_infos/1.json
  def show
    @pay_info = PaymentReport.where(id: @payment_report.id).order(created_at: :desc).first
    logger.info "Payment Info :: #{@pay_info.inspect}"
    logger.info "Cust number :: #{@pay_info.customer_number.inspect}"
  end

  def resend_show
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
      if @payment_info.valid?
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
      if @payment_info.valid? #update(payment_info_params)
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
    #@payment_info.destroy
    respond_to do |format|
      format.html { redirect_to payment_infos_url, notice: 'Payment info was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_info
      @payment_info = PaymentInfo.find(params[:id])
      @payment_report = PaymentReport.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_info_params
      params.require(:payment_info).permit(:session_id, :entity_div_code, :activity_lov_id, :activity_div_id, :pay_id,
                                           :activity_sub_div_id, :processed, :src, :payment_mode, :amount,
                                           :customer_number, :trans_type, :charge, :active_status, :del_status,
                                           :user_id, :copy_email, :recipient_mail)
    end
end
