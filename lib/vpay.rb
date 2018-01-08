require 'nokogiri'
require 'net/https'
require 'builder'
require 'byebug'

$:.unshift(File.dirname(__FILE__))
require 'vpay/initializer'
require 'vpay/config'
require 'vpay/client'

require 'vpay/request'
require 'vpay/response'

module RealEx
  class UnknownError < StandardError; end
end
