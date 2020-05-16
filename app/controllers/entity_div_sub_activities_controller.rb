class EntityDivSubActivitiesController < ApplicationController
  before_action :set_entity_div_sub_activity, only: [:show, :edit, :update, :destroy]

  # GET /entity_div_sub_activities
  # GET /entity_div_sub_activities.json
  def index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page].present? ? page = params[:page].to_i : page = 1

    @entity_div_sub_activities = EntityDivSubActivity.where(entity_div_code: params[:code], del_status: false).paginate(:page => page, :per_page => params[:count]).order(created_at: :desc)

  end


  def entity_div_sub_activity_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1
    params[:page].present? ? page = params[:page].to_i : page = 1

    params[:count1] ? params[:count1] : params[:count1] = 50
    params[:page1] ? params[:page1] : params[:page1] = 1

    params[:count3] ? params[:count3] : params[:count3] = 50
    params[:page3] ? params[:page3] : params[:page3] = 1

    @entity_div_sub_activities = EntityDivSubActivity.where(entity_div_code: params[:code], del_status: false).paginate(:page => params[:page], :per_page => params[:count3]).order(created_at: :desc)


  end


  # GET /entity_div_sub_activities/1
  # GET /entity_div_sub_activities/1.json
  def show
  end

  # GET /entity_div_sub_activities/new
  def new
    @entity_div_sub_activity = EntityDivSubActivity.new
    @existing_entity_div_sub_act = EntityDivSubActivity.where(active_status: true, entity_div_code: params[:code])

    if @existing_entity_div_sub_act.exists?
      exist_str = "'0'"
      @existing_entity_div_sub_act.each do |existing|
        exist_str << ", '#{existing.sub_activity_code}'"
      end
      final_str = "(#{exist_str})"
      @sub_activity_masters = SubActivityMaster.where("active_status = true AND assigned_code NOT IN #{final_str}").order(activity_desc: :asc)
    else
      @sub_activity_masters = SubActivityMaster.where(active_status: true).order(activity_desc: :asc)
    end
  end

  # GET /entity_div_sub_activities/1/edit
  def edit
    @existing_entity_div_sub_act = EntityDivSubActivity.where("active_status = true AND entity_div_code = '#{params[:code]}' AND sub_activity_code != '#{@entity_div_sub_activity.sub_activity_code}'")

    if @existing_entity_div_sub_act.exists?
      exist_str = "'0'"
      @existing_entity_div_sub_act.each do |existing|
        exist_str << ", '#{existing.sub_activity_code}'"
      end
      final_str = "(#{exist_str})"
      @sub_activity_masters = SubActivityMaster.where("active_status = true AND assigned_code NOT IN #{final_str}").order(activity_desc: :asc)
    else
      @sub_activity_masters = SubActivityMaster.where(active_status: true).order(activity_desc: :asc)
    end
  end

  # POST /entity_div_sub_activities
  # POST /entity_div_sub_activities.json
  def create
    @entity_div_sub_activity = EntityDivSubActivity.new(entity_div_sub_activity_params)

    respond_to do |format|
      if @entity_div_sub_activity.save
        format.html { redirect_to @entity_div_sub_activity, notice: 'Entity div sub activity was successfully created.' }
        flash.now[:notice] = "Activity Code was successfully created."
        format.js { render :show}
        format.json { render :show, status: :created, location: @entity_div_sub_activity }
      else
        @existing_entity_div_sub_act = EntityDivSubActivity.where(active_status: true, entity_div_code: params[:code])

        if @existing_entity_div_sub_act.exists?
          exist_str = "'0'"
          @existing_entity_div_sub_act.each do |existing|
            exist_str << ", '#{existing.sub_activity_code}'"
          end
          final_str = "(#{exist_str})"
          @sub_activity_masters = SubActivityMaster.where("active_status = true AND assigned_code NOT IN #{final_str}").order(activity_desc: :asc)
        else
          @sub_activity_masters = SubActivityMaster.where(active_status: true).order(activity_desc: :asc)
        end
        format.html { render :new }
        format.js { render :new }
        format.json { render json: @entity_div_sub_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entity_div_sub_activities/1
  # PATCH/PUT /entity_div_sub_activities/1.json
  def update
    @existing_entity_div_sub_act = EntityDivSubActivity.where("active_status = true AND entity_div_code = '#{params[:code]}' AND sub_activity_code != '#{@entity_div_sub_activity.sub_activity_code}'")

    if @existing_entity_div_sub_act.exists?
      exist_str = "'0'"
      @existing_entity_div_sub_act.each do |existing|
        exist_str << ", '#{existing.sub_activity_code}'"
      end
      final_str = "(#{exist_str})"
      @sub_activity_masters = SubActivityMaster.where("active_status = true AND assigned_code NOT IN #{final_str}").order(activity_desc: :asc)
    else
      @sub_activity_masters = SubActivityMaster.where(active_status: true).order(activity_desc: :asc)
    end
    respond_to do |format|
      if @entity_div_sub_activity.update(entity_div_sub_activity_params)
        format.html { redirect_to @entity_div_sub_activity, notice: 'Activity Code was successfully updated.' }
        flash.now[:notice] = "Activity code was successfully created."
        format.js { render :show}
        format.json { render :show, status: :ok, location: @entity_div_sub_activity }
      else

        format.html { render :edit }
        format.js { render :edit}
        format.json { render json: @entity_div_sub_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entity_div_sub_activities/1
  # DELETE /entity_div_sub_activities/1.json

  def destroy
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    params[:count1] ? params[:count1] : params[:count1] = 50
    params[:page1] ? params[:page1] : params[:page1] = 1

    params[:count3] ? params[:count3] : params[:count3] = 50
    params[:page3] ? params[:page3] : params[:page3] = 1

    if @entity_div_sub_activity.active_status
      @entity_div_sub_activity.active_status = false
      @entity_div_sub_activity.save(validate: false)
      @entity_div_sub_activities = EntityDivSubActivity.where(entity_div_code: params[:code], del_status: false).paginate(:page => params[:page], :per_page => params[:count3]).order(created_at: :desc)
      respond_to do |format|
        format.html { redirect_to activity_types_url, notice: 'Occupation master was successfully disabled.' }
        flash.now[:note] = 'Activity code was successfully disabled.'
        format.js { render :layout => false}
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end


    else
      @entity_div_sub_activity.active_status = true
      @entity_div_sub_activity.save(validate: false)
      @entity_div_sub_activities = EntityDivSubActivity.where(entity_div_code: params[:code], del_status: false).paginate(:page => params[:page], :per_page => params[:count3]).order(created_at: :desc)
      respond_to do |format|
        format.html { redirect_to activity_types_url, notice: 'Allergy master was successfully enabled.' }
        flash.now[:notice] = 'Activity code was successfully enabled.'
        format.js { render :layout => false }
        format.json { head :no_content }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entity_div_sub_activity
      @entity_div_sub_activity = EntityDivSubActivity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entity_div_sub_activity_params
      params.require(:entity_div_sub_activity).permit(:sub_activity_code, :div_sub_activity_desc, :entity_div_code, :user_id, :active_status, :del_status)
    end
end
