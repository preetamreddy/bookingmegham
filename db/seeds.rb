# This file contains all the record creation needed to seed the database with its default values.
# The data can be loaded with the rake db:seed (or created alongside the db with db:setup).

Agency.delete_all
Advisor.delete_all
User.delete_all

Agency.create(
				name: 'BookingMegham',
				phone_number: 919902012405,
				email_id: 'preetam.reddy@gmail.com',
				postal_address:
					%{<p>
							C-401, Tower-1, Adarsh Palm Retreat,
							Devarabisanahalli, Outer Ring Road,
							Bangalore - 560103, India
						</p>},
				city: 'Bangalore',
				url: 'www.bookingmegham.com')

Advisor.create(
				agency_id: Agency.find_by_name('BookingMegham').id,
				name: 'Preetam Reddy',
				phone_number_1: 919902012405,
				phone_number_2: 918025843149,
				email_id: 'preetam.reddy@gmail.com')

User.create(
				agency_id: Agency.find_by_name('BookingMegham').id,
				advisor_id: Advisor.find_by_name('Preetam Reddy').id,
				name: 'preetam',
				password: 'znmd')
