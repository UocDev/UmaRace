local Char = {}
export type Char = stringChar

function CharUtils.requireChar(value: string): string
	assert(type(value) == "string", "Value must be a string")
	assert(#value == 1, "Value must be a single character")
	return value
end

function CharUtils.requireAlpha(value: string): string
	assert(type(value) == "string", "Value must be a string")
	assert(#value == 1, "Value must be a single character")
	assert(string.match(value, "^[A-Za-z]$"), "Character must be alphabetic")
	return value
end

function CharUtils.requireDigit(value: string): string
	assert(type(value) == "string", "Value must be a string")
	assert(#value == 1, "Value must be a single character")
	assert(string.match(value, "^[0-9]$"), "Character must be a digit")
	return value
end

return CharUtils
