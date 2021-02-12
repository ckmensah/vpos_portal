class EntityDivMedium < ApplicationRecord
  self.table_name = "entity_div_media"
  self.primary_key = :id
  attr_accessor :assigned_code, :handle, :media_data_vid, :media_vid_path, :media_vid_type
  #mount_uploader MediaDataUploader
  belongs_to :entity_division, class_name: 'EntityDivision', foreign_key: :entity_div_code
  #has_many_attached :media_data_vid


  #validates :assigned_code, presence: {message: " cannot be empty."}
  validates :entity_div_code, presence: true
  validates :media_path, presence: {message: " cannot be empty."}
  validates :media_data, presence: {message: " cannot be empty."}
  validates :media_type, presence: {message: " cannot be empty."}
  #validates :media_data_url, allow_blank: true, format: {
  #    with: %r{\.(jpeg|jpg|png)\Z}i,
  #    message: 'must be a png or jpg image.'
  #}, on: :create
  #validates :handle, presence: {message: " cannot be empty."}

  def self.handle_validity(the_medium)
    handle_inputted = false
    the_medium.each do |key, value|
      if value["handle"].present?
        handle_inputted = true
        break
      end
    end
    handle_inputted
  end

  def self.inner_media_validity(div_med_params, div_code, media_type)
    valid_media = true

    if  media_type == "IMG"
      if div_med_params.key?(:media_data)
        div_med_params[:media_data].each_with_index do |image, ind|
          filename = image
          logger.info "#{ind + 1}. Media IMG ==== 1 #{image.inspect}"
          logger.info "#{ind + 1}. Media IMG ==== 2 #{filename.inspect}"
          @entity_div_medium = EntityDivMedium.new(media_type: div_med_params[:media_type],
                                                   media_path: div_med_params[:media_path],
                                                   media_data: filename,
                                                   entity_div_code: div_code)
          logger.info "#{ind + 1}. Media IMG ==== 3 #{@entity_div_medium.media_data.inspect}"
          unless @entity_div_medium.valid?
            valid_media = false
            break
          end
        end
      else
        valid_media = false
      end
    elsif  media_type == "VID"
      if div_med_params.key?(:media_data_vid)
        div_med_params[:media_data_vid].each_with_index do |video, ind|
          filename_vid = video
          logger.info "#{ind + 1}. Media VID ==== 1 #{video.inspect}"
          logger.info "#{ind + 1}. Media VID ==== 2 #{filename_vid.inspect}"
          @entity_div_med_vid = EntityDivMedium.new(media_type: div_med_params[:media_vid_type],
                                                    media_path: div_med_params[:media_vid_path],
                                                    media_data: filename_vid,
                                                    entity_div_code: div_code)
          logger.info "#{ind + 1}. Media VID ==== 3 #{@entity_div_med_vid.media_data.inspect}"
          unless @entity_div_med_vid.valid?
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

  def self.media_upload_validity(div_med_params, div_code)
    valid_image = true
    valid_video = true
    selected = true

    if div_med_params[:media_type] == "IMG"
      if div_med_params.key?(:media_data)
        div_med_params[:media_data].each_with_index do |image, ind|
          filename = image
          logger.info "#{ind + 1}. Media IMG ==== 1 #{image.inspect}"
          logger.info "#{ind + 1}. Media IMG ==== 2 #{filename.inspect}"
          @entity_div_medium = EntityDivMedium.new(media_type: div_med_params[:media_type],
                                                   media_path: div_med_params[:media_path],
                                                   media_data: filename,
                                                   entity_div_code: div_code)
          logger.info "#{ind + 1}. Media IMG ==== 3 #{@entity_div_medium.media_data.inspect}"
          unless @entity_div_medium.valid?
            valid_image = false
            break
          end
        end
      else
        #valid_image = false
        selected = false
      end
    end

    if div_med_params[:media_vid_type] == "VID"
      if div_med_params.key?(:media_data_vid)
        div_med_params[:media_data_vid].each_with_index do |video, ind|
          filename_vid = video
          logger.info "#{ind + 1}. Media VID ==== 1 #{video.inspect}"
          logger.info "#{ind + 1}. Media VID ==== 2 #{filename_vid.inspect}"
          @entity_div_med_vid = EntityDivMedium.new(media_type: div_med_params[:media_vid_type],
                                                   media_path: div_med_params[:media_vid_path],
                                                   media_data: filename_vid,
                                                   entity_div_code: div_code)
          logger.info "#{ind + 1}. Media VID ==== 3 #{@entity_div_med_vid.media_data.inspect}"
          unless @entity_div_med_vid.valid?
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


  def self.inner_media_save(div_med_params, media_uploader, media_type, div_code, current_user, created_at = "default")
    if media_type == "IMG"
      if div_med_params.key?(:media_data)
        div_med_params[:media_data].each_with_index do |image, ind|
          img_public_id = media_uploader.media_public_id(div_med_params[:media_type])
          filename = media_uploader.filename(image, img_public_id)
          logger.info "#{ind + 1}. Media ==== 1 #{image.inspect}"
          logger.info "#{ind + 1}. Media ==== 2 #{filename.inspect}"
          if created_at == "default"
            @entity_div_medium = EntityDivMedium.new(media_type: div_med_params[:media_type],
                                                     media_path: div_med_params[:media_path],
                                                     media_data: filename,
                                                     entity_div_code: div_code, active_status: true,
                                                     del_status: false, user_id: current_user.id)
          else
            @entity_div_medium = EntityDivMedium.new(media_type: div_med_params[:media_type],
                                                     media_path: div_med_params[:media_path],
                                                     media_data: filename,
                                                     entity_div_code: div_code, active_status: true,
                                                     del_status: false, user_id: current_user.id, created_at: created_at)
          end
          logger.info "#{ind + 1}. Media ==== 3 #{@entity_div_medium.media_data.inspect}"
          if @entity_div_medium.save
            Cloudinary::Uploader.upload(image, :resource_type => :image, :public_id => img_public_id)
          else
            logger.info "Couldn't Save"
          end
        end
      end
    elsif media_type == "VID"
      if div_med_params.key?(:media_data_vid)
        div_med_params[:media_data_vid].each_with_index do |video, ind|
          vid_public_id = media_uploader.media_public_id(div_med_params[:media_vid_type])
          vid_filename = media_uploader.filename(video, vid_public_id)
          logger.info "#{ind + 1}. Media Video ==== 1 #{video.inspect}"
          logger.info "#{ind + 1}. Media Video ==== 2 #{vid_filename.inspect}"
          if created_at == "default"
            @vid_div_medium = EntityDivMedium.new(media_type: div_med_params[:media_vid_type],
                                                  media_path: div_med_params[:media_vid_path],
                                                  media_data: vid_filename,
                                                  entity_div_code: div_code, active_status: true,
                                                  del_status: false, user_id: current_user.id)
          else
            @vid_div_medium = EntityDivMedium.new(media_type: div_med_params[:media_vid_type],
                                                  media_path: div_med_params[:media_vid_path],
                                                  media_data: vid_filename,
                                                  entity_div_code: div_code, active_status: true,
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


  def self.media_upload_save(div_med_params, media_uploader, div_code, current_user)
    if div_med_params[:media_type] == "IMG"
      if div_med_params.key?(:media_data)
        div_med_params[:media_data].each_with_index do |image, ind|
          img_public_id = media_uploader.media_public_id(div_med_params[:media_type])
          filename = media_uploader.filename(image, img_public_id)
          logger.info "#{ind + 1}. Media ==== 1 #{image.inspect}"
          logger.info "#{ind + 1}. Media ==== 2 #{filename.inspect}"
          @entity_div_medium = EntityDivMedium.new(media_type: div_med_params[:media_type],
                                                   media_path: div_med_params[:media_path],
                                                   media_data: filename,
                                                   entity_div_code: div_code, active_status: true,
                                                   del_status: false, user_id: current_user.id)
          logger.info "#{ind + 1}. Media ==== 3 #{@entity_div_medium.media_data.inspect}"
          if @entity_div_medium.save
            Cloudinary::Uploader.upload(image, :public_id => img_public_id)
          else
            logger.info "Couldn't Save"
          end
        end
      end
    end

    if div_med_params[:media_vid_type] == "VID"
      if div_med_params.key?(:media_data_vid)
        div_med_params[:media_data_vid].each_with_index do |video, ind|
          vid_public_id = media_uploader.media_public_id(div_med_params[:media_vid_type])
          vid_filename = media_uploader.filename(video, vid_public_id)
          logger.info "#{ind + 1}. Media Video ==== 1 #{video.inspect}"
          logger.info "#{ind + 1}. Media Video ==== 2 #{vid_filename.inspect}"
          @vid_div_medium = EntityDivMedium.new(media_type: div_med_params[:media_vid_type],
                                                   media_path: div_med_params[:media_vid_path],
                                                   media_data: vid_filename,
                                                   entity_div_code: div_code, active_status: true,
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


  def self.social_handles_save(the_medium, social_media, div_code, current_user)
    logger.info "The Medium :: #{the_medium.inspect}"
    the_medium.each do |key, value|
      if social_media.include?(value["assigned_code"]) && value["handle"].present?
        social_media_obj = EntityDivSocialHandle.new(assigned_code: value["assigned_code"], handle: value["handle"],
                                                     entity_div_code: div_code, active_status: true, del_status: false,
                                                     user_id: current_user.id)
        social_media_obj.save(validate: false)
        social_media_obj
      end
    end
  end



end
