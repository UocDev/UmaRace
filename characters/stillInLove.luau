local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local AttributesManager = {}
AttributesManager.__index = AttributesManager

-- this still dummy stats, we don't have function that read the config files
AttributesManager.BASE_ATTRIBUTES = {
	Speed = 99999,
	Stamina = 99999,
	Power = 9999,
	Guts = 50,
	Wit = 5 
}

AttributesManager.MAX_ATTRIBUTES = {
	Speed = 99999999,
	Stamina = 999999999,
	Power = 99999999,
	Guts = 100,
	Wit = 100
}

function AttributesManager.new(player)
	local self = setmetatable({}, AttributesManager)
	
	self.Player = player
	self.Character = nil
	self.Humanoid = nil
	
	
	self.Attributes = {
		Speed = AttributesManager.BASE_ATTRIBUTES.Speed,
		Stamina = AttributesManager.BASE_ATTRIBUTES.Stamina,
		CurrentStamina = AttributesManager.BASE_ATTRIBUTES.Stamina,
		Power = AttributesManager.BASE_ATTRIBUTES.Power,
		Guts = AttributesManager.BASE_ATTRIBUTES.Guts,
		Wit = AttributesManager.BASE_ATTRIBUTES.Wit
	}
	

	self.AttributesChanged = Instance.new("BindableEvent")
	
	self.DataStore = DataStoreService:GetDataStore("PlayerAttributes_" .. game.PlaceId)
	
	self.StaminaRegenCooldown = 2 
	self.LastStaminaUse = tick()
	self.StaminaRegenRate = 10 
	
	return self
end

function AttributesManager:Load()
	local success, data = pcall(function()
		return self.DataStore:GetAsync(self.Player.UserId)
	end)
	
	if success and data then
		for attribute, value in pairs(data) do
			if self.Attributes[attribute] ~= nil then
				self.Attributes[attribute] = math.clamp(value, 0, self.MAX_ATTRIBUTES[attribute] or 100)
			end
		end

		self.Attributes.CurrentStamina = math.min(self.Attributes.CurrentStamina, self.Attributes.Stamina)
	end
	
	self:SyncToClient()
end

function AttributesManager:Save()
	local dataToSave = {
		Speed = self.Attributes.Speed,
		Stamina = self.Attributes.Stamina,
		Power = self.Attributes.Power,
		Guts = self.Attributes.Guts,
		Wit = self.Attributes.Wit
	}
	
	pcall(function()
		self.DataStore:SetAsync(self.Player.UserId, dataToSave)
	end)
end

function AttributesManager:SetAttribute(attribute, value)
	if self.Attributes[attribute] == nil then
		warn("Attribute not valid: " .. tostring(attribute))
		return false
	end
	
	local maxValue = self.MAX_ATTRIBUTES[attribute] or 100
	self.Attributes[attribute] = math.clamp(value, 0, maxValue)
	
	self:ApplyToCharacter()

	self:SyncToClient()

	self:Save()
	
	return true
end

function AttributesManager:AddAttribute(attribute, amount)
	if self.Attributes[attribute] == nil then
		warn("Attribute not valid: " .. tostring(attribute))
		return false
	end
	
	local current = self.Attributes[attribute]
	local maxValue = self.MAX_ATTRIBUTES[attribute] or 100
	self.Attributes[attribute] = math.clamp(current + amount, 0, maxValue)
	
	self:ApplyToCharacter()
	self:SyncToClient()
	self:Save()
	
	return true
end

function AttributesManager:UseStamina(amount)
	if self.Attributes.CurrentStamina >= amount then
		self.Attributes.CurrentStamina -= amount
		self.LastStaminaUse = tick()
		self:SyncToClient()
		return true
	end
	return false
end

function AttributesManager:RegenerateStamina(deltaTime)
	if tick() - self.LastStaminaUse >= self.StaminaRegenCooldown then
		local regenAmount = self.StaminaRegenRate * deltaTime
		self.Attributes.CurrentStamina = math.min(
			self.Attributes.CurrentStamina + regenAmount,
			self.Attributes.Stamina
		)
		self:SyncToClient()
	end
end

function AttributesManager:ApplyToCharacter()
	if self.Character and self.Humanoid then
	
		self.Humanoid.WalkSpeed = self.Attributes.Speed
		
	
	
	end
end

function AttributesManager:SetupCharacter(character)
	self.Character = character
	self.Humanoid = character:WaitForChild("Humanoid") -- please use besed id

	self:ApplyToCharacter()
	

	coroutine.wrap(function()
		while self.Character and self.Character.Parent do
			local deltaTime = task.wait(0.1)
			self:RegenerateStamina(deltaTime)
		end
	end)()
end

function AttributesManager:SyncToClient()
	self.AttributesChanged:Fire(self.Attributes)
end

function AttributesManager:GetAttributes()
	return self.Attributes
end

function AttributesManager:Reset()
	for attribute, baseValue in pairs(AttributesManager.BASE_ATTRIBUTES) do
		self.Attributes[attribute] = baseValue
	end
	self.Attributes.CurrentStamina = self.Attributes.Stamina
	self:ApplyToCharacter()
	self:SyncToClient()
	self:Save()
end

return AttributesManager
