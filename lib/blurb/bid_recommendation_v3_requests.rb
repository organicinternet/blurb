# frozen_string_literal: true

require 'blurb/request_collection'

class Blurb
  class BidRecommendationV3Requests < RequestCollection
    def initialize(campaign_type:, base_url:, headers:)
      @campaign_type = campaign_type
      @base_url = "#{base_url}/#{@campaign_type}"
      @headers = headers
    end

    def list(payload)
      execute_request(
        api_path: "/targets/bid/recommendations",
        request_type: :post,
        payload: payload
      )
    end
  end
end
