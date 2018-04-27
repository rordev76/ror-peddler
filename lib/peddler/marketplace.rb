# frozen_string_literal: true

module Peddler
  # @api private
  # @see https://docs.developer.amazonservices.com/en_US/dev_guide/DG_Endpoints.html
  Marketplace = Struct.new(:id, :country_code, :host) do
    class << self
      attr_reader :all

      def find(country_code)
        country_code = 'GB' if country_code == 'UK'

        all.find { |marketplace| marketplace.country_code == country_code } ||
          begin
            message = if country_code
                        %("#{country_code}" is not a valid country code)
                      else
                        'missing country code'
                      end

            raise ArgumentError, message
          end
      end
    end

    # Caveat: We use the supersets Windows-31J and CP1252 in place of Shift_JIS
    # and ISO 8859-1 respectively to handle edge cases where latter will not
    # support some characters. The supersets should be safe to use as drop-in
    # replacements.
    def encoding
      case country_code
      when 'JP'
        'Windows-31J'
      when 'CN'
        'UTF-16'
      else
        'CP1252'
      end
    end

    @all = [
      ['A2EUQ1WTGCTBG2', 'CA', 'mws.amazonservices.com'],
      ['A1AM78C64UM0Y8', 'MX', 'mws.amazonservices.com'],
      ['ATVPDKIKX0DER', 'US', 'mws.amazonservices.com'],
      ['A2Q3Y263D00KWC', 'BR', 'mws.amazonservices.com'],
      ['A1PA6795UKMFR9', 'DE', 'mws-eu.amazonservices.com'],
      ['A1RKKUPIHCS9HS', 'ES', 'mws-eu.amazonservices.com'],
      ['A13V1IB3VIYZZH', 'FR', 'mws-eu.amazonservices.com'],
      ['APJ6JRA9NG5V4', 'IT', 'mws-eu.amazonservices.com'],
      ['A1F83G8C2ARO7P', 'GB', 'mws-eu.amazonservices.com'],
      ['A21TJRUUN4KGV', 'IN', 'mws.amazonservices.in'],
      ['A39IBJ37TRP1C6', 'AU', 'mws.amazonservices.com.au'],
      ['A1VC38T7YXB528', 'JP', 'mws.amazonservices.jp'],
      ['AAHKV2X7AFYLW', 'CN', 'mws.amazonservices.com.cn']
    ].map do |values|
      new(*values)
    end
  end
end
