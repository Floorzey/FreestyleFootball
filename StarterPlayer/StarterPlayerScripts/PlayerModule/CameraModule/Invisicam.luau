--[[
    Script Path: Game/StarterPlayer/StarterPlayerScripts/PlayerModule/CameraModule/Invisicam
    Class: ModuleScript
    Time: 2026-10-03 12:27:04
--]]

local Players_upv_1 = game:GetService("Players")
local tbl_upv_1 = {CIRCLE1 = 5, CHAR_OUTLINE = 9, MOVEMENT = 3, CORNERS = 4, LIMBS = 2, SMART_CIRCLE = 8, LIMBMOVE = 7, CIRCLE2 = 6}
local tbl_upv_2 = {}
tbl_upv_2.Head = true
tbl_upv_2["Left Arm"] = true
tbl_upv_2["Right Arm"] = true
tbl_upv_2["Left Leg"] = true
tbl_upv_2["Right Leg"] = true
tbl_upv_2.LeftLowerArm = true
tbl_upv_2.RightLowerArm = true
tbl_upv_2.LeftUpperLeg = true
tbl_upv_2.RightUpperLeg = true
local tbl_upv_3 = {Vector3.new(1, 1, -1), Vector3.new(1, -1, -1), Vector3.new(-1, -1, -1), Vector3.new(-1, 1, -1)}
local function Det3x3(a1, a2, a3, a4, a5, a6, a7, a8, a9)
    --[[
      name: Det3x3
      line: 71
    ]]
    return ((a1 * ((a5 * a9) - (a6 * a8))) - (a2 * ((a4 * a9) - (a6 * a7)))) + (a3 * ((a4 * a8) - (a5 * a7)))
end
local BaseOcclusion_upv_1 = require(script.Parent:WaitForChild("BaseOcclusion"))
local u1 = setmetatable({}, BaseOcclusion_upv_1)
u1.__index = u1
function u1.new()
    --[[
      name: new
      line: 112
      upvalues:
        BaseOcclusion_upv_1 (copy, index: 1)
        u1 (copy, index: 2)
        tbl_upv_1 (copy, index: 3)
    ]]
    local v1 = setmetatable(BaseOcclusion_upv_1.new(), u1)
    v1.char = nil
    v1.humanoidRootPart = nil
    v1.torsoPart = nil
    v1.headPart = nil
    v1.childAddedConn = nil
    v1.childRemovedConn = nil
    v1.behaviors = {}
    v1.behaviors[tbl_upv_1.LIMBS] = v1.LimbBehavior
    v1.behaviors[tbl_upv_1.MOVEMENT] = v1.MoveBehavior
    v1.behaviors[tbl_upv_1.CORNERS] = v1.CornerBehavior
    v1.behaviors[tbl_upv_1.CIRCLE1] = v1.CircleBehavior
    v1.behaviors[tbl_upv_1.CIRCLE2] = v1.CircleBehavior
    v1.behaviors[tbl_upv_1.LIMBMOVE] = v1.LimbMoveBehavior
    v1.behaviors[tbl_upv_1.SMART_CIRCLE] = v1.SmartCircleBehavior
    v1.behaviors[tbl_upv_1.CHAR_OUTLINE] = v1.CharacterOutlineBehavior
    v1.mode = tbl_upv_1.SMART_CIRCLE
    v1.behaviorFunction = v1.SmartCircleBehavior
    v1.savedHits = {}
    v1.trackedLimbs = {}
    v1.camera = game.Workspace.CurrentCamera
    v1.enabled = false
    return v1
end
function u1.Enable(a1, a2)
    --[[
      name: Enable
      line: 145
    ]]
    a1.enabled = a2
    if (a2) then
        return
    end
    a1:Cleanup()
end
function u1.GetOcclusionMode(a1)
    --[[
      name: GetOcclusionMode
      line: 153
    ]]
    return Enum.DevCameraOcclusionMode.Invisicam
