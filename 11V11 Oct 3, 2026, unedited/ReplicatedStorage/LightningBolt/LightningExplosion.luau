--[[
    Script Path: Game/ReplicatedStorage/LightningBolt/LightningExplosion
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local Parent_upv_1 = require(script.Parent)
local LightningSparks_upv_1 = require(script.Parent.LightningSparks)
local u1 = Random.new()
local clock_upv_1 = os.clock
function RandomVectorOffsetBetween(a1, a2, a3)
    --[[
      name: RandomVectorOffsetBetween
      line: 9
      upvalues:
        u1 (copy, index: 1)
    ]]
    return (CFrame.lookAt(Vector3.new(), a1) * CFrame.Angles(0, 0, u1:NextNumber(0, math.tau)) * CFrame.Angles(math.acos(u1:NextNumber(math.cos(a3), math.cos(a2))), 0, 0)).LookVector
end
local tbl_upv_1 = {}
local tbl_upv_2 = {}
tbl_upv_2.__index = tbl_upv_2
function tbl_upv_2.new(a1, a2, a3, a4, a5, a6)
    --[[
      name: new
      line: 20
      upvalues:
        tbl_upv_2 (copy, index: 1)
        u1 (copy, index: 2)
        Parent_upv_1 (copy, index: 3)
        LightningSparks_upv_1 (copy, index: 4)
        clock_upv_1 (copy, index: 5)
        tbl_upv_1 (copy, index: 6)
    ]]
    local v1 = setmetatable({}, tbl_upv_2)
    v1.Size = a2 or 1
    v1.NumBolts = a3 or 6
    v1.Color = a4 or ColorSequence.new(Color3.new(1, 1, 0), Color3.new(1, 1, 0.498039))
    v1.BoltColor = a5 or Color3.new(1, 1, 0.498039)
    v1.UpVector = a6 or Vector3.new(0, 1, 0)
    local v4 = Instance.new("Part")
    v4.Name = "LightningExplosion"
    v4.Anchored = true
    v4.CanCollide = false
    v4.Locked = true
    v4.CastShadow = false
    v4.Transparency = 1
    v4.Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
    v4.CFrame = CFrame.lookAt(a1 + Vector3.new(0, 0.5, 0), (a1 + Vector3.new(0, 0.5, 0)) + v1.UpVector) * CFrame.lookAt(Vector3.new(), Vector3.new(0, 1, 0)):inverse()
    v4.Parent = workspace.CurrentCamera
    local u2 = Instance.new("PointLight")
    u2.Parent = v4
    u2.Color = Color3.new(1, 1, 0.498039)
    local tbl_3 = {Range = 60, Brightness = 5}
    game:GetService("TweenService"):Create(u2, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_3):Play()
    task.delay(
        0.25,
        function()
            --[[
              line: 52
              upvalues:
                u2 (copy, index: 1)
            ]]
            local tbl_4 = {Range = 0, Brightness = 0}
            game:GetService("TweenService"):Create(u2, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), tbl_4):Play()
        end
    )
    local v5 = Instance.new("Attachment")
    v5.Parent = v4
    v5.CFrame = CFrame.new()
    local v6 = script.ExplosionBrightspot:Clone()
    local v7 = script.GlareEmitter:Clone()
    local v8 = script.PlasmaEmitter:Clone()
    local v9 = math.clamp(v1.Size, 0, 1)
    v7.Size = NumberSequence.new(v9 * 30)
    v8.Size = NumberSequence.new(v9 * 18)
    v8.Speed = NumberRange.new(v9 * 100)
    v6.Parent = v5
    v7.Parent = v5
    v8.Parent = v5
    local Color_1 = v1.Color
    if typeof(Color_1) ~= "Color3" then
        v7.Color = Color_1
        v8.Color = Color_1
        local Keypoints_1 = Color_1.Keypoints
        for n_1 = 1, #Keypoints_1 do
            local v10, _, v11 = Color3.toHSV(Keypoints_1[n_1].Value)
            Keypoints_1[n_1] = ColorSequenceKeypoint.new(Keypoints_1[n_1].Time, Color3.fromHSV(v10, 0.5, v11))
        end
        v6.Color = ColorSequence.new(Keypoints_1)
    else
        local v12 = ColorSequence.new(Color_1)
        local v13 = ColorSequence.new(Color_1)
        v7.Color = v12
        v8.Color = v13
        local v12, _, v14 = Color3.toHSV(Color_1)
        v6.Color = ColorSequence.new(Color3.fromHSV(v12, 0.5, v14))
    end
    v6.Enabled = true
    v7.Enabled = true
    v8.Enabled = true
    local tbl_5 = {}
    for _ = 1, v1.NumBolts do
        local tbl_6 = {}
        local tbl_7 = {}
        local v15 = RandomVectorOffsetBetween(v1.UpVector, 1.1344640137963142, 1.3962634015954636)
        tbl_6.WorldPosition = v5.WorldPosition
        tbl_6.WorldAxis = v15
        local v16 = v5.WorldPosition + ((tbl_6.WorldAxis * u1:NextNumber(20, 40)) * 1.4) * v9
        local v17 = RandomVectorOffsetBetween(-v1.UpVector, 1.2217304763960306, 1.9198621771937625)
        tbl_7.WorldPosition = v16
        tbl_7.WorldAxis = v17
        local v18 = Parent_upv_1.new(tbl_6, tbl_7, 10)
        v18.AnimationSpeed = 0
        v18.Thickness = 1
        v18.Color = v1.BoltColor
        v18.PulseLength = 0.8
        v18.ColorOffsetSpeed = 20
        v18.Frequency = 2
        v18.MinRadius = 0
        v18.MaxRadius = v9 * 4
        v18.FadeLength = 0.4
        v18.PulseSpeed = 5
        v18.MinThicknessMultiplier = 0.7
        v18.MaxThicknessMultiplier = 1
        local v19 = LightningSparks_upv_1.new(v18, 5)
        v19.MinDistance = 7.5
        v19.MaxDistance = 10
        v18.Velocity = ((tbl_7.WorldPosition - tbl_6.WorldPosition).Unit * 0.1) * v9
        tbl_5[#tbl_5 + 1] = v18
    end
    v1.Bolts = tbl_5
    v1.Attachment = v5
    v1.Part = v4
    v1.StartT = clock_upv_1()
    v1.RefIndex = #tbl_upv_1 + 1
    tbl_upv_1[v1.RefIndex] = v1
    return v1
end
function tbl_upv_2.Destroy(a1)
    --[[
      name: Destroy
      line: 134
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    tbl_upv_1[a1.RefIndex] = nil
    a1.Part:Destroy()
    for n_2 = 1, #a1.Bolts do
        a1.Bolts[n_2] = nil
    end
end
game:GetService("RunService").Heartbeat:Connect(
    function()
        --[[
          line: 145
          upvalues:
            tbl_upv_1 (copy, index: 1)
            clock_upv_1 (copy, index: 2)
        ]]
        for _, value_1 in pairs(tbl_upv_1) do
            local v20 = clock_upv_1() - value_1.StartT
            local Attachment_1 = value_1.Attachment
            if not (v20 < 0.7) then
                value_1:Destroy()
                continue
            end
            if v20 > 0.2 then
                local GlareEmitter_1 = Attachment_1.GlareEmitter
                local PlasmaEmitter_1 = Attachment_1.PlasmaEmitter
                Attachment_1.ExplosionBrightspot.Enabled = false
                GlareEmitter_1.Enabled = false
                PlasmaEmitter_1.Enabled = false
            end
            for n_3 = 1, #value_1.Bolts do
                local v21 = value_1.Bolts[n_3]
                v21.Attachment1.WorldPosition = v21.Attachment1.WorldPosition + v21.Velocity
            end
        end
    end
)
return tbl_upv_2