class RemoveUnwantedColumnsFromBooking < ActiveRecord::Migration
  def up
    remove_column :bookings, :guest_name
    remove_column :bookings, :guest_phone_number
    remove_column :bookings, :guest_email_id
    remove_column :bookings, :paid
    remove_column :bookings, :balance_payment
    remove_column :bookings, :pay_by_date
  end

  def down
    add_column :bookings, :pay_by_date, :date
    add_column :bookings, :balance_payment, :integer
    add_column :bookings, :paid, :integer
    add_column :bookings, :guest_email_id, :string
    add_column :bookings, :guest_phone_number, :integer
    add_column :bookings, :guest_name, :string
  end
end
