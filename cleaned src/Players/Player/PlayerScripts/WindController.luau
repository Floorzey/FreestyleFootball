local _ = game:GetService("RunService")
local wind_lines = require(script.WindLines)
local wind_shake = require(script.WindShake)
wind_lines:Init({ Speed = 15, Direction = Vector3.new(1, 0, 0.30000001192092896), SpawnRate = 13, Lifetime = 2 })
wind_shake:SetDefaultSettings({
    WindDirection = Vector3.new(1, 0, 0.30000001192092896),
    WindPower = 0.65,
    WindSpeed = 15,
})
wind_shake:Init()
