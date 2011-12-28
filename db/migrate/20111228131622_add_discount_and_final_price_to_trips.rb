class AddDiscountAndFinalPriceToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :discount, :integer
    add_column :trips, :final_price, :integer
  end
end
