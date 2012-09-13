class CreatePaymentModes < ActiveRecord::Migration
  def change
    create_table :payment_modes do |t|
      t.integer :account_id
      t.integer :account_setting_id
      t.string :name

      t.timestamps
    end
  end
end
