class AddBookingStatusAndCancellationChargeToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :booking_status, :string, :default => Booking::BOOKED
    add_column :bookings, :cancellation_charge, :integer, :default => 0
  end
end
