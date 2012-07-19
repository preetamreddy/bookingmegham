require 'test_helper'

class BillingObserverTest < ActiveSupport::TestCase
	setup do
		@himachal_trip = FactoryGirl.create(:trip)
		@trip_id = @himachal_trip.id
		guide = FactoryGirl.create(:vas_booking,
							:trip => @himachal_trip,
							:unit_price => 500,
							:number_of_units => 1)
	end

	test "trip final price includes vas" do
		assert_equal 500, @himachal_trip.final_price
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
									:amount => 500)
		assert_equal Trip::FULLY_PAID, @himachal_trip.reload.payment_status
		assert_equal nil, @himachal_trip.pay_by_date
	end

	test "payment status is fully paid when full payment is made in 2 payments" do
		payment_1 = FactoryGirl.create(:payment,
									:trip => @himachal_trip,
									:amount => 200)
		payment_2 = FactoryGirl.create(:payment,
									:trip => @himachal_trip,
									:amount => 300)
		assert_equal Trip::FULLY_PAID, @himachal_trip.reload.payment_status
		assert_equal nil, @himachal_trip.pay_by_date
	end

	test "payment status is partially paid when full payment is made and partially destroyed" do
		payment_1 = FactoryGirl.create(:payment,
									:trip => @himachal_trip,
									:amount => 200)
		payment_2 = FactoryGirl.create(:payment,
									:trip => @himachal_trip,
									:amount => 300)
		payment_2.destroy
		assert_equal Trip::PARTIALLY_PAID, @himachal_trip.reload.payment_status
		assert_equal (@himachal_trip.start_date - 21), @himachal_trip.pay_by_date
	end

	test "payment status is partially paid when full payment is made and updated lower" do
		payment_1 = FactoryGirl.create(:payment,
									:trip => @himachal_trip,
									:amount => 500)
		payment_1.update_attributes(:amount => 200)
		assert_equal Trip::PARTIALLY_PAID, @himachal_trip.reload.payment_status
		assert_equal (@himachal_trip.start_date - 21), @himachal_trip.pay_by_date
	end

	test "payment status is not paid when full payment is made and destroyed" do
		payment_1 = FactoryGirl.create(:payment,
									:trip => @himachal_trip,
									:amount => 500)
		payment_1.destroy
		assert_equal Trip::NOT_PAID, @himachal_trip.reload.payment_status
		assert_equal (Date.today.to_date + 2), @himachal_trip.pay_by_date
	end

	test "payment status is not paid when full payment is made and updated to 0" do
		payment_1 = FactoryGirl.create(:payment,
									:trip => @himachal_trip,
									:amount => 500)
		payment_1.update_attributes(:amount => 0)
		assert_equal Trip::NOT_PAID, @himachal_trip.reload.payment_status
		assert_equal (Date.today.to_date + 2), @himachal_trip.pay_by_date
	end
end
