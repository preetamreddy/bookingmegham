class AddEnsureAvailabilityBeforeBookingToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :ensure_availability_before_booking, :integer, :default => 1
  end
end
