require 'peddler/request'
require 'mws/reports/parsers/report_request_count'

module MWS
  module Reports
    module Requests
      class ReportRequestCount < ::Peddler::Request
        def get(options = {})
          parameters(:get_report_request_count)
            .update(options)
            .timestamp!
            .format_structured_lists!
            .camelize_keys!

          execute
        end
      end
    end
  end
end
