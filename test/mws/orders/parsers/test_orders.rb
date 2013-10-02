require 'parser_helper'
require 'mws/orders/parsers/orders'

class OrdersParserTest < ParserTest
  def setup
    node = fixture('orders').xpath('//xmlns:Orders')
    @orders = MWS::Orders::Parsers::Orders.new(node)
  end

  def test_has_orders
    refute_empty @orders.to_a
    @orders.each { |order| assert_kind_of MWS::Orders::Parsers::Order, order }
  end
end
