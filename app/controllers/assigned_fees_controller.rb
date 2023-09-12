class AssignedFeesController < ApplicationController
  before_action :set_assigned_fee, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :load_permissions
  # GET /assigned_fees
  # GET /assigned_fees.json
  def index
    #@assigned_fees = AssignedFee.all
  end

  def assigned_fee_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    params[:count1] ? params[:count1] : params[:count1] = 50
    params[:page1] ? params[:page1] : params[:page1] = 1

    params[:count2] ? params[:count2] : params[:count2] = 50
    params[:page2] ? params[:page2] : params[:page2] = 1

    if current_user.super_admin? || current_user.super_user?
      @fee_size_obj = AssignedFee.where(active_status: true, entity_div_code: params[:code])
      @assigned_fees = AssignedFee.where(entity_div_code: params[:code], del_status: false).paginate(:page => params[:page], :per_page => params[:count2]).order('created_at desc')
      @services = EntityDivision.where(active_status: true, assigned_code: params[:code]).order(created_at: :desc).first
      @service_name = @services ? @services.division_name : ""
    else
    end
  end

  # GET /assigned_fees/1
  # GET /assigned_fees/1.json
  def show
  end

  # GET /assigned_fees/new
  def new
    @assigned_fee = AssignedFee.new
    charged_to_merchant = AssignedFee.where(entity_div_code: params[:code], charged_to: 'M', active_status: true)
    charged_to_customer = AssignedFee.where(entity_div_code: params[:code], charged_to: 'C', active_status: true)

    @payment_mode = [["MOMO", "MOM"], ["CARD", "CRD"]]

    if charged_to_customer
      if charged_to_customer.size > 1 && charged_to_customer.size == 2
        @charged_to_type = [["Merchant", "M"]]
      elsif charged_to_customer.size < 2 && charged_to_customer.size == 1
        @charged_to_type = [["Merchant", "M"],["Customer", "C"]]
      else
        @charged_to_type = [["Merchant", "M"],["Customer", "C"]]
      end
    elsif charged_to_merchant
      if charged_to_merchant.size > 1 && charged_to_merchant.size == 2
        @charged_to_type = [["Customer", "C"]]
      elsif charged_to_merchant.size < 2 && charged_to_merchant.size == 1
        @charged_to_type = [["Customer", "C"],["Merchant", "M"]]
      else
        @charged_to_type = [["Merchant", "M"],["Customer", "C"]]
      end
    else
      @charged_to_type = [["Merchant", "M"], ["Customer", "C"]]
    end
  end

  # GET /assigned_fees/1/edit
  def edit
    @fee_size_obj = AssignedFee.where(active_status: true, entity_div_code: @assigned_fee.entity_div_code)
    # Reassigning Charged_to to restrict it from duplicates
    @payment_mode = [["MOMO", "MOM"], ["CARD", "CRD"]]

    if @fee_size_obj.exists? && @fee_size_obj.size > 1
      if @assigned_fee.charged_to == 'C'
        @charged_to_type = [["Customer", "C"]]
      elsif @assigned_fee.charged_to == 'M'
        @charged_to_type = [["Merchant", "M"]]
      else
      @charged_to_type = []
      end
    else
      @charged_to_type = [["Merchant", "M"], ["Customer", "C"]]
    end

  end

  # POST /assigned_fees
  # POST /assigned_fees.json
  def create
    @assigned_fee = AssignedFee.new(assigned_fee_params)
    # Renaming Charged_to
    charged_to_merchant = AssignedFee.where(entity_div_code: params[:code], charged_to: 'M', active_status: true)
    charged_to_customer = AssignedFee.where(entity_div_code: params[:code], charged_to: 'C', active_status: true)
    @payment_mode = [["MOMO", "MOM"], ["CARD", "CRD"]]

    if charged_to_customer
      if charged_to_customer.size > 1 && charged_to_customer.size == 2
        @charged_to_type = [["Merchant", "M"]]
      elsif charged_to_customer.size < 2 && charged_to_customer.size == 1
        @charged_to_type = [["Merchant", "M"],["Customer", "C"]]
      else
        @charged_to_type = [["Merchant", "M"],["Customer", "C"]]
      end
    elsif charged_to_merchant
      if charged_to_merchant.size > 1 && charged_to_merchant.size == 2
        @charged_to_type = [["Customer", "C"]]
      elsif charged_to_merchant.size < 2 && charged_to_merchant.size == 1
        @charged_to_type = [["Customer", "C"],["Merchant", "M"]]
      else
        @charged_to_type = [["Merchant", "M"],["Customer", "C"]]
      end
    else
      @charged_to_type = [["Merchant", "M"], ["Customer", "C"]]
    end

    # if charged_to_customer
    #   @charged_to_type = [["Merchant", "M"]]
    # elsif charged_to_merchant
    #   @charged_to_type = [["Customer", "C"]]
    # else
    #   @charged_to_type = [["Merchant", "M"], ["Customer", "C"]]
    # end

    # Conditions to permit multiple charges on either customer or merchant. Also to prevent duplications
    fee_size_obj = AssignedFee.where(active_status: true, entity_div_code: params[:code])
    charged_to_exist = AssignedFee.where(entity_div_code: params[:code], charged_to: assigned_fee_params[:charged_to], active_status: true)
    if assigned_fee_params[:charged_to].present? && fee_size_obj.exists? && fee_size_obj.size > 3 && charged_to_exist && charged_to_exist.size == 2
      charge_type = assigned_fee_params[:charged_to] == 'M' ? 'Merchant' : 'Customer'
      respond_to do |format|
        @assigned_fee.entity_div_code = ""
        @assigned_fee.valid?
        @assigned_fee.errors.add :charged_to, " for #{charge_type} already exist."
        logger.info "Error :: #{@assigned_fee.errors.messages.inspect}"
        format.js { render :new}
      end
    else
      incoming_assigned_fee = @assigned_fee
      unless @assigned_fee.cap.present?
        @assigned_fee.cap = 0.000
      end

      unless @assigned_fee.limit_capped.present?
        @assigned_fee.limit_capped = 0.000
      end

      respond_to do |format|
        @assigned_fee.entity_div_code = params[:code]
        if @assigned_fee.valid?
          @assigned_fee.save
          flash.now[:notice] = "Assigned Fee was successfully created."
          format.js { render :show}
          format.html { redirect_to @assigned_fee, notice: 'Assigned fee was successfully created.' }
          format.json { render :show, status: :created, location: @assigned_fee }
        else
          #@assigned_fee = incoming_assigned_fee
          @assigned_fee.entity_div_code = ""
          @assigned_fee.valid?

          logger.info "Error :: #{@assigned_fee.errors.messages.inspect}"
          format.js { render :new}
          format.html { render :new }
          format.json { render json: @assigned_fee.errors, status: :unprocessable_entity }
        end
      end
    end

  end


  # PATCH/PUT /assigned_fees/1
  # PATCH/PUT /assigned_fees/1.json
  def update
    @new_record = AssignedFee.new(assigned_fee_params)
    @fee_size_obj = AssignedFee.where(active_status: true, entity_div_code: @assigned_fee.entity_div_code)
    # Reassigning Charged_to to restrict it from duplicates
    @payment_mode = [["MOMO", "MOM"], ["CARD", "CRD"]]
    logger.info "Fee size :: #{@fee_size_obj.inspect}"
    @payment_mode = [["MOMO", "MOM"], ["CARD", "CRD"]]
    if @fee_size_obj.exists? && @fee_size_obj.size > 1
      if @assigned_fee.charged_to == 'C'
        @charged_to_type = [["Customer", "C"]]
      elsif @assigned_fee.charged_to == 'M'
        @charged_to_type = [["Merchant", "M"]]
      else
        @charged_to_type = []
      end
    else
      @charged_to_type = [["Merchant", "M"], ["Customer", "C"]]
    end

    respond_to do |format|
      @assigned_fee.fee = assigned_fee_params[:fee]
      @assigned_fee.flat_percent = assigned_fee_params[:flat_percent]
      @assigned_fee.charged_to = assigned_fee_params[:charged_to]
      @assigned_fee.cap = assigned_fee_params[:cap]
      @assigned_fee.limit_capped = assigned_fee_params[:limit_capped]
      #@assigned_fee.entity_div_code = assigned_fee_params[:entity_div_code]
      if @assigned_fee.valid? && @new_record.valid?
        #@assigned_fee.update(assigned_fee_params)
        @new_record.created_at = @assigned_fee.created_at.strftime('%Y-%m-%d %H:%M:%S.%N')
        #@new_record.updated_at = Time.now.strftime('%Y-%m-%d %H:%M:%S.%N')
        if @new_record.save
          AssignedFee.update_last_but_one("assigned_fees", @assigned_fee.id)
          flash.now[:notice] = "Assigned Fee was successfully updated."
          format.js { render :show}
          format.html { redirect_to @assigned_fee, notice: 'Assigned fee was successfully updated.' }
          format.json { render :show, status: :ok, location: @assigned_fee }
        else
          #@assigned_fee.update(assigned_fee_params)
          logger.info "Error messages 2 :: #{@new_record.errors.messages.inspect}"
          flash.now[:notice] = "Fees could not be edit."
          format.js { render :edit }
          format.html { render :edit }
          format.json { render json: @assigned_fee.errors, status: :unprocessable_entity }
        end

      else
        logger.info "Error messages 1 :: #{@new_record.errors.messages.inspect}"
        logger.info "Error messages 3 :: #{@assigned_fee.errors.messages.inspect}"
        #flash.now[:notice] = "Assigned Fee was successfully updated."
        format.js { render :edit }
        format.html { render :edit }
        format.json { render json: @assigned_fee.errors, status: :unprocessable_entity }
      end

    end


    #respond_to do |format|
    #  if @assigned_fee.update(assigned_fee_params)
    #
    #    flash.now[:notice] = "Assigned Fee was successfully updated."
    #    format.js { render :show}
    #    format.html { redirect_to @assigned_fee, notice: 'Assigned fee was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @assigned_fee }
    #  else
    #    format.js { render :edit }
    #    format.html { render :edit }
    #    format.json { render json: @assigned_fee.errors, status: :unprocessable_entity }
    #  end
    #
    #end
  end

  # DELETE /assigned_fees/1
  # DELETE /assigned_fees/1.json
  #
  def destroy
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    params[:count1] ? params[:count1] : params[:count1] = 50
    params[:page1] ? params[:page1] : params[:page1] = 1

    params[:count2] ? params[:count2] : params[:count2] = 50
    params[:page2] ? params[:page2] : params[:page2] = 1

    @services = EntityDivision.where(active_status: true, assigned_code: params[:code]).order(created_at: :desc).first
    @service_name = @services ? @services.division_name : ""

    if @assigned_fee.active_status
      @assigned_fee.active_status = false
      @assigned_fee.del_status = true
      @assigned_fee.save(validate: false)
      @fee_size_obj = AssignedFee.where(active_status: true, entity_div_code: params[:code])
      @assigned_fees = AssignedFee.where(entity_div_code: params[:code], del_status: false).paginate(:page => params[:page], :per_page => params[:count2]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to activity_types_url, notice: 'Occupation master was successfully disabled.' }
        flash.now[:danger] = 'Assigned Fee was successfully disabled.'
        format.js { render :layout => false}
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end

    else
      @fee_size_objs = AssignedFee.where(active_status: true, entity_div_code: @assigned_fee.entity_div_code)
      # Reassigning Charged_to to restrict it from duplicates
      logger.info "Fee size :: #{@fee_size_objs.inspect}"
      if @fee_size_objs.exists? && @fee_size_objs.size > 1
        @fee_size_obj = AssignedFee.where(active_status: true, entity_div_code: params[:code])
        @assigned_fees = AssignedFee.where(entity_div_code: params[:code], del_status: false).paginate(:page => params[:page], :per_page => params[:count2]).order('created_at desc')
        respond_to do |format|
          flash.now[:danger] = 'Sorry, service fee setup has reached the maximum.'
          format.js { render :layout => false }
          format.json { head :no_content }
        end
      else

        @service_fee_charge = AssignedFee.where(active_status: true, entity_div_code: params[:code], charged_to: @assigned_fee.charged_to).order(updated_at: :desc).first
        if @service_fee_charge
          @fee_size_obj = AssignedFee.where(active_status: true, entity_div_code: params[:code])
          @assigned_fees = AssignedFee.where(entity_div_code: params[:code], del_status: false).paginate(:page => params[:page], :per_page => params[:count2]).order('created_at desc')
          respond_to do |format|
            flash.now[:danger] = "Sorry, enabling this service will create duplicates."
            format.js { render :layout => false }
            format.json { head :no_content }
          end
        else
          @assigned_fee.active_status = true
          @assigned_fee.save(validate: false)
          @fee_size_obj = AssignedFee.where(active_status: true, entity_div_code: params[:code])
          @assigned_fees = AssignedFee.where(entity_div_code: params[:code], del_status: false).paginate(:page => params[:page], :per_page => params[:count2]).order('created_at desc')
          respond_to do |format|
            flash.now[:notice] = 'Assigned Fee was successfully enabled.'
            format.js { render :layout => false }
            format.json { head :no_content }
          end
        end

      end
    end
  end

  #def destroy
  #
  #  params[:count] ? params[:count] : params[:count] = 50
  #  params[:page] ? params[:page] : params[:page] = 1
  #
  #  params[:count1] ? params[:count1] : params[:count1] = 50
  #  params[:page1] ? params[:page1] : params[:page1] = 1
  #
  #  params[:count2] ? params[:count2] : params[:count2] = 50
  #  params[:page2] ? params[:page2] : params[:page2] = 1
  #
  #  if @assigned_fee.active_status
  #    @assigned_fee.active_status = false
  #    @assigned_fee.save(validate: false)
  #    @assigned_fees = AssignedFee.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count2]).order('created_at desc')
  #    respond_to do |format|
  #      format.html { redirect_to activity_types_url, notice: 'Occupation master was successfully disabled.' }
  #      flash.now[:note] = 'Assigned Fee was successfully disabled.'
  #      format.js { render :layout => false}
  #      format.json { head :no_content }
  #      # window.location.href = "<%= recipe_path(@recipe) %>"
  #    end
  #
  #  else
  #    @assigned_fee.active_status = true
  #    @assigned_fee.save(validate: false)
  #    @assigned_fees = AssignedFee.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count2]).order('created_at desc')
  #    respond_to do |format|
  #      format.html { redirect_to activity_types_url, notice: 'Allergy master was successfully enabled.' }
  #      flash.now[:notice] = 'Assigned Fee was successfully enabled.'
  #      format.js { render :layout => false }
  #      format.json { head :no_content }
  #    end
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assigned_fee
      @assigned_fee = AssignedFee.find(params[:id])
      #@assigned_fee = AssignedFee.where(entity_div_code: params[:id], active_status: true, del_status: false).order('id desc').first

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assigned_fee_params
      params.require(:assigned_fee).permit(:entity_div_code, :trans_type, :fee, :flat_percent, :cap, :limit_capped, :charged_to, :comment, :active_status, :del_status, :user_id, :payment_mode)
    end
end
