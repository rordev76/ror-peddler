# Peddler

[![Build Status](https://travis-ci.org/hakanensari/peddler.svg)](https://travis-ci.org/hakanensari/peddler)
[![Code Climate](https://codeclimate.com/github/hakanensari/peddler/badges/gpa.svg)](https://codeclimate.com/github/hakanensari/peddler)
[![Test Coverage](https://codeclimate.com/github/hakanensari/peddler/badges/coverage.svg)](https://codeclimate.com/github/hakanensari/peddler/coverage)

**Peddler** is a Ruby interface to the [Amazon MWS API](https://developer.amazonservices.com/), a collection of web services that help Amazon sellers programmatically exchange data on their listings, orders, payments, reports, and more.

To use Amazon MWS, you must have an eligible seller account and register for MWS. This applies to developers as well.

Some MWS API sections may require additional authorisation from Amazon.

![Peddler](http://f.cl.ly/items/1G1N0A0a0v3a3h241c1Q/peddler.jpg)

## Usage

Require the library.

```ruby
require "peddler"
```

Create a client. Peddler provides one for each MWS API under an eponymous namespace.

```ruby
client = MWS::Orders::Client.new

# or the shorthand
client = MWS.orders
```

Each client requires valid MWS credentials. Set these globally in the shell.

```bash
export MWS_MARKETPLACE_ID=YOUR_MARKETPLACE_ID
export MWS_MERCHANT_ID=YOUR_MERCHANT_OR_SELLER_ID
export AWS_ACCESS_KEY_ID=YOUR_AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=YOUR_AWS_SECRET_ACCESS_KEY
```

You can now instantiate a client. The client will pick up credentials automatically from the environment.

```ruby
client = MWS.orders
```

If you are creating a [client for another seller](https://developer.amazonservices.com/gp/mws/faq.html#developForSeller), pass the latter's Merchant (Seller) ID and Marketplace ID along with the `MWSAuthToken` they obtained for you.

```ruby
client = MWS.orders(
  primary_marketplace_id: "Seller's Marketplace ID",
  merchant_id: "Seller's Merchant or Seller ID",
  auth_token: "Seller's MWS Authorisation Token"
)
```

Finally, if you do not want to use environment variables at all, you can set all credentials when or after creating the client.

```ruby
client = MWS.orders(
  primary_marketplace_id: "Your Marketplace ID",
  merchant_id: "Your Merchant or Seller ID",
  aws_access_key_id: "Your AWS Access Key ID",
  aws_secret_access_key: "Your AWS Secret Access Key",
)

client.primary_marketplace_id = "Another Marketplace ID"
```

Once you have a client with valid credentials, you should be able to make requests to the API. Clients map operation names in a flat structure. Methods have positional arguments for required input and keyword arguments for optional parameters. Both method and argument names are underscored but otherwise identical to the names of the corresponding operations and parameters documented in the API.

### Parser

Peddler wraps successful responses in a parser that handles both XML documents and flat files:

```ruby
parser = client.get_service_status
parser.parse # will return a Hash object
parser.dig('Status') # delegates to Hash#dig for convenience
```

You can swap the default parser with a purpose-built abstraction.

```ruby
MWS::Orders::Client.parser = MyParser
```

For a sample implementation, see my [MWS Orders](https://github.com/hakanensari/mws-orders) library.

### Debugging

To introspect requests, set the `EXCON_DEBUG` environment variable to a truthy value when making requests.

### Errors

Handle network errors caused by throttling or other transient issues by defining an error handler.

```ruby
MWS::Orders::Client.on_error do |e|
  if e.response.status == 503
    logger.warn e.response.message
  end
end
```

Alternatively, rescue.

```ruby
begin
  client.some_method
rescue Excon::Error::ServiceUnavailable => e
  logger.warn e.response.message
  retry
end
```

## The APIs

### Feeds

The MWS Feeds API lets you upload inventory and order data to Amazon. You can also use this API to get information about the processing of feeds.

- [Amazon references](https://developer.amazonservices.com/gp/mws/api.html?group=bde&section=feeds)
- [Peddler API docs](http://www.rubydoc.info/gems/peddler/MWS/Feeds/Client)

### Finances

The MWS Finances API enables you to obtain financial information relevant to your business with Amazon. You can obtain financial events for a given order, financial event group, or date range without having to wait until a statement period closes. You can also obtain financial event groups for a given date range.

- [Amazon references](https://developer.amazonservices.com/gp/mws/api.html?group=finances&section=finances)
- [Peddler API docs](http://www.rubydoc.info/gems/peddler/MWS/Finances/Client)

### Fulfillment Inbound Shipment

With the MWS Fulfillment Inbound Shipment API, you can create and update inbound shipments of inventory in the Amazon Fulfillment Network. You can also also request lists of inbound shipments or inbound shipment items based on criteria that you specify.

- [Amazon references](https://developer.amazonservices.com/gp/mws/api.html?group=fulfillment&section=inbound)
- [Peddler API docs](http://www.rubydoc.info/gems/peddler/MWS/FulfillmentInboundShipment/Client)

### Fulfillment Inventory

The MWS Fulfillment Inventory API can help you stay up-to-date on the availability of your inventory in the Amazon Fulfillment Network. The Fulfillment Inventory API reports real-time availability information for your Amazon Fulfillment Network inventory regardless of whether you are selling your inventory on Amazon's retail web site or through other retail channels.

- [Amazon references](https://developer.amazonservices.com/gp/mws/api.html?group=fulfillment&section=inventory)
- [Peddler API docs](http://www.rubydoc.info/gems/peddler/MWS/FulfillmentInventory/Client)

### Fulfillment Outbound Shipment

The MWS Fulfillment Outbound Shipment API enables you to fulfill orders placed through channels other than Amazon's retail web site, using your inventory in the Amazon Fulfillment Network. You can request previews of potential fulfillment orders that return estimated shipping fees and shipping dates based on shipping speed. You can get detailed item-level, shipment-level, and order-level information for any existing fulfillment order that you specify. You can also request lists of existing fulfillment orders based on when they were fulfilled and by the fulfillment method associated with them.

Support for creating and cancelling fulfillment orders has been implemented, but the rest of the API is not supported yet.

- [Amazon references](https://developer.amazonservices.com/gp/mws/api.html?group=fulfillment&section=outbound)
- [Peddler API docs](http://www.rubydoc.info/gems/peddler/MWS/FulfillmentOutboundShipment/Client)

### Merchant Fulfillment

The Merchant Fulfillment API provides programmatic access to Amazon’s fulfillment shipping services for sellers, including competitive rates with Amazon-partnered carriers. Sellers can find out what shipping services are available by submitting information about a proposed fulfillment shipment, such as package size and weight; shipment origin and destination; and delivery date requirements. Sellers can choose from the shipping service options returned by Amazon, and then receive shipping labels for fulfilling their orders.

- [Amazon references](https://developer.amazonservices.com/gp/mws/api.html?group=merchantfulfillment&section=merchantfulfillment)
- [Peddler API docs](http://www.rubydoc.info/gems/peddler/MWS/MerchantFulfillment/Client)

### Off Amazon Payments

The MWS Off-Amazon Payments API helps you to process payments for purchases made by buyers on your website using the Login and Pay with Amazon service. This API enables you to programmatically retrieve shipping and payment information provided by the buyer from their Amazon account. It allows you to authorize, capture, and refund payments, enabling a variety of payments scenarios.

You can switch the client to the sandbox environment:

```ruby
client = MWS.off_amazon_payments.sandbox
```

- [Amazon references](https://developer.amazonservices.com/gp/mws/api.html?group=offamazonpayments&section=offamazonpayments)
- [Official Ruby client](https://github.com/amzn/login-and-pay-with-amazon-sdk-ruby)
- [Peddler API docs](http://www.rubydoc.info/gems/peddler/MWS/OffAmazonPayments/Client)

### Orders

With the MWS Orders API, you can list orders created or updated during a time frame you specify or retrieve information about specific orders.

- [Amazon references](https://developer.amazonservices.com/gp/mws/api.html?group=orders&section=orders)
- [Peddler API docs](http://www.rubydoc.info/gems/peddler/MWS/Orders/Client)

### Products

The MWS Products API helps you get information to match your products to existing product listings on Amazon Marketplace websites and to make sourcing and pricing decisions for listing those products on Amazon Marketplace websites.

- [Amazon references](https://developer.amazonservices.com/gp/mws/api.html?group=products&section=products)
- [Peddler API docs](http://www.rubydoc.info/gems/peddler/MWS/Products/Client)

### Recommendations

The Recommendations API enables you to programmatically retrieve Amazon Selling Coach recommendations by recommendation category. A recommendation is an actionable, timely, and personalized opportunity to increase your sales and performance.

- [Amazon references](https://developer.amazonservices.com/gp/mws/api.html?group=recommendations&section=recommendations)
- [Peddler API docs](http://www.rubydoc.info/gems/peddler/MWS/Recommendations/Client)

### Reports

The Reports API lets you request reports about your inventory and orders.

- [Amazon references](https://developer.amazonservices.com/gp/mws/api.html?group=bde&section=reports)
- [Peddler API docs](http://www.rubydoc.info/gems/peddler/MWS/Reports/Client)

### Sellers

The Sellers API lets sellers retrieve information about their seller account, such as the marketplaces they participate in.

- [Amazon references](https://developer.amazonservices.com/gp/mws/api.html?group=sellers&section=sellers)
- [Peddler API docs](http://www.rubydoc.info/gems/peddler/MWS/Sellers/Client)

### Subscriptions

The Amazon MWS Subscriptions API section enables you to subscribe to receive notifications that are relevant to your business with Amazon. With the operations in the Subscriptions API section, you can register to receive important information from Amazon without having to poll the Amazon MWS service. Instead, the information is sent directly to you when an event occurs to which you are subscribed.

- [Amazon references](https://developer.amazonservices.com/gp/mws/api.html?group=subscriptions&section=subscriptions)
- [Peddler API docs](http://www.rubydoc.info/gems/peddler/MWS/Subscriptions/Client)
