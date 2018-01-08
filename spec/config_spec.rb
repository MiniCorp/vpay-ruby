require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Vpay::Config" do
  before do
    Vpay::Config.base_url = "0.0.0.0"
    Vpay::Config.use_ssl = false
    Vpay::Config.currency = "EUR"
  end

  it "should set the base_url config" do
    expect(Vpay::Config.base_url).to eq "0.0.0.0"
  end

  it "should set the use_ssl config" do
    expect(Vpay::Config.use_ssl).to eq false
  end

  it "should set the currency config" do
    expect(Vpay::Config.currency).to eq "EUR"
  end
end
