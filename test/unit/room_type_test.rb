require 'test_helper'

class RoomTypeTest < ActiveSupport::TestCase
	setup do
		@darjeeling = FactoryGirl.create(:property)
		@standard = FactoryGirl.create(:room_type,
									:property => @darjeeling)
    @price_list = FactoryGirl.create(:price_list,
                  :room_type => @standard)
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
		assert_equal(5600, a_room_type.price("Double", 2, 0, 0, Date.today, 'APAI'))
		assert_equal(4700, a_room_type.price("Single", 1, 0, 0, Date.today, 'APAI'))

		assert_equal(6711, a_room_type.price("Double", 3, 0, 0, Date.today, 'APAI'))
		assert_equal(7822, a_room_type.price("Double", 4, 0, 0, Date.today, 'APAI'))
		assert_equal(6155, a_room_type.price("Double", 2, 1, 0, Date.today, 'APAI'))
		assert_equal(6710, a_room_type.price("Double", 2, 2, 0, Date.today, 'APAI'))

		assert_equal(5255, a_room_type.price("Single", 1, 1, 0, Date.today, 'APAI'))
		assert_equal(5810, a_room_type.price("Single", 1, 2, 0, Date.today, 'APAI'))

		assert_equal(5811, a_room_type.price("Single", 2, 0, 0, Date.today, 'APAI'))
		assert_equal(6366, a_room_type.price("Single", 2, 1, 0, Date.today, 'APAI'))

		assert_equal(5822, a_room_type.price("Double", 2, 0, 1, Date.today, 'APAI'))
		assert_equal(6044, a_room_type.price("Double", 2, 0, 2, Date.today, 'APAI'))
		assert_equal(6377, a_room_type.price("Double", 2, 1, 1, Date.today, 'APAI'))

		assert_equal(4922, a_room_type.price("Single", 1, 0, 1, Date.today, 'APAI'))
		assert_equal(5144, a_room_type.price("Single", 1, 0, 2, Date.today, 'APAI'))
		assert_equal(5477, a_room_type.price("Single", 1, 1, 1, Date.today, 'APAI'))
	end

  test "extra guest rates are taken from price list when found" do
		a_room_type = FactoryGirl.create(:room_type,
                    :price_for_single_occupancy => 4700,
                    :price_for_double_occupancy => 5600,
										:price_for_triple_occupancy => 1111,
										:price_for_children_between_5_and_12_years => 555,
										:price_for_children_below_5_years => 222)
    a_price_list = FactoryGirl.create(:price_list,
                    :room_type => a_room_type,
                    :price_for_single_occupancy => 47000,
                    :price_for_double_occupancy => 56000,
										:price_for_extra_adults => 11110,
										:price_for_children => 5550,
										:price_for_infants => 2220)
		assert_equal(56000, a_room_type.price("Double", 2, 0, 0, Date.today, 'APAI'))
		assert_equal(47000, a_room_type.price("Single", 1, 0, 0, Date.today, 'APAI'))

		assert_equal(67110, a_room_type.price("Double", 3, 0, 0, Date.today, 'APAI'))
		assert_equal(78220, a_room_type.price("Double", 4, 0, 0, Date.today, 'APAI'))
		assert_equal(61550, a_room_type.price("Double", 2, 1, 0, Date.today, 'APAI'))
		assert_equal(67100, a_room_type.price("Double", 2, 2, 0, Date.today, 'APAI'))

		assert_equal(52550, a_room_type.price("Single", 1, 1, 0, Date.today, 'APAI'))
		assert_equal(58100, a_room_type.price("Single", 1, 2, 0, Date.today, 'APAI'))

		assert_equal(58110, a_room_type.price("Single", 2, 0, 0, Date.today, 'APAI'))
		assert_equal(63660, a_room_type.price("Single", 2, 1, 0, Date.today, 'APAI'))

		assert_equal(58220, a_room_type.price("Double", 2, 0, 1, Date.today, 'APAI'))
		assert_equal(60440, a_room_type.price("Double", 2, 0, 2, Date.today, 'APAI'))
		assert_equal(63770, a_room_type.price("Double", 2, 1, 1, Date.today, 'APAI'))

		assert_equal(49220, a_room_type.price("Single", 1, 0, 1, Date.today, 'APAI'))
		assert_equal(51440, a_room_type.price("Single", 1, 0, 2, Date.today, 'APAI'))
		assert_equal(54770, a_room_type.price("Single", 1, 1, 1, Date.today, 'APAI'))
	end

	test "room rate calculation" do
		assert_equal 4700, @standard.price("Single", 1, 0, 0, Date.today, 'MAPAI')
		assert_equal 5600, @standard.price("Double", 2, 0, 0, Date.today, 'MAPAI')
		assert_equal 470, @standard.price("Single", 1, 0, 0, Date.today, 'APAI')
		assert_equal 560, @standard.price("Double", 2, 0, 0, Date.today, 'APAI')
	end
end
