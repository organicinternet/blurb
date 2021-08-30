require 'blurb/request_collection'

class Blurb
  class BudgetRulesRecommendationRequests < RequestCollection
    def initialize(campaign_type:, base_url:, headers:)
      @campaign_type = campaign_type
      @base_url = "#{base_url}/#{@campaign_type}"
      @headers = headers
    end

    def retrieve(payload)
      execute_request(
        api_path: "/campaigns​/budgetRules​/recommendations",
        request_type: :post,
        payload: payload
      )
    end
  end
end
