# frozen_string_literal: true

require 'integration_helper'
require 'mws/reports'

class TestReports < IntegrationTest
  def test_getting_report_request_count
    clients.each do |client|
      res = client.get_report_request_count
      refute_empty res.parse
    end
  end

  def test_getting_report_request_list
    clients.each do |client|
      res = client.get_report_request_list
      refute_empty res.parse
    end
  end

  def test_getting_report_schedule_count
    clients.each do |client|
      res = client.get_report_schedule_count
      refute_empty res.parse
    end
  end

  def test_listing_report_schedules
    clients.each do |client|
      res = client.get_report_schedule_list
      refute_empty res.parse
    end
  end

  def test_getting_report_count
    clients.each do |client|
      res = client.get_report_count
      refute_empty res.parse
    end
  end

  def test_getting_report
    clients.each do |client|
      res = client.get_report_list(max_count: 1)
      id = res.parse['ReportInfo']['ReportId']
      res = client.get_report(id)
      assert res.valid?
      assert res.records_count || res.parse
    end
  end
end
