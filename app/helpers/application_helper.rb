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

	def number_to_currency(number, html=true)
		txt = html ? content_tag(:span, 'Rs. ', :class => :WebRupee) : 'Rs. '
		if number >= 0
			txt + "#{number.to_s.gsub(/(\d+?)(?=(\d\d)+(\d)(?!\d))(\.\d+)?/, "\\1,")}" 
		else
			number = 0 - number
			txt + "(#{number.to_s.gsub(/(\d+?)(?=(\d\d)+(\d)(?!\d))(\.\d+)?/, "\\1,")})"
		end
	end

	def number_to_currency_wo_symbol(number)
		if number >= 0
			"#{number.to_s.gsub(/(\d+?)(?=(\d\d)+(\d)(?!\d))(\.\d+)?/, "\\1,")}" 
		else
			number = 0 - number
			"(#{number.to_s.gsub(/(\d+?)(?=(\d\d)+(\d)(?!\d))(\.\d+)?/, "\\1,")})"
		end
	end
end
