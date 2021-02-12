class ActivitySubDivClassesController < ApplicationController
  before_action :set_activity_sub_div_class, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :load_permissions

  # GET /activity_sub_div_classes
  # GET /activity_sub_div_classes.json
  def index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    params[:count1] ? params[:count1] : params[:count1] = 50
    params[:page1] ? params[:page1] : params[:page1] = 1

    params[:count4] ? params[:count4] : params[:count4] = 50
    params[:page4] ? params[:page4] : params[:page4] = 1


    @entity_div_name = EntityDivision.where(assigned_code: params[:code], active_status: true).order(created_at: :desc).first
    @entity_div_name = @entity_div_name ? "#{@entity_div_name.division_name} (#{@entity_div_name.division_alias})" : ""
    @activity_sub_div_classes = ActivitySubDivClass.where(entity_div_code: params[:code], del_status: false).paginate(:page => params[:page], :per_page => params[:count4]).order('created_at desc')
  end

  # GET /activity_sub_div_classes/1
  # GET /activity_sub_div_classes/1.json
  def show
  end

  # GET /activity_sub_div_classes/new
  def new
    @activity_sub_div_class = ActivitySubDivClass.new
    @activity_groups = ActivityGroup.where(active_status: true, del_status: false).order(activity_group_desc: :asc)
  end

  # GET /activity_sub_div_classes/1/edit
  def edit
    @activity_groups = ActivityGroup.where(active_status: true, del_status: false).order(activity_group_desc: :asc)
  end

  def classification_update
    logger.info "Params:: #{params[:id_act_group].inspect}"
    @classification_update_ticket = [["", ""]].insert(0,['Please select tickets', ""])
    if params[:id_act_group].empty?
      # @region_update_city = [["", ""]]
      @act_group_update_ticket = [["", ""]].insert(0,['Please select ticket type', ""])
    else
      info_id_record = ActivityGroup.find(params[:id_act_group])
      if info_id_record.activity_sub_div_classes != nil
        act_group_update_ticket = info_id_record.activity_sub_div_classes.where(active_status: true, entity_div_code: params[:div_code]).order(class_desc: :asc).map { |a| [a.class_desc, a.id] }.insert(0,['Please select ticket type', ""])
        act_group_update_ticket.empty? ? @act_group_update_ticket = [["", ""]].insert(0,['Please select ticket type', ""]) : @act_group_update_ticket = act_group_update_ticket
      else
        @act_group_update_ticket = [["", ""]].insert(0,['Please select ticket type', ""])
      end
    end
    logger.info "For Classes :: #{@act_group_update_ticket.inspect}"
  end

  def ticket_update
    logger.info "Params:: classification id: #{params[:id_classification].inspect} AND activity div id: #{params[:act_div_id].inspect}"
    if params[:id_classification].empty?
      # @region_update_city = [["", ""]]
      @classification_update_ticket = [["", ""]].insert(0,['Please select tickets', ""])
    else
      class_id_record = ActivitySubDivClass.find(params[:id_classification])
      classification_update_ticket = class_id_record.activity_sub_divs.where(active_status: true, activity_div_id: params[:act_div_id]).order(classification: :asc).map { |a| ["#{a.activity_sub_div_class.class_desc} (#{a.activity_time.strftime('%H:%M:%S')} - GHC #{a.amount})", a.id] }.insert(0,['Please select tickets', ""])
      classification_update_ticket.empty? ? @classification_update_ticket = [["", ""]].insert(0,['Please select tickets', ""]) : @classification_update_ticket = classification_update_ticket
    end
    logger.info "For TICKETS :: #{@classification_update_ticket.inspect}"
  end

  # POST /activity_sub_div_classes
  # POST /activity_sub_div_classes.json
  def create
    @activity_sub_div_class = ActivitySubDivClass.new(activity_sub_div_class_params)
    @activity_groups = ActivityGroup.where(active_status: true, del_status: false).order(activity_group_desc: :asc)
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    @entity_info = EntityInfo.where(assigned_code: params[:entity_code], active_status: true, del_status: false).order(created_at: :desc).first
    @entity_info ? @entity_name = "#{@entity_info.entity_name} (#{@entity_info.entity_alias})" : ""
    @entity_divisions = EntityDivision.where(entity_code: params[:entity_code], del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

    valid_result = ActivitySubDivClass.validate_classes(@activity_sub_div_class)
    respond_to do |format|
      if valid_result
        ActivitySubDivClass.save_classes(@activity_sub_div_class)
        format.html { redirect_to @activity_sub_div_class, notice: 'Activity sub div class was successfully created.' }
        format.json { render :show, status: :created, location: @activity_sub_div_class }
        flash.now[:notice] = "Ticket Type(s) are successfully created."
        format.js { render :show }
      else
        format.html { render :new }
        format.json { render json: @activity_sub_div_class.errors, status: :unprocessable_entity }
        flash.now[:danger] = "Sorry, you didn't enter any Ticket Type. Try again."
        format.js { render :new }
      end
    end
  end



  # PATCH/PUT /activity_sub_div_classes/1
  # PATCH/PUT /activity_sub_div_classes/1.json
  def update
    @activity_groups = ActivityGroup.where(active_status: true, del_status: false).order(activity_group_desc: :asc)
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    @entity_info = EntityInfo.where(assigned_code: params[:entity_code], active_status: true, del_status: false).order(created_at: :desc).first
    @entity_info ? @entity_name = "#{@entity_info.entity_name} (#{@entity_info.entity_alias})" : ""
    @entity_divisions = EntityDivision.where(entity_code: params[:entity_code], del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

    respond_to do |format|
      if @activity_sub_div_class.update(activity_sub_div_class_params)
        format.html { redirect_to @activity_sub_div_class, notice: 'Activity sub div class was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity_sub_div_class }
        flash.now[:notice] = "Ticket Type(s) are successfully updated."
        format.js { render :show}
      else
        format.html { render :edit }
        format.json { render json: @activity_sub_div_class.errors, status: :unprocessable_entity }
        format.js { render :edit}
      end
    end
  end



  # DELETE /activity_sub_div_classes/1
  # DELETE /activity_sub_div_classes/1.json
  def destroy
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    params[:count1] ? params[:count1] : params[:count1] = 50
    params[:page1] ? params[:page1] : params[:page1] = 1

    params[:count4] ? params[:count4] : params[:count4] = 50
    params[:page4] ? params[:page4] : params[:page4] = 1

    @entity_div_name = EntityDivision.where(assigned_code: params[:code], active_status: true).order(created_at: :desc).first
    @entity_div_name = @entity_div_name ? "#{@entity_div_name.division_name} (#{@entity_div_name.division_alias})" : ""
    if @activity_sub_div_class.active_status
      @activity_sub_div_class.active_status = false
      @activity_sub_div_class.save(validate: false)
      @activity_sub_div_classes = ActivitySubDivClass.where(entity_div_code: params[:code], del_status: false).paginate(:page => params[:page], :per_page => params[:count4]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to activity_types_url, notice: 'Occupation master was successfully disabled.' }
        flash.now[:note] = 'Ticket Type(s) was successfully disabled.'
        format.js { render :layout => false}
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end

    else
      @activity_sub_div_class.active_status = true
      @activity_sub_div_class.save(validate: false)
      @activity_sub_div_classes = ActivitySubDivClass.where(entity_div_code: params[:code], del_status: false).paginate(:page => params[:page], :per_page => params[:count4]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to activity_types_url, notice: 'Allergy master was successfully enabled.' }
        flash.now[:notice] = 'Ticket Type(s) was successfully enabled.'
        format.js { render :layout => false }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_sub_div_class
      @activity_sub_div_class = ActivitySubDivClass.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_sub_div_class_params
      params.require(:activity_sub_div_class).permit(:entity_div_code, :class_desc, :max_num, :activity_group_code, :comment, :active_status, :del_status,
                                                     :user_id, :class_one, :class_two, :class_three, :class_four, :class_five,
                                                     :max_num_one, :max_num_two, :max_num_three, :max_num_four, :max_num_five,
                                                     :act_group_one, :act_group_two, :act_group_three, :act_group_four,
                                                     :act_group_five)
    end
end
