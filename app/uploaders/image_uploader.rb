require "image_processing/mini_magick"

class ImageUploader < Shrine
  include ImageProcessing::MiniMagick
  plugin :processing
  plugin :versions
  # plugin :store_dimensions
  # other code...
  #

  process(:store) do |io, context|
    original = io.download
    pipeline = ImageProcessing::MiniMagick.source(original)

    #size_800 = pipeline.resize_to_limit!(800, 800)
    #size_600 = pipeline.resize_to_limit!(180, 180)
    #size_500 = pipeline.resize_to_limit!(100, 100)
    #size_300 = pipeline.resize_to_limit!(50, 50)

    original.close!

    #{ original: io, large: size_800, medium: size_500, small: size_300, dp: size_600   }
    { original: io   }
    # validate_mime_type_inclusion ["image/jpg", "image/png", "image/gif"]


  end

  # Attacher.validate do
  #   puts get.mime_type # returns empty strings
  #   # validate_mime_type_inclusion %w[image/jpeg image/png image/gif image/swf]
  #   validate_max_size 4.megabyte, message: "your file is too large (max. 4MB)"
  # end
  # process(:store) do |io, context|
  #   { original: io, thumb: resize_to_limit!(io.download, 30, 30) }
  #   size_400  = resize_to_limit(size_900,  400, 800)
  #
  #   # thumb = with_minimagick(size_400) do |img|
  #   #   img.combine_options do |cmd|
  #   #     cmd.resize '150x150!'
  #   #   end
  #   # end
  # end
end