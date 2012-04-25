require 'test_helper'

class RoomTypeTest < ActiveSupport::TestCase
	setup do
		@darjeeling = FactoryGirl.create(:property)
	end

  test "room type should belong to a valid property" do
		new_room_type = FactoryGirl.build(:room_type, :property => nil)
		assert !new_room_type.save
		new_room_type.property_id = @darjeeling.id
		assert new_room_type.save
  end

#	test "room type cannot be destroyed if it has bookings" do
#		super_deluxe_tent = room_types(:sangla_super_deluxe_tent)
#		assert !super_deluxe_tent.destroy
#	end

	test "room type can not be empty" do
		retreat_deluxe_room = FactoryGirl.build(:room_type,
														:room_type => nil)
		assert retreat_deluxe_room.invalid?
		assert retreat_deluxe_room.errors[:room_type].any?
		retreat_deluxe_room.room_type = "Retreat deluxe room"
		assert retreat_deluxe_room.save
	end

	test "number of rooms should be an integer greater than 0" do
		retreat_super_deluxe_room = FactoryGirl.build(:room_type,
																	:number_of_rooms => 1.5)
		assert retreat_super_deluxe_room.invalid?
		assert retreat_super_deluxe_room.errors[:number_of_rooms].any?
		retreat_super_deluxe_room.number_of_rooms = "abc"
		assert retreat_super_deluxe_room.invalid?
		assert retreat_super_deluxe_room.errors[:number_of_rooms].any?
		retreat_super_deluxe_room.number_of_rooms = -1
		assert retreat_super_deluxe_room.invalid?
		assert retreat_super_deluxe_room.errors[:number_of_rooms].any?
		retreat_super_deluxe_room.number_of_rooms = 6
		assert retreat_super_deluxe_room.save
	end

	test "price should be an integer greater than or equal to 0" do
		new_room_type = FactoryGirl.build(:room_type,
											price_for_single_occupancy: -1,
											price_for_double_occupancy: "abc")
		assert new_room_type.invalid?
		assert new_room_type.errors[:price_for_single_occupancy].any?
		assert new_room_type.errors[:price_for_double_occupancy].any?
		new_room_type.price_for_single_occupancy = 7200.5
		new_room_type.price_for_double_occupancy = 0
		assert new_room_type.invalid?
		assert new_room_type.errors[:price_for_single_occupancy].any?
		assert !new_room_type.errors[:price_for_double_occupancy].any?
		new_room_type.price_for_single_occupancy = 7200
		new_room_type.price_for_single_occupancy = 8100
		assert new_room_type.save
	end

	test "extra guest rates are taken from room type and not property" do
		a_room_type = FactoryGirl.create(:room_type,
										:price_for_triple_occupancy => 1111,
										:price_for_children_between_5_and_12_years => 555,
										:price_for_children_below_5_years => 222)
		assert_equal(5600, RoomType.price(a_room_type.id, "Double", 2, 0, 0))
		assert_equal(4700, RoomType.price(a_room_type.id, "Single", 1, 0, 0))

		assert_equal(6711, RoomType.price(a_room_type.id, "Double", 3, 0, 0))
		assert_equal(7822, RoomType.price(a_room_type.id, "Double", 4, 0, 0))
		assert_equal(6155, RoomType.price(a_room_type.id, "Double", 2, 1, 0))
		assert_equal(6710, RoomType.price(a_room_type.id, "Double", 2, 2, 0))

		assert_equal(5255, RoomType.price(a_room_type.id, "Single", 1, 1, 0))
		assert_equal(5810, RoomType.price(a_room_type.id, "Single", 1, 2, 0))

		assert_equal(5811, RoomType.price(a_room_type.id, "Single", 2, 0, 0))
		assert_equal(6366, RoomType.price(a_room_type.id, "Single", 2, 1, 0))

		assert_equal(5822, RoomType.price(a_room_type.id, "Double", 2, 0, 1))
		assert_equal(6044, RoomType.price(a_room_type.id, "Double", 2, 0, 2))
		assert_equal(6377, RoomType.price(a_room_type.id, "Double", 2, 1, 1))

		assert_equal(4922, RoomType.price(a_room_type.id, "Single", 1, 0, 1))
		assert_equal(5144, RoomType.price(a_room_type.id, "Single", 1, 0, 2))
		assert_equal(5477, RoomType.price(a_room_type.id, "Single", 1, 1, 1))
	end
end
