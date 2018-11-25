class AddAmountToUsers < ActiveRecord::Migration[5.2]
  def self.up
    add_column :users, :amount, :decimal, :precision => 10, :scale => 2, :default => 100
  end

  def self.down
    remove_column :users, :amount
  end
end
