--[[
    Script Path: Game/StarterPlayer/StarterPlayerScripts/SunFlare
    Class: LocalScript
    Time: 2026-10-03 12:27:03
--]]

local u1 = 0
local tbl_upv_1 = {script.SunFlare, script.Bit0, script.Bit1, script.Bit2, script.Bit3, script.Bit4, script.Bit5}
local u2 = 1
local u3 = 0
game["Run Service"].RenderStepped:Connect(
    function(a1)
        --[[
          line: 20
          upvalues:
            u3 (ref,  index: 1)
            tbl_upv_1 (copy, index: 2)
            u2 (ref,  index: 3)
            u1 (ref,  index: 4)
        ]]
        local v1 = workspace.CurrentCamera.CFrame.Position + game.Lighting:GetSunDirection() * 500
        local v2, v3 = workspace.CurrentCamera:WorldToViewportPoint(v1)
        local v4 = Vector2.new(workspace.CurrentCamera.ViewportSize.x / 2, workspace.CurrentCamera.ViewportSize.Y / 2) - Vector2.new(v2.x, v2.y)
        local Unit_1 = v4.Unit
        u3 = math.deg(math.atan2(-v4.y, v4.x)) + 180
        local v5 = v4.Magnitude * 3 / #tbl_upv_1
        for n_1 = 1, #tbl_upv_1 do
            local v6 = n_1 - 1
            local v7 = workspace.CurrentCamera:ViewportPointToRay(v2.x + ((Unit_1.x * v6) * v5), v2.y + ((Unit_1.y * v6) * v5), 1)
            tbl_upv_1[n_1].Position = v7.Origin + (v7.Direction.Unit * 10)
        end
        local v8 = Vector2.new(v2.X / game.Workspace.CurrentCamera.ViewportSize.X, v2.Y / game.Workspace.CurrentCamera.ViewportSize.Y)
        u2 = 1
        if v3 == false then
            u2 = 0
        end
        if u2 > 0 then
            if v8.X < 0.1 then
                local v9 = math.clamp(1 - ((0.1 - v8.X) / 0.1), 0, 1)
                u2 = math.min(u2, v9)
            end
            if v8.X > 0.9 then
                local v10 = math.clamp(1 - (v8.X - 0.9) / 0.1, 0, 1)
                u2 = math.min(u2, v10)
            end
            if v8.Y < 0.1 then
                local v11 = math.clamp(1 - (0.1 - v8.Y) / 0.1, 0, 1)
                u2 = math.min(u2, v11)
            end
            if v8.Y > 0.9 then
                local v12 = math.clamp(1 - (v8.Y - 0.9) / 0.1, 0, 1)
                u2 = math.min(u2, v12)
            end
        end
        if u2 > 0 then
            local v13 = RaycastParams.new()
            v13.RespectCanCollide = false
            if game.Workspace:Raycast(game.Workspace.CurrentCamera.CFrame.Position, (v1 - game.Workspace.CurrentCamera.CFrame.Position).Unit * 500, v13) then
                u1 = u1 - (a1 * 10)
            else
                u1 = u1 + (a1 * 10)
            end
            u1 = math.clamp(u1, 0, 1)
            u2 = math.min(u1, u2)
        end
    end
)
game["Run Service"]:BindToRenderStep(
    "PreCamera",
    5000,
    function()
        --[[
          line: 104
          upvalues:
            tbl_upv_1 (copy, index: 1)
            u2 (ref,  index: 2)
            u3 (ref,  index: 3)
        ]]
        if not game.Players.LocalPlayer:FindFirstChild("Settings") or not game.Players.LocalPlayer.Settings.Misc.SunFlare.Value then
            return
        end
        for _, value_1 in tbl_upv_1 do
            value_1.Parent = game.Workspace
            for v1, value_2 in value_1:GetDescendants() do
                if value_2:IsA("ParticleEmitter") then
                    value_2.Brightness = u2 * 0.15
                    value_2.Rotation = NumberRange.new(u3)
                    value_2.ZOffset = workspace.CurrentCamera:WorldToViewportPoint(value_2.Parent.WorldPosition).Z - 1
                    value_2.Enabled = false
                    value_2:Clear()
                    value_2:Emit(1)
                end
            end
        end
    end
)