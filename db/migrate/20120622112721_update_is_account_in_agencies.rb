class UpdateIsAccountInAgencies < ActiveRecord::Migration
	def up
		Account.all.each do |account|
			agency = Agency.find_by_account_id_and_name(account.id, account.name)
			agency.is_account = 1
			agency.save!
		end
	end

	def down
		Agency.update_all({:is_account => 0})
	end
end
