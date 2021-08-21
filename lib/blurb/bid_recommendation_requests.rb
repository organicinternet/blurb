require 'blurb/request_collection'

class Blurb
  class BidRecommendationRequests < RequestCollection
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

    def retrieve(record_type, resource_id)
      execute_request(
        api_path: "/#{record_type.to_s.camelize(:lower)}/#{resource_id}/bidRecommendations",
        request_type: :get
      )
    end
  end
end
