class RemoveFromToFromBooking < ActiveRecord::Migration
  def up
    remove_column :bookings, :from
    remove_column :bookings, :to
  end

  def down
    add_column :bookings, :to, :date
    add_column :bookings, :from, :date
  end
end
