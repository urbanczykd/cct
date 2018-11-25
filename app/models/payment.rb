class Payment < ApplicationRecord
  belongs_to :user
  validates_presence_of :recipient_id, :amount

  before_create :send_money

  def check_payment_status
    # this deserves own object also
    response = CurrencyCloud.new.list_payments
    response = response.select{|data| data["id"] == self.merchant_id}
    response = OpenStruct.new(response.inject())
    if response.status == "paid"
      self.status = response.status
      self.save
      add_money_to_friend
    end
    response.status
  end


  private

  def send_money
    response = CurrencyCloud.new.send_money(recipient_id, amount.to_f, currency = "GBP")
    if response.success?
      payment = response.parsed_response["payment"]
      self.status       = payment["status"]
      self.recipient_id = payment["recipient_id"]
      self.merchant_id  = payment["id"]
      self.currency     = payment["currency"]
      # we should have state machine aasm or something similar to keep track of that,
      # we can't add money right now to a friend account because we didn't get a
      # confirmation from a merchat and we can add it only if status is success
      user   = User.find_by_id(self.user_id)
      user.amount  = user.amount.to_f - self.amount.to_f
      user.save!
    end

  end

  def add_money_to_friend
    friend = user.friends.find_by_id(self.friend_id)
    friend.amount = friend.amount.to_f + self.amount.to_f
    friend.save!
  end


end
