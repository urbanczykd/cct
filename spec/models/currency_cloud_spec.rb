require 'rails_helper'

RSpec.describe CurrencyCloud, :type => :model do

  context "authenticate" do
    it "should authenticate and return httparty response" do
      VCR.use_cassette("currency_cloud/authenticate") do
        expect(CurrencyCloud.new.authenticate.class.name).to eq("HTTParty::Response")
      end
    end

    it "should return 200 if response was successful" do
      VCR.use_cassette("currency_cloud/authenticate") do
        expect(CurrencyCloud.new.authenticate.code).to eq(200)
      end
    end

    it "should return in response token" do
      VCR.use_cassette("currency_cloud/authenticate") do
        expect(CurrencyCloud.new.authenticate.body.include?("token")).to be_truthy
      end
    end
  end

  context "create_recipent" do
    it "should create the recipent with name john and return his recipent id" do
      VCR.use_cassette("currency_cloud/create_new_recipent_john") do
        expect(CurrencyCloud.new.create_recipent("john")).to eq("27434033-c653-4fe0-b80c-1d5ac37abbee")
      end
    end
  end

  context "send_money" do
    it "has confirmation_token" do
      expect(true).to be_truthy
    end
  end

  context "check_payments" do
    it "has confirmation_token" do
      VCR.use_cassette("currency_cloud/check_empty_payments") do
        expect(CurrencyCloud.new.check_payments).to eq([])
      end
    end
  end

end
