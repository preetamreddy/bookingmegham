module ApplicationHelper
	def hidden_div_if(condition, attributes = {}, &block)
		if condition
			attributes["style"] = "display: none"
		end
		content_tag("div", attributes, &block)
	end
	def hidden_p_unless(condition, attributes = {}, &block)
		unless condition
			attributes["style"] = "display: none"
		end
		content_tag("p", attributes, &block)
	end
end
