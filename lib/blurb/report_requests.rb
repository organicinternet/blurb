# frozen_string_literal: true

require 'blurb/request_collection_with_campaign_type'

class Blurb
  class ReportRequests < RequestCollectionWithCampaignType
    def initialize(campaign_type:, base_url:, headers:)
      @campaign_type = campaign_type
      @base_url = "#{base_url}/v2/#{@campaign_type}"
      @headers = headers
    end

    def create(
      record_type:,
      report_date: Date.today,
      state_filter: 'enabled,paused,archived',
      metrics: nil,
      segment: nil,
      creative_type: nil,
      tactic: nil
    )
      # create payload
      metrics = get_default_metrics(record_type.to_s.underscore.to_sym, segment) if metrics.nil?
      payload = {
        metrics: metrics.map { |m| m.to_s.camelize(:lower) }.join(','),
        report_date: report_date
      }

      payload[:segment]       = segment if segment
      payload[:creative_type] = creative_type if creative_type
      payload[:tactic]        = tactic if tactic

      if @campaign_type.to_sym == :sp
        payload[:state_filter] = state_filter if segment.nil? && !record_type.match?(/asins\Z/i)
        if record_type.match?(/asins\Z/i)
          record_type = record_type.match(/asins\Z/i).to_s
          payload[:campaign_type] = 'sponsoredProducts'
        end
      end

      execute_request(
        api_path: "/#{record_type.to_s.camelize(:lower)}/report",
        request_type: :post,
        payload: payload
      )
    end

    def retrieve(report_id)
      execute_request(
        api_path: "/reports/#{report_id}",
        request_type: :get
      )
    end

    def download(report_id)
      execute_request(
        api_path: "/reports/#{report_id}/download",
        request_type: :get
      )
    end

    private

    def get_default_metrics(record_type, segment = nil)
      if @campaign_type == CAMPAIGN_TYPE_CODES[:sb]
        if record_type == :campaigns
          return %w[
            campaignId
            impressions
            clicks
            cost
            attributedSales14d
            attributedSales14dSameSKU
            attributedConversions14d
            attributedConversions14dSameSKU
          ]
        end
        if record_type == :ad_groups
          return %w[
            adGroupId
            campaignId
            impressions
            clicks
            cost
            attributedSales14d
            attributedSales14dSameSKU
            attributedConversions14d
            attributedConversions14dSameSKU
          ]
        end
        if record_type == :keywords && segment.nil?
          return %w[
            keywordId
            adGroupId
            campaignId
            impressions
            clicks
            cost
            attributedSales14d
            attributedSales14dSameSKU
            attributedConversions14d
            attributedConversions14dSameSKU
          ]
        end
        if record_type == :keywords && segment.present?
          %w[
            adGroupId
            campaignId
            impressions
            clicks
            cost
            attributedSales14d
            attributedConversions14d
          ]
        end
      elsif @campaign_type == CAMPAIGN_TYPE_CODES[:sp]
        if record_type == :campaigns
          return %w[
            campaignId
            impressions
            clicks
            cost
            attributedConversions1d
            attributedConversions7d
            attributedConversions14d
            attributedConversions30d
            attributedConversions1dSameSKU
            attributedConversions7dSameSKU
            attributedConversions14dSameSKU
            attributedConversions30dSameSKU
            attributedUnitsOrdered1d
            attributedUnitsOrdered7d
            attributedUnitsOrdered14d
            attributedUnitsOrdered30d
            attributedSales1d
            attributedSales7d
            attributedSales14d
            attributedSales30d
            attributedSales1dSameSKU
            attributedSales7dSameSKU
            attributedSales14dSameSKU
            attributedSales30dSameSKU
            bidPlus
            campaignName
            campaignStatus
            campaignBudget
            campaignRuleBasedBudget
            applicableBudgetRuleId
            applicableBudgetRuleName
            attributedUnitsOrdered1dSameSKU
            attributedUnitsOrdered7dSameSKU
            attributedUnitsOrdered14dSameSKU
            attributedUnitsOrdered30dSameSKU
          ]
        end
        if record_type == :ad_groups
          return %w[
            campaignId
            adGroupId
            impressions
            clicks
            cost
            attributedConversions1d
            attributedConversions7d
            attributedConversions14d
            attributedConversions30d
            attributedConversions1dSameSKU
            attributedConversions7dSameSKU
            attributedConversions14dSameSKU
            attributedConversions30dSameSKU
            attributedUnitsOrdered1d
            attributedUnitsOrdered7d
            attributedUnitsOrdered14d
            attributedUnitsOrdered30d
            attributedSales1d
            attributedSales7d
            attributedSales14d
            attributedSales30d
            attributedSales1dSameSKU
            attributedSales7dSameSKU
            attributedSales14dSameSKU
            attributedSales30dSameSKU
            campaignName
            adGroupName
            attributedUnitsOrdered1dSameSKU
            attributedUnitsOrdered7dSameSKU
            attributedUnitsOrdered14dSameSKU
            attributedUnitsOrdered30dSameSKU
          ]
        end
        if record_type == :keywords
          return %w[
            campaignId
            keywordId
            impressions
            clicks
            cost
            attributedConversions1d
            attributedConversions7d
            attributedConversions14d
            attributedConversions30d
            attributedConversions1dSameSKU
            attributedConversions7dSameSKU
            attributedConversions14dSameSKU
            attributedConversions30dSameSKU
            attributedUnitsOrdered1d
            attributedUnitsOrdered7d
            attributedUnitsOrdered14d
            attributedUnitsOrdered30d
            attributedSales1d
            attributedSales7d
            attributedSales14d
            attributedSales30d
            attributedSales1dSameSKU
            attributedSales7dSameSKU
            attributedSales14dSameSKU
            attributedSales30dSameSKU
            campaignName
            adGroupName
            adGroupId
            keywordText
            matchType
            attributedUnitsOrdered1dSameSKU
            attributedUnitsOrdered7dSameSKU
            attributedUnitsOrdered14dSameSKU
            attributedUnitsOrdered30dSameSKU
          ]
        end
        if record_type == :product_ads
          return %w[
            campaignId
            adGroupId
            impressions
            clicks
            cost
            attributedConversions1d
            attributedConversions7d
            attributedConversions14d
            attributedConversions30d
            attributedConversions1dSameSKU
            attributedConversions7dSameSKU
            attributedConversions14dSameSKU
            attributedConversions30dSameSKU
            attributedUnitsOrdered1d
            attributedUnitsOrdered7d
            attributedUnitsOrdered14d
            attributedUnitsOrdered30d
            attributedSales1d
            attributedSales7d
            attributedSales14d
            attributedSales30d
            attributedSales1dSameSKU
            attributedSales7dSameSKU
            attributedSales14dSameSKU
            attributedSales30dSameSKU
            campaignName
            adGroupName
            currency
            asin
            sku
            attributedUnitsOrdered1dSameSKU
            attributedUnitsOrdered7dSameSKU
            attributedUnitsOrdered14dSameSKU
            attributedUnitsOrdered30dSameSKU
          ]
        end
        if record_type == :targets
          return %w[
            campaignId
            targetId
            impressions
            clicks
            cost
            attributedConversions1d
            attributedConversions7d
            attributedConversions14d
            attributedConversions30d
            attributedConversions1dSameSKU
            attributedConversions7dSameSKU
            attributedConversions14dSameSKU
            attributedConversions30dSameSKU
            attributedUnitsOrdered1d
            attributedUnitsOrdered7d
            attributedUnitsOrdered14d
            attributedUnitsOrdered30d
            attributedSales1d
            attributedSales7d
            attributedSales14d
            attributedSales30d
            attributedSales1dSameSKU
            attributedSales7dSameSKU
            attributedSales14dSameSKU
            attributedSales30dSameSKU
            campaignName
            adGroupName
            adGroupId
            targetingExpression
            targetingText
            targetingType
            attributedUnitsOrdered1dSameSKU
            attributedUnitsOrdered7dSameSKU
            attributedUnitsOrdered14dSameSKU
            attributedUnitsOrdered30dSameSKU
          ]
        end
        if record_type == :keyword_asins
          return %w[
            keywordId
            keywordText
            campaignName
            campaignId
            adGroupName
            adGroupId
            asin
            otherAsin
            sku
            currency
            matchType
            attributedUnitsOrdered1d
            attributedUnitsOrdered7d
            attributedUnitsOrdered14d
            attributedUnitsOrdered30d
            attributedUnitsOrdered1dOtherSKU
            attributedUnitsOrdered7dOtherSKU
            attributedUnitsOrdered14dOtherSKU
            attributedUnitsOrdered30dOtherSKU
            attributedSales1dOtherSKU
            attributedSales7dOtherSKU
            attributedSales14dOtherSKU
            attributedSales30dOtherSKU
          ]
        end
        if record_type == :target_asins
          %w[
            targetId
            targetingText
            targetingType
            campaignName
            campaignId
            adGroupName
            adGroupId
            asin
            otherAsin
            sku
            currency
            matchType
            attributedUnitsOrdered1d
            attributedUnitsOrdered7d
            attributedUnitsOrdered14d
            attributedUnitsOrdered30d
            attributedUnitsOrdered1dOtherSKU
            attributedUnitsOrdered7dOtherSKU
            attributedUnitsOrdered14dOtherSKU
            attributedUnitsOrdered30dOtherSKU
            attributedSales1dOtherSKU
            attributedSales7dOtherSKU
            attributedSales14dOtherSKU
            attributedSales30dOtherSKU
          ]
        end
      elsif @campaign_type == CAMPAIGN_TYPE_CODES[:sd]
        if record_type == :campaigns
          return %w[
            campaignId
            impressions
            clicks
            cost
            currency
            attributedConversions1d
            attributedConversions7d
            attributedConversions14d
            attributedConversions30d
            attributedConversions1dSameSKU
            attributedConversions7dSameSKU
            attributedConversions14dSameSKU
            attributedConversions30dSameSKU
            attributedUnitsOrdered1d
            attributedUnitsOrdered7d
            attributedUnitsOrdered14d
            attributedUnitsOrdered30d
            attributedSales1d
            attributedSales7d
            attributedSales14d
            attributedSales30d
            attributedSales1dSameSKU
            attributedSales7dSameSKU
            attributedSales14dSameSKU
            attributedSales30dSameSKU
          ]
        end
        if record_type == :ad_groups
          return %w[
            campaignId
            adGroupId
            impressions
            clicks
            cost
            currency
            attributedConversions1d
            attributedConversions7d
            attributedConversions14d
            attributedConversions30d
            attributedConversions1dSameSKU
            attributedConversions7dSameSKU
            attributedConversions14dSameSKU
            attributedConversions30dSameSKU
            attributedUnitsOrdered1d
            attributedUnitsOrdered7d
            attributedUnitsOrdered14d
            attributedUnitsOrdered30d
            attributedSales1d
            attributedSales7d
            attributedSales14d
            attributedSales30d
            attributedSales1dSameSKU
            attributedSales7dSameSKU
            attributedSales14dSameSKU
            attributedSales30dSameSKU
          ]
        end
        if record_type == :product_ads
          return %w[
            campaignId
            adGroupId
            impressions
            clicks
            cost
            currency
            attributedConversions1d
            attributedConversions7d
            attributedConversions14d
            attributedConversions30d
            attributedConversions1dSameSKU
            attributedConversions7dSameSKU
            attributedConversions14dSameSKU
            attributedConversions30dSameSKU
            attributedUnitsOrdered1d
            attributedUnitsOrdered7d
            attributedUnitsOrdered14d
            attributedUnitsOrdered30d
            attributedSales1d
            attributedSales7d
            attributedSales14d
            attributedSales30d
            attributedSales1dSameSKU
            attributedSales7dSameSKU
            attributedSales14dSameSKU
            attributedSales30dSameSKU
          ]
        end
        if record_type == :targets
          return %w[
            campaignId
            targetId
            impressions
            clicks
            cost
            currency
            attributedConversions1d
            attributedConversions7d
            attributedConversions14d
            attributedConversions30d
            attributedConversions1dSameSKU
            attributedConversions7dSameSKU
            attributedConversions14dSameSKU
            attributedConversions30dSameSKU
            attributedUnitsOrdered1d
            attributedUnitsOrdered7d
            attributedUnitsOrdered14d
            attributedUnitsOrdered30d
            attributedSales1d
            attributedSales7d
            attributedSales14d
            attributedSales30d
            attributedSales1dSameSKU
            attributedSales7dSameSKU
            attributedSales14dSameSKU
            attributedSales30dSameSKU
          ]
        end
        if record_type == :keyword_asins
          return %w[
            keywordId
            keywordText
            campaignName
            campaignId
            adGroupName
            adGroupId
            asin
            otherAsin
            sku
            currency
            matchType
            attributedUnitsOrdered1d
            attributedUnitsOrdered7d
            attributedUnitsOrdered14d
            attributedUnitsOrdered30d
            attributedUnitsOrdered1dOtherSKU
            attributedUnitsOrdered7dOtherSKU
            attributedUnitsOrdered14dOtherSKU
            attributedUnitsOrdered30dOtherSKU
            attributedSales1dOtherSKU
            attributedSales7dOtherSKU
            attributedSales14dOtherSKU
            attributedSales30dOtherSKU
          ]
        end
        if record_type == :target_asins
          %w[
            targetId
            targetingText
            targetingType
            campaignName
            campaignId
            adGroupName
            adGroupId
            asin
            otherAsin
            sku
            currency
            matchType
            attributedUnitsOrdered1d
            attributedUnitsOrdered7d
            attributedUnitsOrdered14d
            attributedUnitsOrdered30d
            attributedUnitsOrdered1dOtherSKU
            attributedUnitsOrdered7dOtherSKU
            attributedUnitsOrdered14dOtherSKU
            attributedUnitsOrdered30dOtherSKU
            attributedSales1dOtherSKU
            attributedSales7dOtherSKU
            attributedSales14dOtherSKU
            attributedSales30dOtherSKU
          ]
        end
      end
    end
  end
end
