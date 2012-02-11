class ChangeDatatypeOfPhoneNumberColsInGuests < ActiveRecord::Migration
  def up
		change_column :guests, :phone_number, :bigint
  end

  def down
		change_column :guests, :phone_number, :integer
  end
end
