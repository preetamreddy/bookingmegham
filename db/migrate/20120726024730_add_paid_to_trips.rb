class AddPaidToTrips < ActiveRecord::Migration
  def up
    add_column :trips, :paid, :integer, :default => 0

		Trip.all.each do |trip|
			if trip.payments.any?
				trip.update_column(:paid, trip.payments.to_a.sum { |payment| payment.amount } )
			end
		end
  end

	def down
    remove_column :trips, :paid
	end
end
