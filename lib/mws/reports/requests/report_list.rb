require 'peddler/request'
require 'mws/reports/parsers/report_list'

module MWS
  module Reports
    module Requests
      class ReportList < ::Peddler::Request
        def get(options = {})
          parameters(:get_report_list)
            .update(options)
            .timestamp!
            .format_structured_lists!
            .camelize_keys!

          execute
        end

        def get_by_next_token(token = next_token)
          return false unless token

          parameters(:get_report_list_by_next_token)
            .update(next_token: token)
            .camelize_keys!

          execute
        end
      end
    end
  end
end
