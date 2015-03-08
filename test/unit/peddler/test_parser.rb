require 'helper'
require 'peddler/parser'

class TestPeddlerParser < MiniTest::Test
  def assert_parser(klass, *content_types)
    content_types.each do |content_type|
      res = OpenStruct.new(headers: { 'Content-Type' => content_type }, body: '')
      parser = Peddler::Parser.new(res)

      assert_kind_of klass, parser
    end
  end

  def test_parses_xml
    assert_parser Peddler::XMLParser, 'text/xml', 'text/xml; charset=UTF-8'
  end

  def test_parses_flat_files
    assert_parser Peddler::FlatFileParser, 'text/plain', 'application/octet-stream'
  end
end
