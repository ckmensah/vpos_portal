class EntityDivSubActivitiesController < ApplicationController
  before_action :set_entity_div_sub_activity, only: [:show, :edit, :update, :destroy]

  # GET /entity_div_sub_activities
  # GET /entity_div_sub_activities.json
  def index
    @entity_div_sub_activities = EntityDivSubActivity.all
  end

  # GET /entity_div_sub_activities/1
  # GET /entity_div_sub_activities/1.json
  def show
  end

  # GET /entity_div_sub_activities/new
  def new
    @entity_div_sub_activity = EntityDivSubActivity.new
  end

  # GET /entity_div_sub_activities/1/edit
  def edit
  end

  # POST /entity_div_sub_activities
  # POST /entity_div_sub_activities.json
  def create
    @entity_div_sub_activity = EntityDivSubActivity.new(entity_div_sub_activity_params)

    respond_to do |format|
      if @entity_div_sub_activity.save
        format.html { redirect_to @entity_div_sub_activity, notice: 'Entity div sub activity was successfully created.' }
        format.json { render :show, status: :created, location: @entity_div_sub_activity }
      else
        format.html { render :new }
        format.json { render json: @entity_div_sub_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entity_div_sub_activities/1
  # PATCH/PUT /entity_div_sub_activities/1.json
  def update
    respond_to do |format|
      if @entity_div_sub_activity.update(entity_div_sub_activity_params)
        format.html { redirect_to @entity_div_sub_activity, notice: 'Entity div sub activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @entity_div_sub_activity }
      else
        format.html { render :edit }
        format.json { render json: @entity_div_sub_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entity_div_sub_activities/1
  # DELETE /entity_div_sub_activities/1.json
  def destroy
    @entity_div_sub_activity.destroy
    respond_to do |format|
      format.html { redirect_to entity_div_sub_activities_url, notice: 'Entity div sub activity was successfully destroyed.' }
      format.json { head :no_content }
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
