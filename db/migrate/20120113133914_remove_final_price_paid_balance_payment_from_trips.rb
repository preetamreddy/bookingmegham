class RemoveFinalPricePaidBalancePaymentFromTrips < ActiveRecord::Migration
  def up
		remove_column :trips, :final_price
		remove_column :trips, :paid
		remove_column :trips, :balance_payment
  end

  def down
		add_column :trips, :final_price, :integer
		add_column :trips, :paid, :integer
		add_column :trips, :balance_payment, :integer
  end
end
