class UpdateTacInTrips < ActiveRecord::Migration
  def up
		Trip.all.each do |trip|
			if trip.direct_booking == 0
				trip.tac = trip.discount
				trip.discount = 0
				trip.save
			end
		end
  end

  def down
		Trip.all.each do |trip|
			if trip.direct_booking == 0
				trip.discount = trip.tac
				trip.tac = 0
				trip.save
			end
		end
  end
end
