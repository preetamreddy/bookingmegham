class UpdateTotalPriceForPranavUrjaMarchTrip < ActiveRecord::Migration
  def up
		trip = Trip.find(3178)
			trip.update_column(:total_price, 128000)
  end

  def down
		trip = Trip.find(3178)
			trip.update_column(:total_price, 252000)
  end
end
