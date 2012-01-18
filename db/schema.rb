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

ActiveRecord::Schema.define(:version => 20120118074557) do

  create_table "bookings", :force => true do |t|
    t.time     "guests_arrival_time"
    t.string   "guests_arriving_from"
    t.string   "guests_food_preferences"
    t.integer  "total_price"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "room_type_id"
    t.integer  "number_of_children_below_5_years"
    t.date     "check_in_date"
    t.date     "check_out_date"
    t.integer  "trip_id"
    t.integer  "number_of_drivers"
  end

  create_table "guests", :force => true do |t|
    t.string   "name"
    t.integer  "phone_number"
    t.string   "email_id"
    t.string   "resident_of"
    t.text     "other_information"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.date     "date_recieved"
    t.integer  "amount"
    t.string   "details"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "consider_blocked_rooms_as_booked", :default => 1
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
  end

  create_table "trips", :force => true do |t|
    t.integer  "guest_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "number_of_children_below_5_years"
    t.string   "food_preferences"
    t.date     "pay_by_date"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "discount"
    t.integer  "number_of_drivers"
  end

  create_table "versions", :force => true do |t|
    t.integer  "versioned_id"
    t.string   "versioned_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "user_name"
    t.text     "modifications"
    t.integer  "number"
    t.integer  "reverted_from"
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "versions", ["created_at"], :name => "index_versions_on_created_at"
  add_index "versions", ["number"], :name => "index_versions_on_number"
  add_index "versions", ["tag"], :name => "index_versions_on_tag"
  add_index "versions", ["user_id", "user_type"], :name => "index_versions_on_user_id_and_user_type"
  add_index "versions", ["user_name"], :name => "index_versions_on_user_name"
  add_index "versions", ["versioned_id", "versioned_type"], :name => "index_versions_on_versioned_id_and_versioned_type"

end
