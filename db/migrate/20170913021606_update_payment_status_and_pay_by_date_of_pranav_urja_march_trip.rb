class UpdatePaymentStatusAndPayByDateOfPranavUrjaMarchTrip < ActiveRecord::Migration
  def up
		trip = Trip.find(3178)
			trip.update_column(:payment_status, 'Fully Paid')
			trip.update_column(:pay_by_date, nil)
  end

  def down
		trip = Trip.find(3178)
			trip.update_column(:payment_status, 'Fully Paid')
			trip.update_column(:pay_by_date, nil)
  end
end
