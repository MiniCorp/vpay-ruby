# vPAY Ruby Library

## Cancel Payment Method Request ##

```
request = Vpay::CancelPaymentMethodRequest.new(u_number: "test@example.com", token: "b5c564a5-4feb-4500-b004-abba3bf622bb")
request.process!
```

## Process Payment Request ##

```
request = Vpay::ProcessPaymentRequest.new(u_number: "test@example.com", amount: 1000, token: "b5c564a5-4feb-4500-b004-abba3bf622bb")
request.process!
```
