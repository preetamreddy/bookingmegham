class RemoveGuestIdAgencyIdDirectBookingFromTrips < ActiveRecord::Migration
  def up
    remove_column :trips, :guest_id
    remove_column :trips, :agency_id
    remove_column :trips, :direct_booking
  end

  def down
    add_column :trips, :guest_id, :integer
    add_column :trips, :agency_id, :integer
    add_column :trips, :direct_booking, :integer, :default => 1
  end
end
