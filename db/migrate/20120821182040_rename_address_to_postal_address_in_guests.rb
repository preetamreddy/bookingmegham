class RenameAddressToPostalAddressInGuests < ActiveRecord::Migration
  def up
    rename_column :guests, :address, :postal_address
  end

  def down
    rename_column :guests, :postal_address, :address
  end
end
