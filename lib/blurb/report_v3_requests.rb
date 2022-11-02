# frozen_string_literal: true

require 'blurb/request_collection_with_campaign_type'

class Blurb
  class ReportV3Requests < RequestCollectionWithCampaignType
    def initialize(campaign_type:, base_url:, headers:)
      @campaign_type = campaign_type
      @base_url = "#{base_url}/reporting"
      @headers = headers
    end

    def create(start_date:, end_date:, report_type_id:, group_by:, time_unit: "DAILY", metrics: nil, filters: nil)

      # create payload
      time_unit_columns = %w[ date ]              if time_unit == "DAILY"
      time_unit_columns = %w[ startDate endDate ] if time_unit == "SUMMARY"

      ad_product_string = "SPONSORED_PRODUCTS" if @campaign_type == CAMPAIGN_TYPE_CODES[:sp]
      metrics = get_default_metrics(report_type_id, group_by) if metrics.nil?

      payload = {
        name: "#{report_type_id}->#{group_by.join("&")} report: #{start_date} ~ #{end_date}",
        start_date:,
        end_date:,
        configuration: {
          filters:,
          time_unit:,
          report_type_id:,
          group_by:,
          ad_product: ad_product_string,
          columns: metrics.map { |m| m.to_s.camelize(:lower) } + time_unit_columns,
          format: "GZIP_JSON",
        }
      }

      execute_request(
        api_path: "/reports",
        request_type: :post,
        payload:
      )
    end

    def retrieve(report_id)
      execute_request(
        api_path: "/reports/#{report_id}",
        request_type: :get
      )
    end

    def download(download_url)
      RestClient.get(download_url)
    end

    private
      def get_default_metrics(report_type_id, group_by)
        if @campaign_type == CAMPAIGN_TYPE_CODES[:sp]
          case report_type_id.to_sym
          when :spCampaigns
            metrics = %w[
              impressions
              clicks
              cost
              purchases1d
              purchases7d
              purchases14d
              purchases30d
              purchasesSameSku1d
              purchasesSameSku7d
              purchasesSameSku14d
              purchasesSameSku30d
              unitsSoldClicks1d
              unitsSoldClicks7d
              unitsSoldClicks14d
              unitsSoldClicks30d
              sales1d
              sales7d
              sales14d
              sales30d
              attributedSalesSameSku1d
              attributedSalesSameSku7d
              attributedSalesSameSku14d
              attributedSalesSameSku30d
              unitsSoldSameSku1d
              unitsSoldSameSku7d
              unitsSoldSameSku14d
              unitsSoldSameSku30d
              kindleEditionNormalizedPagesRead14d
              kindleEditionNormalizedPagesRoyalties14d
              campaignBiddingStrategy
              costPerClick
              clickThroughRate
              spend
            ]
            metrics += %w[
              campaignName
              campaignId
              campaignStatus
              campaignBudgetAmount
              campaignBudgetType
              campaignRuleBasedBudgetAmount
              campaignApplicableBudgetRuleId
              campaignApplicableBudgetRuleName
              campaignBudgetCurrencyCode
            ] if group_by.map(&:to_s).include?("campaign")
            metrics +=%w[
              adGroupName
              adGroupId
              adStatus
            ] if group_by.map(&:to_s).include?("adGroup")
            metrics +=%w[
              placementClassification
            ] if group_by.map(&:to_s).include?("campaignPlacement")
          when :spTargeting
            metrics = %w[
              impressions
              clicks
              costPerClick
              clickThroughRate
              cost
              purchases1d
              purchases7d
              purchases14d
              purchases30d
              purchasesSameSku1d
              purchasesSameSku7d
              purchasesSameSku14d
              purchasesSameSku30d
              unitsSoldClicks1d
              unitsSoldClicks7d
              unitsSoldClicks14d
              unitsSoldClicks30d
              sales1d
              sales7d
              sales14d
              sales30d
              attributedSalesSameSku1d
              attributedSalesSameSku7d
              attributedSalesSameSku14d
              attributedSalesSameSku30d
              unitsSoldSameSku1d
              unitsSoldSameSku7d
              unitsSoldSameSku14d
              unitsSoldSameSku30d
              kindleEditionNormalizedPagesRead14d
              kindleEditionNormalizedPagesRoyalties14d
              salesOtherSku7d
              unitsSoldOtherSku7d
              acosClicks7d
              acosClicks14d
              roasClicks7d
              roasClicks14d
              keywordId
              keyword
              campaignBudgetCurrencyCode
              portfolioId
              campaignName
              campaignId
              campaignBudgetType
              campaignBudgetAmount
              campaignStatus
              keywordBid
              adGroupName
              adGroupId
              keywordType
              matchType
              targeting
              adKeywordStatus
            ]
          when :spSearchTerm
            metrics = %w[
              impressions
              clicks
              costPerClick
              clickThroughRate
              cost
              purchases1d
              purchases7d
              purchases14d
              purchases30d
              purchasesSameSku1d
              purchasesSameSku7d
              purchasesSameSku14d
              purchasesSameSku30d
              unitsSoldClicks1d
              unitsSoldClicks7d
              unitsSoldClicks14d
              unitsSoldClicks30d
              sales1d
              sales7d
              sales14d
              sales30d
              attributedSalesSameSku1d
              attributedSalesSameSku7d
              attributedSalesSameSku14d
              attributedSalesSameSku30d
              unitsSoldSameSku1d
              unitsSoldSameSku7d
              unitsSoldSameSku14d
              unitsSoldSameSku30d
              kindleEditionNormalizedPagesRead14d
              kindleEditionNormalizedPagesRoyalties14d
              salesOtherSku7d
              unitsSoldOtherSku7d
              acosClicks7d
              acosClicks14d
              roasClicks7d
              roasClicks14d
              keywordId
              keyword
              campaignBudgetCurrencyCode
              portfolioId
              searchTerm
              campaignName
              campaignId
              campaignBudgetType
              campaignBudgetAmount
              campaignStatus
              keywordBid
              adGroupName
              adGroupId
              keywordType
              matchType
              targeting
              adKeywordStatus
            ]
          when :spAdvertisedProduct
            metrics = %w[
              campaignName
              campaignId
              adGroupName
              adGroupId
              adId
              portfolioId
              impressions
              clicks
              costPerClick
              clickThroughRate
              cost
              spend
              campaignBudgetCurrencyCode
              campaignBudgetAmount
              campaignBudgetType
              campaignStatus
              advertisedAsin
              advertisedSku
              purchases1d
              purchases7d
              purchases14d
              purchases30d
              purchasesSameSku1d
              purchasesSameSku7d
              purchasesSameSku14d
              purchasesSameSku30d
              unitsSoldClicks1d
              unitsSoldClicks7d
              unitsSoldClicks14d
              unitsSoldClicks30d
              sales1d
              sales7d
              sales14d
              sales30d
              attributedSalesSameSku1d
              attributedSalesSameSku7d
              attributedSalesSameSku14d
              attributedSalesSameSku30d
              salesOtherSku7d
              unitsSoldSameSku1d
              unitsSoldSameSku7d
              unitsSoldSameSku14d
              unitsSoldSameSku30d
              unitsSoldOtherSku7d
              kindleEditionNormalizedPagesRead14d
              kindleEditionNormalizedPagesRoyalties14d
              acosClicks7d
              acosClicks14d
              roasClicks7d
              roasClicks14d
            ]
          when :spPurchasedProduct
            metrics = %w[
              portfolioId
              campaignName
              campaignId
              adGroupName
              adGroupId
              keywordId
              keyword
              keywordType
              advertisedAsin
              purchasedAsin
              advertisedSku
              campaignBudgetCurrencyCode
              matchType
              unitsSoldClicks1d
              unitsSoldClicks7d
              unitsSoldClicks14d
              unitsSoldClicks30d
              sales1d
              sales7d
              sales14d
              sales30d
              purchases1d
              purchases7d
              purchases14d
              purchases30d
              unitsSoldOtherSku1d
              unitsSoldOtherSku7d
              unitsSoldOtherSku14d
              unitsSoldOtherSku30d
              salesOtherSku1d
              salesOtherSku7d
              salesOtherSku14d
              salesOtherSku30d
              purchasesOtherSku1d
              purchasesOtherSku7d
              purchasesOtherSku14d
              purchasesOtherSku30d
              kindleEditionNormalizedPagesRead14d
              kindleEditionNormalizedPagesRoyalties14d
            ]
          end
          return metrics.uniq
        end
      end
  end
end
