module Vpay
  class Config
    class << self
      attr_accessor :base_url, :is_dev, :use_ssl, :currency
    end
  end
end
