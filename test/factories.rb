FactoryGirl.define do
	factory :account do
		id 3
		name { Faker::Company.name }
		subdomain { Faker::Company.name }
	  phone_number_1 { Faker::PhoneNumber.phone_number.gsub(/[^\d\s]/, '') }
	  email { Faker::Internet.email }
		postal_address { "#{Faker::Address.secondary_address}, #{Faker::Address.street_name}" }
		url { Faker::Internet.url }
		logo_file_name { "#{Faker::Company.name}.jpg" }
    pan ABCDE1234F
	end

	factory :agency do
		account_id 3
	  registered_name { Faker::Company.name }
	  name { Faker::Company.name }
	  phone_number { Faker::PhoneNumber.phone_number.gsub(/[^\d\s]/, '') }
	  email_id { Faker::Internet.email }
		postal_address { "#{Faker::Address.secondary_address}, #{Faker::Address.street_name}" }
	  city { Faker::Address.city }
		url { Faker::Internet.url }
	  operates_properties 1
	  operates_taxis 1
	  is_travel_agency 1
    pan_number ABCDE1234F
	end

	factory :advisor do
		account_id 3
		name { Faker::Name.name }
	  phone_number_1 { Faker::PhoneNumber.phone_number.gsub(/[^\d\s]/, '') }
	  email_id { Faker::Internet.email }
	end

	factory :property do
		account_id 3
	  name { Faker::Address.city }
	  price_for_driver 500
	  ensure_availability_before_booking 1
	  phone_number { Faker::PhoneNumber.phone_number.gsub(/[^\d\s]/, '') }
	  phone_number_2 { Faker::PhoneNumber.phone_number.gsub(/[^\d\s]/, '') }
		suggested_activities { Faker::Lorem.paragraph }
		url { Faker::Internet.url }
		service_tax_rate 6.18
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

	factory :taxi do
		account_id 3
		agency
		model "Toyota Innova"
		max_passengers 7
		unit_price 3500
	end

	factory :guest do
		account_id 3
		name { Faker::Name.name }
	  phone_number { Faker::PhoneNumber.phone_number.gsub(/[^\d\s]/, '') }
		email_id { Faker::Internet.email }
		city { Faker::Address.city }
	  phone_number_2 { Faker::PhoneNumber.phone_number.gsub(/[^\d\s]/, '') }
		title "Mr"
	end

	factory :trip do
		account_id 3
    association :customer, :factory => :guest
		name { Faker::Lorem.words(1).first }
		start_date { Date.today + 30.days }
		number_of_days 10
		advisor
	end

	factory :booking do
		account_id 3
		trip
		property
		check_in_date { Date.today + 30.days }
		number_of_nights 4
		meal_plan "EPAI"
	end

	factory :room do
		account_id 3
		booking
		room_type
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
		every_day 0	

		factory :vas_booking_for_trip do
			trip
		end

		factory :vas_booking_for_booking do
			booking
		end
	end

	factory :taxi_booking do
		account_id 3
		trip
		taxi
		number_of_vehicles 1
		start_date { Date.today + 30.days }
		number_of_days 10
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
