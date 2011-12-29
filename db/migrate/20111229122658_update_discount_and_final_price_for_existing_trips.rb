class UpdateDiscountAndFinalPriceForExistingTrips < ActiveRecord::Migration
  def up
		Trip.all.each do |trip|
			trip.discount = 0
			trip.final_price = trip.total_price
		end
  end

  def down
		Trip.all.each do |trip|
			trip.discount = nil
			trip.final_price = nil
		end
  end
end
