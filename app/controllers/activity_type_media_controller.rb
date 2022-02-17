class ActivityTypeMediaController < ApplicationController
  before_action :set_activity_type_medium, only: [:show, :edit, :inner_destroy, :update, :destroy]

  require 'vpos_core'
  # GET /entity_div_media
  # GET /entity_div_media.json
  def index
    #@entity_div_media = ActivityTypeMedium.all
  end

  def activity_type_media_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1
    params[:page].present? ? page = params[:page].to_i : page = 1

    params[:count1] ? params[:count1] : params[:count1] = 50
    params[:page1] ? params[:page1] : params[:page1] = 1

    params[:count5] ? params[:count5] : params[:count5] = 50
    params[:page5] ? params[:page5] : params[:page5] = 1

    @image_media = ActivityTypeMedium.where(activity_type_code: params[:code], media_type: "IMG", del_status: false).order(created_at: :desc)
    @video_media = ActivityTypeMedium.where(activity_type_code: params[:code], media_type: "VID", del_status: false).order(created_at: :desc)
    #@entity_div_media = ActivityTypeMedium.where(activity_type_code: params[:code], del_status: false).paginate(:page => params[:page], :per_page => params[:count5]).order(created_at: :desc)

  end


  def image_media
    @image_media = ActivityTypeMedium.where(activity_type_code: params[:code], media_type: "IMG", del_status: false).order(created_at: :desc)
  end


  def video_media
    @video_media = ActivityTypeMedium.where(activity_type_code: params[:code], media_type: "VID", del_status: false).order(created_at: :desc)
  end


  # GET /entity_div_media/1
  # GET /entity_div_media/1.json
  def show
  end


  # GET /entity_div_media/new
  def inner_new
    @activity_type_medium = ActivityTypeMedium.new
    @media_types = [["Videos", "VID"], ["Images", "IMG"]]
    @data_media = ""
    @data_media_vid = ""
  end

  def new
    @activity_type_medium = ActivityTypeMedium.new
    @media_types = [["Videos", "VID"], ["Images", "IMG"]]
    @data_media = ""
    @data_media_vid = ""
  end

  # GET /entity_div_media/1/edit
  def edit
    @media_types = [["Videos", "VID"], ["Images", "IMG"]]
  end


  def inner_destroy

  end


  def inner_create
    @activity_type_medium = ActivityTypeMedium.new(activity_type_medium_params) #if !params[:activity_type_medium][:media_data].nil?
    media_uploader = VposCore::MediaDataUploader.new
    if params[:medium_type] == "images"
      @data_media = !params[:activity_type_medium].nil? && !params[:activity_type_medium][:media_data].nil? ? params[:activity_type_medium][:media_data] : ""
      valid_image = ActivityTypeMedium.inner_media_validity(params[:activity_type_medium], params[:code], activity_type_medium_params[:media_type])
      respond_to do |format|
        if valid_image
          ActivityTypeMedium.inner_media_save(params[:activity_type_medium], media_uploader, activity_type_medium_params[:media_type], params[:code], current_user)
          flash.now[:notice] = "Image Media was/were successfully created."
          image_media
          format.js { render :image_media }
        else
          #@data_media = activity_type_medium_params[:media_data]
          logger.info "Media =========== 1 #{activity_type_medium_params[:media_data].inspect}"
          flash.now[:danger] = "Please no image has been uploaded. Kindly try again."
          format.js { render :inner_new }
        end
      end

    elsif params[:medium_type] == "videos"
      @data_media_vid = !params[:activity_type_medium].nil? && !params[:activity_type_medium][:media_data_vid].nil? ? params[:activity_type_medium][:media_data_vid] : ""
      valid_video = ActivityTypeMedium.inner_media_validity(params[:activity_type_medium], params[:code], activity_type_medium_params[:media_vid_type])
      respond_to do |format|
        if valid_video
          ActivityTypeMedium.inner_media_save(params[:activity_type_medium], media_uploader, activity_type_medium_params[:media_vid_type], params[:code], current_user)
          flash.now[:notice] = "Video Media was/were successfully created."
          video_media
          format.js { render :video_media }
        else
          #@data_media_vid = activity_type_medium_params[:media_data_vid]
          logger.info "Media =========== 2 #{activity_type_medium_params[:media_data_vid].inspect}"
          flash.now[:danger] = "Please no video has been uploaded. Kindly try again."
          format.js { render :inner_new }
        end
      end
    end
  end
  
  # POST /entity_div_media
  # POST /entity_div_media.json
  def create
    @activity_type_medium = ActivityTypeMedium.new(activity_type_medium_params) #if !params[:activity_type_medium][:media_data].nil?
    @media_params = params["the_medium"]
    @media_types = [["Videos", "VID"], ["Images", "IMG"]]
    @data_media = !params[:activity_type_medium].nil? && !params[:activity_type_medium][:media_data].nil? ? params[:activity_type_medium][:media_data] : ""
    @data_media_vid = !params[:activity_type_medium].nil? && !params[:activity_type_medium][:media_data_vid].nil? ? params[:activity_type_medium][:media_data_vid] : ""


    media_uploader = VposCore::MediaDataUploader.new
    valid_image, valid_video, selected = ActivityTypeMedium.media_upload_validity(params[:activity_type_medium], params[:code])
    respond_to do |format|
      if valid_image && valid_video
        # if selected
          ActivityTypeMedium.media_upload_save(params[:activity_type_medium], media_uploader, params[:code], current_user)
          flash.now[:notice] = "Activity Type Media were successfully created."
          activity_type_media_index
          format.js { render :activity_type_media_index }
        # else
        #   flash.now[:danger] = "Please nothing has been selected. Kindly try again."
        #   format.js { render :new }
        # end
      else
        @data_media = activity_type_medium_params[:media_data]
        logger.info "Media =========== 1 #{activity_type_medium_params[:media_data].inspect}"
        format.js { render :new }
      end
    end
  end

  # PATCH/PUT /entity_div_media/1
  # PATCH/PUT /entity_div_media/1.json
  def update
    media_uploader = VposCore::MediaDataUploader.new
    date = @activity_type_medium.created_at.strftime('%Y-%m-%d %H:%M:%S.%N')
    updated_date = @activity_type_medium.updated_at.strftime('%Y-%m-%d %H:%M:%S.%N')

    if params[:medium_type] == "images"
      @data_media = !params[:activity_type_medium].nil? && !params[:activity_type_medium][:media_data].nil? ? params[:activity_type_medium][:media_data] : ""
      valid_image = ActivityTypeMedium.inner_media_validity(params[:activity_type_medium], params[:code], activity_type_medium_params[:media_type])
      respond_to do |format|
        if valid_image
          # sql = "UPDATE entity_div_media SET active_status = false, del_status = true, updated_at = '#{updated_date}' WHERE id = #{@activity_type_medium.id}"
          sql = "UPDATE entity_div_media SET active_status = false, del_status = true WHERE id = #{@activity_type_medium.id}"
          ActiveRecord::Base.connection.execute(sql)
          ActivityTypeMedium.inner_media_save(params[:activity_type_medium], media_uploader, activity_type_medium_params[:media_type], params[:code], current_user, date)
          flash.now[:notice] = "Image Media was successfully updated."
          image_media
          format.js { render :image_media }
        else
          #@data_media = activity_type_medium_params[:media_data]
          logger.info "Media =========== 1 #{activity_type_medium_params[:media_data].inspect}"
          flash.now[:danger] = "Please no image has been uploaded. Kindly try again."
          format.js { render :edit }
        end
      end

    elsif params[:medium_type] == "videos"
      @data_media_vid = !params[:activity_type_medium].nil? && !params[:activity_type_medium][:media_data_vid].nil? ? params[:activity_type_medium][:media_data_vid] : ""
      valid_video = ActivityTypeMedium.inner_media_validity(params[:activity_type_medium], params[:code], activity_type_medium_params[:media_vid_type])
      respond_to do |format|
        if valid_video
          # sql = "UPDATE entity_div_media SET active_status = false, del_status = true, updated_at = '#{updated_date}' WHERE id = #{@activity_type_medium.id}"
          sql = "UPDATE entity_div_media SET active_status = false, del_status = true WHERE id = #{@activity_type_medium.id}"
          ActiveRecord::Base.connection.execute(sql)
          ActivityTypeMedium.inner_media_save(params[:activity_type_medium], media_uploader, activity_type_medium_params[:media_vid_type], params[:code], current_user, date)
          flash.now[:notice] = "Video Media was successfully updated."
          video_media
          format.js { render :video_media }
        else
          #@data_media_vid = activity_type_medium_params[:media_data_vid]
          logger.info "Media =========== 2 #{activity_type_medium_params[:media_data_vid].inspect}"
          flash.now[:danger] = "Please no video has been uploaded. Kindly try again."
          format.js { render :edit }
        end
      end
    end

  end

  # DELETE /entity_div_media/1
  # DELETE /entity_div_media/1.json
  def destroy
    if @activity_type_medium.active_status && @activity_type_medium.del_status == false
      @activity_type_medium.active_status = false
      @activity_type_medium.save(validate: false)
      respond_to do |format|
        if params[:medium_type] == "images"
          image_media
          flash.now[:note] = "Image media was successfully disabled."
        elsif params[:medium_type] == "videos"
          video_media
          flash.now[:note] = "Video media was successfully disabled."
        end
        format.js { render :layout => false}
      end

    elsif @activity_type_medium.active_status == false && @activity_type_medium.del_status == false
      @activity_type_medium.active_status = true
      @activity_type_medium.save(validate: false)
      respond_to do |format|
        if params[:medium_type] == "images"
          image_media
          flash.now[:notice] = "Image media was successfully enabled."
        elsif params[:medium_type] == "videos"
          video_media
          flash.now[:notice] = "Video media was successfully enabled."
        end
        format.js { render :layout => false }
      end
    else
      respond_to do |format|
        flash.now[:notice] = 'Please try again.'
        format.js { render :layout => false }
      end
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_activity_type_medium
    @activity_type_medium = ActivityTypeMedium.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def activity_type_medium_params
    params.require(:activity_type_medium).permit(:activity_type_code, :media_path, :media_type, :active_status,
                                              :del_status, :user_id, :media_vid_path, :media_vid_type, media_data: [], media_data_vid: [])
  end
end





