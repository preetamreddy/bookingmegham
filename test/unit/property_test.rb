require 'test_helper'

class PropertyTest < ActiveSupport::TestCase
  test "property cannot be destroyed if it has room types" do
		sangla = properties(:sangla)
		assert !sangla.destroy
  end

	test "property should have a name" do
		thanedar = Property.new
		assert thanedar.invalid?
		thanedar.name = "Thanedar"
		assert thanedar.valid?
	end

	test "property name should be unique" do
		sangla = Property.new(name: "sangla")
		assert sangla.invalid?
		assert sangla.errors[:name].any?
	end

	test "price should be an integer greater than or equal to 0" do
		thanedar = Property.new(name: "Thanedar",
								price_for_children_between_5_and_12_years: -1,
								price_for_children_below_5_years: "abc",
								price_for_triple_occupancy: 2000.5,
								price_for_driver: nil)
		assert thanedar.invalid?
		assert thanedar.errors[:price_for_children_between_5_and_12_years].any?
		assert thanedar.errors[:price_for_children_below_5_years].any?
		assert thanedar.errors[:price_for_triple_occupancy].any?
		assert !thanedar.errors[:price_for_driver].any?
		sojha = Property.new(name: "Sojha",
								price_for_children_between_5_and_12_years: 1200,
								price_for_children_below_5_years: 0,
								price_for_triple_occupancy: 2000,
								price_for_driver: 500)
		assert sojha.valid?
	end
end
