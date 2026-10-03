--[[
    Script Path: Game/ReplicatedStorage/Packages/Knit
    Class: ModuleScript
    Time: 2026-10-03 12:27:10
--]]

local RunService_1 = game:GetService("RunService")
if RunService_1:IsServer() then
    return require(script.KnitServer)
end
local KnitServer_1 = script:FindFirstChild("KnitServer")
if KnitServer_1 and RunService_1:IsRunning() then
    KnitServer_1:Destroy()
end
return require(script.KnitClient)