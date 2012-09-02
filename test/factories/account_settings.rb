# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account_setting do
    registered_name "MyString"
    name "MyString"
    name_abbreviation "MyString"
    phone_number_1 "MyString"
    email "MyString"
    postal_address "MyText"
    url "MyString"
    pan "MyString"
    service_tax_number "MyString"
    tds_percent 1
    account_id 1
  end
end
