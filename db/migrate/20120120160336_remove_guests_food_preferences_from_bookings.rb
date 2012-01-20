class RemoveGuestsFoodPreferencesFromBookings < ActiveRecord::Migration
  def up
		remove_column :bookings, :guests_food_preferences
  end

  def down
		add_column :bookings, :guests_food_preferences, :string
  end
end
