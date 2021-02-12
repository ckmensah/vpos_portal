require 'socket'
require 'timeout'
require 'date'
require "base64"

module VposCore

  class CoreConnect
    HEADER={'Content-Type'=>'application/json','timeout'=>'180'}
    #R_HEADER={'Content-Type'=>'application/json','timeout'=>'600'}
    URL = "http://#{ENV['VPOS_API_IP']}:#{ENV['VPOS_API_PORT']}" #"http://10.105.85.78:7045" #"http://5.153.40.138:7045" #5.153.40.138, 10.105.85.78

    def connection
      Faraday.new(:url => URL, :headers => HEADER, :ssl => {:verify => false}) do |faraday|
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def compute_signature(secret, data)
      digest=OpenSSL::Digest.new('sha256')
      signature = OpenSSL::HMAC.hexdigest(digest, secret.to_s, data)
      return signature
    end

    def json_validate(json)
      JSON.parse(json)
      return true
    rescue JSON::ParserError => e
      return false
    end

  end

  class CheckConnection
    def is_port_open?(ip, port)
      begin
        Timeout::timeout(1) do
          begin
            s = TCPSocket.new(ip, port)
            s.close

            puts "IP #{ip} port #{port} is open"

            return true #Port is open. return true
          rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
            puts "port #{port} is closed"

            return false    #Port is closed. return false
          end
        end
      rescue Timeout::Error
      end

      return false
    end

  end


  class VposEncryptor

    #def encrypt text
    #  text = text.to_s unless text.is_a? String
    #
    #  len   = ActiveSupport::MessageEncryptor.key_len
    #  salt  = SecureRandom.hex len
    #  key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key salt, len
    #  crypt = ActiveSupport::MessageEncryptor.new key
    #  encrypted_data = crypt.encrypt_and_sign text
    #  "#{salt}$$#{encrypted_data}"
    #end
    #
    #def decrypt text
    #  salt, data = text.split "$$"
    #
    #  len   = ActiveSupport::MessageEncryptor.key_len
    #  key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key salt, len
    #  crypt = ActiveSupport::MessageEncryptor.new key
    #  crypt.decrypt_and_verify data
    #end


    def encrypt_and_sign(text)
      text  = String(text)
      iv    = SecureRandom.random_bytes(key_length)
      key   = generate_key(iv)
      crypt = encryptor(key)

      encrypted_data = crypt.encrypt_and_sign text
      "#{iv}#{encrypted_data}"
    end

    def decrypt(encrypted_text)
      iv, encrypted_data = decompose(encrypted_text)
      key   = generate_key(iv)
      crypt = encryptor(key)
      crypt.decrypt_and_verify(encrypted_data)
    end

    private

    def encryptor(key)
      ActiveSupport::MessageEncryptor.new(key)
    end

    def generate_key(iv)
      ActiveSupport::KeyGenerator.new(password).generate_key(iv, key_length)
    end

    def key_length
      ActiveSupport::MessageEncryptor.key_len
    end

    def password
      Rails.application.secrets.secret_key_base
    end

    def decompose(encrypted_text)
      [
          encrypted_text[0...key_length],
          encrypted_text[key_length .. -1]
      ]
    end

  end


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

    def media_store_dir(media_type)
      if media_type == "VID"
        "virtual_pos/media/videos"
      elsif media_type == "IMG"
        "virtual_pos/media/images"
      end
    end

    def public_id
      "#{store_dir}/" + Cloudinary::Utils.random_public_id
    end

    def media_public_id(media_type)
      if media_type == "VID"
        "#{media_store_dir(media_type)}/" + Cloudinary::Utils.random_public_id
      elsif media_type == "IMG"
        "#{media_store_dir(media_type)}/" + Cloudinary::Utils.random_public_id
      end
    end
    # Add a white list of extensions which are allowed to be uploaded.
    # For images you might use something like this:
    def extension_whitelist
      %w(jpg jpeg gif png)
    end

    # Override the filename of the uploaded files:
    # Avoid using model.id or version_name here, see uploader/store.rb for details.

    def filename(file, public_id)
      if file.original_filename.present?
        file_extension = file.content_type.split("/")[1]
        "#{public_id}.#{file_extension}" if file_extension.present?
      end
      #"#{public_id}.#{file.extension}" #if original_filename.present?
    end


  end


end

