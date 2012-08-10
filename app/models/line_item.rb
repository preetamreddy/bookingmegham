class LineItem < ActiveRecord::Base
	belongs_to :booking
	belongs_to :room_type

	validates :booking_id, :room_type_id, :date, :booked_rooms, :presence => true

	before_create :set_account_id

	def LineItem.booked_rooms(id, date)
		bookings = LineItem.
			where("room_type_id = :id AND date = :date",
				{ :id => id, :date => date }).
			group(:room_type_id, :date).
			sum(:booked_rooms)

		return bookings[[id, date]]
	end

	private

		def set_account_id
			self.account_id = booking.account_id
		end

end
