require 'test_helper'

class PaymentObserverTest < ActiveSupport::TestCase
	setup do
		@himachal_trip = FactoryGirl.create(:trip)
		@sangla_booking = FactoryGirl.create(:booking,
			:trip => @himachal_trip)
		@room = FactoryGirl.create(:room_for_booking,
			:booking => @sangla_booking)
		@payment = FactoryGirl.create(:payment,
			:trip => @himachal_trip)
	end

	test "payments are aggregated into trip" do
		assert_equal 1000, @himachal_trip.reload.paid
	end

	test "changes to payment amount updates trip" do
		@payment.update_attributes(:amount => 2000)
		assert_equal 2000, @himachal_trip.reload.paid
	end

	test "creating a new payment updates trip" do
		payment_2 = FactoryGirl.create(:payment,
			:trip => @himachal_trip,
			:amount => 9900)
		assert_equal 10900, @himachal_trip.reload.paid
	end

	test "deleting a payment updates trip" do
		payment_2 = FactoryGirl.create(:payment,
			:trip => @himachal_trip,
			:amount => 9900)
		@payment.destroy
		assert_equal 9900, @himachal_trip.reload.paid
	end
end
