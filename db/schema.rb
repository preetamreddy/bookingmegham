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

ActiveRecord::Schema.define(:version => 20111214091520) do

  create_table "bookings", :force => true do |t|
    t.string   "guest_name"
    t.integer  "guest_phone_number"
    t.string   "guest_email_id"
    t.integer  "number_of_rooms"
    t.date     "from"
    t.date     "to"
    t.integer  "number_of_adults"
    t.integer  "number_of_children"
    t.integer  "number_of_infants"
    t.time     "guests_arrival_time"
    t.string   "guests_arriving_from"
    t.string   "guests_food_preferences"
    t.integer  "total_price"
    t.integer  "paid"
    t.integer  "balance_payment"
    t.date     "pay_by_date"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
