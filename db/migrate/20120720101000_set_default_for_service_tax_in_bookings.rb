class SetDefaultForServiceTaxInBookings < ActiveRecord::Migration
  def up
		change_column_default :bookings, :service_tax, 0
  end

  def down
		change_column_default :bookings, :service_tax, nil
  end
end
