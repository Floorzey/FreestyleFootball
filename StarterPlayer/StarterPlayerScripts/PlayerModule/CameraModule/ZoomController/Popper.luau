--[[
    Script Path: Game/StarterPlayer/StarterPlayerScripts/PlayerModule/CameraModule/ZoomController/Popper
    Class: ModuleScript
    Time: 2026-10-03 12:27:04
--]]

local Players_1 = game:GetService("Players")
local CurrentCamera_upv_1 = game.Workspace.CurrentCamera
local min_upv_1 = math.min
local tan_upv_1 = math.tan
local rad_upv_1 = math.rad
local new_upv_1 = Ray.new
local function getTotalTransparency(a1)
    --[[
      name: getTotalTransparency
      line: 17
    ]]
    return 1 - ((1 - a1.Transparency) * (1 - a1.LocalTransparencyModifier))
end
local function eraseFromEnd(a1, a2)
    --[[
      name: eraseFromEnd
      line: 21
    ]]
    for n_1 = #a1, a2 + 1, -1 do
        a1[n_1] = nil
    end
end
local u1 = nil
local u2 = nil
local function updateProjection()
    --[[
      name: updateProjection
      line: 28
      upvalues:
        CurrentCamera_upv_1 (copy, index: 1)
        rad_upv_1 (copy, index: 2)
        u2 (ref,  index: 3)
        tan_upv_1 (copy, index: 4)
        u1 (ref,  index: 5)
    ]]
    local v1 = rad_upv_1(CurrentCamera_upv_1.FieldOfView)
    local ViewportSize_1 = CurrentCamera_upv_1.ViewportSize
    u2 = tan_upv_1(v1 / 2) * 2
    u1 = (ViewportSize_1.X / ViewportSize_1.Y) * u2
end
CurrentCamera_upv_1:GetPropertyChangedSignal("FieldOfView"):Connect(updateProjection)
CurrentCamera_upv_1:GetPropertyChangedSignal("ViewportSize"):Connect(updateProjection)
local u3 = rad_upv_1(CurrentCamera_upv_1.FieldOfView)
local ViewportSize_2 = CurrentCamera_upv_1.ViewportSize
local v2 = tan_upv_1(u3 / 2)
u2 = v2 * 2
u1 = ViewportSize_2.X / ViewportSize_2.Y * u2
local NearPlaneZ_upv_1 = CurrentCamera_upv_1.NearPlaneZ
CurrentCamera_upv_1:GetPropertyChangedSignal("NearPlaneZ"):Connect(
    function()
        --[[
          line: 43
          upvalues:
            NearPlaneZ_upv_1 (ref,  index: 1)
            CurrentCamera_upv_1 (copy, index: 2)
        ]]
        NearPlaneZ_upv_1 = CurrentCamera_upv_1.NearPlaneZ
    end
)
local tbl_upv_1 = {}
local tbl_upv_2 = {}
local function refreshIgnoreList()
    --[[
      name: refreshIgnoreList
      line: 51
      upvalues:
        tbl_upv_1 (ref,  index: 1)
        tbl_upv_2 (copy, index: 2)
    ]]
    local v3 = 1
    tbl_upv_1 = {}
    for _, value_1 in pairs(tbl_upv_2) do
        tbl_upv_1[v3] = value_1
        v3 = v3 + 1
    end
end
local function playerAdded(a1)
    --[[
      name: playerAdded
      line: 60
      upvalues:
        tbl_upv_2 (copy, index: 1)
        tbl_upv_1 (ref,  index: 2)
    ]]
    local function characterAdded_1(a2)
        --[[
          name: characterAdded
          line: 61
          upvalues:
            tbl_upv_2 (copy, index: 1)
            a1 (copy, index: 2)
            tbl_upv_1 (ref,  index: 3)
        ]]
        tbl_upv_2[a1] = a2
        local v4 = 1
        tbl_upv_1 = {}
        for _, value_2 in pairs(tbl_upv_2) do
            tbl_upv_1[v4] = value_2
            v4 = v4 + 1
        end
    end
    local function characterRemoving_1()
        --[[
          name: characterRemoving
          line: 65
          upvalues:
            tbl_upv_2 (copy, index: 1)
            a1 (copy, index: 2)
            tbl_upv_1 (ref,  index: 3)
        ]]
        tbl_upv_2[a1] = nil
        local v5 = 1
        tbl_upv_1 = {}
        for _, value_3 in pairs(tbl_upv_2) do
            tbl_upv_1[v5] = value_3
            v5 = v5 + 1
        end
    end
    a1.CharacterAdded:Connect(characterAdded_1)
    a1.CharacterRemoving:Connect(characterRemoving_1)
    if a1.Character then
        tbl_upv_2[a1] = a1.Character
        local v6 = 1
        tbl_upv_1 = {}
        for _, value_4 in pairs(tbl_upv_2) do
            tbl_upv_1[v6] = value_4
            v6 = v6 + 1
        end
    end
