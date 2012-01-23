class UpdatePayByDateInTrips < ActiveRecord::Migration
  def up
		Trip.all.each do |trip|
			if !trip.pay_by_date
				trip.pay_by_date = trip.created_at.to_date + 7
				trip.save!
			end
		end
  end
end
