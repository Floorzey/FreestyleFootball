--[[
    Script Path: Game/Players/Player/PlayerScripts/WindController
    Class: LocalScript
    Time: 2026-10-03 12:27:02
--]]

local _ = game:GetService("RunService")
local WindLines_1 = require(script.WindLines)
local WindShake_1 = require(script.WindShake)
WindLines_1:Init({Speed = 15, Direction = Vector3.new(1, 0, 0.30000001192092896), SpawnRate = 13, Lifetime = 2})
WindShake_1:SetDefaultSettings({WindDirection = Vector3.new(1, 0, 0.30000001192092896), WindPower = 0.65, WindSpeed = 15})
WindShake_1:Init()