end
local function playerRemoving(a1)
    --[[
      name: playerRemoving
      line: 77
      upvalues:
        tbl_upv_2 (copy, index: 1)
        tbl_upv_1 (ref,  index: 2)
    ]]
    tbl_upv_2[a1] = nil
    local v7 = 1
    tbl_upv_1 = {}
    for _, value_5 in pairs(tbl_upv_2) do
        tbl_upv_1[v7] = value_5
        v7 = v7 + 1
    end
end
Players_1.PlayerAdded:Connect(playerAdded)
Players_1.PlayerRemoving:Connect(playerRemoving)
for _, value_6 in ipairs(Players_1:GetPlayers()) do
    playerAdded(value_6)
end
local v8 = 1
tbl_upv_1 = {}
local v9 = v8
for _, value_7 in pairs(tbl_upv_2) do
    tbl_upv_1[v9] = value_7
    v9 = v9 + 1
end
u3 = nil
local u4 = nil
CurrentCamera_upv_1:GetPropertyChangedSignal("CameraSubject"):Connect(
    function()
        --[[
          line: 111
          upvalues:
            CurrentCamera_upv_1 (copy, index: 1)
            u4 (ref,  index: 2)
        ]]
        local CameraSubject_1 = CurrentCamera_upv_1.CameraSubject
        if CameraSubject_1:IsA("Humanoid") then
            u4 = CameraSubject_1.RootPart
        elseif CameraSubject_1:IsA("BasePart") then
            u4 = CameraSubject_1
        else
            u4 = nil
        end
    end
)
local function canOcclude(a1)
    --[[
      name: canOcclude
      line: 122
      upvalues:
        u3 (ref, index: 1)
    ]]
    local v10 = (1 - ((1 - a1.Transparency) * (1 - a1.LocalTransparencyModifier)) < 0.25) and (a1.CanCollide and ((u3 ~= (a1:GetRootPart() or a1)) and (not a1:IsA("TrussPart"))))
    return v10
