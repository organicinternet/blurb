require 'blurb/request_collection'

class Blurb
  class HistoryRequest < RequestCollection
    FROM_DATE = (DateTime.now - 30).strftime('%Q')
    TO_DATE = DateTime.now.strftime('%Q')
    COUNT = 100.freeze
    FILTERS = []
    PARENT_CAMPAIGN_ID = nil

    def initialize(base_url:, headers:)
      @base_url = base_url
      @headers = headers
    end

    def retrieve(
      from_date: FROM_DATE,
      to_date: TO_DATE,
      campaign_ids:,
      filters: FILTERS,
      parent_campaign_id: PARENT_CAMPAIGN_ID,
      count: COUNT
    )

      payload = {
        sort: {
          key: 'DATE',
          direction: 'DESC'
        },
        fromDate: from_date.to_i,
        toDate: to_date.to_i,
        eventTypes: {
          CAMPAIGN: {
            eventTypeIds: campaign_ids
          }
        },
        count: count
      }

      payload[:eventTypes][:CAMPAIGN].merge!({ filters: filters }) if filters.present?
      payload[:eventTypes][:CAMPAIGN].merge!({ parents: [{ campaignId: parent_campaign_id }] }) if parent_campaign_id.present?

      execute_request(
        api_path: "/history",
        request_type: :post,
        payload: payload
      )
    end
  end
end
