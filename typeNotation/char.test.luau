local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CharUtils = require(ReplicatedStorage.Char)

local c1 = CharUtils.requireChar("A")     -- OK
local c2 = CharUtils.requireAlpha("z")    -- OK
local c3 = CharUtils.requireDigit("7")    -- OK

-- Type checker error
-- CharUtils.requireChar(1)

-- Runtime error
-- CharUtils.requireChar("AB")
-- CharUtils.requireAlpha("1")
-- CharUtils.requireDigit("a")

print(c1, c2, c3)
