# frozen_string_literal: true

require 'helper'
require 'mws/fulfillment_inbound_shipment/client'

class TestMWSFulfillmentInboundShipmentClient < MiniTest::Test
  def setup
    @client = MWS::FulfillmentInboundShipment::Client.new
  end

  def test_gets_inbound_guidance_for_sku
    operation = {
      'Action' => 'GetInboundGuidanceForSKU',
      'MarketplaceId' => 'ATVPDKIKX0DER',
      'SellerSKUList.Id.1' => 'us001'
    }

    @client.stub(:run, nil) do
      @client.get_inbound_guidance_for_sku('ATVPDKIKX0DER', 'us001')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_inbound_guidance_for_asin
    operation = {
      'Action' => 'GetInboundGuidanceForASIN',
      'MarketplaceId' => 'ATVPDKIKX0DER',
      'ASINList.Id.1' => 'B00005N5PF'
    }

    @client.stub(:run, nil) do
      @client.get_inbound_guidance_for_asin('ATVPDKIKX0DER', 'B00005N5PF')
    end

    assert_equal operation, @client.operation
  end

  def test_creates_inbound_shipment_plan
    operation = {
      'Action' => 'CreateInboundShipmentPlan',
      'LabelPrepPreference' => 'SELLER_LABEL',
      'ShipFromAddress.Name' => 'test1',
      'ShipFromAddress.City' => 'Seattle',
      'ShipFromAddress.CountryCode' => 'US',
      'InboundShipmentPlanRequestItems.member.1.SellerSKU' => 'SKU00001',
      'InboundShipmentPlanRequestItems.member.1.Quantity' => '1',
      'InboundShipmentPlanRequestItems.member.1.PrepDetailsList.member.1.PrepInstruction' => 'Taping',
      'InboundShipmentPlanRequestItems.member.1.PrepDetailsList.member.1.PrepOwner' => 'AMAZON'
    }

    @client.stub(:run, nil) do
      address = {
        'Name' => 'test1',
        'City' => 'Seattle',
        'CountryCode' => 'US'
      }
      request_items = [
        {
          'SellerSKU' => 'SKU00001',
          'Quantity' => '1',
          'PrepDetailsList' => [{ 'PrepInstruction' => 'Taping', 'PrepOwner' => 'AMAZON' }]
        }
      ]
      @client.create_inbound_shipment_plan(address, request_items,
                                           label_prep_preference: 'SELLER_LABEL')
    end

    assert_equal operation, @client.operation
  end

  def test_creates_inbound_shipment
    operation = {
      'Action' => 'CreateInboundShipment',
      'ShipmentId' => '1',
      'InboundShipmentHeader.Foo' => '1',
      'InboundShipmentItems.member.1.Bar' => '2'
    }

    @client.stub(:run, nil) do
      @client.create_inbound_shipment('1', { 'Foo' => '1' }, inbound_shipment_items: [{ 'Bar' => '2' }])
    end

    assert_equal operation, @client.operation
  end

  def test_updates_inbound_shipment
    operation = {
      'Action' => 'UpdateInboundShipment',
      'ShipmentId' => '1',
      'InboundShipmentHeader.Foo' => '1',
      'InboundShipmentItems.member.1.Bar' => '2'
    }

    @client.stub(:run, nil) do
      @client.update_inbound_shipment('1', { 'Foo' => '1' }, inbound_shipment_items: [{ 'Bar' => '2' }])
    end

    assert_equal operation, @client.operation
  end

  def test_gets_preorder_info
    operation = {
      'Action' => 'GetPreorderInfo',
      'ShipmentId' => '1'
    }

    @client.stub(:run, nil) do
      @client.get_preorder_info('1')
    end

    assert_equal operation, @client.operation
  end

  def test_confirms_preorder
    operation = {
      'Action' => 'ConfirmPreorder',
      'ShipmentId' => '1',
      'NeedByDate' => '2015-12-27'
    }

    @client.stub(:run, nil) do
      @client.confirm_preorder('1', Date.new(2015, 12, 27))
    end

    assert_equal operation, @client.operation
  end

  def test_gets_prep_instructions_for_sku
    operation = {
      'Action' => 'GetPrepInstructionsForSKU',
      'ShipToCountryCode' => 'US',
      'SellerSKUList.Id.1' => 'ca_001'
    }

    @client.stub(:run, nil) do
      @client.get_prep_instructions_for_sku('US', 'ca_001')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_prep_instructions_for_asin
    operation = {
      'Action' => 'GetPrepInstructionsForASIN',
      'ShipToCountryCode' => 'US',
      'ASINList.Id.1' => 'B00005N5PF',
      'ASINList.Id.2' => 'B0INVALIDF'
    }

    @client.stub(:run, nil) do
      @client.get_prep_instructions_for_asin('US', 'B00005N5PF', 'B0INVALIDF')
    end

    assert_equal operation, @client.operation
  end

  def test_puts_transport_content_with_package_list
    transport_details = {
      parcel_data: {
        package_list: [
          {
            tracking_id: '123'
          }
        ]
      }
    }

    operation = {
      'Action' => 'PutTransportContent',
      'ShipmentId' => '1',
      'IsPartnered' => true,
      'ShipmentType' => 'Foo',
      'TransportDetails.ParcelData.PackageList.member.1.TrackingId' => '123'
    }

    @client.stub(:run, nil) do
      @client.put_transport_content('1', true, 'Foo', transport_details)
    end

    assert_equal operation, @client.operation
  end

  def test_puts_transport_content_with_pallet_list
    transport_details = {
      parcel_data: {
        pallet_list: [
          {
            tracking_id: '123'
          }
        ]
      }
    }

    operation = {
      'Action' => 'PutTransportContent',
      'ShipmentId' => '1',
      'IsPartnered' => true,
      'ShipmentType' => 'Foo',
      'TransportDetails.ParcelData.PalletList.member.1.TrackingId' => '123'
    }

    @client.stub(:run, nil) do
      @client.put_transport_content('1', true, 'Foo', transport_details)
    end

    assert_equal operation, @client.operation
  end

  def test_estimates_transport_request
    operation = {
      'Action' => 'EstimateTransportRequest',
      'ShipmentId' => '1'
    }

    @client.stub(:run, nil) do
      @client.estimate_transport_request('1')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_transport_request
    operation = {
      'Action' => 'GetTransportContent',
      'ShipmentId' => '1'
    }

    @client.stub(:run, nil) do
      @client.get_transport_content('1')
    end

    assert_equal operation, @client.operation
  end

  def test_confirms_transport_request
    operation = {
      'Action' => 'ConfirmTransportRequest',
      'ShipmentId' => '1'
    }

    @client.stub(:run, nil) do
      @client.confirm_transport_request('1')
    end

    assert_equal operation, @client.operation
  end

  def test_voids_transport_request
    operation = {
      'Action' => 'VoidTransportRequest',
      'ShipmentId' => '1'
    }

    @client.stub(:run, nil) do
      @client.void_transport_request('1')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_package_labels
    operation = {
      'Action' => 'GetPackageLabels',
      'ShipmentId' => '1',
      'PageType' => '2'
    }

    @client.stub(:run, nil) do
      @client.get_package_labels('1', '2')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_unique_package_labels
    operation = {
      'Action' => 'GetUniquePackageLabels',
      'ShipmentId' => 'FBAQFGQZ',
      'PageType' => 'PackageLabel_Letter_6',
      'PackageLabelsToPrint.member.1' => 'CartonA',
      'PackageLabelsToPrint.member.2' => 'CartonB',
      'PackageLabelsToPrint.member.3' => 'CartonC',
      'PackageLabelsToPrint.member.4' => 'CartonD'
    }

    @client.stub(:run, nil) do
      @client.get_unique_package_labels(
        'FBAQFGQZ',
        'PackageLabel_Letter_6',
        %w[CartonA CartonB CartonC CartonD]
      )
    end

    assert_equal operation, @client.operation
  end

  def test_gets_pallet_labels
    operation = {
      'Action' => 'GetPalletLabels',
      'ShipmentId' => 'FBAQFGQZ',
      'PageType' => 'PackageLabel_Letter_4',
      'NumberOfPallets' => 4
    }

    @client.stub(:run, nil) do
      @client.get_pallet_labels('FBAQFGQZ', 'PackageLabel_Letter_4', 4)
    end

    assert_equal operation, @client.operation
  end

  def test_gets_bill_of_lading
    operation = {
      'Action' => 'GetBillOfLading',
      'ShipmentId' => '1'
    }

    @client.stub(:run, nil) do
      @client.get_bill_of_lading('1')
    end

    assert_equal operation, @client.operation
  end

  def test_lists_inbound_shipments
    operation = {
      'Action' => 'ListInboundShipments',
      'ShipmentStatusList.member.1' => 'Foo',
      'ShipmentIdList.member.1' => 'Bar'
    }

    @client.stub(:run, nil) do
      @client.list_inbound_shipments(
        shipment_status_list: ['Foo'],
        shipment_id_list: ['Bar']
      )
    end

    assert_equal operation, @client.operation
  end

  def test_lists_inbound_shipments_by_next_token
    operation = {
      'Action' => 'ListInboundShipmentsByNextToken',
      'NextToken' => '1'
    }

    @client.stub(:run, nil) do
      @client.list_inbound_shipments_by_next_token('1')
    end

    assert_equal operation, @client.operation
  end

  def test_lists_inbound_shipment_items
    operation = {
      'Action' => 'ListInboundShipmentItems'
    }

    @client.stub(:run, nil) do
      @client.list_inbound_shipment_items
    end

    assert_equal operation, @client.operation
  end

  def test_lists_inbound_shipment_items_by_next_token
    operation = {
      'Action' => 'ListInboundShipmentItemsByNextToken',
      'NextToken' => '1'
    }

    @client.stub(:run, nil) do
      @client.list_inbound_shipment_items_by_next_token('1')
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
