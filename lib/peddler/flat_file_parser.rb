# frozen_string_literal: true

require 'delegate'
require 'csv'
require 'digest/md5'
require 'peddler/headers'

module Peddler
  # @api private
  class FlatFileParser < SimpleDelegator
    include Headers

    # http://stackoverflow.com/questions/8073920/importing-csv-quoting-error-is-driving-me-nuts
    OPTIONS = { col_sep: "\t", quote_char: "\x00", headers: true }.freeze
    private_constant :OPTIONS

    attr_reader :content, :summary

    def initialize(res, encoding)
      super(res)
      scrub_body!(encoding)
      extract_content_and_summary
    end

    def parse(&blk)
      CSV.parse(content, OPTIONS, &blk) unless content.empty?
    end

    def records_count
      summarize if summary
    end

    def valid?
      headers['Content-MD5'] == Digest::MD5.base64digest(body)
    end

    private

    def scrub_body!(encoding)
      return if body.encoding == Encoding::UTF_8
      self.body = body.dup.force_encoding(encoding)
    end

    def extract_content_and_summary
      @content = body.encode('UTF-8', invalid: :replace, undef: :replace)
      @summary, @content = @content.split("\n\n", 2) if @content =~ /\t\t.*\n\n/
    end

    def summarize
      Hash[summary.split("\n\t")[1, 2].map { |line| line.split("\t\t") }]
    end
  end
end
