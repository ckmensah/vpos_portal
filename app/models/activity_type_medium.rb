class ActivityTypeMedium < ApplicationRecord
  self.table_name = "activity_type_media"
  self.primary_key = :id
  attr_accessor :assigned_code, :handle, :media_data_vid, :media_vid_path, :media_vid_type
  belongs_to :activity_type, class_name: 'ActivityType', foreign_key: :activity_type_code#, primary_key: :assigned_code


  validates :activity_type_code, presence: true
  validates :media_path, presence: {message: " cannot be empty."}
  validates :media_data, presence: {message: " cannot be empty."}
  validates :media_type, presence: {message: " cannot be empty."}

  def self.inner_media_validity(activity_type_params, act_type_code, media_type)
    valid_media = true

    if  media_type == "IMG"
      if activity_type_params.key?(:media_data)
        activity_type_params[:media_data].each_with_index do |image, ind|
          filename = image
          logger.info "#{ind + 1}. Media IMG ==== 1 #{image.inspect}"
          logger.info "#{ind + 1}. Media IMG ==== 2 #{filename.inspect}"
          @activity_type_medium = ActivityTypeMedium.new(media_type: activity_type_params[:media_type],
                                                   media_path: activity_type_params[:media_path],
                                                   media_data: filename,
                                                   activity_type_code: act_type_code)
          logger.info "#{ind + 1}. Media IMG ==== 3 #{@activity_type_medium.media_data.inspect}"
          unless @activity_type_medium.valid?
            valid_media = false
            break
          end
        end
      else
        valid_media = false
      end
    elsif  media_type == "VID"
      if activity_type_params.key?(:media_data_vid)
        activity_type_params[:media_data_vid].each_with_index do |video, ind|
          filename_vid = video
          logger.info "#{ind + 1}. Media VID ==== 1 #{video.inspect}"
          logger.info "#{ind + 1}. Media VID ==== 2 #{filename_vid.inspect}"
          @act_type_med_vid = ActivityTypeMedium.new(media_type: activity_type_params[:media_vid_type],
                                                    media_path: activity_type_params[:media_vid_path],
                                                    media_data: filename_vid,
                                                    activity_type_code: act_type_code)
          logger.info "#{ind + 1}. Media VID ==== 3 #{@act_type_med_vid.media_data.inspect}"
          unless @act_type_med_vid.valid?
            valid_media = false
            break
          end
        end
      else
        valid_media = false
      end
    end
    valid_media
  end

  def self.media_upload_validity(activity_type_params, act_type_code)
    valid_image = true
    valid_video = true
    selected = true

    if activity_type_params[:media_type] == "IMG"
      if activity_type_params.key?(:media_data)
        activity_type_params[:media_data].each_with_index do |image, ind|
          filename = image
          logger.info "#{ind + 1}. Media IMG ==== 1 #{image.inspect}"
          logger.info "#{ind + 1}. Media IMG ==== 2 #{filename.inspect}"
          @activity_type_medium = ActivityTypeMedium.new(media_type: activity_type_params[:media_type],
                                                   media_path: activity_type_params[:media_path],
                                                   media_data: filename,
                                                   activity_type_code: act_type_code)
          logger.info "#{ind + 1}. Media IMG ==== 3 #{@activity_type_medium.media_data.inspect}"
          unless @activity_type_medium.valid?
            valid_image = false
            break
          end
        end
      else
        #valid_image = false
        selected = false
      end
    end

    if activity_type_params[:media_vid_type] == "VID"
      if activity_type_params.key?(:media_data_vid)
        activity_type_params[:media_data_vid].each_with_index do |video, ind|
          filename_vid = video
          logger.info "#{ind + 1}. Media VID ==== 1 #{video.inspect}"
          logger.info "#{ind + 1}. Media VID ==== 2 #{filename_vid.inspect}"
          @act_type_med_vid = ActivityTypeMedium.new(media_type: activity_type_params[:media_vid_type],
                                                    media_path: activity_type_params[:media_vid_path],
                                                    media_data: filename_vid,
                                                    activity_type_code: act_type_code)
          logger.info "#{ind + 1}. Media VID ==== 3 #{@act_type_med_vid.media_data.inspect}"
          unless @act_type_med_vid.valid?
            valid_video = false
            break
          end
        end
      else
        #valid_video = false
        selected = false
      end
    end

    return valid_image, valid_video, selected

  end


  def self.inner_media_save(activity_type_params, media_uploader, media_type, act_type_code, current_user, created_at = "default")
    if media_type == "IMG"
      if activity_type_params.key?(:media_data)
        activity_type_params[:media_data].each_with_index do |image, ind|
          img_public_id = media_uploader.media_public_id(activity_type_params[:media_type])
          filename = media_uploader.filename(image, img_public_id)
          logger.info "#{ind + 1}. Media ==== 1 #{image.inspect}"
          logger.info "#{ind + 1}. Media ==== 2 #{filename.inspect}"
          if created_at == "default"
            @activity_type_medium = ActivityTypeMedium.new(media_type: activity_type_params[:media_type],
                                                     media_path: activity_type_params[:media_path],
                                                     media_data: filename,
                                                     activity_type_code: act_type_code, active_status: true,
                                                     del_status: false, user_id: current_user.id)
          else
            @activity_type_medium = ActivityTypeMedium.new(media_type: activity_type_params[:media_type],
                                                     media_path: activity_type_params[:media_path],
                                                     media_data: filename,
                                                     activity_type_code: act_type_code, active_status: true,
                                                     del_status: false, user_id: current_user.id, created_at: created_at)
          end
          logger.info "#{ind + 1}. Media ==== 3 #{@activity_type_medium.media_data.inspect}"
          if @activity_type_medium.save
            Cloudinary::Uploader.upload(image, :resource_type => :image, :public_id => img_public_id)
          else
            logger.info "Couldn't Save"
          end
        end
      end
    elsif media_type == "VID"
      if activity_type_params.key?(:media_data_vid)
        activity_type_params[:media_data_vid].each_with_index do |video, ind|
          vid_public_id = media_uploader.media_public_id(activity_type_params[:media_vid_type])
          vid_filename = media_uploader.filename(video, vid_public_id)
          logger.info "#{ind + 1}. Media Video ==== 1 #{video.inspect}"
          logger.info "#{ind + 1}. Media Video ==== 2 #{vid_filename.inspect}"
          if created_at == "default"
            @vid_div_medium = ActivityTypeMedium.new(media_type: activity_type_params[:media_vid_type],
                                                  media_path: activity_type_params[:media_vid_path],
                                                  media_data: vid_filename,
                                                  activity_type_code: act_type_code, active_status: true,
                                                  del_status: false, user_id: current_user.id)
          else
            @vid_div_medium = ActivityTypeMedium.new(media_type: activity_type_params[:media_vid_type],
                                                  media_path: activity_type_params[:media_vid_path],
                                                  media_data: vid_filename,
                                                  activity_type_code: act_type_code, active_status: true,
                                                  del_status: false, user_id: current_user.id, created_at: created_at)
          end
          logger.info "#{ind + 1}. Media Video ==== 3 #{@vid_div_medium.media_data.inspect}"
          if @vid_div_medium.save
            #Cloudinary::Uploader.upload(video, :public_id => vid_public_id)
            Cloudinary::Uploader.upload_large(video, :resource_type => :video,
                                              :public_id => vid_public_id)
          else
            logger.info "Couldn't Save Video...."
          end
        end
      end
    end

  end


  def self.media_upload_save(activity_type_params, media_uploader, act_type_code, current_user)
    if activity_type_params[:media_type] == "IMG"
      if activity_type_params.key?(:media_data)
        activity_type_params[:media_data].each_with_index do |image, ind|
          img_public_id = media_uploader.media_public_id(activity_type_params[:media_type])
          filename = media_uploader.filename(image, img_public_id)
          logger.info "#{ind + 1}. Media ==== 1 #{image.inspect}"
          logger.info "#{ind + 1}. Media ==== 2 #{filename.inspect}"
          @activity_type_medium = ActivityTypeMedium.new(media_type: activity_type_params[:media_type],
                                                   media_path: activity_type_params[:media_path],
                                                   media_data: filename,
                                                   activity_type_code: act_type_code, active_status: true,
                                                   del_status: false, user_id: current_user.id)
          logger.info "#{ind + 1}. Media ==== 3 #{@activity_type_medium.media_data.inspect}"
          if @activity_type_medium.save
            Cloudinary::Uploader.upload(image, :public_id => img_public_id)
          else
            logger.info "Couldn't Save"
          end
        end
      end
    end

    if activity_type_params[:media_vid_type] == "VID"
      if activity_type_params.key?(:media_data_vid)
        activity_type_params[:media_data_vid].each_with_index do |video, ind|
          vid_public_id = media_uploader.media_public_id(activity_type_params[:media_vid_type])
          vid_filename = media_uploader.filename(video, vid_public_id)
          logger.info "#{ind + 1}. Media Video ==== 1 #{video.inspect}"
          logger.info "#{ind + 1}. Media Video ==== 2 #{vid_filename.inspect}"
          @vid_div_medium = ActivityTypeMedium.new(media_type: activity_type_params[:media_vid_type],
                                                media_path: activity_type_params[:media_vid_path],
                                                media_data: vid_filename,
                                                activity_type_code: act_type_code, active_status: true,
                                                del_status: false, user_id: current_user.id)
          logger.info "#{ind + 1}. Media Video ==== 3 #{@vid_div_medium.media_data.inspect}"
          if @vid_div_medium.save
            #Cloudinary::Uploader.upload(video, :public_id => vid_public_id)
            Cloudinary::Uploader.upload_large(video, :resource_type => :video,
                                              :public_id => vid_public_id)
          else
            logger.info "Couldn't Save Video...."
          end
        end
      end
    end

  end



end