end
function u1.LimbBehavior(a1, a2)
    --[[
      name: LimbBehavior
      line: 158
    ]]
    for key_1, _ in pairs(a1.trackedLimbs) do
        a2[#a2 + 1] = key_1.Position
    end
end
function u1.MoveBehavior(a1, a2)
    --[[
      name: MoveBehavior
      line: 164
    ]]
    for n_1 = 1, 3 do
        local Velocity_1 = a1.humanoidRootPart.Velocity
        a2[#a2 + 1] = a1.humanoidRootPart.Position + (((n_1 - 1) * a1.humanoidRootPart.CFrame.lookVector) * (Vector3.new(Velocity_1.X, 0, Velocity_1.Z).Magnitude / 2))
    end
end
function u1.CornerBehavior(a1, a2)
    --[[
      name: CornerBehavior
      line: 173
      upvalues:
        tbl_upv_3 (copy, index: 1)
    ]]
    local CFrame_1 = a1.humanoidRootPart.CFrame
    local Position_1 = CFrame_1.Position
    local v2 = a1.char:GetExtentsSize() / 2
    a2[#a2 + 1] = Position_1
    for n_2 = 1, #tbl_upv_3 do
        a2[#a2 + 1] = Position_1 + ((CFrame_1 - Position_1) * (v2 * tbl_upv_3[n_2]))
    end
end
function u1.CircleBehavior(a1, a2)
    --[[
      name: CircleBehavior
      line: 184
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v3
    if a1.mode ~= tbl_upv_1.CIRCLE1 then
        local _ = a1.camera.CoordinateFrame
        v3 = a1.camera.CoordinateFrame - a1.camera.CoordinateFrame.Position + a1.humanoidRootPart.Position
    else
        v3 = a1.humanoidRootPart.CFrame
    end
    a2[#a2 + 1] = v3.Position
    for n_3 = 0, 9 do
        local v4 = 0.6283185307179586 * n_3
        a2[#a2 + 1] = v3 * (Vector3.new(math.cos(v4), math.sin(v4), 0) * 3)
    end
end
function u1.LimbMoveBehavior(a1, a2)
    --[[
      name: LimbMoveBehavior
      line: 200
    ]]
    a1:LimbBehavior(a2)
    a1:MoveBehavior(a2)
end
function u1.CharacterOutlineBehavior(a1, a2)
    --[[
      name: CharacterOutlineBehavior
      line: 205
    ]]
    local unit_1 = a1.torsoPart.CFrame.upVector.unit
    local unit_2 = a1.torsoPart.CFrame.rightVector.unit
    a2[#a2 + 1] = a1.torsoPart.CFrame.p
    a2[#a2 + 1] = a1.torsoPart.CFrame.p + unit_1
    a2[#a2 + 1] = a1.torsoPart.CFrame.p - unit_1
    a2[#a2 + 1] = a1.torsoPart.CFrame.p + unit_2
    a2[#a2 + 1] = a1.torsoPart.CFrame.p - unit_2
    if a1.headPart then
        a2[#a2 + 1] = a1.headPart.CFrame.p
    end
    local v5 = CFrame.new(Vector3.new(0, 0, 0), Vector3.new(a1.camera.CoordinateFrame.lookVector.X, 0, a1.camera.CoordinateFrame.lookVector.Z))
    local v6 = ((a1.torsoPart) and (a1.torsoPart.Position)) or (a1.humanoidRootPart.Position)
    local tbl_4 = {a1.torsoPart}
    if a1.headPart then
        tbl_4[#tbl_4 + 1] = a1.headPart
    end
    for n_4 = 1, 24 do
        local v7 = math.tau * n_4 / 24
        local v8 = v5 * (Vector3.new(math.cos(v7), math.sin(v7), 0) * 3)
        local v9 = Vector3.new(v8.X, math.max(v8.Y, -2.25), v8.Z)
        local v10, v11 = game.Workspace:FindPartOnRayWithWhitelist(Ray.new(v6 + v9, -3 * v9), tbl_4, false)
        if v10 then
            a2[#a2 + 1] = v11 + (0.2 * (v6 - v11).unit)
        end
    end
end
local function RayIntersection(a1, a2, a3, a4)
    --[[
      name: RayIntersection
      line: 79
    ]]
    local v12 = a2:Cross(a4)
    local v13 = a3.X - a1.X
    local v14 = a3.Y - a1.Y
    local v15 = a3.Z - a1.Z
    local Y_1 = a2.Y
    local v16 = -a4.Y
    local Y_2 = v12.Y
    local Z_1 = a2.Z
    local v17 = -a4.Z
    local Z_2 = v12.Z
    local v18 = (a2.X * ((v16 * Z_2) - (Y_2 * v17))) - (-a4.X * ((Y_1 * Z_2) - (Y_2 * Z_1))) + v12.X * ((Y_1 * v17) - (v16 * Z_1))
    if v18 == 0 then
        return Vector3.new(0, 0, 0)
    end
    local v19 = -a4.Y
    local Y_3 = v12.Y
    local v20 = -a4.Z
    local Z_3 = v12.Z
    local Y_4 = a2.Y
    local Y_5 = v12.Y
    local Z_4 = a2.Z
    local Z_5 = v12.Z
    local v21 = a1 + ((((v13 * ((v19 * Z_3) - (Y_3 * v20))) - (-a4.X * ((v14 * Z_3) - (Y_3 * v15)))) + (v12.X * ((v14 * v20) - (v19 * v15)))) / v18) * a2
    local v22 = a3 + ((((a2.X * ((v14 * Z_5) - (Y_5 * v15))) - (v13 * ((Y_4 * Z_5) - (Y_5 * Z_4)))) + (v12.X * ((Y_4 * v15) - (v14 * Z_4)))) / v18) * a4
    if (v22 - v21).Magnitude < 0.25 then
        return v21 + ((v22 - v21) * 0.5)
    end
    return Vector3.new(0, 0, 0)
end
function u1.SmartCircleBehavior(a1, a2)
    --[[
      name: SmartCircleBehavior
      line: 244
      upvalues:
        RayIntersection (copy, index: 1)
    ]]
    local unit_3 = a1.torsoPart.CFrame.upVector.unit
    local unit_4 = a1.torsoPart.CFrame.rightVector.unit
    a2[#a2 + 1] = a1.torsoPart.CFrame.p
    a2[#a2 + 1] = a1.torsoPart.CFrame.p + unit_3
    a2[#a2 + 1] = a1.torsoPart.CFrame.p - unit_3
    a2[#a2 + 1] = a1.torsoPart.CFrame.p + unit_4
    a2[#a2 + 1] = a1.torsoPart.CFrame.p - unit_4
    if a1.headPart then
        a2[#a2 + 1] = a1.headPart.CFrame.p
    end
    local v23 = Vector3.new(0, 0.5, 0) + (((a1.torsoPart) and (a1.torsoPart.Position)) or (a1.humanoidRootPart.Position))
    local v24, v24 = nil, nil
    for n_5 = 1, 24 do
        local v25 = 0.2617993877991494 * n_5 - 1.5707963267948966
        local v26 = v23 + (a1.camera.CFrame - a1.camera.CFrame.p) * (Vector3.new(math.cos(v25), math.sin(v25), 0) * 2.5)
        local v27 = v26 - a1.camera.CFrame.p
        local v28, v29, v30 = game.Workspace:FindPartOnRayWithIgnoreList(Ray.new(v23, v26 - v23), {a1.char}, false, false)
        if not (v28) then
            v24 = v26
            a2[#a2 + 1] = v24
            continue
        end
        local v31 = v29 + 0.1 * v30.unit
        local v32 = v31 - v23
        local unit_5 = v32:Cross(v27).unit:Cross(v30).unit
        if not (v32.unit:Dot(-unit_5) < v32.unit:Dot((v31 - a1.camera.CFrame.p).unit)) then
            v24 = v31
            local v33, v34 = game.Workspace:FindPartOnRayWithIgnoreList(Ray.new(v23, v24 - v23), {a1.char}, false, false)
            v24 = (v33 and (v34 - (0.1 * (v24 - v23).unit))) or v24
            a2[#a2 + 1] = v24
            continue
        end
        v24 = RayIntersection(v31, unit_5, v26, v27)
        if v24.Magnitude > 0 then
            local v35, v36 = nil, nil
            local v37, v35, v36 = game.Workspace:FindPartOnRayWithIgnoreList(Ray.new(v31, v24 - v31), {a1.char}, false, false)
            v24 = (v37 and (v35 + (0.1 * v36.unit))) or v24
        else
            v24 = v31
        end
        local v33, v34 = game.Workspace:FindPartOnRayWithIgnoreList(Ray.new(v23, v24 - v23), {a1.char}, false, false)
        v24 = (v33 and (v34 - (0.1 * (v24 - v23).unit))) or v24
        a2[#a2 + 1] = v24
    end
end
function u1.CheckTorsoReference(a1)
    --[[
      name: CheckTorsoReference
      line: 329
    ]]
    if not a1.char then
        return
    end
    a1.torsoPart = a1.char:FindFirstChild("Torso")
    if not (a1.torsoPart) then
        a1.torsoPart = a1.char:FindFirstChild("UpperTorso")
        if not (a1.torsoPart) then
            a1.torsoPart = a1.char:FindFirstChild("HumanoidRootPart")
        end
    end
    a1.headPart = a1.char:FindFirstChild("Head")
end
function u1.CharacterAdded(a1, a2, a3)
    --[[
      name: CharacterAdded
      line: 343
      upvalues:
        Players_upv_1 (copy, index: 1)
        tbl_upv_2 (copy, index: 2)
    ]]
    if a3 ~= Players_upv_1.LocalPlayer then
        return
    end
    if a1.childAddedConn then
        a1.childAddedConn:Disconnect()
        a1.childAddedConn = nil
    end
    if a1.childRemovedConn then
        a1.childRemovedConn:Disconnect()
        a1.childRemovedConn = nil
    end
    a1.char = a2
    a1.trackedLimbs = {}
    local function childRemoved(a4)
        --[[
          name: childRemoved
          line: 375
          upvalues:
            a1 (copy, index: 1)
        ]]
        a1.trackedLimbs[a4] = nil
        a1:CheckTorsoReference()
    end
    local function childAdded(a5)
        --[[
          name: childAdded
          line: 359
          upvalues:
            tbl_upv_2 (copy, index: 1)
            a1 (copy, index: 2)
        ]]
        if not a5:IsA("BasePart") then
            return
        end
        if tbl_upv_2[a5.Name] then
            a1.trackedLimbs[a5] = true
        end
        if a5.Name == "Torso" or a5.Name == "UpperTorso" then
            a1.torsoPart = a5
        end
        if a5.Name ~= "Head" then
            return
        end
        a1.headPart = a5
    end
    a1.childAddedConn = a2.ChildAdded:Connect(childAdded)
    a1.childRemovedConn = a2.ChildRemoved:Connect(childRemoved)
    for _, value_1 in pairs(a1.char:GetChildren()) do
        if not (value_1:IsA("BasePart")) then
            continue
        end
        if tbl_upv_2[value_1.Name] then
            a1.trackedLimbs[value_1] = true
        end
        if value_1.Name == "Torso" or value_1.Name == "UpperTorso" then
            a1.torsoPart = value_1
        end
        if value_1.Name == "Head" then
            a1.headPart = value_1
        end
    end
end
local function AssertTypes(a1, ...)
    --[[
      name: AssertTypes
      line: 59
    ]]
    local tbl_5 = {}
    local v38 = ""
    for _, value_2 in pairs({...}) do
        tbl_5[value_2] = true
        v38 = v38 .. (((v38 ~= "") and " or ") or "") .. value_2
    end
    local ty_1 = type(a1)
    assert(tbl_5[ty_1], v38 .. " type expected, got: " .. ty_1)
end
function u1.SetMode(a1, a2)
    --[[
      name: SetMode
      line: 389
      upvalues:
        AssertTypes (copy, index: 1)
        tbl_upv_1 (copy, index: 2)
    ]]
    AssertTypes(a2, "number")
    for _, value_3 in pairs(tbl_upv_1) do
        if value_3 ~= a2 then
            continue
        end
        a1.mode = a2
        a1.behaviorFunction = a1.behaviors[a1.mode]
        return
    end
    error("Invalid mode number")
end
function u1.GetObscuredParts(a1)
    --[[
      name: GetObscuredParts
      line: 401
    ]]
    return a1.savedHits
end
function u1.Cleanup(a1)
    --[[
      name: Cleanup
      line: 406
    ]]
    for key_2, value_4 in pairs(a1.savedHits) do
        key_2.LocalTransparencyModifier = value_4
    end
end
function u1.Update(a1, a2, a3, a4)
    --[[
      name: Update
      line: 412
    ]]
    if not a1.enabled or not a1.char then
        return a3, a4
    end
    a1.camera = game.Workspace.CurrentCamera
    local v39 = nil
    if not (a1.humanoidRootPart) then
        v39 = a1.char:FindFirstChildOfClass("Humanoid")
        if v39 and v39.RootPart then
            a1.humanoidRootPart = v39.RootPart
        else
            a1.humanoidRootPart = a1.char:FindFirstChild("HumanoidRootPart")
            if not (a1.humanoidRootPart) then
                return a3, a4
            end
        end
        local u2 = nil
        local v40 = a1.humanoidRootPart.AncestryChanged:Connect(
            function(a5, a6)
                --[[
                  line: 437
                  upvalues:
                    a1 (copy, index: 1)
                    u2 (ref,  index: 2)
                ]]
                if a5 ~= a1.humanoidRootPart or (a6) then
                    return
                end
                a1.humanoidRootPart = nil
                if not u2 or not u2.Connected then
                    return
                end
                u2:Disconnect()
                u2 = nil
            end
        )
        u2 = v40
    end
    if not (a1.torsoPart) then
        a1:CheckTorsoReference()
        if not (a1.torsoPart) then
            return a3, a4
        end
    end
    local tbl_6 = {}
    a1.behaviorFunction(a1, tbl_6)
    local tbl_upv_7 = {}
    local tbl_8 = {a1.char}
    local function add(a7)
        --[[
          name: add
          line: 463
          upvalues:
            tbl_upv_7 (copy, index: 1)
            a1 (copy, index: 2)
        ]]
        tbl_upv_7[a7] = true
        if (a1.savedHits[a7]) then
            return
        end
        a1.savedHits[a7] = a7.LocalTransparencyModifier
    end
    local v41 = 0
    local tbl_9 = {}
    local v42 = 0.75
    local v43 = 0.75
    local v44 = (a1.headPart and (a1.headPart.CFrame.p)) or (tbl_6[1])
    local v45 = a1.camera:GetPartsObscuringTarget({v44, ((a1.torsoPart) and (a1.torsoPart.CFrame.p)) or (tbl_6[2])}, tbl_8)
    for n_6 = 1, #v45 do
        local v46 = v45[n_6]
        v41 = v41 + 1
        tbl_9[v46] = true
        for _, value_5 in pairs(v46:GetChildren()) do
            local v47 = value_5:IsA("Decal")
            if v47 then
                v41 = v41 + 1
            end
        end
        local v48 = value_5:IsA("Texture")
        if v48 then
            v41 = v41 + 1
        end
    end
    if v41 > 0 then
        v42, v43 = math.pow((0.375 / v41) + 0.375, 1 / v41), math.pow((0.25 / v41) + 0.25, 1 / v41)
    end
    local v49 = a1.camera:GetPartsObscuringTarget(tbl_6, tbl_8)
    local tbl_10 = {}
    tbl_10 = tbl_10
    for n_7 = 1, #v49 do
        local v50 = v49[n_7]
        local v46
        if (tbl_9[v50]) and (v42) then
            v46 = v42
        else
            v46 = v43
        end
        tbl_10[v50] = v46
        if v50.Transparency < tbl_10[v50] then
            tbl_upv_7[v50] = true
            if not (a1.savedHits[v50]) then
                a1.savedHits[v50] = v50.LocalTransparencyModifier
            end
        end
        for _, value_6 in pairs(v50:GetChildren()) do
            if value_6:IsA("Decal") or value_6:IsA("Texture") then
                if not (value_6.Transparency < tbl_10[v50]) then
                    continue
                end
                tbl_10[value_6] = tbl_10[v50]
                tbl_upv_7[value_6] = true
                if not (a1.savedHits[value_6]) then
                    a1.savedHits[value_6] = value_6.LocalTransparencyModifier
                end
            end
        end
    end
    for key_3, value_7 in pairs(a1.savedHits) do
        if tbl_upv_7[key_3] then
            key_3.LocalTransparencyModifier = ((key_3.Transparency < 1) and ((tbl_10[key_3] - key_3.Transparency) / (1 - key_3.Transparency))) or 0
        else
            key_3.LocalTransparencyModifier = value_7
            a1.savedHits[key_3] = nil
        end
    end
    return a3, a4
end
return u1