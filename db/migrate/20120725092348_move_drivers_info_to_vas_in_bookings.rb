class MoveDriversInfoToVasInBookings < ActiveRecord::Migration
  def up
		Booking.observers.disable :all do
			Booking.where("number_of_drivers > 0").each do |booking|
				booking.vas_bookings.build(value_added_service: "Accompanying drivers",
					unit_price: booking.property.price_for_driver,
					number_of_units: booking.number_of_drivers,
					every_day: 1)	
				booking.save!
			end
		end
  end

  def down
		Booking.observers.disable :all do
			VasBooking.where("value_added_service = 'Accompanying drivers' and every_day = 1").each do |vas_booking|
				vas_booking.destroy
			end
		end
  end
end
