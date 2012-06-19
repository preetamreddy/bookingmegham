# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    name "MyString"
    subdomain "MyString"
    phone_number_1 "MyString"
    email "MyString"
    postal_address "MyText"
    url "MyString"
  end
end
