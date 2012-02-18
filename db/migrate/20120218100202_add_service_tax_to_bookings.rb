class AddServiceTaxToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :service_tax, :integer
  end
end
