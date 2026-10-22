--[[
    Script Path: Game/ReplicatedStorage/LightningBolt/LightningSparks
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local Parent_upv_1 = require(script.Parent)
local tbl_upv_1 = {}
local u1 = Random.new()
local tbl_upv_2 = {}
tbl_upv_2.__index = tbl_upv_2
function tbl_upv_2.new(a1, a2, a3, a4)
    --[[
      name: new
      line: 11
      upvalues:
        tbl_upv_2 (copy, index: 1)
        tbl_upv_1 (copy, index: 2)
    ]]
    local v1 = setmetatable({}, tbl_upv_2)
    v1.Enabled = true
    if a3 == nil then
        v1.LightningBolt = a1
    else
        v1.Part = a3
    end
    v1.SparkColor = a4
    v1.MaxSparkCount = a2 or 10
    v1.MinSpeed = 4
    v1.MaxSpeed = 6
    v1.MinDistance = 3
    v1.MaxDistance = 6
    v1.MinPartsPerSpark = 8
    v1.MaxPartsPerSpark = 10
    v1.SparksN = 0
    v1.SlotPlayer = {}
    v1.RefIndex = #tbl_upv_1 + 1
    tbl_upv_1[v1.RefIndex] = v1
    return v1
end
function tbl_upv_2.Destroy(a1)
    --[[
      name: Destroy
      line: 39
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    tbl_upv_1[a1.RefIndex] = nil
    for key_1, value_1 in pairs(a1.SlotPlayer) do
        if value_1.Parts[1].Parent == nil then
            a1.SlotPlayer[key_1] = nil
        end
    end
end
function RandomVectorOffset(a1, a2)
    --[[
      name: RandomVectorOffset
      line: 51
      upvalues:
        u1 (copy, index: 1)
    ]]
    return (CFrame.lookAt(Vector3.new(), a1) * CFrame.Angles(0, 0, u1:NextNumber(0, math.tau)) * CFrame.Angles(math.acos(u1:NextNumber(math.cos(a2), 1)), 0, 0)).LookVector
end
game:GetService("RunService").Heartbeat:Connect(
    function()
        --[[
          line: 55
          upvalues:
            tbl_upv_1 (copy, index: 1)
            u1 (copy, index: 2)
            Parent_upv_1 (copy, index: 3)
        ]]
        local Part_1
        local v2 = nil
        local v3 = nil
        for _, value_2 in pairs(tbl_upv_1) do
            if value_2.Enabled ~= true then
                local v4 = 0
                Part_1 = v4
                for key_2, value_3 in pairs(value_2.SlotPlayer) do
                    if value_3.Parts[1].Parent == nil then
                        value_2.SlotPlayer[key_2] = nil
                    else
                        Part_1 = Part_1 + 1
                    end
                end
                value_2.SparksN = Part_1
                continue
            elseif value_2.SparksN < value_2.MaxSparkCount then
                if value_2.Part == nil then
                    local LightningBolt_1 = value_2.LightningBolt
                    if LightningBolt_1.Parts[1].Parent ~= nil then
                        local Parts_1 = LightningBolt_1.Parts
                        local v5 = #Parts_1
                        local tbl_3 = {}
                        for n_1 = 1, #Parts_1 do
                            if Parts_1[n_1].Transparency < 0.3 then
                                tbl_3[#tbl_3 + 1] = (n_1 - 0.5) / v5
                            end
                        end
                        local v6 = nil
                        local v7 = nil
                        if #tbl_3 == 0 then
                            v2, v3 = v6, v7
                        else
                            v2, v3 = math.ceil(tbl_3[1] * value_2.MaxSparkCount), math.ceil(tbl_3[#tbl_3] * value_2.MaxSparkCount)
                        end
                        for v22 = 1, u1:NextInteger(1, value_2.MaxSparkCount - value_2.SparksN) do
                            if #tbl_3 == 0 then
                                break
                            end
                            local tbl_4 = {}
                            for n_2 = v2, v3 do
                                if value_2.SlotPlayer[n_2] == nil then
                                    tbl_4[#tbl_4 + 1] = n_2
                                end
                            end
                            if #tbl_4 == 0 then
                                continue
                            end
                            local v8 = tbl_4[u1:NextInteger(1, #tbl_4)]
                            local v9 = u1:NextNumber(-0.5, 0.5)
                            local v10 = 10
                            local v11 = 1
                            for n_3 = 1, #tbl_3 do
                                local v12 = math.abs(tbl_3[n_3] - ((v8 - 0.5) + v9) / value_2.MaxSparkCount)
                                if v12 < v10 then
                                    v10, v11 = v12, math.floor(((tbl_3[n_3] * v5) + 0.5) + 0.5)
                                end
                            end
                            local v13 = Parts_1[v11]
                            local tbl_5 = {}
                            local tbl_6 = {}
                            tbl_5.WorldPosition = v13.Position + ((v9 * v13.CFrame.RightVector) * v13.Size.X)
                            tbl_6.WorldPosition = tbl_5.WorldPosition + (RandomVectorOffset(v13.CFrame.RightVector, 0.7853981633974483) * u1:NextNumber(value_2.MinDistance, value_2.MaxDistance))
                            tbl_5.WorldAxis = (tbl_6.WorldPosition - tbl_5.WorldPosition).Unit
                            tbl_6.WorldAxis = tbl_5.WorldAxis
                            local v14 = Parent_upv_1.new(tbl_5, tbl_6, u1:NextInteger(value_2.MinPartsPerSpark, value_2.MaxPartsPerSpark))
                            v14.MinRadius = 0
                            v14.MaxRadius = 0.8
                            v14.AnimationSpeed = 0
                            v14.Thickness = v13.Size.Y / 2
                            v14.MinThicknessMultiplier = 1
                            v14.MaxThicknessMultiplier = 1
                            v14.PulseLength = 0.5
                            v14.PulseSpeed = u1:NextNumber(value_2.MinSpeed, value_2.MaxSpeed)
                            v14.FadeLength = 0.25
                            local v15, v23, v16 = v13.Color:ToHSV()
                            v14.Color = value_2.SparkColor or Color3.fromHSV(v15, 0.5, v16)
                            value_2.SlotPlayer[v8] = v14
                        end
                        local v4 = 0
                        Part_1 = v4
                        for key_2, value_3 in pairs(value_2.SlotPlayer) do
                            if value_3.Parts[1].Parent == nil then
                                value_2.SlotPlayer[key_2] = nil
                            else
                                Part_1 = Part_1 + 1
                            end
                        end
                        value_2.SparksN = Part_1
                        continue
                    else
                        value_2:Destroy()
                        return
                    end
                else
                    Part_1 = value_2.Part
                    if Part_1.Parent ~= nil then
                        for v24 = 1, u1:NextInteger(1, value_2.MaxSparkCount - value_2.SparksN) do
                            local v25 = u1:NextNumber(-0.5, 0.5)
                            local tbl_7 = {}
                            local tbl_8 = {}
                            tbl_7.WorldPosition = Part_1.Position + Vector3.new(math.random(-150, 150) * 0.01, math.random(-150, 150) * 0.01, math.random(-150, 150) * 0.01)
                            tbl_8.WorldPosition = tbl_7.WorldPosition + (RandomVectorOffset(Part_1.CFrame.RightVector, 0.7853981633974483) * u1:NextNumber(value_2.MinDistance, value_2.MaxDistance))
                            tbl_7.WorldAxis = (tbl_8.WorldPosition - tbl_7.WorldPosition).Unit
                            tbl_8.WorldAxis = tbl_7.WorldAxis
                            local v18 = Parent_upv_1.new(tbl_7, tbl_8, u1:NextInteger(value_2.MinPartsPerSpark, value_2.MaxPartsPerSpark))
                            v18.MinRadius = 0
                            v18.MaxRadius = 0.8
                            v18.AnimationSpeed = 0
                            v18.Thickness = Part_1.Size.X
                            v18.MinThicknessMultiplier = 1
                            v18.MaxThicknessMultiplier = 1
                            v18.PulseLength = u1:NextNumber(0.25, 0.75)
                            v18.PulseSpeed = u1:NextNumber(value_2.MinSpeed, value_2.MaxSpeed)
                            v18.FadeLength = u1:NextNumber(0.125, 0.375)
                            local v19, v26, v20 = Part_1.Color:ToHSV()
                            v18.Color = value_2.SparkColor or Color3.fromHSV(v19, 0.5, v20)
                        end
                        local v4 = 0
                        Part_1 = v4
                        for key_2, value_3 in pairs(value_2.SlotPlayer) do
                            if value_3.Parts[1].Parent == nil then
                                value_2.SlotPlayer[key_2] = nil
                            else
                                Part_1 = Part_1 + 1
                            end
                        end
                        value_2.SparksN = Part_1
                        continue
                    else
                        value_2:Destroy()
                        return
                    end
                end
            else
                local v4 = 0
                Part_1 = v4
                for key_2, value_3 in pairs(value_2.SlotPlayer) do
                    if value_3.Parts[1].Parent == nil then
                        value_2.SlotPlayer[key_2] = nil
                    else
                        Part_1 = Part_1 + 1
                    end
                end
                value_2.SparksN = Part_1
            end
        end
    end
)
return tbl_upv_2