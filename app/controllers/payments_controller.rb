class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @payments = current_user.payments
  end

  def new
    @payment = current_user.payments.new
  end

  def create
    # we have in here recipient_id and friend_id, only to be able later to track back
    # who exactly had which recipient_id is something would go wrong for example when somehow
    # it happens that our friend in future change his recipient_id
    @payment = current_user.payments.build(recipient_id: friend.recipient_id, amount: amount, friend_id: friend.id)
    respond_to do |format|
      if @payment.save
        format.html { redirect_to user_payments_path(current_user), notice: 'Payment was successfully created.' }
      else
        format.html { redirect_to users_payments_path(current_user), error: "ups something went wrong." }
      end
    end
  end

  def check
    payment = current_user.payments.find_by_id(params["id"])
    status = payment.check_payment_status
    respond_to do |format|
      format.html { redirect_to users_path, notice: "Payment status is: #{status}"}
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def payment_params
    params.require(:payment).permit(:friend_id, :amount)
  end

  def amount
    # it would be move this to separate object and do some validation.
    payment_params["amount"]
  end

  def friend
    current_user.friendships.find_by_friend_id(payment_params["friend_id"]).friend
  end

end
