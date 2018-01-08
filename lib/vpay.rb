require 'nokogiri'
require 'net/https'
require 'builder'

$:.unshift(File.dirname(__FILE__))
require 'vpay/initializer'
require 'vpay/config'
require 'vpay/client'

require 'vpay/request'
require 'vpay/response'
