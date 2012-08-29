class UpdateNameInTrips < ActiveRecord::Migration
  def up
    Trip.where("direct_booking = 0").each do |trip|
      guest = Guest.find(trip.guest_id)
      trip.update_column(:name, guest.name)
    end
  end

  def down
  end
end
