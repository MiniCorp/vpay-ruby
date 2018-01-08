module Vpay
  require 'securerandom'

  class Response
    class XSDValidationError < StandardError; end
    class DecryptionError < StandardError; end

    include Initializer

    attributes :response_type, :request_guid, :response_guid, :error_code,
      :message

    def initialize(xml)
      parsed_xml = parse_xml(xml)

      self.response_type = (parsed_xml).at('responseType').text if (parsed_xml).at('responseType')
      self.request_guid = (parsed_xml).at('requestGUID').text if (parsed_xml).at('requestGUID')
      self.response_guid = (parsed_xml).at('responseGUID').text if (parsed_xml).at('responseGUID')
      self.error_code = (parsed_xml).at('responseErrorcode').text.to_i if (parsed_xml).at('responseErrorcode')
      self.message = (parsed_xml).at('responseMessage').text if (parsed_xml).at('responseMessage')
    end

    def success?
      error_code == 0
    end

    def to_xml(&block)
      xml = Builder::XmlMarkup.new(:indent => 2)
      xml.instruct!
      xml.crewFood(
        "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
        "xmlns:xsd": "http://www.w3.org/2001/XMLSchema",
        "xmlns": "http://www.RetailinMotion.com/crewfood/"
      ) { |cf|
        cf.crewFoodResponse { |cfr|
          block.call(cfr)
        }
      }

      xml.target!
    end

    private

    def configure_xsd_validation_message_for_errors(xml_errors)
      error_message = String.new
      xml_errors.each do |error|
        if error_message.strip.empty?
          error_message = "XSD Validation - #{error.message}"
        else
          error_message << " #{error.message}"
        end
      end
      error_message
    end

    def parse_xml(xml)
      xml.kind_of?(String) ? Nokogiri.XML(xml) : xml
    end

    def response_guid
      SecureRandom.uuid
    end

    def validate_xml_against_schema(xml)
      xml_errors = xsd_schema.validate(xml)
      return true if xml_errors.empty?

      raise Vpay::Response::XSDValidationError.new configure_xsd_validation_message_for_errors(xml_errors)
    end

    def xsd_schema
      xsd_path = File.dirname(__FILE__) + '/xsd/CrewFood.xsd'
      Nokogiri::XML::Schema(File.open(xsd_path))
    end

    class ReceiveTokenResponse < Response
      class ResponseToken
        include Initializer
        attributes :u_number, :token, :partial_pan, :payment_type
      end

      FIELDS_TO_DECRYPT = ['uNumber', 'token', 'partialPAN', 'paymentType']

      attributes :response_token

      def initialize(xml, private_key)
        @private_key = private_key
        parsed_xml = parse_xml(xml)
        super(parsed_xml)

        begin
          parsed_xml = decrypt_xml_fields(parsed_xml)
        rescue Vpay::Response::DecryptionError => error
          self.error_code = 2001
          self.message = error.message
          return
        end

        begin
          validate_xml_against_schema(parsed_xml)
        rescue Vpay::Response::XSDValidationError => error
          self.error_code = 2000
          self.message = error.message
          return
        end

        self.message = "Token received successfully"

        rt = ResponseToken.new
        rt.u_number = (parsed_xml).at('uNumber').text if (parsed_xml).at('uNumber')
        rt.token = (parsed_xml).at('token').text if (parsed_xml).at('token')
        rt.partial_pan = (parsed_xml).at('partialPAN').text if (parsed_xml).at('partialPAN')
        rt.payment_type = (parsed_xml).at('paymentType').text if (parsed_xml).at('paymentType')
        
        self.response_token = rt
      end

      def to_xml
        super do |r|
          r.responseType response_type if response_type
          r.requestGUID request_guid if request_guid
          r.responseGUID response_guid if response_guid
          r.responseErrorcode error_code if error_code
          r.responseMessage message
        end
      end

      private

      def decrypt_xml_fields(xml)
        FIELDS_TO_DECRYPT.each do |field|
          if xml.at(field)
            encrypted_field = xml.at(field).text
            xml.at(field).content = decrypt(encrypted_field)
          end
        end
        xml
      end

      def decrypt(text)
        begin
          key = OpenSSL::PKey::RSA.new(@private_key)
          data = key.private_decrypt(Base64.strict_decode64(text))
        rescue Exception => error
          raise Vpay::Response::DecryptionError.new "Decryption Error - please check your private key is correct"
        end
      end
    end

    class PublicKeyResponse < Response
      def initialize(xml, public_key)
        parsed_xml = parse_xml(xml)

        self.response_type = "GetPublicKey"
        self.response_guid = response_guid
        self.error_code = 0
        self.message = public_key

        begin
          validate_xml_against_schema(parsed_xml)
        rescue Vpay::Response::XSDValidationError => error
          self.error_code = 2000
          self.message = error.message
          return
        end

        request_type = (parsed_xml).at('requestType').text
        if request_type.downcase != "getpublickey"
          self.error_code = 2000
          self.message = "XSD Validation - Expected GetPublicKey. Received #{request_type}."
        end

        self.request_guid = (parsed_xml).at('requestGUID').text if (parsed_xml).at('requestGUID')
      end

      def to_xml
        super do |r|
          r.responseType response_type if response_type
          r.requestGUID request_guid if request_guid
          r.responseGUID response_guid if response_guid
          r.responseErrorcode error_code if error_code
          r.responseMessage message if message
        end
      end
    end
  end
end
