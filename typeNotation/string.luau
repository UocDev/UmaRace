local String = {}
export type Str = string

function String.requireString(value: string): string
	assert(type(value) == "string", "Value must be a string")
	return value
end

function String.requireNonEmpty(value: string): string
	assert(type(value) == "string", "Value must be a string")
	assert(#value > 0, "String must not be empty")
	return value
end

function String.requireMaxLength(value: string, maxLen: number): string
	assert(type(value) == "string", "Value must be a string")
	assert(#value <= maxLen, "String exceeds maximum length")
	return value
end

return StringUtils
