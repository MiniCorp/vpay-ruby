module Vpay
  class Config
    class << self
      attr_accessor :base_url, :use_ssl, :currency
    end
  end
end
