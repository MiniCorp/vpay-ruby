module Vpay
  class Response
    include Initializer

    attributes :response_type, :request_guid, :response_guid, :error_code,
      :message

    def self.new_from_xml(xml)
      parsed_xml = xml.kind_of?(String) ? Nokogiri.XML(xml) : xml
      r = new
      r.response_type = (parsed_xml).at('responseType').text if (parsed_xml).at('responseType')
      r.request_guid = (parsed_xml).at('requestGUID').text if (parsed_xml).at('requestGUID')
      r.response_guid = (parsed_xml).at('responseGUID').text if (parsed_xml).at('responseGUID')
      r.error_code = (parsed_xml).at('responseErrorcode').text.to_i if (parsed_xml).at('responseErrorcode')
      r.message = (parsed_xml).at('responseMessage').text if (parsed_xml).at('responseMessage')
      r
    end

    def success?
      error_code == 0
    end
  end
end
