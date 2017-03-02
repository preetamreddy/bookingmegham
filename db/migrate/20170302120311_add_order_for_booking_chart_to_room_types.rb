class AddOrderForBookingChartToRoomTypes < ActiveRecord::Migration
  def change
    add_column :room_types, :order_for_booking_chart, :integer, :default => 0
  end
end
