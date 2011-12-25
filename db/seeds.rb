# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Booking.delete_all

Booking.create(guest_name: "Mr. Ravi Mariwala",
guest_phone_number: 9998887776,
guest_email_id: "rm@rm.com",
number_of_rooms: 4,
check_in_date: "2012/05/10",
check_out_date: "2012/05/15",
number_of_adults: 8,
number_of_children: 4,
number_of_infants: 0,
guests_arrival_time: "14:00",
guests_arriving_from: "Thanedar",
total_price: 80000,
paid: 0,
balance_payment: 80000,
pay_by_date: "2012/05/01",
comments: "Old guests of Banjara. Have sent so many people over the years. 50% discounted. Infact, we didn't want to charge, but Ravi insisted. Extras: include any barbecue items they ask for")
