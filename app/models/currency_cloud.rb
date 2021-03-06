class CurrencyCloud
  include HTTParty
  format :json

  base_uri 'https://coolpay.herokuapp.com'

  def initialize
    self.class.headers 'Content-type':  "application/json"
  end

  def authenticate
    self.class.post('/api/login', body: { "username": Rails.application.credentials.currency_cloud[:username],
      "apikey": Rails.application.credentials.currency_cloud[:api_key]}.to_json )
  end

  def create_recipient(name)
    response = with_token { self.class.post('/api/recipients', body: {recipient: {name: name}}.to_json) }
    response.parsed_response["recipient"]["id"]
  end

  def send_money(recipient_id = nil, amount = nil, currency = "GBP")
    with_token { self.class.post("/api/payments", body: {payment: {amount: amount, currency: currency, recipient_id: recipient_id}}.to_json) }
  end

  def list_payments
    with_token { self.class.get("/api/payments", body: ''.to_json)["payments"] }
  end

  def token
    @token ||= JSON.parse(authenticate.response.body)["token"]
  end

  private

    def with_token(&block)
      self.class.headers 'Authorization': "Bearer #{token}"
      # here should be good place for catching any exeptions and handling them
      # and i don't have time for most importnt thing here :|
      response = block.call
    end

end
