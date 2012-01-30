class UpdateNumberOfDaysInTrips < ActiveRecord::Migration
  def up
		Trip.all.each do |trip|
			trip.number_of_days = (trip.end_date - trip.start_date).to_i + 1
			trip.save
		end
  end

  def down
		Trip.all.each do |trip|
			trip.number_of_days = nil
			trip.save
		end
  end
end
