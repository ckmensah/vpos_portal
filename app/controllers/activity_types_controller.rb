class ActivityTypesController < ApplicationController
  before_action :set_activity_type, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :load_permissions
  # GET /activity_types
  # GET /activity_types.json
  def index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    @activity_types = ActivityType.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
  end



  def activity_type_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    @activity_types = ActivityType.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

  end

  # GET /activity_types/1
  # GET /activity_types/1.json
  def show
  end

  # GET /activity_types/new
  def new
    @activity_type = ActivityType.new
  end

  # GET /activity_types/1/edit
  def edit
  end

  # POST /activity_types
  # POST /activity_types.json

  def create
    @activity_type = ActivityType.new(activity_type_params)
    respond_to do |format|
      if @activity_type.save
        format.html { redirect_to @activity_type, notice: 'Activity type was successfully created.' }
        flash.now[:notice] = "Activity type was successfully created."
        format.js { render :show}
        format.json { render :show, status: :created, location: @activity_type }
      else
        format.html { render :new }
        format.js {render :new }
        format.json { render json: @activity_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activity_types/1
  # PATCH/PUT /activity_types/1.json

  def update

    respond_to do |format|
      if @activity_type.update(activity_type_params)
        format.html { redirect_to @activity_type, notice: 'Activity type was successfully updated.' }
        flash.now[:notice] = "Activity type was successfully updated."
        format.js { render :show}
        format.json { render :show, status: :ok, location: @activity_type }
      else
        format.html { render :edit }
        format.js {render :edit }
        format.json { render json: @activity_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_types/1
  # DELETE /activity_types/1.json

  def destroy
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    if @activity_type.active_status
      @activity_type.active_status = false
      @activity_type.save(validate: false)
      @activity_types = ActivityType.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to activity_types_url, notice: 'Occupation master was successfully disabled.' }
        flash.now[:note] = 'Activity type was successfully disabled.'
        format.js { render :layout => false}
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end

    else
      @activity_type.active_status = true
      @activity_type.save(validate: false)
      @activity_types = ActivityType.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to activity_types_url, notice: 'Allergy master was successfully enabled.' }
        flash.now[:notice] = 'Activity type was successfully enabled.'
        format.js { render :layout => false }
        format.json { head :no_content }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_type
      # @activity_type = ActivityType.find(params[:id])
      @activity_type = ActivityType.where(assigned_code: params[:id]).order('id desc').first
      # @activity_type = ActivityType.where(assigned_code: params[:id], active_status: true, del_status: false).order('id desc').first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_type_params
      params.require(:activity_type).permit(:assigned_code, :activity_type_desc, :comment, :active_status, :del_status, :user_id)
    end
end
