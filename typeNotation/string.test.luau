--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StringUtils = require(ReplicatedStorage.String)

local name = StringUtils.requireString("Uoc")           -- OK
local username = StringUtils.requireNonEmpty("player1") -- OK
local tag = StringUtils.requireMaxLength("ADMIN", 10)   -- OK

-- Type checker error
-- StringUtils.requireString(123)

-- Runtime error
-- StringUtils.requireNonEmpty("")
-- StringUtils.requireMaxLength("TOO_LONG_NAME", 5)

print(name, username, tag)
