class EntityAdminWhitelistsController < ApplicationController
  before_action :set_entity_admin_whitelist, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :load_permissions
  # GET /entity_admin_whitelists
  # GET /entity_admin_whitelists.json
  def index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page].present? ? page = params[:page].to_i : page = 1

    @entity_admin_whitelists = EntityAdminWhitelist.where(entity_division_code: params[:code], del_status: false).paginate(:page => page, :per_page => params[:count]).order(created_at: :desc)

  end



  def entity_admin_whitelist_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1
    params[:page].present? ? page = params[:page].to_i : page = 1

    params[:count1] ? params[:count1] : params[:count1] = 50
    params[:page1] ? params[:page1] : params[:page1] = 1

    params[:count5] ? params[:count5] : params[:count5] = 50
    params[:page5] ? params[:page5] : params[:page5] = 1

    @entity_admin_whitelists = EntityAdminWhitelist.where(entity_division_code: params[:code], del_status: false).paginate(:page => params[:page], :per_page => params[:count5]).order(created_at: :desc)

  end


  # GET /entity_admin_whitelists/1
  # GET /entity_admin_whitelists/1.json
  def show
  end

  # GET /entity_admin_whitelists/new
  def new
    @entity_admin_whitelist = EntityAdminWhitelist.new

    @display = @display.present? ? @display : params[:display_cnt].present? ? params[:display_cnt].to_i : 0
    params[:into_create] = params[:merchant_admin_whitelists].nil? ? "into_create" : ""

  end

  # GET /entity_admin_whitelists/1/edit
  def edit
  end

  # POST /entity_admin_whitelists
  # POST /entity_admin_whitelists.json
  def create
    @entity_admin_whitelist = EntityAdminWhitelist.new(entity_admin_whitelist_params)
    @entity_admin_whitelist_params = entity_admin_whitelist_params
    @display = params[:merchant_admin_whitelists]
    @display_length = params[:display_cnt]

    validity_result, div_num, not_empty, valid_mobile_num, existing_mob_num = EntityAdminWhitelist.validate_admin_whitelists(@display, entity_admin_whitelist_params)
    logger.info "Validity result is :: #{validity_result.inspect} and division number is :: #{div_num.inspect} and NotEmpty is :: #{not_empty.inspect} and Valid mobile Number is :: #{valid_mobile_num.inspect}"

    respond_to do |format|

      if validity_result
        logger.info "I WAS HERE SOME...."
        EntityAdminWhitelist.save_admin_whitelists(@display, entity_admin_whitelist_params, current_user)
        format.html { redirect_to @entity_division, notice: 'Entity division was successfully created.' }
        flash.now[:notice] = "Merchant Admin Whitelist(s) was successfully created."
        format.js { render :show}
        format.json { render :show, status: :ok, location: @entity_division }
      else

        if params[:display_cnt] == nil || params[:display_cnt] == 0
          if div_num == 0
            if not_empty
              if valid_mobile_num
                flash.now[:danger] = existing_mob_num ? "Sorry the mobile number at number #{div_num} already exist." : "Kindly enter the number to whitelist."
              else
                flash.now[:danger] = "Kindly enter a correct mobile number at number #{div_num}."
              end
            else
              flash.now[:danger] = "You haven't entered anything yet. Please try again."
            end
          else
            if not_empty
              if valid_mobile_num
                flash.now[:danger] = existing_mob_num ? "Sorry the mobile number at number #{div_num} already exist." : "Please ensure that every field has been filled at number #{div_num}."
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
              flash.now[:danger] = div_num == 0 ? "You haven't entered anything yet. Please try again." : "Pleasee ensure that every field has been filled at number #{div_num}."
            end
          else
            flash.now[:danger] = "Kindly enter a correct mobile number at number #{div_num}."
          end
        end
        format.html { render :new }
        format.js { render :new }
        format.json { render json: @entity_division.errors, status: :unprocessable_entity }
      end

    end

  end

  # PATCH/PUT /entity_admin_whitelists/1
  # PATCH/PUT /entity_admin_whitelists/1.json
  def update
    #mobile_num = break_number(value["mobile_number"])
    @entity_admin_whitelist_old = @entity_admin_whitelist
    @new_record = EntityAdminWhitelist.new(entity_admin_whitelist_params)
    respond_to do |format|
      if @new_record.valid? # @entity_admin_whitelist.update(entity_admin_whitelist_params)
        if @new_record.save
          EntityAdminWhitelist.update_last_but_one("entity_admin_whitelist","mobile_number", entity_admin_whitelist_params[:mobile_number], @entity_admin_whitelist.entity_division_code)
          flash.now[:danger] = "Entity admin whitelist was successfully updated."
          format.html { redirect_to @entity_admin_whitelist, notice: 'Entity admin whitelist was successfully updated.' }
          format.js { render :show }
          format.json { render :show, status: :ok, location: @entity_admin_whitelist }
        else
          @entity_admin_whitelist.update(entity_admin_whitelist_params)
          logger.info "Error Messages 2 :: #{@entity_admin_whitelist.errors.messages.inspect}"
          format.html { render :edit }
          format.js { render :edit }
          format.json { render json: @entity_admin_whitelist.errors, status: :unprocessable_entity }
        end
      else
        #@entity_admin_whitelist = @new_record
        @entity_admin_whitelist.update(entity_admin_whitelist_params)
        logger.info "Error Messages 1 :: #{@entity_admin_whitelist.errors.messages.inspect}"
        format.html { render :edit }
        format.js { render :edit }
        format.json { render json: @entity_admin_whitelist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entity_admin_whitelists/1
  # DELETE /entity_admin_whitelists/1.json

  def destroy
    #puts page = params[:page]
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1
    #params[:page].present? ? page = params[:page].to_i : page = 1

    params[:count1] ? params[:count1] : params[:count1] = 50
    params[:page1] ? params[:page1] : params[:page1] = 1

    params[:count5] ? params[:count5] : params[:count5] = 50
    params[:page5] ? params[:page5] : params[:page5] = 1
    puts "JUST STARTING.................."
    if current_user.merchant_admin?
      params[:entity_code] = current_user.user_entity_code
    end
    @entity_admin_whitelist = EntityAdminWhitelist.where(entity_division_code: params[:code], mobile_number: params[:id], active_status: true, del_status: false).order('id desc').first

    if @entity_admin_whitelist.active_status && @entity_admin_whitelist.del_status == false
      EntityAdminWhitelist.delete_by_update_onef("entity_admin_whitelist","mobile_number",@entity_admin_whitelist.mobile_number, @entity_admin_whitelist.entity_division_code)

      @entity_admin_whitelists = EntityAdminWhitelist.where(entity_division_code: params[:code], del_status: false).paginate(:page => params[:page], :per_page => params[:count5]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to entity_divisions_url, notice: 'Occupation master was successfully disabled.' }
        flash.now[:notice] = "#{@entity_admin_whitelist.full_name} was successfully deactivated from the Merchant Admin Whitelist."
        format.js { render :layout => false}
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end
    elsif @entity_admin_whitelist.active_status == false && @entity_admin_whitelist.del_status == false
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
    def set_entity_admin_whitelist
      #@entity_admin_whitelist = EntityAdminWhitelist.find(params[:id])
      @entity_admin_whitelist = EntityAdminWhitelist.where(entity_division_code: params[:code], mobile_number: params[:id], active_status: true, del_status: false).order('id desc').first

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entity_admin_whitelist_params
      params.require(:entity_admin_whitelist).permit(:entity_division_code, :for_whitelist_update, :full_name, :mobile_number, :active_status, :del_status, :user_id)
    end
end
