# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120315140513) do

  create_table "advisors", :force => true do |t|
    t.integer  "agency_id"
    t.string   "name"
    t.string   "phone_number_1"
    t.string   "phone_number_2"
    t.string   "email_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "agencies", :force => true do |t|
    t.string   "name"
    t.string   "phone_number"
    t.string   "email_id"
    t.text     "postal_address"
    t.string   "city"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "pan_number"
  end

  create_table "bookings", :force => true do |t|
    t.time     "guests_arrival_time"
    t.string   "guests_arriving_from"
    t.integer  "total_price"
    t.text     "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "room_type_id"
    t.date     "check_in_date"
    t.date     "check_out_date"
    t.integer  "trip_id"
    t.integer  "number_of_rooms"
    t.integer  "guest_id"
    t.integer  "property_id"
    t.integer  "number_of_nights"
    t.integer  "service_tax"
    t.text     "suggested_activities"
    t.string   "departure_destination"
    t.integer  "collect_for_all_extras",      :default => 1
    t.integer  "collect_for_children",        :default => 1
    t.integer  "collect_for_driver_and_help", :default => 1
    t.integer  "bill_agent_on_chosen_plan",   :default => 1
    t.string   "meal_plan"
    t.string   "reservation_reference"
    t.string   "distance_and_time"
    t.text     "getting_there"
    t.text     "getting_home"
  end

  create_table "feedbacks", :force => true do |t|
    t.string   "model"
    t.string   "view"
    t.text     "description"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "priority"
    t.string   "criticality"
  end

  create_table "guests", :force => true do |t|
    t.string   "name"
    t.string   "phone_number"
    t.string   "email_id"
    t.string   "resident_of"
    t.text     "other_information"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number_2"
    t.string   "email_id_2"
    t.text     "address"
    t.string   "title"
  end

  create_table "line_items", :force => true do |t|
    t.integer  "booking_id"
    t.integer  "room_type_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "booked_rooms"
    t.integer  "blocked",      :default => 1
  end

  create_table "payments", :force => true do |t|
    t.integer  "trip_id"
    t.date     "date_received"
    t.integer  "amount"
    t.string   "details"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "payee_name"
  end

  create_table "properties", :force => true do |t|
    t.string   "name"
    t.integer  "price_for_children_below_5_years"
    t.integer  "price_for_triple_occupancy"
    t.integer  "price_for_driver"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price_for_children_between_5_and_12_years"
    t.integer  "ensure_availability_before_booking",        :default => 1
    t.integer  "consider_blocked_rooms_as_booked",          :default => 1
    t.integer  "agency_id"
    t.string   "phone_number"
    t.string   "phone_number_2"
    t.text     "address"
    t.text     "suggested_activities"
    t.string   "url"
  end

  create_table "room_types", :force => true do |t|
    t.integer  "property_id"
    t.string   "room_type"
    t.integer  "price_for_single_occupancy"
    t.integer  "price_for_double_occupancy"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number_of_rooms"
    t.integer  "price_for_room"
  end

  create_table "rooms", :force => true do |t|
    t.string   "occupancy"
    t.integer  "number_of_adults"
    t.integer  "number_of_children_between_5_and_12_years"
    t.integer  "number_of_rooms"
    t.integer  "trip_id"
    t.integer  "booking_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "room_rate"
    t.integer  "service_tax_rate"
  end

  create_table "taxi_bookings", :force => true do |t|
    t.integer  "trip_id"
    t.integer  "taxi_id"
    t.integer  "number_of_vehicles"
    t.integer  "unit_price"
    t.string   "reservation_reference"
    t.text     "pickup_address"
    t.time     "pickup_time"
    t.string   "drop_off_city"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.integer  "number_of_days"
    t.date     "end_date"
  end

  create_table "taxi_details", :force => true do |t|
    t.integer  "taxi_booking_id"
    t.string   "registration_number"
    t.string   "driver_name"
    t.string   "driver_phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taxis", :force => true do |t|
    t.integer  "agency_id"
    t.string   "model"
    t.integer  "max_passengers"
    t.integer  "unit_price"
    t.text     "terrain_limitations"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trek_bookings", :force => true do |t|
    t.integer  "trip_id"
    t.integer  "trek_id"
    t.integer  "unit_price"
    t.date     "start_date"
    t.string   "origin"
    t.string   "final_destination"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number_of_days"
    t.date     "end_date"
  end

  create_table "trek_prices", :force => true do |t|
    t.integer  "trek_id"
    t.integer  "unit_price"
    t.integer  "min_group_size"
    t.integer  "max_group_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "treks", :force => true do |t|
    t.string   "name"
    t.text     "itinerary"
    t.string   "difficulty"
    t.integer  "number_of_days"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trips", :force => true do |t|
    t.integer  "guest_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "number_of_children_below_5_years"
    t.string   "food_preferences"
    t.date     "pay_by_date"
    t.text     "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "discount"
    t.integer  "number_of_drivers"
    t.string   "payment_status"
    t.integer  "number_of_trekkers",               :default => 0
    t.integer  "number_of_days"
    t.string   "medical_constraints"
    t.integer  "agency_id"
    t.integer  "advisor_id"
    t.string   "email_ids"
    t.date     "invoice_date"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.integer  "advisor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agency_id"
  end

  create_table "value_added_services", :force => true do |t|
    t.integer  "property_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unit_price",  :default => 0
    t.integer  "min_people",  :default => 1
  end

  create_table "vas_bookings", :force => true do |t|
    t.integer  "trip_id"
    t.integer  "booking_id"
    t.integer  "value_added_service_id"
    t.integer  "unit_price"
    t.integer  "number_of_people"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
