local Int = {}
export type Int = number

function IntUtils.requireInt(value: number): number
	assert(type(value) == "number", "Value must be a number")
	assert(value % 1 == 0, "Value must be an integer")
	return value
end
