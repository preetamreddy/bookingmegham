class Feedback < ActiveRecord::Base
	before_save :strip_whitespaces

	def strip_whitespaces
		self.description = description.strip	
	end
end
