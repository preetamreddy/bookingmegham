class UpdatePaymentStatusInTrips < ActiveRecord::Migration
  def up
		Trip.all.each do |trip|
			trip.update_payment_status
			trip.save!
		end
  end

  def down
		Trip.all.each do |trip|
			trip.payment_status = nil
			trip.save!
		end
  end
end
