Gem::Specification.new do |s|
  s.name        = 'vpay'
  s.version     = '0.1.6'
  s.date        = '2023-04-03'
  s.summary     = "vPAY"
  s.description = "A Ruby library to make use of the vPAY API."
  s.authors     = ["Brian Kenny"]
  s.email       = 'brian@minicorphq.com'
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
  s.homepage    = 'https://minicorphq.com'
  s.license     = 'MIT'
end
