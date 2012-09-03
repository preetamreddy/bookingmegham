class AddCounterToPayments < ActiveRecord::Migration
  def up
    add_column :payments, :counter, :integer

    Payment.reset_column_information

    Trip.find(:all).each do |trip|
      counter = 1
      trip.payments.order(:created_at).find(:all).each do |payment|
        payment.update_column(:counter, counter)
        counter += 1
      end
    end
  end

  def down
    remove_column :payments, :counter
  end
end
