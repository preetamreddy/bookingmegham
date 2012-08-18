require 'test_helper'

class TripTest < ActiveSupport::TestCase
	setup do
		@preetam = FactoryGirl.create(:guest,
										:name => "Preetam Reddy")
		@himachal_trip = FactoryGirl.create(:trip,
			:guest => @preetam)
		@sangla_booking = FactoryGirl.create(:booking,
			:trip => @himachal_trip)
		@room = FactoryGirl.create(:room,
			:booking => @sangla_booking)
		@guide = FactoryGirl.create(:vas_booking_for_trip,
							:trip => @himachal_trip,
							:unit_price => 500,
							:number_of_units => 1)
	end

  test "trip should belong to a valid guest" do
		new_trip = FactoryGirl.build(:trip,
								:guest => nil)
		assert !new_trip.save
		assert new_trip.errors[:guest_id].any?
		new_trip.guest_id = @preetam.id
		assert new_trip.save
  end

	test "trip details can not be empty" do
		a_trip = FactoryGirl.build(:trip,
							:name => nil,
							:start_date => nil,
							:number_of_days => nil)
		assert a_trip.invalid?
		assert a_trip.errors[:name].any?
		assert a_trip.errors[:start_date].any?
		a_trip.name = "Signature Banjara"
		a_trip.start_date = Date.today + 30
		a_trip.number_of_days = 9
		assert a_trip.save
	end

	test "trip cannot be destroyed if it has bookings" do
		assert !@himachal_trip.reload.destroy
	end

	test "price for vas rolls up from vas bookings - single vas" do
		assert_equal 500, @himachal_trip.reload.price_for_vas
	end

	test "price for vas rolls up from vas bookings - multiple vas" do
		airport_pickup = FactoryGirl.create(:vas_booking_for_trip,
			:value_added_service => "Airport pickup",
			:unit_price => 2000,
			:trip => @himachal_trip)
		assert_equal 2500, @himachal_trip.reload.price_for_vas
	end
	test "trip final price includes vas" do
		assert_equal 22900, @himachal_trip.reload.final_price
	end

	test "payment status is not paid until payments are made" do
		assert_equal Trip::NOT_PAID, @himachal_trip.payment_status
	end

	test "payment status is partially paid when partial payment is made" do
		payment_1 = FactoryGirl.create(:payment,
									:trip => @himachal_trip,
									:amount => 200)
		assert_equal Trip::PARTIALLY_PAID, @himachal_trip.reload.payment_status
		assert_equal (@himachal_trip.start_date - 21), @himachal_trip.pay_by_date
	end

	test "payment status is fully paid when full payment is made in 1 payment" do
		payment_1 = FactoryGirl.create(:payment,
									:trip => @himachal_trip,
									:amount => 22900)
		assert_equal Trip::FULLY_PAID, @himachal_trip.reload.payment_status
		assert_equal nil, @himachal_trip.pay_by_date
	end

	test "payment status is fully paid when full payment is made in 2 payments" do
		payment_1 = FactoryGirl.create(:payment,
									:trip => @himachal_trip,
									:amount => 200)
		payment_2 = FactoryGirl.create(:payment,
									:trip => @himachal_trip,
									:amount => 22700)
		assert_equal Trip::FULLY_PAID, @himachal_trip.reload.payment_status
		assert_equal nil, @himachal_trip.pay_by_date
	end

	test "payment status is partially paid when full payment is made and partially destroyed" do
		payment_1 = FactoryGirl.create(:payment,
									:trip => @himachal_trip,
									:amount => 200)
		payment_2 = FactoryGirl.create(:payment,
									:trip => @himachal_trip,
									:amount => 22700)
		payment_2.destroy
		assert_equal Trip::PARTIALLY_PAID, @himachal_trip.reload.payment_status
		assert_equal (@himachal_trip.start_date - 21), @himachal_trip.pay_by_date
	end

	test "payment status is partially paid when full payment is made and updated lower" do
		payment_1 = FactoryGirl.create(:payment,
									:trip => @himachal_trip,
									:amount => 22900)
		payment_1.update_attributes(:amount => 200)
		assert_equal Trip::PARTIALLY_PAID, @himachal_trip.reload.payment_status
		assert_equal (@himachal_trip.start_date - 21), @himachal_trip.pay_by_date
	end

	test "payment status is not paid when full payment is made and destroyed" do
		payment_1 = FactoryGirl.create(:payment,
									:trip => @himachal_trip,
									:amount => 22900)
		payment_1.destroy
		assert_equal Trip::NOT_PAID, @himachal_trip.reload.payment_status
		assert_equal (Date.today.to_date + 2), @himachal_trip.pay_by_date
	end

	test "payment status is not paid when full payment is made and updated to 0" do
		payment_1 = FactoryGirl.create(:payment,
									:trip => @himachal_trip,
									:amount => 22900)
		payment_1.update_attributes(:amount => 0)
		assert_equal Trip::NOT_PAID, @himachal_trip.reload.payment_status
		assert_equal (Date.today.to_date + 2), @himachal_trip.pay_by_date
	end

	test "payment status is partially paid when fully paid trip has a new booking" do
		payment_1 = FactoryGirl.create(:payment,
			:trip => @himachal_trip,
			:amount => 22900)
		booking_2 = FactoryGirl.create(:booking,
			:trip => @himachal_trip)
		room = FactoryGirl.create(:room,
			:booking => booking_2)
		assert_equal Trip::PARTIALLY_PAID, @himachal_trip.reload.payment_status
		assert_equal (@himachal_trip.start_date - 21), @himachal_trip.pay_by_date
	end

	test "payment status is updated when trip vas is destroyed" do
		payment_1 = FactoryGirl.create(:payment,
			:trip => @himachal_trip,
			:amount => 22400)
		@guide.destroy		
		assert_equal Trip::FULLY_PAID, @himachal_trip.reload.payment_status
		assert_equal nil, @himachal_trip.pay_by_date
	end

	test "payment status is updated when room is destroyed" do
		payment_1 = FactoryGirl.create(:payment,
			:trip => @himachal_trip,
			:amount => 500)
		@room.destroy
		@sangla_booking.destroy
		assert_equal 500, @himachal_trip.reload.total_price
		assert_equal Trip::FULLY_PAID, @himachal_trip.reload.payment_status
		assert_equal nil, @himachal_trip.pay_by_date
	end
end
