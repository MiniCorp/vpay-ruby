module Vpay
  class Client
    class << self
      def build_xml(type, &block)
        xml = Builder::XmlMarkup.new(:indent => 2)
        xml.instruct!
        xml.crewFood(
          "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
          "xmlns:xsd": "http://www.w3.org/2001/XMLSchema",
          "xmlns": "http://www.RetailinMotion.com/crewfood/"
        ) { |cf|
          cf.crewFoodRequest { |cfr|
            block.call(cfr)
          }
        }

        xml.target!
      end

      def call(base_url, path, use_ssl, xml)
        puts "BASE_URL: #{base_url}"
        puts "PATH: #{path}"
        puts "USE_SSL: #{use_ssl}"
        h = Net::HTTP.new(base_url, use_ssl ? 443 : 80)
        h.use_ssl = use_ssl
        response = h.request_post(path, xml, {'Content-Type' =>'application/xml'})
        result = Nokogiri.XML(response.body)
        result
      end

      def parse(response)
        status = (response/:result).inner_html
        raise VpayError, "#{(response/:message).inner_html} (#{status})" unless status == "0"
      end
    end
  end
end
