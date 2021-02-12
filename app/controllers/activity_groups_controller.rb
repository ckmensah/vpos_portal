class ActivityGroupsController < ApplicationController
  before_action :set_activity_group, only: [:show, :edit, :update, :destroy]

  # GET /activity_groups
  # GET /activity_groups.json
  def index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    @activity_groups = ActivityGroup.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
  end

  def activity_group_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    @activity_groups = ActivityGroup.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
  end

  # GET /activity_groups/1
  # GET /activity_groups/1.json
  def show
  end

  # GET /activity_groups/new
  def new
    @activity_group = ActivityGroup.new
  end

  # GET /activity_groups/1/edit
  def edit
  end

  # POST /activity_groups
  # POST /activity_groups.json
  def create
    @activity_group = ActivityGroup.new(activity_group_params)

    respond_to do |format|
      if @activity_group.save
        flash.now[:notice] = "Activity Group was successfully created."
        format.js { render :show}
      else
        format.js { render :new}
      end
    end
  end

  # PATCH/PUT /activity_groups/1
  # PATCH/PUT /activity_groups/1.json
  def update
    respond_to do |format|
      if @activity_group.update(activity_group_params)
        flash.now[:danger] = "Activity group was successfully updated."
        format.js { render :show}
      else
        format.js { render :edit}
      end
    end
  end

  # DELETE /activity_groups/1
  # DELETE /activity_groups/1.json
  def destroy
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    if @activity_group.active_status
      @activity_group.active_status = false
      @activity_group.save(validate: false)
      @activity_groups = ActivityGroup.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        flash.now[:note] = 'Activity Group was successfully disabled.'
        format.js { render :layout => false}
      end

    else
      @activity_group.active_status = true
      @activity_group.save(validate: false)
      @activity_groups = ActivityGroup.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        flash.now[:notice] = 'Activity Group was successfully enabled.'
        format.js { render :layout => false }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_group
      @activity_group = ActivityGroup.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def activity_group_params
      params.require(:activity_group).permit(:assigned_code, :activity_group_desc, :active_status, :del_status, :user_id)
    end
end
