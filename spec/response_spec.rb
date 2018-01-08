require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Vpay::Response" do
  before do
    @request_guid = "8d67312e-3ef3-4568-a44d-edfa5e03c7e7"
    @response_guid = "b5c564a5-4feb-4500-b004-abba3bf622bb"
    @public_key = "-----BEGIN PUBLIC KEY-----\nLOTSOFKEYDATA\n-----END PUBLIC KEY-----"
  end

  describe "PublicKeyResponse" do
    it "should build the xml" do
      xml_body =
        '<?xml version="1.0" encoding="UTF-8"?>' +
          '<crewFood xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.RetailinMotion.com/crewfood/">' +
            '<crewFoodRequest>' +
              '<requestType>GetPublicKey</requestType>' +
              "<requestGUID>#{ @request_guid }</requestGUID>" +
            '</crewFoodRequest>' +
          '</crewFood>'

      @request = Vpay::Response::PublicKeyResponse.new(xml_body, @public_key)

      allow(@request).to receive(:response_guid).and_return(@response_guid)

      expected_xml =
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
        "<crewFood xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns=\"http://www.RetailinMotion.com/crewfood/\">\n" +
        "  <crewFoodResponse>\n" +
        "    <responseType>GetPublicKey</responseType>\n" +
        "    <requestGUID>#{ @request_guid }</requestGUID>\n" +
        "    <responseGUID>#{ @response_guid }</responseGUID>\n" +
        "    <responseErrorcode>0</responseErrorcode>\n" +
        "    <responseMessage>#{ @public_key }</responseMessage>\n" +
        "  </crewFoodResponse>\n" +
        "</crewFood>\n"

      expect(@request.to_xml).to eq expected_xml
    end
  end
end
