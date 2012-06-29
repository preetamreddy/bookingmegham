class CreateFirstAccount < ActiveRecord::Migration
  def up
		Account.skip_callback(:create, :after, :create_agency_for_account)
		account = Account.new
		account.name = "Banjara Camps And Retreats Pvt. Ltd."
		account.subdomain = "banjaracamps"
		account.phone_number_1 = "+91 11 2685 5152"
		account.email = "info@banjaracamps.com"
		account.url = "www.banjaracamps.com"
		account.save!
		Account.set_callback(:create, :after, :create_agency_for_account)
  end

  def down
		account = Account.find_by_subdomain('banjaracamps')
		account.destroy
  end
end
