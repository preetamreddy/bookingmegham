class UpdatePaymentStatusAgainInTrips < ActiveRecord::Migration
  def up
		Trip.all.each do |t|
			if t.payment_status == 'Blocked'
				t.payment_status = Trip::NOT_PAID
				t.save!
			end
		end
  end

  def down
		Trip.all.each do |t|
			if t.payment_status == 'Not Paid'
				t.payment_status = 'Blocked'
				t.save!
			end
		end
  end
end
