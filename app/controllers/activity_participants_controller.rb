class ActivityParticipantsController < ApplicationController
  before_action :set_activity_participant, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :load_permissions
  # GET /activity_participants
  # GET /activity_participants.json
  def index
    #@activity_participants = ActivityParticipant.all
  end

  def activity_participant_index
    params[:count] ? params[:count] : params[:count] = 10
    params[:page] ? params[:page] : params[:page] = 1

    @entity_info = EntityInfo.where(assigned_code: params[:entity_code], active_status: true, del_status: false).order(created_at: :desc).first
    @entity_info ? @entity_name = "#{@entity_info.entity_name} (#{@entity_info.entity_alias})" : ""

    @activity_participants = ActivityParticipant.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
  end

  # GET /activity_participants/1
  # GET /activity_participants/1.json
  def show
  end

  # GET /activity_participants/new
  def new
    @activity_participant = ActivityParticipant.new
  end

  # GET /activity_participants/1/edit
  def edit
  end

  # POST /activity_participants
  # POST /activity_participants.json
  def create
    #params[:activity_participant][:image].open if activity_participant_params[:image].present?
    logger.info "Result :: #{params[:activity_participant][:image].inspect}"
    @activity_participant = ActivityParticipant.new(activity_participant_params)

    respond_to do |format|
      if @activity_participant.save
        flash.now[:notice] = "Activity participant was succissfully created."
        format.js { render :show}
        format.html { redirect_to @activity_participant, notice: 'Activity participant was successfully created.' }
        format.json { render :show, status: :created, location: @activity_participant }
      else
        logger.info "Error messages:: #{@activity_participant.errors.messages.inspect}"
        format.js { render :new }
        format.html { render :new }
        format.json { render json: @activity_participant.errors, status: :unprocessable_entity }
      end
    end

  end

  # PATCH/PUT /activity_participants/1
  # PATCH/PUT /activity_participants/1.json
  def update
    #params[:activity_participant][:image].open if activity_participant_params[:image].present?
    respond_to do |format|
      if @activity_participant.update(activity_participant_params)
        flash.now[:notice] = "Activity participant was successfully updated."
        format.js { render :show }
        format.html { redirect_to @activity_participant, notice: 'Activity participant was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity_participant }
      else
        logger.info "Error messages :: #{@activity_participant.errors.messages.inspect}"
        format.js { render :edit }
        format.html { render :edit }
        format.json { render json: @activity_participant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_participants/1
  # DELETE /activity_participants/1.json
  def destroy
    params[:count] ? params[:count] : params[:count] = 10
    params[:page] ? params[:page] : params[:page] = 1

    if @activity_participant.active_status
      @activity_participant.active_status = false
      @activity_participant.save(validate: false)
      @activity_participants = ActivityParticipant.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to activity_types_url, notice: 'Occupation master was successfully disabled.' }
        flash.now[:note] = 'Activity Participant was successfully disabled.'
        format.js { render :layout => false}
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end

    else
      @activity_participant.active_status = true
      @activity_participant.save(validate: false)
      @activity_participants = ActivityParticipant.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to activity_types_url, notice: 'Allergy master was successfully enabled.' }
        flash.now[:notice] = 'Activity Participant was successfully enabled.'
        format.js { render :layout => false }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_participant
      @activity_participant = ActivityParticipant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_participant_params
      params.require(:activity_participant).permit(:assigned_code, :division_code, :participant_name, :participant_alias, :image, :image_path, :comment, :active_status, :del_status, :user_id)
    end
end
