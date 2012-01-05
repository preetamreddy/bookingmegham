require 'test_helper'

class RoomTypeTest < ActiveSupport::TestCase
	setup do
		@sangla_id = properties(:sangla).id
	end

  test "room type should belong to a valid property" do
		retreat_deluxe_room = RoomType.new(property_id: 42,
														room_type: "Retreat deluxe room",
														number_of_rooms: 6)
		assert !retreat_deluxe_room.save
		retreat_deluxe_room.property_id = @sangla_id
		assert retreat_deluxe_room.save
  end

	test "room type cannot be destroyed if it has bookings" do
		super_deluxe_tent = room_types(:sangla_super_deluxe_tent)
		assert !super_deluxe_tent.destroy
	end

	test "room type details can not be empty" do
		retreat_deluxe_room = RoomType.new
		assert retreat_deluxe_room.invalid?
		assert retreat_deluxe_room.errors[:property_id].any?
		assert retreat_deluxe_room.errors[:room_type].any?
		assert retreat_deluxe_room.errors[:number_of_rooms].any?
	end

	test "room type should be unique" do
		deluxe_tent = RoomType.new(property_id: @sangla_id,
										room_type: "DELUXE TENT",
										number_of_rooms: 8)
		assert deluxe_tent.invalid?
		assert deluxe_tent.errors[:room_type].any?
	end

	test "number of rooms should be an integer greater than 0" do
		retreat_super_deluxe_room = RoomType.new(property_id: @sangla_id,
																	room_type: "Retreat super deluxe room",
																	number_of_rooms: 0)
		assert retreat_super_deluxe_room.invalid?
		assert retreat_super_deluxe_room.errors[:number_of_rooms].any?
		retreat_super_deluxe_room.number_of_rooms = "abc"
		assert retreat_super_deluxe_room.invalid?
		assert retreat_super_deluxe_room.errors[:number_of_rooms].any?
		retreat_super_deluxe_room.number_of_rooms = 1.5
		assert retreat_super_deluxe_room.invalid?
		assert retreat_super_deluxe_room.errors[:number_of_rooms].any?
		retreat_super_deluxe_room.number_of_rooms = -1
		assert retreat_super_deluxe_room.invalid?
		assert retreat_super_deluxe_room.errors[:number_of_rooms].any?
		retreat_super_deluxe_room.number_of_rooms = 6
		assert retreat_super_deluxe_room.valid?
	end

	test "price should be an integer greater than or equal to 0" do
		retreat_super_deluxe_room = RoomType.new(property_id: @sangla_id,
																	room_type: "Retreat super deluxe room",
																	number_of_rooms: 6,
																	price_for_single_occupancy: -1,
																	price_for_double_occupancy: "abc")
		assert retreat_super_deluxe_room.invalid?
		assert retreat_super_deluxe_room.errors[:price_for_single_occupancy].any?
		assert retreat_super_deluxe_room.errors[:price_for_double_occupancy].any?
		retreat_super_deluxe_room.price_for_single_occupancy = 7200.5
		retreat_super_deluxe_room.price_for_double_occupancy = 0
		assert retreat_super_deluxe_room.invalid?
		assert retreat_super_deluxe_room.errors[:price_for_single_occupancy].any?
		assert !retreat_super_deluxe_room.errors[:price_for_double_occupancy].any?
		retreat_super_deluxe_room.price_for_single_occupancy = 7200
		retreat_super_deluxe_room.price_for_single_occupancy = 8100
		assert retreat_super_deluxe_room.valid?
	end
end
