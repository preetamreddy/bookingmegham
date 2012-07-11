class RenameVasToValueAddedServiceInVasBookings < ActiveRecord::Migration
  def up
		rename_column :vas_bookings, :vas, :value_added_service
  end

  def down
		rename_column :vas_bookings, :value_added_service, :vas
  end
end
