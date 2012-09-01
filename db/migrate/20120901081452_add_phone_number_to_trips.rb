class AddPhoneNumberToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :phone_number, :string
  end
end
