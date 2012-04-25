require 'test_helper'

class PropertyTest < ActiveSupport::TestCase
  test "property cannot be destroyed if it has room types" do
		sangla = properties(:sangla)
		assert !sangla.destroy
  end

	test "property should have a name" do
		darjeeling = FactoryGirl.build(:property, :name => "")
		assert darjeeling.invalid?
		assert darjeeling.errors[:name].any?
		darjeeling.name = "Darjeeling"
		assert darjeeling.save
	end

	test "property name should be unique" do
		darjeeling = FactoryGirl.create(:property, :name => "Darjeeling")
		darjeeling_2 = FactoryGirl.build(:property, :name => "Darjeeling")
		assert darjeeling_2.invalid?
		assert darjeeling_2.errors[:name].any?
		darjeeling_2.name = "Darjeeling 2"
		assert darjeeling_2.save
	end

	test "price should be an integer greater than or equal to 0" do
		new_property = FactoryGirl.build(:property,
									:price_for_children_between_5_and_12_years => -1,
									:price_for_children_below_5_years => "abc",
									:price_for_triple_occupancy => 2000.5,
									:price_for_driver => nil)
		assert new_property.invalid?
		assert new_property.errors[:price_for_children_between_5_and_12_years].any?
		assert new_property.errors[:price_for_children_below_5_years].any?
		assert new_property.errors[:price_for_triple_occupancy].any?
		assert !new_property.errors[:price_for_driver].any?
		new_property.price_for_children_between_5_and_12_years = 1200
		new_property.price_for_children_below_5_years = 1200
		new_property.price_for_triple_occupancy = 1200
		new_property.price_for_driver = 1200
		assert new_property.valid?
	end
end
