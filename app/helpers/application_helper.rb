module ApplicationHelper

	def in_words(int)
		number_to_name = {
			1000 => "Thousand",
			100 => "Hundred",
			90 => "Ninety",
			80 => "Eighty",
			70 => "Seventy",
			60 => "Sixty",
			50 => "Fifty",
			40 => "Fourty",
			30 => "Thirty",
			20 => "Twenty",
			10 => "Ten",
			9 => "Nine",
			8 => "Eight",
			7 => "Seven",
			6 => "Six",
			5 => "Five",
			4 => "Four",
			3 => "Three",
			2 => "Two",
			1 => "One"
		}

		if int < 19
			number_to_name[int]
		end
	end
end
