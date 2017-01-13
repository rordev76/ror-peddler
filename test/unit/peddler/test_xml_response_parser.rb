require 'helper'
require 'peddler/xml_response_parser'

class TestPeddlerXMLResponseParser < MiniTest::Test
  def test_parses_responses
    body = '<Response><Result><Foo>Bar</Foo></Result></Response>'
    parser = Peddler::XMLResponseParser.new(response(body))
    assert_equal 'Bar', parser.parse['Foo']
  end

  def test_parses_messages
    body = '<Response><Message><Foo>Bar</Foo></Message></Response>'
    parser = Peddler::XMLResponseParser.new(response(body))
    assert_equal 'Bar', parser.parse['Foo']
  end

  def test_parses_reports
    body = '<fooReports><fooReport><foo>Bar</foo></fooReport></fooReports>'
    parser = Peddler::XMLResponseParser.new(response(body))
    assert_equal 'Bar', parser.parse['foo']
  end

  def test_parses_next_token
    body = '<Response><Result><NextToken>123</NextToken></Result></Response>'
    parser = Peddler::XMLResponseParser.new(response(body))
    assert_equal '123', parser.next_token
  end

  private

  def response(body)
    OpenStruct.new(
      body: body,
      headers: { 'Content-Type' => 'text/xml', 'Content-Length' => '78' }
    )
  end
end
