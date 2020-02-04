require "shrine"
# require "shrine/storage/file_system"
require "cloudinary"
require "shrine/storage/cloudinary"

# Shrine.storages = {
#     cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
#     store: Shrine::Storage::FileSystem.new("public", prefix: "uploads"),       # permanent
# }


Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file





Cloudinary.config(
    cloud_name: "appsnmob",
    api_key:    "461494615625846",
    api_secret: "kEDJlg4uJOKU5pZ9nyXrz4qzOUU",
    )

Shrine.storages = {
    cache: Shrine::Storage::Cloudinary.new(prefix: "virtual_pos/sports"), # for direct uploads
    store: Shrine::Storage::Cloudinary.new(prefix: "virtual_pos/sports"),
}

