class RemovePaymentStatusFromTrips < ActiveRecord::Migration
  def up
		remove_column :trips, :payment_status
  end

  def down
		add_column :trips, :payment_status, :string
  end
end
