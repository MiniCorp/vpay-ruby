Gem::Specification.new do |s|
  s.name        = 'vpay'
  s.version     = '0.1.2'
  s.date        = '2018-02-02'
  s.summary     = "vPAY"
  s.description = "A Ruby library to make use of the vPAY API."
  s.authors     = ["Steve Thornton"]
  s.email       = 'steve@minicorp.ie'
  s.files = [
    "lib/vpay/xsd/CrewFood.xsd",
    "lib/vpay/xsd/CrewFoodTypes.xsd",
    "lib/vpay/client.rb",
    "lib/vpay/config.rb",
    "lib/vpay/initializer.rb",
    "lib/vpay/request.rb",
    "lib/vpay/response.rb",
    "lib/vpay.rb",
    "vpay.gemspec",
    "spec/config_spec.rb",
    "spec/spec.opts",
    "spec/spec_helper.rb",
    "spec/request_spec.rb"
  ]
  s.homepage    = 'https://minicorp.ie'
  s.license     = 'MIT'
end
