class CreateFirstAccount < ActiveRecord::Migration
  def up
		account = Account.new
		account.name = "Banjara Camps and Retreats Pvt. Ltd."
		account.subdomain = "banjaracamps"
		account.save!
  end

  def down
		account = Account.find_by_subdomain('banjaracamps')
		account.destroy
  end
end
