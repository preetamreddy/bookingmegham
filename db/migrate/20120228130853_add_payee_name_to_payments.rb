class AddPayeeNameToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :payee_name, :string
  end
end