end
local tbl_upv_3 = {Vector2.new(0.4, 0), Vector2.new(-0.4, 0), Vector2.new(0, -0.4), Vector2.new(0, 0.4), Vector2.new(0, 0.2)}
local function getCollisionPoint(a1, a2)
    --[[
      name: getCollisionPoint
      line: 150
      upvalues:
        tbl_upv_1 (ref,  index: 1)
        new_upv_1 (copy, index: 2)
    ]]
    local v11 = #tbl_upv_1
    local v12 = nil
    while true do
        local v13, v12 = workspace:FindPartOnRayWithIgnoreList(new_upv_1(a1, a2), tbl_upv_1, false, true)
        if v13 then
            if v13.CanCollide then
                for n_2 = #tbl_upv_1, v11 + 1, -1 do
                    tbl_upv_1[n_2] = nil
                end
                return v12, true
            end
            tbl_upv_1[#tbl_upv_1 + 1] = v13
        end
        if v13 then
            continue
        end
        for n_3 = #tbl_upv_1, v11 + 1, -1 do
            tbl_upv_1[n_3] = nil
        end
        return a1 + a2, false
    end
end
local function queryPoint(a1, a2, a3, a4)
    --[[
      name: queryPoint
      line: 172
      upvalues:
        tbl_upv_1 (ref,  index: 1)
        NearPlaneZ_upv_1 (ref,  index: 2)
        new_upv_1 (copy, index: 3)
        u3 (ref,  index: 4)
    ]]
    debug.profilebegin("queryPoint")
    local v14 = #tbl_upv_1
    a3 = a3 + NearPlaneZ_upv_1
    local v15 = a1 + a2 * a3
    local v16 = math.huge
    local v17 = math.huge
    local v18 = 0
    local v19 = a1
    local v20 = nil
    local v21
    repeat
        local v22
        v21, v22 = workspace:FindPartOnRayWithIgnoreList(new_upv_1(v19, v15 - v19), tbl_upv_1, false, true)
        v18 = v18 + 1
        if v21 then
            local v23 = v18 >= 64
            local v24 = 1 - (1 - v21.Transparency) * (1 - v21.LocalTransparencyModifier) < 0.25 and v21.CanCollide and u3 ~= (v21:GetRootPart() or v21) and not v21:IsA("TrussPart")
            if v24 or v23 then
                local tbl_4 = {v21}
                local v25 = workspace:FindPartOnRayWithWhitelist(new_upv_1(v15, v22 - v15), tbl_4, true)
                local Magnitude_1 = (v22 - a1).Magnitude
                if not (v25) or v23 then
                    v17 = Magnitude_1
                    tbl_upv_1[#tbl_upv_1 + 1] = v21
                    v19 = v22 - a2 * 0.001
                    if v17 < math.huge or not (v21) then
                        break
                    end
                end
                v20 = false
                if a4 then
                    v20 = workspace:FindPartOnRayWithWhitelist(new_upv_1(a4, v15 - a4), tbl_4, true) or workspace:FindPartOnRayWithWhitelist(new_upv_1(v15, a4 - v15), tbl_4, true)
                end
                if v20 then
                    v17 = Magnitude_1
                elseif a3 < v16 then
                    v16 = Magnitude_1
                end
                tbl_upv_1[#tbl_upv_1 + 1] = v21
                v19 = v22 - a2 * 0.001
                if v17 < math.huge or not (v21) then
                    break
                end
            end
            tbl_upv_1[#tbl_upv_1 + 1] = v21
            v19 = v22 - a2 * 0.001
        end
        if v17 < math.huge then
            break
        end
    until not (v21)
    for n_4 = #tbl_upv_1, v14 + 1, -1 do
        tbl_upv_1[n_4] = nil
    end
    debug.profileend()
    return v16 - NearPlaneZ_upv_1, v17 - NearPlaneZ_upv_1
end
local function queryViewport(a1, a2)
    --[[
      name: queryViewport
      line: 232
      upvalues:
        CurrentCamera_upv_1 (copy, index: 1)
        u1 (ref,  index: 2)
        u2 (ref,  index: 3)
        NearPlaneZ_upv_1 (ref,  index: 4)
        queryPoint (copy, index: 5)
    ]]
    debug.profilebegin("queryViewport")
    local p_1 = a1.p
    local rightVector_1 = a1.rightVector
    local upVector_1 = a1.upVector
    local ViewportSize_3 = CurrentCamera_upv_1.ViewportSize
    local v27 = math.huge
    local v28 = math.huge
    for n_5 = 0, 1 do
        local v29 = rightVector_1 * ((n_5 - 0.5) * u1)
        for n_6 = 0, 1 do
            local v30, v31 = queryPoint(p_1 + (NearPlaneZ_upv_1 * (v29 + (upVector_1 * ((n_6 - 0.5) * u2)))), -a1.lookVector, a2, CurrentCamera_upv_1:ViewportPointToRay(ViewportSize_3.x * n_5, ViewportSize_3.y * n_6).Origin)
            if v31 < v27 then
                v27 = v31
            end
            if v30 < v28 then
                v28 = v30
            end
        end
    end
    debug.profileend()
    return v28, v27
end
local function testPromotion(a1, a2, a3)
    --[[
      name: testPromotion
      line: 273
      upvalues:
        getCollisionPoint (copy, index: 1)
        min_upv_1 (copy, index: 2)
        queryPoint (copy, index: 3)
        tbl_upv_3 (copy, index: 4)
    ]]
    debug.profilebegin("testPromotion")
    local p_2 = a1.p
    local rightVector_2 = a1.rightVector
    local upVector_2 = a1.upVector
    debug.profilebegin("extrapolate")
    for n_7 = 0, min_upv_1(1.25, a3.rotVelocity.magnitude + ((getCollisionPoint(p_2, a3.posVelocity * 1.25) - p_2).Magnitude / a3.posVelocity.magnitude)), 0.0625 do
        local v32 = a3.extrapolate(n_7)
        if not (a2 <= queryPoint(v32.p, -v32.lookVector, a2)) then
            continue
        end
        return false
    end
    debug.profileend()
    debug.profilebegin("testOffsets")
    for _, value_8 in ipairs(tbl_upv_3) do
        local v33 = getCollisionPoint(p_2, (rightVector_2 * value_8.x) + (upVector_2 * value_8.y))
        if queryPoint(v33, ((p_2 + (-a1.lookVector * a2)) - v33).Unit, a2) ~= math.huge then
            continue
        end
        return false
    end
    debug.profileend()
    debug.profileend()
    return true
end
local function Popper(a1, a2, a3)
    --[[
      name: Popper
      line: 322
      upvalues:
        u3 (ref,  index: 1)
        u4 (ref,  index: 2)
        queryViewport (copy, index: 3)
        testPromotion (copy, index: 4)
    ]]
    debug.profilebegin("popper")
    local v34 = (u4 and (u4:GetRootPart())) or u4
    u3 = v34
    local v35, v36 = queryViewport(a1, a2)
    if v36 < a2 then

    end
    if v35 < a2 then
        if testPromotion(a1, a2, a3) then

        end
    end
    u3 = nil
    debug.profileend()
    return a2
end
return Popper