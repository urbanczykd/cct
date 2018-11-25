class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.integer :friend_id
      t.string :merchant, :default => "CurrencyCloud"
      t.string :merchant_id
      t.decimal :amount, :precision => 10, :scale => 2
      t.string :currency
      t.string :recipient_id
      t.string :status

      t.timestamps
    end
  end
end
