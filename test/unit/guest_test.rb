require 'test_helper'

class GuestTest < ActiveSupport::TestCase
  test "guest cannot be destroyed if it has trips" do
		preetam = guests(:preetam)
		assert !preetam.destroy
  end

	test "guest details can not be empty" do
		srini = Guest.new
		assert srini.invalid?
		assert srini.errors[:name].any?
		assert srini.errors[:phone_number].any?
		assert srini.errors[:email_id].any?
	end

	test "guest name should be unique" do
		preetam = Guest.new(name: "preetam reddy",
								phone_number: 99,
								email_id: "ab")
		assert preetam.invalid?
		assert preetam.errors[:name].any?
	end

	test "guest phone number should be unique" do
		pallavi = Guest.new(name: "Pallavi Singh",
								phone_number: 9902012405,
								email_id: "pallavi")
		assert pallavi.invalid?
		assert pallavi.errors[:phone_number].any?
	end

	test "guest email id should be unique" do
		pallavi = Guest.new(name: "Pallavi Singh",
								phone_number: 9886833500,
								email_id: "preetam.reddy@gmail.com")
		assert pallavi.invalid?
		assert pallavi.errors[:email_id].any?
	end
	
	test "guest phone number should be an integer greater than 0" do
		pallavi = Guest.new(name: "Pallavi Singh",
								phone_number: "ab",
								email_id: "pallavi2410@yahoo.com")
		assert pallavi.invalid?
		assert pallavi.errors[:phone_number].any?
		pallavi.phone_number = 0
		assert pallavi.invalid?
		assert pallavi.errors[:phone_number].any?
		pallavi.phone_number = -1
		assert pallavi.invalid?
		assert pallavi.errors[:phone_number].any?
		pallavi.phone_number = 90.4
		assert pallavi.invalid?
		assert pallavi.errors[:phone_number].any?
	end
end
