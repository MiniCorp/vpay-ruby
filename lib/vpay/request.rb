module Vpay
  require 'securerandom'
  require 'openssl'
  require 'base64'

  class Request
    include Initializer

    attributes :base_url, :use_ssl, :currency

    def initialize(hash = {})
      super(hash)
      self.base_url ||= Vpay::Config.base_url || '0.0.0.0'
      self.use_ssl ||= Vpay::Config.use_ssl || false
      self.currency ||= Vpay::Config.currency || 'EUR'
    end

    def process!(path)
      Vpay::Response.new(
        Vpay::Client.call(base_url, path, use_ssl, to_xml)
      )
    end

    protected

    def encrypt(text)
      key = OpenSSL::PKey::RSA.new(public_key)
      Base64.strict_encode64(key.public_encrypt(text))
    end

    def request_guid
      SecureRandom.uuid
    end

    def request_type
      self.class.name.split('::').last.downcase
    end

    def to_xml(&block)
      xml = Vpay::Client.build_xml(request_type) do |r|
        block.call(r)
      end
    end

    private

    def public_key
      @public_key ||= request_public_key
    end

    def request_public_key
      xml = Vpay::Client.build_xml("publickey") do |r|
        r.requestType "GetPublicKey"
        r.requestGUID request_guid
      end

      response = Vpay::Response.new(
        Vpay::Client.call(base_url, '/LHCrewFood/Key/Get', use_ssl, xml)
      )

      response.message
    end
  end

  class CancelPaymentMethodRequest < Request
    attributes :u_number, :token

    def initialize(hash = {})
      super(hash)
    end

    def to_xml
      super do |r|
        r.requestType "CancelCard"
        r.requestGUID request_guid
        r.requestCancelToken { |rct|
          rct.uNumber encrypt(u_number)
          rct.token encrypt(token)
        }
      end
    end

    def process!
      super '/LHCrewFood/Token/Cancel'
    end
  end

  class ProcessPaymentRequest < Request
    attributes :u_number, :token, :amount, :airport_code

    def initialize(hash = {})
      super(hash)
    end

    def to_xml
      super do |r|
        r.requestType "ProcessPayment"
        r.requestGUID request_guid
        r.requestPayment { |rp|
          rp.uNumber encrypt(u_number)
          rp.amount amount
          rp.currency currency
          rp.token encrypt(token)
          rp.airportCode airport_code
        }
      end
    end

    def process!
      super '/LHCrewFood/Token/ProcessPayment'
    end
  end
end
