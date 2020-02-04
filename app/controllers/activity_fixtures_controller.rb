class ActivityFixturesController < ApplicationController
  before_action :set_activity_fixture, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :load_permissions
  # GET /activity_fixtures
  # GET /activity_fixtures.json
  def index
    #@activity_fixtures = ActivityFixture.all
  end

  def activity_fixture_index
    params[:count] ? params[:count] : params[:count] = 10
    params[:page] ? params[:page] : params[:page] = 1
    @entity_info = EntityInfo.where(assigned_code: params[:entity_code], active_status: true, del_status: false).order(created_at: :desc).first
    @entity_info ? @entity_name = "#{@entity_info.entity_name} (#{@entity_info.entity_alias})" : ""
    @activity_fixtures = ActivityFixture.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
  end

  # GET /activity_fixtures/1
  # GET /activity_fixtures/1.json
  def show
  end

  # GET /activity_fixtures/new
  def new
    @activity_fixture = ActivityFixture.new
    @activity_category_divs = ActivityCategoryDiv.where(active_status: true, division_code: params[:code]).order(category_div_desc: :asc)
    @activity_participants = ActivityParticipant.where(active_status: true, division_code: params[:code]).order(participant_name: :asc)
  end

  # GET /activity_fixtures/1/edit
  def edit
    @activity_category_divs = ActivityCategoryDiv.where(active_status: true, division_code: params[:code]).order(category_div_desc: :asc)
    @activity_participants = ActivityParticipant.where(active_status: true, division_code: params[:code]).order(participant_name: :asc)
  end

  # POST /activity_fixtures
  # POST /activity_fixtures.json
  def create
    @activity_fixture = ActivityFixture.new(activity_fixture_params)
    @activity_category_divs = ActivityCategoryDiv.where(active_status: true, division_code: params[:code]).order(category_div_desc: :asc)
    @activity_participants = ActivityParticipant.where(active_status: true, division_code: params[:code]).order(participant_name: :asc)

    respond_to do |format|
      if @activity_fixture.save
        flash.now[:notice] = "Activity fixture was successfully created."
        format.js { render :show }
        format.html { redirect_to @activity_fixture, notice: 'Activity fixture was successfully created.' }
        format.json { render :show, status: :created, location: @activity_fixture }
      else
        format.js { render :new }
        format.html { render :new }
        format.json { render json: @activity_fixture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activity_fixtures/1
  # PATCH/PUT /activity_fixtures/1.json
  def update
    @activity_participants = ActivityParticipant.where(active_status: true, division_code: params[:code]).order(participant_name: :asc)
    @activity_category_divs = ActivityCategoryDiv.where(active_status: true, division_code: params[:code]).order(category_div_desc: :asc)
    respond_to do |format|
      if @activity_fixture.update(activity_fixture_params)
        flash.now[:notice] = "Activity fixture was successfully updated."
        format.js { render :show }
        format.html { redirect_to @activity_fixture, notice: 'Activity fixture was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity_fixture }
      else
        format.js { render :edit }
        format.html { render :edit }
        format.json { render json: @activity_fixture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_fixtures/1
  # DELETE /activity_fixtures/1.json
  def destroy

    params[:count] ? params[:count] : params[:count] = 10
    params[:page] ? params[:page] : params[:page] = 1
    if @activity_fixture.active_status
      @activity_fixture.active_status = false
      @activity_fixture.save(validate: false)
      @activity_fixtures = ActivityFixture.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to activity_types_url, notice: 'Occupation master was successfully disabled.' }
        flash.now[:note] = 'Activity Fixture was successfully disabled.'
        format.js { render :layout => false}
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end

    else
      @activity_fixture.active_status = true
      @activity_fixture.save(validate: false)
      @activity_fixtures = ActivityFixture.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to activity_types_url, notice: 'Allergy master was successfully enabled.' }
        flash.now[:notice] = 'Activity Fixture was successfully enabled.'
        format.js { render :layout => false }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_fixture
      @activity_fixture = ActivityFixture.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_fixture_params
      params.require(:activity_fixture).permit(:division_code, :activity_participant_a, :activity_participant_b,  :comment, :active_status, :del_status, :user_id)
    end
end
