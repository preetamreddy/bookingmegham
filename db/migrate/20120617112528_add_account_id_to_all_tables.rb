class AddAccountIdToAllTables < ActiveRecord::Migration
  def up
		add_column :advisors, :account_id, :integer
		add_column :agencies, :account_id, :integer
		add_column :bookings, :account_id, :integer
		add_column :feedbacks, :account_id, :integer
		add_column :guests, :account_id, :integer
		add_column :line_items, :account_id, :integer
		add_column :payments, :account_id, :integer
		add_column :properties, :account_id, :integer
		add_column :room_types, :account_id, :integer
		add_column :rooms, :account_id, :integer
		add_column :taxi_bookings, :account_id, :integer
		add_column :taxi_details, :account_id, :integer
		add_column :taxis, :account_id, :integer
		add_column :trek_bookings, :account_id, :integer
		add_column :trek_prices, :account_id, :integer
		add_column :treks, :account_id, :integer
		add_column :trips, :account_id, :integer
		add_column :users, :account_id, :integer
		add_column :value_added_services, :account_id, :integer
		add_column :vas_bookings, :account_id, :integer

		add_index "advisors", ["account_id"], :name => "index_advisors_on_account_id"
		add_index "agencies", ["account_id"], :name => "index_agencies_on_account_id"
		add_index "bookings", ["account_id"], :name => "index_bookings_on_account_id"
		add_index "feedbacks", ["account_id"], :name => "index_feedbacks_on_account_id"
		add_index "guests", ["account_id"], :name => "index_guests_on_account_id"
		add_index "line_items", ["account_id"], :name => "index_line_items_on_account_id"
		add_index "payments", ["account_id"], :name => "index_payments_on_account_id"
		add_index "properties", ["account_id"], :name => "index_properties_on_account_id"
		add_index "room_types", ["account_id"], :name => "index_room_types_on_account_id"
		add_index "rooms", ["account_id"], :name => "index_rooms_on_account_id"
		add_index "taxi_bookings", ["account_id"], :name => "index_taxi_bookings_on_account_id"
		add_index "taxi_details", ["account_id"], :name => "index_taxi_details_on_account_id"
		add_index "taxis", ["account_id"], :name => "index_taxis_on_account_id"
		add_index "trek_bookings", ["account_id"], :name => "index_trek_bookings_on_account_id"
		add_index "trek_prices", ["account_id"], :name => "index_trek_prices_on_account_id"
		add_index "treks", ["account_id"], :name => "index_treks_on_account_id"
		add_index "trips", ["account_id"], :name => "index_trips_on_account_id"
		add_index "users", ["account_id"], :name => "index_users_on_account_id"
		add_index "value_added_services", ["account_id"], :name => "index_value_added_services_on_account_id"
		add_index "vas_bookings", ["account_id"], :name => "index_vas_bookings_on_account_id"

		banjara = Account.find_by_subdomain('banjaracamps').id
		Advisor.update_all({:account_id => banjara}, "name != 'Preetam Reddy'")
		Agency.update_all({:account_id => banjara})
		Booking.update_all({:account_id => banjara})
		Feedback.update_all({:account_id => banjara})
		Guest.update_all({:account_id => banjara})
		LineItem.update_all({:account_id => banjara})
		Payment.update_all({:account_id => banjara})
		Property.update_all({:account_id => banjara})
		RoomType.update_all({:account_id => banjara})
		Room.update_all({:account_id => banjara})
		TaxiBooking.update_all({:account_id => banjara})
		TaxiDetail.update_all({:account_id => banjara})
		Taxi.update_all({:account_id => banjara})
		TrekBooking.update_all({:account_id => banjara})
		TrekPrice.update_all({:account_id => banjara})
		Trek.update_all({:account_id => banjara})
		Trip.update_all({:account_id => banjara})
		User.update_all({:account_id => banjara}, "role != 'super_admin'")
		ValueAddedService.update_all({:account_id => banjara})
		VasBooking.update_all({:account_id => banjara})
	end

	def down
		remove_column :advisors, :account_id
		remove_column :agencies, :account_id
		remove_column :bookings, :account_id
		remove_column :feedbacks, :account_id
		remove_column :guests, :account_id
		remove_column :line_items, :account_id
		remove_column :payments, :account_id
		remove_column :properties, :account_id
		remove_column :room_types, :account_id
		remove_column :rooms, :account_id
		remove_column :taxi_bookings, :account_id
		remove_column :taxi_details, :account_id
		remove_column :taxis, :account_id
		remove_column :trek_bookings, :account_id
		remove_column :trek_prices, :account_id
		remove_column :treks, :account_id
		remove_column :trips, :account_id
		remove_column :users, :account_id
		remove_column :value_added_services, :account_id
		remove_column :vas_bookings, :account_id
	end
end
