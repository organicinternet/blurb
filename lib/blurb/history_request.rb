# frozen_string_literal: true

require 'blurb/request_collection'

class Blurb
  class HistoryRequest < RequestCollection
    FROM_DATE = (DateTime.now - 30).strftime('%Q')
    TO_DATE = DateTime.now.strftime('%Q')
    MAX_COUNT = 200
    MIN_COUNT = 50
    FILTERS = [].freeze
    PARENT_CAMPAIGN_ID = nil

    def initialize(base_url:, headers:)
      @base_url = base_url
      @headers = headers
    end

    def retrieve(
      campaign_ids:, from_date: FROM_DATE,
      to_date: TO_DATE,
      filters: FILTERS,
      parent_campaign_id: PARENT_CAMPAIGN_ID,
      count: MAX_COUNT
    )

      count = MIN_COUNT if count < MIN_COUNT
      count = MAX_COUNT if count > MAX_COUNT

      payload = {
        sort: {
          key: 'DATE',
          direction: 'ASC'
        },
        fromDate: from_date.to_i,
        toDate: to_date.to_i,
        eventTypes: {
          CAMPAIGN: {
            eventTypeIds: campaign_ids
          }
        },
        count:
      }

      payload[:eventTypes][:CAMPAIGN].merge!({ filters: }) if filters.present?
      if parent_campaign_id.present?
        payload[:eventTypes][:CAMPAIGN].merge!({ parents: [{ campaignId: parent_campaign_id }] })
      end

      execute_request(
        api_path: '/history',
        request_type: :post,
        payload:
      )
    end
  end
end
