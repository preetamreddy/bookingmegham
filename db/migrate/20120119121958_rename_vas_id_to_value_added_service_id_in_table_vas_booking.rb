class RenameVasIdToValueAddedServiceIdInTableVasBooking < ActiveRecord::Migration
  def up
		rename_column :vas_bookings, :vas_id, :value_added_service_id
  end

  def down
		rename_column :vas_bookings, :value_added_service_id, :vas_id
  end
end
