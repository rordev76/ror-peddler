require 'integration_helper'
require 'mws/recommendations'

class RecommendationsTest < IntegrationTest
  def test_gets_last_updated_time_for_recommendations
    clients.each do |client|
      res = client.get_last_updated_time_for_recommendations
      refute_empty res.parse
    end
  end

  def test_lists_recommendations
    clients.each do |client|
      res = client.list_recommendations
      refute_empty res.parse
    end
  end

  def test_gets_service_status
    clients.each do |client|
      res = client.get_service_status
      refute_empty res.parse
    end
  end
end
