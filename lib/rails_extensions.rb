class Fixnum
	WORD_TO_NUM = {
		:ten			=> 10,
		:hundred	=> 100,
		:thousand	=> 1000,
		:lakh			=> 100000
	}
	LT_TWENTY = [''] + %w[one two three four five six seven eight nine ten 
		eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen 
		nineteen]
	TENS  = ['', ''] + %w[twenty thirty forty fifty sixty seventy eighty 
		ninety]
	HUNDRED = ' hundred '
	THOUSAND = ' thousand '
	LAKH = ' lakh '

	def to_english
		if self == 1
			return 'Yes'
		elsif self == 0
			return 'No'
		end
	end

	def to_words
		num = self
		num_hash = {}

		num_hash[:lakhs] = num / WORD_TO_NUM[:lakh]
		num_lakhs = num_hash[:lakhs] * WORD_TO_NUM[:lakh]

		num_hash[:thousands] = (num - num_lakhs) / WORD_TO_NUM[:thousand]
		num_thousands = num_hash[:thousands] * WORD_TO_NUM[:thousand]

		num_hash[:hundreds] = (num - num_lakhs - num_thousands) /
														WORD_TO_NUM[:hundred]
		num_hundreds = num_hash[:hundreds] * WORD_TO_NUM[:hundred]

		num_hash[:tens_and_units] = (num - num_lakhs - num_thousands - num_hundreds)

		num_words = ''

		if num_hash[:lakhs] > 0
			num_words = num_words + num_lt_hundred_to_words(num_hash[:lakhs]) + LAKH
		end

		if num_hash[:thousands] > 0
			num_words = num_words + num_lt_hundred_to_words(num_hash[:thousands]) + 
										THOUSAND
		end

		if num_hash[:hundreds] > 0
			num_words = num_words + num_lt_hundred_to_words(num_hash[:hundreds]) + 
										HUNDRED
		end

		if num_hash[:tens_and_units] > 0
			if num_words == ''
				num_words = num_words + 
											num_lt_hundred_to_words(num_hash[:tens_and_units])
			else
				num_words = num_words + 'and ' +
											num_lt_hundred_to_words(num_hash[:tens_and_units])
			end
		end

		num_words = num_words.capitalize
		return num_words
	end
	
	private

		def num_lt_hundred_to_words(number)
			if number < 20
				num_words = LT_TWENTY[number]	
			elsif number >= 20
				num_tens = number / WORD_TO_NUM[:ten]
				num_words = TENS[num_tens]

				num_units = number - num_tens * WORD_TO_NUM[:ten]
				if num_units > 0
					num_words = num_words + ' ' + LT_TWENTY[num_units]
				end
			end

			return num_words
		end

end
