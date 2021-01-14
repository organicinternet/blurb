require 'blurb/request_collection_with_campaign_type'

class Blurb
  class BidRecommendationRequests < RequestCollectionWithCampaignType
    def initialize(campaign_type:, base_url:, headers:)
      @campaign_type = campaign_type
      @base_url = "#{base_url}/v2/#{@campaign_type}"
      @headers = headers
    end

    def list(record_type, payload)
      execute_request(
        api_path: "/#{record_type.to_s.camelize(:lower)}/bidRecommendations",
        request_type: :post,
        payload: payload
      )
    end
  end
end
