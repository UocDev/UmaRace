local ReplicatedStorage = game:GetService("ReplicatedStorage")
local IntUtils = require(ReplicatedStorage..Int)

local x = IntUtils.requireInt(10)      -- OK
local y = IntUtils.add(5, 7)            -- OK

-- Type error (Luau type checker)
-- local z = IntUtils.requireInt("10")

-- Runtime assert error
-- local w = IntUtils.requireInt(3.14)

print(x, y)
