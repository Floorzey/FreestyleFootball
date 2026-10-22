local _ = workspace.CurrentCamera
game:GetService("RunService")
local script_wind_lines = require(script.WindLines)
local script_wind_shake = require(script.WindShake)
script_wind_lines:Init({
    Direction = Vector3.new(1, 0, 0.3),
    Speed = 15,
    Lifetime = 2,
    SpawnRate = 13,
})
script_wind_shake:SetDefaultSettings({
    WindSpeed = 15,
    WindDirection = Vector3.new(1, 0, 0.3),
    WindPower = 0.65,
})
script_wind_shake:Init()
