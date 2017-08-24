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

ActiveRecord::Schema.define(:version => 20170823034045) do

  create_table "account_settings", :force => true do |t|
    t.string   "registered_name"
    t.string   "name"
    t.string   "name_abbreviation"
    t.string   "phone_number_1"
    t.string   "email"
    t.text     "postal_address"
    t.string   "url"
    t.string   "pan"
    t.string   "service_tax_number"
    t.integer  "tds_percent"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "service_charge",                       :default => 0
    t.float    "vat_rate",                             :default => 0.0
    t.float    "service_tax_rate",                     :default => 0.0
    t.float    "tour_operator_service_tax_rate",       :default => 0.0
    t.string   "tax_setting"
    t.string   "gstin"
    t.float    "cgst_rate_for_tour_operator_services", :default => 0.0
    t.float    "sgst_rate_for_tour_operator_services", :default => 0.0
    t.float    "cgst_rate_for_hotel_services",         :default => 0.0
    t.float    "sgst_rate_for_hotel_services",         :default => 0.0
    t.integer  "counter_for_tax_invoice",              :default => 1
  end

  add_index "account_settings", ["account_id"], :name => "index_account_settings_on_account_id"

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "subdomain"
    t.string   "phone_number_1"
    t.string   "email"
    t.text     "postal_address"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "pan"
  end

  create_table "advisors", :force => true do |t|
    t.string   "name"
    t.string   "phone_number_1"
    t.string   "phone_number_2"
    t.string   "email_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  add_index "advisors", ["account_id"], :name => "index_advisors_on_account_id"

  create_table "agencies", :force => true do |t|
    t.string   "registered_name"
    t.string   "phone_number"
    t.string   "email_id"
    t.text     "postal_address"
    t.string   "city"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pan_number"
    t.string   "name"
    t.integer  "account_id"
    t.string   "phone_number_2"
    t.string   "email_id_2"
    t.string   "gstin"
  end

  add_index "agencies", ["account_id"], :name => "index_agencies_on_account_id"

  create_table "bookings", :force => true do |t|
    t.time     "guests_arrival_time"
    t.string   "guests_arriving_from"
    t.integer  "total_price"
    t.text     "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "check_in_date"
    t.date     "check_out_date"
    t.integer  "trip_id"
    t.integer  "property_id"
    t.integer  "number_of_nights"
    t.integer  "service_tax",                 :default => 0
    t.string   "departure_destination"
    t.integer  "collect_for_all_extras",      :default => 1
    t.integer  "collect_for_children",        :default => 1
    t.integer  "collect_for_driver_and_help", :default => 1
    t.integer  "bill_agent_on_chosen_plan",   :default => 1
    t.string   "meal_plan"
    t.string   "reservation_reference"
    t.string   "booking_status",              :default => "Booked"
    t.integer  "account_id"
    t.integer  "price_for_rooms",             :default => 0
    t.integer  "price_for_vas",               :default => 0
    t.integer  "counter"
    t.integer  "vat",                         :default => 0
    t.integer  "luxury_tax",                  :default => 0
    t.float    "cgst",                        :default => 0.0
    t.float    "sgst",                        :default => 0.0
    t.integer  "taxable_value",               :default => 0
    t.integer  "discount",                    :default => 0
  end

  add_index "bookings", ["account_id"], :name => "index_bookings_on_account_id"

  create_table "guests", :force => true do |t|
    t.string   "name"
    t.string   "phone_number"
    t.string   "email_id"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number_2"
    t.string   "email_id_2"
    t.text     "postal_address"
    t.string   "title"
    t.integer  "account_id"
    t.string   "gstin"
  end

  add_index "guests", ["account_id"], :name => "index_guests_on_account_id"

  create_table "line_items", :force => true do |t|
    t.integer  "room_type_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "booked_rooms"
    t.integer  "account_id"
    t.integer  "room_id"
  end

  add_index "line_items", ["account_id"], :name => "index_line_items_on_account_id"

  create_table "payment_modes", :force => true do |t|
    t.integer  "account_id"
    t.integer  "account_setting_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payment_modes", ["account_id"], :name => "index_payment_modes_on_account_id"

  create_table "payments", :force => true do |t|
    t.integer  "trip_id"
    t.date     "date_received"
    t.integer  "amount"
    t.string   "details"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "payee_name"
    t.string   "payment_mode"
    t.integer  "account_id"
    t.integer  "counter"
  end

  add_index "payments", ["account_id"], :name => "index_payments_on_account_id"

  create_table "price_lists", :force => true do |t|
    t.integer  "room_type_id"
    t.integer  "account_id"
    t.integer  "price_for_single_occupancy"
    t.integer  "price_for_double_occupancy"
    t.integer  "price_for_extra_adults"
    t.integer  "price_for_children"
    t.integer  "price_for_infants"
    t.string   "meal_plan"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price_for_lodging",                  :default => 0
    t.integer  "price_for_food_on_single",           :default => 0
    t.integer  "price_for_food_on_double",           :default => 0
    t.integer  "price_for_transportation_and_guide", :default => 0
  end

  add_index "price_lists", ["account_id"], :name => "index_price_lists_on_account_id"

  create_table "properties", :force => true do |t|
    t.string   "name"
    t.integer  "price_for_driver"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ensure_availability_before_booking", :default => 0
    t.string   "phone_number"
    t.string   "phone_number_2"
    t.text     "address"
    t.text     "suggested_activities"
    t.string   "url"
    t.integer  "account_id"
    t.string   "email"
    t.string   "city"
    t.float    "service_tax_rate"
    t.integer  "allow_online_availability_check",    :default => 0
    t.float    "luxury_tax_rate",                    :default => 0.0
    t.float    "vat_rate",                           :default => 0.0
    t.float    "cgst_rate",                          :default => 0.0
    t.float    "sgst_rate",                          :default => 0.0
  end

  add_index "properties", ["account_id"], :name => "index_properties_on_account_id"

  create_table "room_types", :force => true do |t|
    t.integer  "property_id"
    t.string   "room_type"
    t.integer  "price_for_single_occupancy"
    t.integer  "price_for_double_occupancy"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number_of_rooms"
    t.integer  "price_for_lodging"
    t.integer  "price_for_triple_occupancy"
    t.integer  "price_for_children_between_5_and_12_years"
    t.integer  "price_for_children_below_5_years"
    t.integer  "account_id"
    t.integer  "deleted",                                   :default => 0
    t.integer  "price_for_transportation_and_guide",        :default => 0
    t.integer  "price_for_food_on_single",                  :default => 0
    t.integer  "price_for_food_on_double",                  :default => 0
    t.integer  "order_for_booking_chart",                   :default => 0
    t.float    "cgst_rate",                                 :default => 0.0
    t.float    "sgst_rate",                                 :default => 0.0
  end

  add_index "room_types", ["account_id"], :name => "index_room_types_on_account_id"

  create_table "rooms", :force => true do |t|
    t.string   "occupancy"
    t.integer  "number_of_adults"
    t.integer  "number_of_children_between_5_and_12_years", :default => 0
    t.integer  "number_of_rooms"
    t.integer  "booking_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "room_rate"
    t.integer  "service_tax_per_room_night"
    t.integer  "number_of_children_below_5_years",          :default => 0
    t.integer  "account_id"
    t.integer  "total_price"
    t.integer  "service_tax"
    t.integer  "room_type_id"
    t.date     "check_in_date"
    t.date     "check_out_date"
    t.integer  "number_of_nights"
    t.integer  "cancelled",                                 :default => 0
    t.integer  "cancellation_charge",                       :default => 0
    t.integer  "vat",                                       :default => 0
    t.integer  "luxury_tax",                                :default => 0
    t.float    "cgst",                                      :default => 0.0
    t.float    "sgst",                                      :default => 0.0
    t.integer  "discount",                                  :default => 0
    t.integer  "taxable_value",                             :default => 0
  end

  add_index "rooms", ["account_id"], :name => "index_rooms_on_account_id"

  create_table "taxi_bookings", :force => true do |t|
    t.integer  "trip_id"
    t.integer  "taxi_id"
    t.integer  "number_of_vehicles"
    t.integer  "unit_price"
    t.text     "pickup_address"
    t.time     "pickup_time"
    t.string   "drop_off_city"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.integer  "number_of_days"
    t.date     "end_date"
    t.integer  "account_id"
    t.integer  "total_price"
    t.integer  "counter"
    t.float    "cgst",               :default => 0.0
    t.float    "sgst",               :default => 0.0
    t.integer  "taxable_value",      :default => 0
  end

  add_index "taxi_bookings", ["account_id"], :name => "index_taxi_bookings_on_account_id"

  create_table "taxi_details", :force => true do |t|
    t.integer  "taxi_booking_id"
    t.string   "registration_number"
    t.string   "driver_name"
    t.string   "driver_phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  add_index "taxi_details", ["account_id"], :name => "index_taxi_details_on_account_id"

  create_table "taxis", :force => true do |t|
    t.integer  "agency_id"
    t.string   "model"
    t.integer  "max_passengers"
    t.integer  "unit_price"
    t.text     "terrain_limitations"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  add_index "taxis", ["account_id"], :name => "index_taxis_on_account_id"

  create_table "tooltips", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "markup",     :default => "markdown"
    t.string   "locale"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trip_rooms", :force => true do |t|
    t.integer  "trip_id"
    t.string   "occupancy"
    t.integer  "number_of_rooms"
    t.integer  "number_of_adults"
    t.integer  "number_of_children_between_5_and_12_years", :default => 0
    t.integer  "number_of_children_below_5_years",          :default => 0
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trips", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.string   "food_preferences"
    t.date     "pay_by_date"
    t.text     "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "discount"
    t.string   "payment_status"
    t.integer  "number_of_days"
    t.string   "medical_constraints"
    t.integer  "advisor_id"
    t.date     "invoice_date"
    t.integer  "tac",                     :default => 0
    t.integer  "account_id"
    t.integer  "price_for_vas",           :default => 0
    t.integer  "price_for_transport",     :default => 0
    t.integer  "price_for_rooms",         :default => 0
    t.integer  "service_tax",             :default => 0
    t.integer  "paid",                    :default => 0
    t.string   "customer_type"
    t.integer  "customer_id"
    t.string   "phone_number"
    t.integer  "payments_counter",        :default => 0
    t.integer  "bookings_counter",        :default => 0
    t.integer  "taxi_bookings_counter",   :default => 0
    t.integer  "tds",                     :default => 0
    t.integer  "vat",                     :default => 0
    t.integer  "luxury_tax",              :default => 0
    t.integer  "banjara_vat",             :default => 0
    t.integer  "banjara_service_tax",     :default => 0
    t.integer  "banjara_luxury_tax",      :default => 0
    t.integer  "show_tax_breakup",        :default => 0
    t.float    "cgst",                    :default => 0.0
    t.float    "sgst",                    :default => 0.0
    t.integer  "taxable_value",           :default => 0
    t.integer  "counter_for_tax_invoice", :default => 0
    t.integer  "checked_out",             :default => 0
    t.integer  "tds_on_tac",              :default => 0
  end

  add_index "trips", ["account_id"], :name => "index_trips_on_account_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",        :null => false
    t.string   "encrypted_password",     :default => "",        :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "advisor_id"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "role",                   :default => "advisor"
    t.integer  "account_id"
  end

  add_index "users", ["account_id"], :name => "index_users_on_account_id"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

  create_table "vas_bookings", :force => true do |t|
    t.integer  "trip_id"
    t.integer  "booking_id"
    t.integer  "unit_price"
    t.integer  "number_of_units"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.text     "value_added_service"
    t.integer  "total_price",         :default => 0
    t.integer  "every_day",           :default => 0
    t.string   "tax_type"
    t.float    "cgst",                :default => 0.0
    t.float    "sgst",                :default => 0.0
    t.integer  "taxable_value",       :default => 0
    t.integer  "discount",            :default => 0
  end

  add_index "vas_bookings", ["account_id"], :name => "index_vas_bookings_on_account_id"

end
