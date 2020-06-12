class EntityDivAlertRecipientsController < ApplicationController
  before_action :set_entity_div_alert_recipient, only: [:show, :edit, :update, :destroy]

  # GET /entity_div_alert_recipients
  # GET /entity_div_alert_recipients.json
  def index

    #params[:count] ? params[:count] : params[:count] = 50
    #params[:page].present? ? page = params[:page].to_i : page = 1
    #
    #@entity_div_alert_recipients = EntityDivAlertRecipient.where(entity_division_code: params[:code], del_status: false).paginate(:page => page, :per_page => params[:count]).order(created_at: :desc)

  end

  def entity_div_alert_recipient_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1
    params[:page].present? ? page = params[:page].to_i : page = 1

    params[:count1] ? params[:count1] : params[:count1] = 50
    params[:page1] ? params[:page1] : params[:page1] = 1

    params[:count6] ? params[:count6] : params[:count6] = 50
    params[:page6] ? params[:page6] : params[:page6] = 1


    @entity_div_alert_recipients = EntityDivAlertRecipient.where(entity_div_code: params[:code], del_status: false).paginate(:page => params[:page], :per_page => params[:count6]).order(created_at: :desc)

  end

  # GET /entity_div_alert_recipients/1
  # GET /entity_div_alert_recipients/1.json
  def show
    @for_alert_update = false
  end

  # GET /entity_div_alert_recipients/new
  def new
    @entity_div_alert_recipient = EntityDivAlertRecipient.new

    @display = @display.present? ? @display : params[:display_cnt].present? ? params[:display_cnt].to_i : 0
    params[:into_create] = params[:entity_div_alert_recipients].nil? ? "into_create" : ""
  end

  # GET /entity_div_alert_recipients/1/edit
  def edit
  end

  # POST /entity_div_alert_recipients
  # POST /entity_div_alert_recipients.json

  def create
    @entity_div_alert_recipient = EntityDivAlertRecipient.new(entity_div_alert_recipient_params)
    @entity_div_alert_recipient_params = entity_div_alert_recipient_params
    @display = params[:entity_div_alert_recipients]
    @display_length = params[:display_cnt]

    validity_result, div_num, not_empty, valid_mobile_num, existing_mob_num, duplicate_mob_num = EntityDivAlertRecipient.validate_alert_recipients(@display, entity_div_alert_recipient_params)
    logger.info "Validity result is :: #{validity_result.inspect} and division number is :: #{div_num.inspect} and NotEmpty is :: #{not_empty.inspect} and Valid mobile Number is :: #{valid_mobile_num.inspect}"

    respond_to do |format|

      if validity_result
        logger.info "I WAS HERE SOME...."
        EntityDivAlertRecipient.save_alert_recipients(@display, entity_div_alert_recipient_params, current_user)
        format.html { redirect_to @entity_div_alert_recipient, notice: 'Entity division was successfully created.' }
        flash.now[:notice] = "Merchant Recipient was successfully created."
        format.js { render :show}
        format.json { render :show, status: :ok, location: @entity_div_alert_recipient }
      else

        if params[:display_cnt] == nil || params[:display_cnt] == 0
          if div_num == 0
            if not_empty
              if valid_mobile_num
                #flash.now[:danger] = existing_mob_num ? "Sorry the mobile number at number #{div_num} already exist." : "Kindly enter the number to whitelist."
                if existing_mob_num
                  flash.now[:danger] = "Sorry the mobile number at number #{div_num} already exist."
                else
                  flash.now[:danger] = duplicate_mob_num ? "Please there are duplicates of the mobile number at number #{div_num}" : "Kindly enter the number to whitelist."
                end
              else
                flash.now[:danger] = "Kindly enter a correct mobile number at number #{div_num}."
              end
            else
              flash.now[:danger] = "You haven't entered anything yet. Please try again."
            end
          else
            if not_empty
              if valid_mobile_num
                #flash.now[:danger] = existing_mob_num ? "Sorry the mobile number at number #{div_num} already exist." : "Please ensure that every field has been filled at number #{div_num}."
                if existing_mob_num
                  flash.now[:danger] = "Sorry the mobile number at number #{div_num} already exist."
                else
                  flash.now[:danger] = duplicate_mob_num ? "Please there are duplicates of the mobile number at number #{div_num}" : "Please ensure that every field has been filled at number #{div_num}."
                end
              else
                flash.now[:danger] = "Kindly enter a correct mobile number at number #{div_num}."
              end
            else
              flash.now[:danger] = "You haven't entered anything yet. Please try again."
            end
          end
        else
          if valid_mobile_num
            if existing_mob_num
              flash.now[:danger] = "Sorry the mobile number at number #{div_num} already exist."
            else
              if div_num == 0
                flash.now[:danger] = "You haven't entered anything yet. Please try again."
              else
                flash.now[:danger] = duplicate_mob_num ? "Please there are duplicates of the mobile number at number #{div_num}" : "Pleasee ensure that every field has been filled at number #{div_num}."
              end
            end
          else
            flash.now[:danger] = "Kindly enter a correct mobile number at number #{div_num}."
          end
        end

        format.html { render :new }
        format.js { render :new }
        format.json { render json: @entity_div_alert_recipient.errors, status: :unprocessable_entity }
      end

    end

  end


  # PATCH/PUT /entity_div_alert_recipients/1
  # PATCH/PUT /entity_div_alert_recipients/1.json

  def update
    #mobile_num = break_number(value["mobile_number"])
    @entity_div_alert_recipient_old = @entity_div_alert_recipient
    @new_record = EntityDivAlertRecipient.new(entity_div_alert_recipient_params)
    respond_to do |format|
      if @new_record.valid? # @entity_admin_whitelist.update(entity_admin_whitelist_params)
        if @new_record.save
          @entity_div_alert_recipient_params = entity_div_alert_recipient_params
          @for_alert_update = entity_div_alert_recipient_params[:for_alert_update]
          EntityDivAlertRecipient.update_last_but_one("entity_div_alert_recipient","mobile_number", entity_div_alert_recipient_params[:mobile_number], @entity_div_alert_recipient.entity_div_code)
          flash.now[:danger] = "Alert recipient was successfully updated."
          format.html { redirect_to @entity_div_alert_recipient, notice: 'Entity admin whitelist was successfully updated.' }
          format.js { render :show }
          format.json { render :show, status: :ok, location: @entity_div_alert_recipient }
        else
          @entity_div_alert_recipient.update(entity_div_alert_recipient_params)
          logger.info "Error Messages 2 :: #{@entity_div_alert_recipient.errors.messages.inspect}"
          format.html { render :edit }
          format.js { render :edit }
          format.json { render json: @entity_div_alert_recipient.errors, status: :unprocessable_entity }
        end
      else
        #@entity_admin_whitelist = @new_record
        @entity_div_alert_recipient.update(entity_div_alert_recipient_params)
        logger.info "Error Messages 1 :: #{@entity_div_alert_recipient.errors.messages.inspect}"
        format.html { render :edit }
        format.js { render :edit }
        format.json { render json: @entity_div_alert_recipient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entity_div_alert_recipients/1
  # DELETE /entity_div_alert_recipients/1.json

  def destroy
    #puts page = params[:page]
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1
    #params[:page].present? ? page = params[:page].to_i : page = 1

    params[:count1] ? params[:count1] : params[:count1] = 50
    params[:page1] ? params[:page1] : params[:page1] = 1

    params[:count6] ? params[:count6] : params[:count6] = 50
    params[:page6] ? params[:page6] : params[:page6] = 1
    puts "JUST STARTING.................."
    if current_user.merchant_admin?
      params[:entity_code] = current_user.entity_code
    end
    @entity_div_alert_recipient = EntityDivAlertRecipient.where(entity_div_code: params[:code], mobile_number: params[:id], active_status: true, del_status: false).order('id desc').first

    if @entity_div_alert_recipient.active_status && @entity_div_alert_recipient.del_status == false
      recipient_full_name = @entity_div_alert_recipient.recipient_name != nil ? @entity_div_alert_recipient.recipient_name : "Recipient"
      EntityDivAlertRecipient.delete_by_update_onef("entity_div_alert_recipient","mobile_number",@entity_div_alert_recipient.mobile_number, @entity_div_alert_recipient.entity_div_code)


      @entity_div_alert_recipients = EntityDivAlertRecipient.where(entity_div_code: params[:code], del_status: false).paginate(:page => params[:page], :per_page => params[:count6]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to entity_divisions_url, notice: 'Occupation master was successfully disabled.' }
        flash.now[:notice] = "#{recipient_full_name} was successfully deactivated from the Merchant Notifications."
        format.js { render :layout => false}
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end
    elsif @entity_div_alert_recipient.active_status == false && @entity_div_alert_recipient.del_status == false
      #EntityAdminWhitelist.enable_by_update_onet("entity_admin_whitelist","mobile_number",@entity_admin_whitelist.mobile_number, params[:code])
      #@entity_admin_whitelists = EntityAdminWhitelist.where(entity_division_code: params[:code], del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      #
      #respond_to do |format|
      #  format.html { redirect_to entity_infos_url, notice: 'Allergy master was successfully enabled.' }
      #  flash.now[:notice] = 'Merchant Admin Whitelist was successfully enabled.'
      #  format.js { render :layout => false }
      #  format.json { head :no_content }
      #end
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entity_div_alert_recipient
      #@entity_div_alert_recipient = EntityDivAlertRecipient.find(params[:id])
      @entity_div_alert_recipient = EntityDivAlertRecipient.where(entity_div_code: params[:code], mobile_number: params[:id], active_status: true, del_status: false).order('id desc').first
    end

    # Only allow a list of trusted parameters through.
    def entity_div_alert_recipient_params
      params.require(:entity_div_alert_recipient).permit(:entity_div_code, :for_alert_update, :recipient_name, :mobile_number, :alerts, :trans_rpt, :active_status, :del_status, :user_id)
    end

end
