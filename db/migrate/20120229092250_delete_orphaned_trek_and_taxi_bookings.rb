class DeleteOrphanedTrekAndTaxiBookings < ActiveRecord::Migration
  def up
		TrekBooking.all.each do |tb|
			trip = Trip.find_all_by_id(tb.trip_id)
			if trip.count == 0
				tb.destroy
			end
		end
		TaxiBooking.all.each do |tb|
			trip = Trip.find_all_by_id(tb.trip_id)
			if trip.coint == 0
				tb.destroy
			end
		end
  end
end
