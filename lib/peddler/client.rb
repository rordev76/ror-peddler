require 'forwardable'
require 'jeff'
require 'peddler/marketplace'
require 'peddler/operation'
require 'peddler/parser'

module Peddler
  # @abstract Subclass to implement an MWS API section.
  class Client
    extend Forwardable
    include Jeff

    attr_writer :merchant_id, :marketplace_id, :path
    attr_reader :body

    alias_method :configure, :tap

    def_delegators :marketplace, :host, :encoding

    params('SellerId' => -> { merchant_id })

    def self.parser
      @parser ||= Parser
    end

    def self.parser=(parser)
      @parser = parser
    end

    def self.path(path = nil)
      path ? @path = path : @path ||= '/'
    end

    def self.inherited(base)
      base.params(params)
    end

    def initialize(opts = {})
      opts.each { |k, v| send("#{k}=", v) }
    end

    def aws_endpoint
      "https://#{host}#{path}"
    end

    def marketplace_id
      @marketplace_id ||= ENV['MWS_MARKETPLACE_ID']
    end

    def merchant_id
      @merchant_id ||= ENV['MWS_MERCHANT_ID']
    end

    def marketplace
      @marketplace ||= find_marketplace
    end

    def defaults
      @defaults ||= { expects: 200 }
    end

    def headers
      @headers ||= {}
    end

    def path
      @path ||= self.class.path
    end

    def body=(str)
      headers['Content-Type'] = content_type(str)
      @body = str
    end

    def on_error(&blk)
      @error_handler = blk
    end

    def operation(action = nil)
      action ? @operation = Operation.new(action) : @operation
    end

    def run(&blk)
      opts = defaults.merge(query: operation, headers: headers)
      opts.store(:body, body) if body
      opts.store(:response_block, blk) if block_given?
      res = post(opts)

      parser.parse(res, encoding)
    rescue Excon::Errors::Error => ex
      handle_error(ex) or raise
    end

    private

    def find_marketplace
      Marketplace.new(marketplace_id)
    end

    def content_type(str)
      if str.start_with?('<?xml')
        'text/xml'
      else
        "text/tab-separated-values; charset=#{encoding}"
      end
    end

    def extract_options(args)
      args.last.is_a?(Hash) ? args.pop : {}
    end

    def parser
      self.class.parser
    end

    def handle_error(ex)
      return false unless @error_handler
      @error_handler.call(ex.request, ex.response)
    end
  end
end
