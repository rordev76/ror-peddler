require 'parser_helper'
require 'mws/reports/parsers/report_request_list'

class ReportRequestListParserTest < ParserTest
  def setup
    node = fixture('reports/report_request_list').xpath('//xmlns:GetReportRequestListResult')
    @list = MWS::Reports::Parsers::ReportRequestList.new(node)
  end

  def test_has_report_request_list
    refute_empty @list.to_a
    @list.each { |report_request| assert_kind_of MWS::Reports::Parsers::ReportRequest, report_request }
  end

  def test_has_token
    assert @list.has_next_token?
  end
end
