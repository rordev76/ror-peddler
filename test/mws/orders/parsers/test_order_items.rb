require 'parser_helper'
require 'mws/orders/parsers/order_items'

class OrderItemsParserTest < ParserTest
  def setup
    node = fixture('orders/order_items').xpath('//xmlns:ListOrderItemsResult')
    @order_items = MWS::Orders::Parsers::OrderItems.new(node)
  end

  def test_has_order_items
    refute_empty @order_items.to_a
    @order_items.each { |order_item| assert_kind_of MWS::Orders::Parsers::OrderItem, order_item }
  end

  def test_has_token
    assert @order_items.has_next_token?
  end
end
