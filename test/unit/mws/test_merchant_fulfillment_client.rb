require 'helper'
require 'mws/merchant_fulfillment/client'

class TestMWSMerchantFulfillmentClient < MiniTest::Test
  def setup
    @client = MWS::MerchantFulfillment::Client.new
  end

  def test_gets_eligible_shipping_services
    operation = {
      'Action' => 'GetEligibleShippingServices',
      'ShipmentRequestDetails.Id' => '123',
      'ShipmentRequestDetails.Foo.Bar' => 'baz'
    }

    @client.stub(:run, nil) do
      shipment_request_details = {
        id: '123',
        foo: { bar: 'baz' }
      }
      @client.get_eligible_shipping_services(shipment_request_details)
    end

    assert_equal operation, @client.operation
  end

  def test_creates_shipment
    operation = {
      'Action' => 'CreateShipment',
      'ShipmentRequestDetails.Id' => '123',
      'ShipmentRequestDetails.Foo.Bar' => 'baz',
      'ShippingServiceId' => 'FOO'
    }

    @client.stub(:run, nil) do
      shipment_request_details = {
        id: '123',
        foo: { bar: 'baz' }
      }
      @client.create_shipment(shipment_request_details, 'FOO')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_shipment
    operation = {
      'Action' => 'GetShipment',
      'ShipmentId' => '123'
    }

    @client.stub(:run, nil) do
      @client.get_shipment('123')
    end

    assert_equal operation, @client.operation
  end

  def test_cancels_shipment
    operation = {
      'Action' => 'CancelShipment',
      'ShipmentId' => '123'
    }

    @client.stub(:run, nil) do
      @client.cancel_shipment('123')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_service_status
    operation = {
      'Action' => 'GetServiceStatus'
    }

    @client.stub(:run, nil) do
      @client.get_service_status
    end

    assert_equal operation, @client.operation
  end
end
