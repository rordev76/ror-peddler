# frozen_string_literal: true

require 'delegate'
require 'dig_rb'
require 'forwardable'
require 'peddler/headers'
require 'multi_xml'

module Peddler
  # @api private
  class XMLParser < SimpleDelegator
    extend Forwardable
    include Headers

    def_delegator :parse, :dig

    def parse
      @data ||= find_data
    end

    def xml
      MultiXml.parse(body)
    end

    def valid?
      return unless headers['Content-Length']
      headers['Content-Length'].to_i == body.size
    end

    private

    def find_data
      raise NotImplementedError
    end
  end
end
