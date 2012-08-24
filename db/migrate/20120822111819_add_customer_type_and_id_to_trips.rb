class AddCustomerTypeAndIdToTrips < ActiveRecord::Migration
  def up
    add_column :trips, :customer_type, :string
    add_column :trips, :customer_id, :integer

    Trip.all.each do |trip|
      if trip.direct_booking == 1
        trip.update_column(:customer_type, 'Guest')
        trip.update_column(:customer_id, trip.guest_id)
      elsif trip.direct_booking == 0
        trip.update_column(:customer_type, 'Agency')
        trip.update_column(:customer_id, trip.agency_id)
      end
    end
  end

  def down
    remove_column :trips, :customer_type
    remove_column :trips, :customer_id
  end
end
