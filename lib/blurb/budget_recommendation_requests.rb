require 'blurb/request_collection'

class Blurb
  class BudgetRecommendationRequests < RequestCollection
    def initialize(campaign_type:, base_url:, headers:)
      @campaign_type = campaign_type
      @base_url = "#{base_url}/#{@campaign_type}"
      @headers = headers
    end

    def list(payload)
      execute_request(
        api_path: "/campaigns/budgetRecommendations",
        request_type: :post,
        payload: payload
      )
    end
  end
end
