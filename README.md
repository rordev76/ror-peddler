
# Peddler

[![Build Status](https://travis-ci.org/hakanensari/peddler.svg)](https://travis-ci.org/hakanensari/peddler)
[![Code Climate](http://img.shields.io/codeclimate/github/hakanensari/peddler.svg)](https://codeclimate.com/github/hakanensari/peddler)
[![Coverage Status](http://img.shields.io/coveralls/hakanensari/peddler/master.svg)](https://coveralls.io/r/hakanensari/peddler)

**Peddler** is a Ruby interface to the [Amazon MWS API](https://developer.amazonservices.com/), a collection of web services that help Amazon sellers programmatically exchange data on their listings, orders, payments, reports, and more.

To use Amazon MWS, you must have an eligible seller account.

![Peddler](http://f.cl.ly/items/231z2m0r1Q2o2q1n0w1N/peddler.jpg)

## Configuration

Require the library and instantiate a client:

```ruby
require 'peddler'
client = MWS.orders
```

You can set up credentials when instantiating:

```ruby
client = MWS.orders(
  marketplace_id: 'A1F83G8C2ARO7P',
  merchant_id: 'A2A9WNXCU02UZW',
  aws_access_key_id: 'AKIVICHZMZ2JRSSLC27W',
  aws_secret_access_key: 'rOMa3ydPBTJ3AD0bxERTOX0Fv0fAC6Q0s6/czMZO'
)
```

Alternatively, use environment variables if you only have a single set of credentials:

```sh
export MWS_MARKETPLACE_ID="A1F83G8C2ARO7P"
export MWS_MERCHANT_ID="A2A9WNXCU02UZW"
export AWS_ACCESS_KEY_ID="AKIVICHZMZ2JRSSLC27W"
export AWS_SECRET_ACCESS_KEY="rOMa3ydPBTJ3AD0bxERTOX0Fv0fAC6Q0s6/czMZO"
```

## Usage

### Cart Information

With the MWS Cart Information API, you can retrieve shopping carts that your Amazon Webstore customers have created. The Cart Information API enables you to programmatically integrate Amazon Webstore cart information with your CRM systems, marketing applications, and other systems that require cart data.

[Read the API](http://rubydoc.info/github/hakanensari/peddler/MWS/CartInformation/Client)

### Customer Information

With the MWS Customer Information API, you can retrieve information from the customer accounts of your Amazon Webstore customers. This customer information includes customer name, contact information, customer account type, and associated Amazon Webstore marketplaces. The Customer Information API enables you to programmatically integrate Amazon Webstore customer account information with your CRM systems, marketing applications, and other systems that require customer data.

[Read the API](http://rubydoc.info/github/hakanensari/peddler/MWS/CustomerInformation/Client)

### Feeds

The MWS Feeds API lets you upload inventory and order data to Amazon. You can also use this API to get information about the processing of feeds.

[Read the API](http://rubydoc.info/github/hakanensari/peddler/MWS/Feeds/Client)

### Fulfillment Inbound Shipment

With the MWS Fulfillment Inbound Shipment API, you can create and update inbound shipments of inventory in the Amazon Fulfillment Network. You can also also request lists of inbound shipments or inbound shipment items based on criteria that you specify.

[Read the API](http://rubydoc.info/github/hakanensari/peddler/MWS/FulfillmentInboundShipment/Client)

### Fulfillment Inventory

The MWS Fulfillment Inventory API can help you stay up-to-date on the availability of your inventory in the Amazon Fulfillment Network. The Fulfillment Inventory API reports real-time availability information for your Amazon Fulfillment Network inventory regardless of whether you are selling your inventory on Amazon's retail web site or through other retail channels.

[Read the API](http://rubydoc.info/github/hakanensari/peddler/MWS/FulfillmentInventory/Client)

### Fulfillment Outbound Shipment

The MWS Fulfillment Outbound Shipment API enables you to fulfill orders placed through channels other than Amazon's retail web site, using your inventory in the Amazon Fulfillment Network. You can request previews of potential fulfillment orders that return estimated shipping fees and shipping dates based on shipping speed. You can get detailed item-level, shipment-level, and order-level information for any existing fulfillment order that you specify. You can also request lists of existing fulfillment orders based on when they were fulfilled and by the fulfillment method associated with them.

Support for creating and cancelling fulfillment orders has been implemented, but the rest of the API is not supported yet.

[Read the API](http://rubydoc.info/github/hakanensari/peddler/MWS/FulfillmentOutboundShipment/Client)

### Off Amazon Payments

The MWS Off-Amazon Payments API helps you to process payments for purchases made by buyers on your website using the Login and Pay with Amazon service. This API enables you to programmatically retrieve shipping and payment information provided by the buyer from their Amazon account. It allows you to authorize, capture, and refund payments, enabling a variety of payments scenarios.

You can switch the client to the sandbox environment:

```ruby
client = MWS.off_amazon_payments.sandbox
```

[Read the API](http://rubydoc.info/github/hakanensari/peddler/MWS/OffAmazonPayments/Client)

### Orders

With the MWS Orders API, you can list orders created or updated during a time frame you specify or retrieve information about specific orders.

[Read the API](http://rubydoc.info/github/hakanensari/peddler/MWS/Orders/Client)

### Products

The MWS Products API helps you get information to match your products to existing product listings on Amazon Marketplace websites and to make sourcing and pricing decisions for listing those products on Amazon Marketplace websites.

[Read the API](http://rubydoc.info/github/hakanensari/peddler/MWS/Products/Client)

### Recommendations

The Recommendations API enables you to programmatically retrieve Amazon Selling Coach recommendations by recommendation category. A recommendation is an actionable, timely, and personalized opportunity to increase your sales and performance.

[Read the API](http://rubydoc.info/github/hakanensari/peddler/MWS/Recommendations/Client)

### Reports

The Reports API lets you request reports about your inventory and orders.

[Read the API](http://rubydoc.info/github/hakanensari/peddler/MWS/Reports/Client)

### Sellers

The Sellers API lets sellers retrieve information about their seller account, such as the marketplaces they participate in.

[Read the API](http://rubydoc.info/github/hakanensari/peddler/MWS/Sellers/Client)

### Subscriptions

The Amazon MWS Subscriptions API section enables you to subscribe to receive notifications that are relevant to your business with Amazon. With the operations in the Subscriptions API section, you can register to receive important information from Amazon without having to poll the Amazon MWS service. Instead, the information is sent directly to you when an event occurs to which you are subscribed.

[Read the API](http://rubydoc.info/github/hakanensari/peddler/MWS/Subscriptions/Client)
