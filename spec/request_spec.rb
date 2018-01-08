require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Vpay::Request" do
  before do
    @u_number = "steve@minicorp.ie"
    @amount = 1000
    @token = "4455579a-8a01-445e-933c-4edf16e3eaeb"
    @request_guid = "b5c564a5-4feb-4500-b004-abba3bf622bb"
  end

  describe "CancelPaymentMethodRequest" do
    it "should build the xml" do
      @request = Vpay::CancelPaymentMethodRequest.new(
        u_number: @u_number,
        token: @token
      )

      allow(@request).to receive(:request_guid).and_return(@request_guid)
      allow(@request).to receive(:encrypted).and_return("encrypted")

      expected_xml =
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
        "<crewFood xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns=\"http://www.RetailinMotion.com/crewfood/\">\n" +
        "  <crewFoodRequest>\n" +
        "    <requestType>CancelCard</requestType>\n" +
        "    <requestGUID>#{ @request_guid }</requestGUID>\n" +
        "    <requestCancelToken>\n" +
        "      <uNumber>encrypted</uNumber>\n" +
        "      <token>encrypted</token>\n" +
        "    </requestCancelToken>\n" +
        "  </crewFoodRequest>\n" +
        "</crewFood>\n"

      expect(@request.to_xml).to eq expected_xml
    end
  end

  describe "ProcessPaymentRequest" do
    it "should build the xml" do
      @request = Vpay::ProcessPaymentRequest.new(
        u_number: @u_number,
        amount: @amount,
        token: @token
      )

      allow(@request).to receive(:request_guid).and_return(@request_guid)
      allow(@request).to receive(:encrypted).and_return("encrypted")

      expected_xml =
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
        "<crewFood xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns=\"http://www.RetailinMotion.com/crewfood/\">\n" +
        "  <crewFoodRequest>\n" +
        "    <requestType>ProcessPayment</requestType>\n" +
        "    <requestGUID>#{ @request_guid }</requestGUID>\n" +
        "    <requestPayment>\n" +
        "      <uNumber>encrypted</uNumber>\n" +
        "      <amount>1000</amount>\n" +
        "      <currency>EUR</currency>\n" +
        "      <token>encrypted</token>\n" +
        "    </requestPayment>\n" +
        "  </crewFoodRequest>\n" +
        "</crewFood>\n"

      expect(@request.to_xml).to eq expected_xml
    end
  end
end
