class_name StringValidator
extends RefCounted

enum Validation {
	ONLY_LETTERS,
	ONLY_NUMBERS,
	ONLY_SYMBOLS,
	LETTERS_AND_NUMBERS,
	LETTERS_AND_SYMBOLS,
	NUMBERS_AND_SYMBOLS
}

static func check_type(data: String, valid: Validation) -> bool:
	var has_letters := false
	var has_numbers := false
	var has_symbols := false
	
	for c in data:
		var code := c.unicode_at(0)
	
		if (code >= 65 and code <= 90) or (code >= 97 and code <= 122):
			has_letters = true
		elif code >= 48 and code <= 57:
			has_numbers = true
		else:
			has_symbols = true
	
	match valid:
		Validation.ONLY_LETTERS:
			return has_letters and !has_numbers and !has_symbols
		
		Validation.ONLY_NUMBERS:
			return !has_letters and has_numbers and !has_symbols
		
		Validation.ONLY_SYMBOLS:
			return !has_letters and !has_numbers and has_symbols
		
		Validation.LETTERS_AND_NUMBERS:
			return has_letters and has_numbers and !has_symbols
		
		Validation.LETTERS_AND_SYMBOLS:
			return has_letters and !has_numbers and has_symbols
		
		Validation.NUMBERS_AND_SYMBOLS:
			return !has_letters and has_numbers and has_symbols
	
	return false
