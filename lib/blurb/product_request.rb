# frozen_string_literal: true

require "blurb/request_collection"

class Blurb
  class ProductRequest < RequestCollection

    def initialize(base_url:, headers:)
      @base_url = base_url
      @headers = headers
    end

    def metadata(payload)
      execute_request(
        api_path: "/product/metadata",
        request_type: :post,
        payload: payload
      )
    end

    def eligibility_product_list(payload)
      execute_request(
        api_path: "/eligibility/product/list",
        request_type: :post,
        payload: payload
      )
    end

    def eligibility_programs(payload = {})
      execute_request(
        api_path: "/eligibility/programs",
        request_type: :post,
        payload: payload
      )
    end
  end
end
