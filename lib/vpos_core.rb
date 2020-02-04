require 'socket'
require 'timeout'
require 'date'
require "base64"

module VposCore

  class CoreConnect
    HEADER={'Content-Type'=>'application/json','timeout'=>'180'}
    #R_HEADER={'Content-Type'=>'application/json','timeout'=>'600'}
    URL = "http://10.105.85.78:7045" #"http://5.153.40.138:7045" #5.153.40.138, 10.105.85.78

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


end

