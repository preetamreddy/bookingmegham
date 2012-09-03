class AddCounterToPayments < ActiveRecord::Migration
  def up
    add_column :payments, :counter, :integer

    Payment.reset_column_information

    Payment.find(:all).each do |payment|
      payment.update_column(:counter, payment.id)
    end
  end

  def down
    remove_column :payments, :counter
  end
end
