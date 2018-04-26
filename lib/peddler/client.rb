# frozen_string_literal: true

require 'forwardable'
require 'jeff'
require 'peddler/errors/builder'
require 'peddler/marketplace'
require 'peddler/operation'
require 'peddler/parser'

module Peddler
  # An abstract client
  #
  # Subclass to implement an MWS API section.
  class Client
    extend Forwardable
    include Jeff

    # The MWSAuthToken used to access another seller's account
    # @return [String]
    attr_accessor :auth_token

    # The merchant's Seller ID
    # @return [String]
    attr_accessor :merchant_id

    # The Marketplace ID where merchant is signed up on
    # @return [String]
    attr_accessor :primary_marketplace_id

    # @api private
    attr_writer :path

    # @api private
    attr_writer :version

    # The body of the HTTP request
    # @return [String]
    attr_reader :body

    alias configure tap

    def_delegators :primary_marketplace, :host, :encoding

    params(
      'SellerId' => -> { merchant_id },
      'MWSAuthToken' => -> { auth_token },
      'Version' => -> { version }
    )

    class << self
      # @api private
      attr_accessor :error_handler, :parser

      # @api private
      def path(path = nil)
        path ? @path = path : @path ||= '/'
      end

      # @api private
      def version(version = nil)
        version ? @version = version : @version ||= nil
      end

      # Sets an error handler
      # @yieldparam [Excon::Error] error
      def on_error(&blk)
        @error_handler = blk
      end

      private

      def inherited(base)
        base.parser = parser
        base.error_handler = error_handler
        base.path(path)
        base.params(params)
      end
    end

    self.error_handler = ->(error) { raise error }
    self.parser = Parser

    # Creates a new client instance
    #
    # @param [Hash] opts
    # @option opts [String] :primary_marketplace_id
    # @option opts [String] :merchant_id
    # @option opts [String] :aws_access_key_id
    # @option opts [String] :aws_secret_access_key
    # @option opts [String] :auth_token
    def initialize(opts = {})
      opts.each { |k, v| send("#{k}=", v) }
    end

    # @api private
    def aws_endpoint
      "https://#{host}#{path}"
    end

    # @api private
    def primary_marketplace
      @primary_marketplace ||= find_primary_marketplace
    end

    # The HTTP path of the API
    # @!parse attr_reader :path
    # @return [String]
    def path
      @path ||= self.class.path
    end

    # @api private
    def version
      @version ||= self.class.version
    end

    # @!parse attr_writer :body
    def body=(str)
      str ? add_content(str) : clear_content!
    end

    # @api private
    def defaults
      @defaults ||= { expects: 200 }
    end

    # @api private
    def headers
      @headers ||= {}
    end

    # Sets an error handler
    # @yieldparam [Excon::Error] error
    def on_error(&blk)
      @error_handler = blk
    end

    # @api private
    def error_handler
      (@error_handler ||= nil) || self.class.error_handler
    end

    # @api private
    def operation(action = nil)
      action ? @operation = Operation.new(action) : @operation
    end

    # @api private
    def run
      opts = build_options
      opts.store(:response_block, Proc.new) if block_given?
      res = post(opts)
      self.body = nil if res.status == 200

      parser.new(res, encoding)
    rescue ::Excon::Error::HTTPStatus => error
      handle_http_status_error(error)
    end

    private

    def find_primary_marketplace
      Marketplace.find(primary_marketplace_id)
    end

    def clear_content!
      headers.delete('Content-Type')
      @body = nil
    end

    def add_content(content)
      if content.start_with?('<?xml')
        headers['Content-Type'] = 'text/xml'
        @body = content
      else
        headers['Content-Type'] =
          "text/tab-separated-values; charset=#{encoding}"
        @body = content.encode(encoding)
      end
    end

    def extract_options(args)
      args.last.is_a?(Hash) ? args.pop : {}
    end

    def parser
      self.class.parser
    end

    def build_options
      opts = defaults.merge(query: operation, headers: headers)
      body ? opts.update(body: body) : opts
    end

    def handle_http_status_error(error)
      new_error = Errors::Builder.call(error)
      new_error ? error_handler.call(new_error) : raise
    end
  end
end
