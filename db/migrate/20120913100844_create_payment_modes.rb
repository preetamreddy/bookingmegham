class CreatePaymentModes < ActiveRecord::Migration
  def up
    create_table :payment_modes do |t|
      t.integer :account_id
      t.integer :account_setting_id
      t.string :name

      t.timestamps
    end

    add_index "payment_modes", ["account_id"], :name => "index_payment_modes_on_account_id"
  end

  def down
    drop_table :payment_modes
  end
end
