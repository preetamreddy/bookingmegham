FactoryGirl.define do
	factory :account do
		id 3
		name { Faker::Company.name }
		subdomain { name.gsub(/[^a-zA-Z]/, '') }
	  phone_number_1 { Faker::PhoneNumber.phone_number.gsub(/[^\d\s]/, '') }
	  email { Faker::Internet.email }
		postal_address { "#{Faker::Address.secondary_address}, #{Faker::Address.street_name}" }
		url { Faker::Internet.url }
	end

	factory :agency do
		account_id 3
	  name { Faker::Company.name }
	  phone_number { Faker::PhoneNumber.phone_number.gsub(/[^\d\s]/, '') }
	  email_id { Faker::Internet.email }
		postal_address { "#{Faker::Address.secondary_address}, #{Faker::Address.street_name}" }
	  city { Faker::Address.city }
		url { Faker::Internet.url }
		logo_file_name { "#{name.gsub(/[^a-zA-Z]/, '')}.jpg" }
	  operates_properties 1
	  operates_taxis 1
	  is_travel_agency 1
	  short_name { "#{name}" }
	end

	factory :property do
		account_id 3
	  name { Faker::Address.city }
	  price_for_driver 500
	  ensure_availability_before_booking 1
	  consider_blocked_rooms_as_booked 1
	  phone_number { Faker::PhoneNumber.phone_number.gsub(/[^\d\s]/, '') }
	  phone_number_2 { Faker::PhoneNumber.phone_number.gsub(/[^\d\s]/, '') }
		address { "#{name}" }
		suggested_activities { Faker::Lorem.paragraph }
		url { Faker::Internet.url }
	end

	factory :room_type do
		account_id 3
		property
		room_type { Faker::Lorem.words(1).first }
		price_for_single_occupancy 4700
		price_for_double_occupancy 5600
		number_of_rooms 8
		price_for_lodging 1500
	  price_for_children_below_5_years 0
	  price_for_triple_occupancy 2000
	  price_for_children_between_5_and_12_years 1200
	end

	factory :guest do
		account_id 3
		name { Faker::Name.name }
	  phone_number { Faker::PhoneNumber.phone_number.gsub(/[^\d\s]/, '') }
		email_id { Faker::Internet.email }
		resident_of { Faker::Address.city }
	  phone_number_2 { Faker::PhoneNumber.phone_number.gsub(/[^\d\s]/, '') }
		title "Mr"
	end

	factory :trip do
		account_id 3
		guest
		name { Faker::Lorem.words(1).first }
		start_date { Date.today + 30.days }
		number_of_days 10
		agency_id { Agency.find_by_short_name("Banjara Camps").id }
		advisor_id { Advisor.find_by_name("Kavita Goel").id }
		direct_booking 1
	end

	factory :booking do
		account_id 3
		trip
		room_type
		check_in_date { trip.start_date }
		number_of_nights 4
		meal_plan "EPAI"
	end

	factory :room do
		account_id 3
		booking
		occupancy "Double"
		number_of_adults 2
		number_of_children_between_5_and_12_years 0
		number_of_children_below_5_years 1
		number_of_rooms 1
	end

	factory :vas_booking do
		account_id 3
		value_added_service { Faker::Lorem.words(1).first }
		unit_price 1000
		number_of_units 1

		factory :vas_booking_for_trip do
			trip
		end

		factory :vas_booking_for_booking do
			booking
		end
	end

	factory :payment do
		account_id 3
		trip
		payee_name { Faker::Lorem.words(1).first }
		date_received { Date.today }
		amount 1000
		payment_mode "Axis"
	end
end
