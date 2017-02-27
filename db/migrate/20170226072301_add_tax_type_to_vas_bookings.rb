class AddTaxTypeToVasBookings < ActiveRecord::Migration
  def change
    add_column :vas_bookings, :tax_type, :string
  end
end
