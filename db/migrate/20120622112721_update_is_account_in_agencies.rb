class UpdateIsAccountInAgencies < ActiveRecord::Migration
	def up
		Account.all.each do |account|
			agency = Agency.where('account_id = ? and name = ?', account.id, account.name).first!
			agency.is_account = 1
			agency.save
		end
	end

	def down
		Agency.update_all({:is_account => 0})
	end
end
