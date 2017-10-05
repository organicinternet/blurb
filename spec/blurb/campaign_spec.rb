require "spec_helper"

RSpec.describe Blurb::Campaign do
  include_context "shared setup"

  describe "campaign crud operations" do
    it "creates, lists and finds campaigns" do
      campaigns = Blurb::Campaign.create({
        "name" => "test",
        "campaignType" => "sponsoredProducts",
        "state" => "enabled",
        "dailyBudget" => 10,
        "startDate" => (Time.now).strftime('%Y%m%d'),
        "targetingType" => "abc"
      })

      expect(campaigns).not_to be nil
      payload_response = Blurb::Campaign.retrieve(campaigns.first["campaignId"])
      payload_response = Blurb::Campaign.list()
    end
  end

end
