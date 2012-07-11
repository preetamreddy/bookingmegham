class RemoveValueAddedServiceIdFromVasBookings < ActiveRecord::Migration
  def up
		remove_column :vas_bookings, :value_added_service_id
  end

  def down
		add_column :vas_bookings, :value_added_service_id, :integer
  end
end
