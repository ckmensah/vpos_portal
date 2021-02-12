class EntityDivMediaController < ApplicationController
  before_action :set_entity_div_medium, only: [:show, :edit, :inner_destroy, :update, :destroy]

  require 'vpos_core'
  # GET /entity_div_media
  # GET /entity_div_media.json
  def index
    #@entity_div_media = EntityDivMedium.all
  end

  def entity_div_media_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1
    params[:page].present? ? page = params[:page].to_i : page = 1

    params[:count1] ? params[:count1] : params[:count1] = 50
    params[:page1] ? params[:page1] : params[:page1] = 1

    params[:count5] ? params[:count5] : params[:count5] = 50
    params[:page5] ? params[:page5] : params[:page5] = 1

    @entity_div_social_handles = EntityDivSocialHandle.where(entity_div_code: params[:code], del_status: false).order(created_at: :desc)
    @image_media = EntityDivMedium.where(entity_div_code: params[:code], media_type: "IMG", del_status: false).order(created_at: :desc)
    @video_media = EntityDivMedium.where(entity_div_code: params[:code], media_type: "VID", del_status: false).order(created_at: :desc)
    #@entity_div_media = EntityDivMedium.where(entity_div_code: params[:code], del_status: false).paginate(:page => params[:page], :per_page => params[:count5]).order(created_at: :desc)

  end


  def image_media
    @image_media = EntityDivMedium.where(entity_div_code: params[:code], media_type: "IMG", del_status: false).order(created_at: :desc)
  end


  def video_media
    @video_media = EntityDivMedium.where(entity_div_code: params[:code], media_type: "VID", del_status: false).order(created_at: :desc)
  end


  # GET /entity_div_media/1
  # GET /entity_div_media/1.json
  def show
  end


  # GET /entity_div_media/new
  def inner_new
    @entity_div_medium = EntityDivMedium.new
    @social_handles = EntityDivSocialHandle.where(del_status: false, entity_div_code: params[:code])
    @handle_codes = [["Twitter", "TWT"], ["Youtube", "YTU"], ["Facebook", "FBK"]]
    @handle_initials = ["TWT", "YTU", "FBK"]
    if @social_handles.exists?
      @available_handle_inits = @social_handles.map { |a| a.assigned_code if @handle_initials.include?(a.assigned_code) }
      @unavailable_handles = []
      @handle_codes.each do |handle|
        unless @available_handle_inits.include?(handle[1])
          @unavailable_handles << handle
        end
      end
    else
      @unavailable_handles = @handle_codes
    end

    logger.info "The available handle inits :: #{@available_handle_inits.inspect}"
    logger.info "The available handles :: #{@unavailable_handles.inspect}"
    @media_types = [["Videos", "VID"], ["Images", "IMG"]]
    @data_media = ""
    @data_media_vid = ""
  end

  def new
    @entity_div_medium = EntityDivMedium.new
    @handle_codes = [["Twitter", "TWT"], ["Youtube", "YTU"], ["Facebook", "FBK"]]
    @handle_initials = ["TWT", "YTU", "FBK"]
    @media_types = [["Videos", "VID"], ["Images", "IMG"]]
    @data_media = ""
    @data_media_vid = ""
  end

  # GET /entity_div_media/1/edit
  def edit
    @handle_codes = [["Twitter", "TWT"], ["Youtube", "YTU"], ["Facebook", "FBK"]]
    @media_types = [["Videos", "VID"], ["Images", "IMG"]]
  end


  def inner_destroy

  end


  def inner_create
    @entity_div_medium = EntityDivMedium.new(entity_div_medium_params) #if !params[:entity_div_medium][:media_data].nil?
    media_uploader = VposCore::MediaDataUploader.new
    if params[:medium_type] == "images"
      @data_media = !params[:entity_div_medium].nil? && !params[:entity_div_medium][:media_data].nil? ? params[:entity_div_medium][:media_data] : ""
      valid_image = EntityDivMedium.inner_media_validity(params[:entity_div_medium], params[:code], entity_div_medium_params[:media_type])
      respond_to do |format|
        if valid_image
          EntityDivMedium.inner_media_save(params[:entity_div_medium], media_uploader, entity_div_medium_params[:media_type], params[:code], current_user)
          flash.now[:notice] = "Image Media was/were successfully created."
          image_media
          format.js { render :image_media }
        else
          #@data_media = entity_div_medium_params[:media_data]
          logger.info "Media =========== 1 #{entity_div_medium_params[:media_data].inspect}"
          flash.now[:danger] = "Please no image has been uploaded. Kindly try again."
          format.js { render :inner_new }
        end
      end

    elsif params[:medium_type] == "videos"
      @data_media_vid = !params[:entity_div_medium].nil? && !params[:entity_div_medium][:media_data_vid].nil? ? params[:entity_div_medium][:media_data_vid] : ""
      valid_video = EntityDivMedium.inner_media_validity(params[:entity_div_medium], params[:code], entity_div_medium_params[:media_vid_type])
      respond_to do |format|
        if valid_video
          EntityDivMedium.inner_media_save(params[:entity_div_medium], media_uploader, entity_div_medium_params[:media_vid_type], params[:code], current_user)
          flash.now[:notice] = "Video Media was/were successfully created."
          video_media
          format.js { render :video_media }
        else
          #@data_media_vid = entity_div_medium_params[:media_data_vid]
          logger.info "Media =========== 2 #{entity_div_medium_params[:media_data_vid].inspect}"
          flash.now[:danger] = "Please no video has been uploaded. Kindly try again."
          format.js { render :inner_new }
        end
      end

    elsif params[:medium_type] == "handles"
      @media_params = params["the_medium"]
      @handle_codes = [["Twitter", "TWT"], ["Youtube", "YTU"], ["Facebook", "FBK"]]
      @handle_initials = ["TWT", "YTU", "FBK"]

      handle_inputted = EntityDivMedium.handle_validity(@media_params)
      respond_to do |format|
        if handle_inputted
          @entity_div_social_handle = EntityDivMedium.social_handles_save(@media_params, @handle_initials, params[:code], current_user)
          logger.info "After Save object ========== :: #{@entity_div_social_handle.inspect}"
          flash.now[:notice] = "Social handle(s) was/were successfully created."
          @entity_div_social_handles = EntityDivSocialHandle.where(entity_div_code: params[:code], del_status: false).order(created_at: :desc)
          format.js { render '/entity_div_social_handles/entity_div_social_handle_index' }
        else
          @social_handles = EntityDivSocialHandle.where(del_status: false, entity_div_code: params[:code])
          if @social_handles.exists?
            @available_handle_inits = @social_handles.map { |a| a.assigned_code if @handle_initials.include?(a.assigned_code) }
            @unavailable_handles = []
            @handle_codes.each do |handle|
              unless @available_handle_inits.include?(handle[1])
                @unavailable_handles << handle
              end
            end
          else
            @unavailable_handles = @handle_codes
          end
          flash.now[:danger] = "Please nothing has been entered. Kindly try again."
          format.js { render :inner_new }
        end
      end
    end
  end
  # POST /entity_div_media
  # POST /entity_div_media.json
  def create
    @entity_div_medium = EntityDivMedium.new(entity_div_medium_params) #if !params[:entity_div_medium][:media_data].nil?
    @media_params = params["the_medium"]
    @handle_codes = [["Twitter", "TWT"], ["Youtube", "YTU"], ["Facebook", "FBK"]]
    @handle_initials = ["TWT", "YTU", "FBK"]
    @media_types = [["Videos", "VID"], ["Images", "IMG"]]
    @data_media = !params[:entity_div_medium].nil? && !params[:entity_div_medium][:media_data].nil? ? params[:entity_div_medium][:media_data] : ""
    @data_media_vid = !params[:entity_div_medium].nil? && !params[:entity_div_medium][:media_data_vid].nil? ? params[:entity_div_medium][:media_data_vid] : ""


    media_uploader = VposCore::MediaDataUploader.new
    valid_image, valid_video, selected = EntityDivMedium.media_upload_validity(params[:entity_div_medium], params[:code])
    handle_inputted = EntityDivMedium.handle_validity(@media_params)
    respond_to do |format|
      if valid_image && valid_video
        if selected || handle_inputted
          EntityDivMedium.social_handles_save(@media_params, @handle_initials, params[:code], current_user)
          EntityDivMedium.media_upload_save(params[:entity_div_medium], media_uploader, params[:code], current_user)
          flash.now[:notice] = "Media and Social handles were successfully created."
          entity_div_media_index
          format.js { render :entity_div_media_index }
          #format.js { render :close_entity_div_media }
        else
          flash.now[:danger] = "Please nothing has been selected or inputted. Kindly try again."
          format.js { render :new }
        end
      else
        @data_media = entity_div_medium_params[:media_data]
        logger.info "Media =========== 1 #{entity_div_medium_params[:media_data].inspect}"
        format.js { render :new }
      end
    end
  end

  # PATCH/PUT /entity_div_media/1
  # PATCH/PUT /entity_div_media/1.json
  def update
    media_uploader = VposCore::MediaDataUploader.new
    date = @entity_div_medium.created_at.strftime('%Y-%m-%d %H:%M:%S.%N')
    updated_date = @entity_div_medium.updated_at.strftime('%Y-%m-%d %H:%M:%S.%N')

    if params[:medium_type] == "images"
      @data_media = !params[:entity_div_medium].nil? && !params[:entity_div_medium][:media_data].nil? ? params[:entity_div_medium][:media_data] : ""
      valid_image = EntityDivMedium.inner_media_validity(params[:entity_div_medium], params[:code], entity_div_medium_params[:media_type])
      respond_to do |format|
        if valid_image
          sql = "UPDATE entity_div_media SET active_status = false, del_status = true, updated_at = '#{updated_date}' WHERE id = #{@entity_div_medium.id}"
          ActiveRecord::Base.connection.execute(sql)
          EntityDivMedium.inner_media_save(params[:entity_div_medium], media_uploader, entity_div_medium_params[:media_type], params[:code], current_user, date)
          flash.now[:notice] = "Image Media was successfully updated."
          image_media
          format.js { render :image_media }
        else
          #@data_media = entity_div_medium_params[:media_data]
          logger.info "Media =========== 1 #{entity_div_medium_params[:media_data].inspect}"
          flash.now[:danger] = "Please no image has been uploaded. Kindly try again."
          format.js { render :edit }
        end
      end

    elsif params[:medium_type] == "videos"
      @data_media_vid = !params[:entity_div_medium].nil? && !params[:entity_div_medium][:media_data_vid].nil? ? params[:entity_div_medium][:media_data_vid] : ""
      valid_video = EntityDivMedium.inner_media_validity(params[:entity_div_medium], params[:code], entity_div_medium_params[:media_vid_type])
      respond_to do |format|
        if valid_video
          sql = "UPDATE entity_div_media SET active_status = false, del_status = true, updated_at = '#{updated_date}' WHERE id = #{@entity_div_medium.id}"
          ActiveRecord::Base.connection.execute(sql)
          EntityDivMedium.inner_media_save(params[:entity_div_medium], media_uploader, entity_div_medium_params[:media_vid_type], params[:code], current_user, date)
          flash.now[:notice] = "Video Media was successfully updated."
          video_media
          format.js { render :video_media }
        else
          #@data_media_vid = entity_div_medium_params[:media_data_vid]
          logger.info "Media =========== 2 #{entity_div_medium_params[:media_data_vid].inspect}"
          flash.now[:danger] = "Please no video has been uploaded. Kindly try again."
          format.js { render :edit }
        end
      end

    elsif params[:medium_type] == "handles"
    end

  end

  # DELETE /entity_div_media/1
  # DELETE /entity_div_media/1.json
  def destroy
    if @entity_div_medium.active_status && @entity_div_medium.del_status == false
      @entity_div_medium.active_status = false
      @entity_div_medium.save(validate: false)
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

    elsif @entity_div_medium.active_status == false && @entity_div_medium.del_status == false
      @entity_div_medium.active_status = true
      @entity_div_medium.save(validate: false)
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
    def set_entity_div_medium
      @entity_div_medium = EntityDivMedium.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def entity_div_medium_params
      params.require(:entity_div_medium).permit(:entity_div_code, :media_path, :media_type, :active_status,
                                                :del_status, :user_id, :media_vid_path, :media_vid_type, media_data: [], media_data_vid: [])
    end
end
