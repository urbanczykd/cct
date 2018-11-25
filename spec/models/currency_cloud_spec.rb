require 'rails_helper'

RSpec.describe CurrencyCloud, :type => :model do

  context "authenticate" do
    it "should authenticate and return httparty response" do
      VCR.use_cassette("currency_cloud/authenticate", record: :new_episodes) do
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

  context "create_recipient" do
    it "should create the recipient with name john and return his recipient id" do
      VCR.use_cassette("currency_cloud/create_new_recipient_john", record: :new_episodes) do
        expect(CurrencyCloud.new.create_recipient("john")).to eq("48380908-d66b-4814-9808-ddaa4c91cab0")
      end
    end
  end

  context "send_money" do
    it "should return valid response if a payment was successful" do
      VCR.use_cassette("currency_cloud/send_money", record: :none) do
        response = CurrencyCloud.new.send_money("7e559235-c05f-4c9c-9914-84c09173ca85", 10.22)
        response = response.parsed_response["payment"]
        expect(response["status"]).to       eq("processing")
        expect(response["recipient_id"]).to eq("7e559235-c05f-4c9c-9914-84c09173ca85")
        expect(response["id"]).to           eq("31ba0157-6140-46df-9d48-71db841927f0")
        expect(response["currency"]).to     eq("GBP")
        expect(response["amount"]).to       eq("10.22")
      end
    end
    it "shoud return response error invalid amount if amount was passed as invalid type" do
      VCR.use_cassette("currency_cloud/send_money_invalid_amount", record: :none) do
        response = CurrencyCloud.new.send_money("7e559235-c05f-4c9c-9914-84c09173ca85", amount: 10.22)
        response = response.parsed_response
        expect(response["errors"]).to eq({"amount"=>["is invalid"]})
      end
    end
  end

  context "list_payments" do
    it "should return a list of all paments" do
      VCR.use_cassette("currency_cloud/list_payments") do
        response = CurrencyCloud.new.list_payments
        expect(response.class).to be(Array)
        expect(response.count).to eq(6)
        first_payment = response.first
        expect(first_payment["status"]).to eq("failed")
        expect(first_payment["amount"]).to eq("10.22")
      end
    end
  end
# error handling :/
end
