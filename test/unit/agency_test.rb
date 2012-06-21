require 'test_helper'

class AgencyTest < ActiveSupport::TestCase
  test "duplicate entries for an agency can exist under different accounts" do
		himwon = FactoryGirl.create(:agency, 
			:account_id => 1, 
			:name => "Himalayan Wonders",
			:phone_number => "+91 12345 12345",
			:email_id => "info@himwon.com")
		himwon_2 = FactoryGirl.build(:agency, 
			:account_id => 2, 
			:name => "Himalayan Wonders",
			:phone_number => "+91 12345 12345",
			:email_id => "info@himwon.com")
		assert himwon_2.valid?
  end
  test "agency email id should be unique within an account" do
		himwon = FactoryGirl.create(:agency, 
			:account_id => 1, 
			:email_id => "info@himwon.com")
		himwon_2 = FactoryGirl.build(:agency, 
			:account_id => 1, 
			:email_id => "info@himwon.com")
		assert himwon_2.invalid?
		himwon_2.email_id = "INFO@HIMWON.COM"
		assert himwon_2.invalid?
		himwon_2.email_id = "INFO@HIMWON2.COM"
		assert himwon_2.valid?
		himwon.name = "Himalayan Wonder"
		assert himwon.valid?
		himwon.email_id = ""
		assert himwon.valid?
  end
  test "agency phone number should be unique within an account" do
		himwon = FactoryGirl.create(:agency, 
			:account_id => 1, 
			:phone_number => "+91 12345 12345")
		himwon_2 = FactoryGirl.build(:agency, 
			:account_id => 1, 
			:phone_number => "+91 12345 12345")
		assert himwon_2.invalid?
		himwon_2.phone_number = "+91 12345 56789"
		assert himwon_2.valid?
		himwon.name = "Himalayan Wonder"
		assert himwon.valid?
		himwon.phone_number = ""
		assert himwon.valid?
  end
end
