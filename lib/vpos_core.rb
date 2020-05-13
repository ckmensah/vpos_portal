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


end

