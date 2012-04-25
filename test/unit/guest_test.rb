require 'test_helper'

class GuestTest < ActiveSupport::TestCase
#  test "guest cannot be destroyed if she has trips" do
#  end

	test "guest details can not be empty" do
		srini = FactoryGirl.build(:guest,
							:name => "",
							:title => "")
		assert srini.invalid?
		assert srini.errors[:name].any?
		assert srini.errors[:title].any?
		srini.name = "Srinivas Rao"
		srini.title = "Mr"
		assert srini.save
	end

	test "guest phone number should be unique" do
		preetam = FactoryGirl.create(:guest,
							:phone_number => "+91 99020 12405")
		pallavi = FactoryGirl.build(:guest,
							:phone_number => "+91 99020 12405")
		assert pallavi.invalid?
		assert pallavi.errors[:phone_number].any?
		pallavi.phone_number = "+91 98868 33500"
		assert pallavi.save
	end

	test "guest email id should be unique" do
		preetam = FactoryGirl.create(:guest,
							:email_id => "preetam@ezbook.in")
		pallavi = FactoryGirl.build(:guest,
							:email_id => "preetam@ezbook.in")
		assert pallavi.invalid?
		assert pallavi.errors[:email_id].any?
		pallavi.email_id = "pallavi@ezbook.in"
		assert pallavi.save
	end

	test "guest phone number format" do
		new_guest = FactoryGirl.build(:guest,
									phone_number: "ab")
		assert new_guest.invalid?
		assert new_guest.errors[:phone_number].any?
		new_guest.phone_number = "-1"
		assert new_guest.invalid?
		assert new_guest.errors[:phone_number].any?
		new_guest.phone_number = "90.4"
		assert new_guest.invalid?
		assert new_guest.errors[:phone_number].any?
		new_guest.phone_number = "+91 80 2333 3333"
		assert new_guest.save
	end
end
