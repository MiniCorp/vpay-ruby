module Vpay
  class PaymentMethod
    include Initializer

    attributes :token, :partial_pan, :payment_type
  end
end
