--[[
    Script Path: Game/ReplicatedStorage/LightningBolt
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local clock_upv_1 = os.clock
function DiscretePulse(a1, a2, a3, a4, a5, a6, a7)
    --[[
      name: DiscretePulse
      line: 14
    ]]
    return (math.clamp((a3 / (2 * a4)) - math.abs(((a1 - (a5 * a2)) + (0.5 * a3)) / a4), a6, a7))
end
function NoiseBetween(a1, a2, a3, a4, a5)
    --[[
      name: NoiseBetween
      line: 18
    ]]
    return a4 + ((a5 - a4) * (math.noise(a1, a2, a3) + 0.5))
end
function CubicBezier(a1, a2, a3, a4, a5)
    --[[
      name: CubicBezier
      line: 22
    ]]
    return (((a1 * ((1 - a5) ^ 3)) + (((a2 * 3) * a5) * ((1 - a5) ^ 2))) + (((a3 * 3) * (1 - a5)) * (a5 ^ 2))) + (a4 * (a5 ^ 3))
end
local u1 = Instance.new("Part")
u1.TopSurface = 0
u1.BottomSurface = 0
u1.Anchored = true
u1.CanCollide = false
u1.Shape = "Cylinder"
u1.Name = "BoltPart"
u1.Material = Enum.Material.Neon
u1.Color = Color3.new(1, 1, 1)
u1.Transparency = 1
local _ = Random.new()
local u2 = CFrame.lookAt(Vector3.new(), Vector3.new(1, 0, 0)):inverse()
local tbl_upv_1 = {}
local tbl_upv_2 = {}
tbl_upv_2.__index = tbl_upv_2
function tbl_upv_2.new(a1, a2, a3)
    --[[
      name: new
      line: 51
      upvalues:
        tbl_upv_2 (copy, index: 1)
        u1 (copy, index: 2)
        u2 (copy, index: 3)
        clock_upv_1 (copy, index: 4)
        tbl_upv_1 (copy, index: 5)
    ]]
    local v1 = setmetatable({}, tbl_upv_2)
    v1.Enabled = true
    v1.Attachment0 = a1
    v1.Attachment1 = a2
    v1.CurveSize0 = 0
    v1.CurveSize1 = 0
    v1.MinRadius = 0
    v1.MaxRadius = 2.4
    v1.Frequency = 1
    v1.AnimationSpeed = 7
    v1.Thickness = 1
    v1.MinThicknessMultiplier = 0.2
    v1.MaxThicknessMultiplier = 1
    v1.MinTransparency = 0
    v1.MaxTransparency = 1
    v1.PulseSpeed = 2
    v1.PulseLength = 1e+06
    v1.FadeLength = 0.2
    v1.ContractFrom = 0.5
    v1.Color = Color3.new(1, 1, 1)
    v1.ColorOffsetSpeed = 3
    v1.Parts = {}
    local Temp_1 = workspace.Temp
    local WorldPosition_1 = a1.WorldPosition
    local WorldPosition_2 = a2.WorldPosition
    local v2 = a3 or 30
    local v3, v4 = nil, nil
    local v5
    v3, v5 = WorldPosition_1, WorldPosition_1
    for n_1 = 1, v2 do
        local v6 = CubicBezier(WorldPosition_1, a1.WorldPosition + (a1.WorldAxis * v1.CurveSize0), a2.WorldPosition - (a2.WorldAxis * v1.CurveSize1), WorldPosition_2, n_1 / v2)
        if n_1 == v2 then
            v4 = v6
            local v7 = u1:Clone()
            v7.Size = Vector3.new((v4 - v5).Magnitude, 0, 0)
            v7.CFrame = CFrame.lookAt(0.5 * (v5 + v4), v4) * u2
            v7.Parent = Temp_1
            v7.Locked = true
            v7.CastShadow = false
            v1.Parts[n_1] = v7
            v3, v5 = v6, v4
            continue
        end
        local Position_1 = CFrame.lookAt(v3, v6).Position
        v4 = Position_1 or v6
        local v7 = u1:Clone()
        v7.Size = Vector3.new((v4 - v5).Magnitude, 0, 0)
        v7.CFrame = CFrame.lookAt(0.5 * (v5 + v4), v4) * u2
        v7.Parent = Temp_1
        v7.Locked = true
        v7.CastShadow = false
        v1.Parts[n_1] = v7
        v3, v5 = v6, v4
    end
    v1.PartsHidden = false
    v1.DisabledTransparency = 1
    v1.StartT = clock_upv_1()
    v1.RanNum = math.random() * 100
    v1.RefIndex = #tbl_upv_1 + 1
    tbl_upv_1[v1.RefIndex] = v1
    return v1
end
function tbl_upv_2.Destroy(a1)
    --[[
      name: Destroy
      line: 116
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    tbl_upv_1[a1.RefIndex] = nil
    for n_2 = 1, #a1.Parts do
        a1.Parts[n_2]:Destroy()
        if n_2 % 100 == 0 then
            wait()
        end
    end
end
game:GetService("RunService").Heartbeat:Connect(
    function()
        --[[
          line: 130
          upvalues:
            tbl_upv_1 (copy, index: 1)
            clock_upv_1 (copy, index: 2)
            u2 (copy, index: 3)
        ]]
        for _, value_1 in pairs(tbl_upv_1) do
            if value_1.Enabled == true then
                value_1.PartsHidden = false
                local MinRadius_1 = value_1.MinRadius
                local MaxRadius_1 = value_1.MaxRadius
                local Thickness_1 = value_1.Thickness
                local Parts_1 = value_1.Parts
                local v8 = #Parts_1
                local RanNum_1 = value_1.RanNum
                local AnimationSpeed_1 = value_1.AnimationSpeed
                local Frequency_1 = value_1.Frequency
                local MinThicknessMultiplier_1 = value_1.MinThicknessMultiplier
                local MaxThicknessMultiplier_1 = value_1.MaxThicknessMultiplier
                local Attachment0_1 = value_1.Attachment0
                local Attachment1_1 = value_1.Attachment1
                local WorldPosition_3 = Attachment0_1.WorldPosition
                local WorldPosition_4 = Attachment1_1.WorldPosition
                local v9 = clock_upv_1() - value_1.StartT
                local PulseLength_1 = value_1.PulseLength
                local PulseSpeed_1 = value_1.PulseSpeed
                local FadeLength_1 = value_1.FadeLength
                local Color_1 = value_1.Color
                local ColorOffsetSpeed_1 = value_1.ColorOffsetSpeed
                local v10 = 1 - value_1.ContractFrom
                if not (v9 < (PulseLength_1 + 1) / PulseSpeed_1) then
                    value_1:Destroy()
                    continue
                end
                local v11, v12 = WorldPosition_3, WorldPosition_3
                for n_3 = 1, v8 do
                    local v13 = Parts_1[n_3]
                    local v14 = n_3 / v8
                    local v15 = DiscretePulse(v14, PulseSpeed_1, PulseLength_1, FadeLength_1, v9, 1 - value_1.MaxTransparency, 1 - value_1.MinTransparency)
                    local v16 = CubicBezier(WorldPosition_3, Attachment0_1.WorldPosition + (Attachment0_1.WorldAxis * value_1.CurveSize0), Attachment1_1.WorldPosition - (Attachment1_1.WorldAxis * value_1.CurveSize1), WorldPosition_4, v14)
                    local v17 = -v9
                    local v18 = ((AnimationSpeed_1 * v17) + ((Frequency_1 * 10) * v14)) - 0.2 + RanNum_1 * 4
                    local v19 = 5 * ((((AnimationSpeed_1 * 0.01) * v17) / 10) + (Frequency_1 * v14)) + RanNum_1 * 4
                    local v20 = NoiseBetween(5 * v18, 1.5, 1 * v19, 0, 0.6283185307179586) + NoiseBetween(0.5 * v18, 1.5, 0.1 * v19, 0, 5.654866776461628)
                    local v21 = NoiseBetween(3.4, v19, v18, MinRadius_1, MaxRadius_1) * math.exp(((v14 - 0.5) ^ 10) * -5000)
                    local v22 = NoiseBetween(2.3, v19, v18, MinThicknessMultiplier_1, MaxThicknessMultiplier_1)
                    local v23 = ((n_3 ~= v8) and (((CFrame.new(v11, v16) * CFrame.Angles(0, 0, v20)) * CFrame.Angles(math.acos(math.clamp(NoiseBetween(v19, v18, 2.7, 6.123233995736766e-17, 1), -1, 1)), 0, 0) * CFrame.new(0, 0, -v21)).Position)) or v16
                    if v10 < v15 then
                        v13.Size = Vector3.new((v23 - v12).Magnitude, (Thickness_1 * v22) * v15, (Thickness_1 * v22) * v15)
                        v13.CFrame = CFrame.lookAt(0.5 * (v12 + v23), v23) * u2
                        v13.Transparency = 1 - v15
                    elseif v10 - 1 / (v8 * FadeLength_1) < v15 then
                        local v24 = (1 - (((v15 - (v10 - (1 / (v8 * FadeLength_1)))) * v8) * FadeLength_1)) * (((v14 < (v9 * PulseSpeed_1) - (0.5 * PulseLength_1)) and 1) or -1)
                        v13.Size = Vector3.new((1 - math.abs(v24)) * (v23 - v12).Magnitude, (Thickness_1 * v22) * v15, (Thickness_1 * v22) * v15)
                        v13.CFrame = CFrame.lookAt(v12 + ((v23 - v12) * (math.max(0, v24) + ((1 - math.abs(v24)) * 0.5))), v23) * u2
                        v13.Transparency = 1 - v15
                    else
                        v13.Transparency = 1
                    end
                    if typeof(Color_1) == "Color3" then
                        v13.Color = Color_1
                        v11, v12 = v16, v23
                        continue
                    end
                    v14 = ((RanNum_1 + v14) - (v9 * ColorOffsetSpeed_1)) % 1
                    local Keypoints_1 = Color_1.Keypoints
                    for n_4 = 1, #Keypoints_1 - 1 do
                        if not (Keypoints_1[n_4].Time < v14) then
                            continue
                        end
                        if v14 < Keypoints_1[n_4 + 1].Time then
                            v13.Color = Keypoints_1[n_4].Value:lerp(Keypoints_1[n_4 + 1].Value, (v14 - Keypoints_1[n_4].Time) / (Keypoints_1[n_4 + 1].Time - Keypoints_1[n_4].Time))
                            break
                        else
                            continue
                        end
                    end
                    v11, v12 = v16, v23
                end
            elseif value_1.PartsHidden == false then
                value_1.PartsHidden = true
                local DisabledTransparency_1 = value_1.DisabledTransparency
                for n_5 = 1, #value_1.Parts do
                    value_1.Parts[n_5].Transparency = DisabledTransparency_1
                end
            end
        end
    end
)
return tbl_upv_2