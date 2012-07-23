class UpdatePayeeNameInPayments < ActiveRecord::Migration
  def up
		Payment.all.each do |payment|
			if payment.payee_name == ""
				payment.update_column(:payee_name, payment.trip.guest.name_with_title)
			end
		end
  end

  def down
		Payment.all.each do |payment|
			if payment.payee_name == payment.trip.guest.name_with_title
				payment.update_column(:payee_name, "")
			end
		end
  end
end
