class User < ApplicationRecord

  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :payments

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_save :add_currency_cloud_recipient

  def add_currency_cloud_recipient
    self.recipient_id = CurrencyCloud.new.create_recipient(email)
  end


end
