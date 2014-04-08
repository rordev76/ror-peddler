require 'helper'
require 'excon'
require 'peddler/client'

class ClientTest < MiniTest::Test
  module Parser
    def self.parse(res); res; end
  end

  def setup
    @body = 'foo'
    Excon.defaults[:mock] = true
    Excon.stub({}, body: @body, status: 200)

    @klass = Class.new(Peddler::Client)
    @client = @klass.new
    @client.marketplace_id = 'A1F83G8C2ARO7P'
    @client.operation('Foo')
  end

  def teardown
    Excon.stubs.clear
    Excon.defaults.delete(:mock)
  end

  def test_configures_path
    @klass.path('Foo')
    assert @client.aws_endpoint.match(/Foo$/)
  end

  def test_has_user_agent
    assert @client.connection.data[:headers].has_key?('User-Agent')
  end

  def test_inherits_parents_params
    assert_equal Peddler::Client.params, @klass.params
  end

  def test_configures
    @client.configure do |config|
      config.aws_access_key_id = '123'
    end

    assert_equal '123', @client.aws_access_key_id
  end

  def test_guards_against_bad_marketplace_id
    assert_raises(Peddler::Client::BadMarketplaceId) do
      client = Peddler::Client.new
      client.marketplace_id = '123'
      client.get
    end
  end

  def test_sets_content_type_header_for_latin_flat_file_body
    @client.body = 'foo'
    content_type = @client.headers.fetch('Content-Type')

    assert_equal 'text/tab-separated-values; charset=ISO-8859-1', content_type
  end

  def test_sets_content_type_header_for_chinese_flat_file_body
    @client.marketplace_id = 'AAHKV2X7AFYLW'
    @client.body = 'foo'
    content_type = @client.headers.fetch('Content-Type')

    assert_equal 'text/tab-separated-values; charset=UTF-16', content_type
  end

  def test_sets_content_type_header_for_japanese_flat_file_body
    @client.marketplace_id = 'A1VC38T7YXB528'
    @client.body = 'foo'
    content_type = @client.headers.fetch('Content-Type')

    assert_equal 'text/tab-separated-values; charset=Shift_JIS', content_type
  end

  def test_sets_content_type_header_for_xml_body
    @client.body = '<?xml version="1.0"?><Foo></Foo>'
    content_type = @client.headers.fetch('Content-Type')

    assert_equal 'text/xml', content_type
  end

  def test_runs_a_request
    res = @client.run(Parser)
    assert_equal @body, res.body
  end

  def test_streams_response
    chunks = ''
    streamer = -> (chunk, _, _) { chunks << chunk }
    @client.run(Parser, &streamer)

    assert_equal @body, chunks
  end
end
