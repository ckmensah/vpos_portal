class ActivitySubDivClassesController < ApplicationController
  before_action :set_activity_sub_div_class, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :load_permissions

  # GET /activity_sub_div_classes
  # GET /activity_sub_div_classes.json
  def index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    @entity_div_name = EntityDivision.where(assigned_code: params[:code], active_status: true).order(created_at: :desc).first
    @entity_div_name = @entity_div_name ? "#{@entity_div_name.division_name} (#{@entity_div_name.division_alias})" : ""
    @activity_sub_div_classes = ActivitySubDivClass.where(entity_div_code: params[:code], del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
  end

  # GET /activity_sub_div_classes/1
  # GET /activity_sub_div_classes/1.json
  def show
  end

  # GET /activity_sub_div_classes/new
  def new
    @activity_sub_div_class = ActivitySubDivClass.new
  end

  # GET /activity_sub_div_classes/1/edit
  def edit
  end

  # POST /activity_sub_div_classes
  # POST /activity_sub_div_classes.json
  def create
    @activity_sub_div_class = ActivitySubDivClass.new(activity_sub_div_class_params)
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
    @entity_div_name = EntityDivision.where(assigned_code: params[:code], active_status: true).order(created_at: :desc).first
    @entity_div_name = @entity_div_name ? "#{@entity_div_name.division_name} (#{@entity_div_name.division_alias})" : ""
    if @activity_sub_div_class.active_status
      @activity_sub_div_class.active_status = false
      @activity_sub_div_class.save(validate: false)
      @activity_sub_div_classes = ActivitySubDivClass.where(entity_div_code: params[:code], del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
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
      @activity_sub_div_classes = ActivitySubDivClass.where(entity_div_code: params[:code], del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
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
      params.require(:activity_sub_div_class).permit(:entity_div_code, :class_desc, :comment, :active_status, :del_status,
                                                     :user_id, :class_one, :class_two, :class_three, :class_four, :class_five)
    end
end
