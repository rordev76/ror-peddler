require 'integration_helper'
require 'mws/reports'

class ReportRequestCountTest < IntegrationTest
  self.api = MWS::Reports

  def test_gets_report_request_count
    VCR.use_cassette('get_report_request_count/test_gets_report_request_count') do
      @clients.each do |client|
        res = client.get_report_request_count
        assert_kind_of Integer, res.count
      end
    end
  end
end
