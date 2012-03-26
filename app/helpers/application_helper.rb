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
		txt + "#{number.to_s.gsub(/(\d+?)(?=(\d\d)+(\d)(?!\d))(\.\d+)?/, "\\1,")}"
	end

	def number_to_currency_wo_symbol(number)
		"#{number.to_s.gsub(/(\d+?)(?=(\d\d)+(\d)(?!\d))(\.\d+)?/, "\\1,")}"
	end
end
