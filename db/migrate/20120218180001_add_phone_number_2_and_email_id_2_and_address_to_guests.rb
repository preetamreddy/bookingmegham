class AddPhoneNumber2AndEmailId2AndAddressToGuests < ActiveRecord::Migration
  def change
    add_column :guests, :phone_number_2, :string
    add_column :guests, :email_id_2, :string
    add_column :guests, :address, :text
  end
end
