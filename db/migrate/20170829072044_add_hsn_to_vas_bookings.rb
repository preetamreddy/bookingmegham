class AddHsnToVasBookings < ActiveRecord::Migration
  def change
    add_column :vas_bookings, :hsn, :string
  end
end
