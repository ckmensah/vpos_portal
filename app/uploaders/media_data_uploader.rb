class MediaDataUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  version :standard do
    process :resize_to_fill => [100, 150, :north]
  end

  #version :thumbnail do
  #  resize_to_fit(50, 50)
  #end

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fill: [100, 100]
  end
  version :medium do
    process resize_to_fit: [200, 200]
  end

  # def public_id
  #   return "trickles/portal_images"
  # end

  def store_dir
    #"uploads/#{model.class.to_s.underscore}/#{mounted_as}"
    "virtual_pos/media"
  end

  def public_id
    "#{store_dir}/" + Cloudinary::Utils.random_public_id
  end
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.

  #def filename
  #  "#{public_id}.#{file.extension}" if original_filename.present?
  #end


end