class AddPaymentStatusAgainToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :payment_status, :string
  end
end
