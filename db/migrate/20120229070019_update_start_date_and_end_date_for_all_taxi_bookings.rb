class UpdateStartDateAndEndDateForAllTaxiBookings < ActiveRecord::Migration
  def up
		TaxiBooking.all.each do |tb|
			tb.start_date = tb.trip.start_date
			tb.end_date = tb.trip.end_date
			tb.number_of_days = tb.trip.number_of_days
			tb.save
		end
  end

  def down
		TaxiBooking.all.each do |tb|
			tb.start_date = nil
			tb.end_date = nil
			tb.number_of_days = nil
			tb.save
		end
  end
end
