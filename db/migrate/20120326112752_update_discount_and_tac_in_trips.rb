class UpdateDiscountAndTacInTrips < ActiveRecord::Migration
  def up
		Trip.all.each do |trip|
			if trip.discount == "" or trip.discount == nil
				trip.discount = 0
			end
			if trip.tac == "" or trip.tac == nil
				trip.tac = 0
			end
			trip.save
		end
  end

  def down
		Trip.all.each do |trip|
			if trip.discount == 0
				trip.discount = nil
			end
			if trip.tac == 0
				trip.tac = nil
			end
			trip.save
		end
  end
end
