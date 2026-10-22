local run_service = game:GetService("RunService")

if run_service:IsServer() then
    return require(script.KnitServer)
end

local knit_server = script:FindFirstChild("KnitServer")

if knit_server and run_service:IsRunning() then
    knit_server:Destroy()
end

return require(script.KnitClient)
