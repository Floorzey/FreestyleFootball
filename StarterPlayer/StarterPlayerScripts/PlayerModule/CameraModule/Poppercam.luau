--[[
    Script Path: Game/StarterPlayer/StarterPlayerScripts/PlayerModule/CameraModule/Poppercam
    Class: ModuleScript
    Time: 2026-10-03 12:27:04
--]]

local ZoomController_upv_1 = require(script.Parent:WaitForChild("ZoomController"))
local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
local u1 = CFrame.new()
local function cframeToAxis(a1)
    --[[
      name: cframeToAxis
      line: 13
    ]]
    local v1, v2 = a1:ToAxisAngle()
    return v1 * v2
end
local function axisToCFrame(a1)
    --[[
      name: axisToCFrame
      line: 18
      upvalues:
        u1 (copy, index: 1)
    ]]
    local Magnitude_1 = a1.Magnitude
    if Magnitude_1 > 1e-05 then
        return CFrame.fromAxisAngle(a1, Magnitude_1)
    end
    return u1
end
local function extractRotation(a1)
    --[[
      name: extractRotation
      line: 26
    ]]
    local _, v12, v13, v3, v4, v5, v6, v7, v8, v9, v10, v11 = a1:GetComponents()
    return CFrame.new(0, 0, 0, v3, v4, v5, v6, v7, v8, v9, v10, v11)
end
function tbl_upv_1.new()
    --[[
      name: new
      line: 31
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    return (setmetatable({}, tbl_upv_1))
end
function tbl_upv_1.Step(a1, a2, a3)
    --[[
      name: Step
      line: 37
      upvalues:
        u1 (copy, index: 1)
    ]]
    local v12 = a1.lastCFrame or a3
    a1.lastCFrame = a3
    local Position_upv_1 = a3.Position
    local _, v33, v34, v13, v14, v15, v16, v17, v18, v19, v20, v21 = a3:GetComponents()
    local u2 = CFrame.new(0, 0, 0, v13, v14, v15, v16, v17, v18, v19, v20, v21)
    local p_1 = v12.p
    local v35, v36, v37, v22, v23, v24, v25, v26, v27, v28, v29, v30 = v12:GetComponents()
    local u3 = (Position_upv_1 - p_1) / a2
    local v31, v32 = (u2 * CFrame.new(0, 0, 0, v22, v23, v24, v25, v26, v27, v28, v29, v30):inverse()):ToAxisAngle()
    local u4 = v31 * v32 / a2
    local tbl_2 = {}
    function tbl_2.extrapolate(a4)
        --[[
          name: extrapolate
          line: 52
          upvalues:
            u3 (copy, index: 1)
            Position_upv_1 (copy, index: 2)
            u4 (copy, index: 3)
            u1 (copy, index: 4)
            u2 (copy, index: 5)
        ]]
        local v33 = u3 * a4 + Position_upv_1
        local v34 = u4 * a4
        local Magnitude_2 = v34.Magnitude
        local v35
        if Magnitude_2 > 1e-05 then
            v35 = CFrame.fromAxisAngle(v34, Magnitude_2)
        else
            v35 = u1
        end
        return (v35 * u2) + v33
    end
    tbl_2.posVelocity = u3
    tbl_2.rotVelocity = u4
    return tbl_2
end
function tbl_upv_1.Reset(a1)
    --[[
      name: Reset
      line: 65
    ]]
    a1.lastCFrame = nil
end
local BaseOcclusion_upv_1 = require(script.Parent:WaitForChild("BaseOcclusion"))
local u5 = setmetatable({}, BaseOcclusion_upv_1)
u5.__index = u5
function u5.new()
    --[[
      name: new
      line: 75
      upvalues:
        BaseOcclusion_upv_1 (copy, index: 1)
        u5 (copy, index: 2)
        tbl_upv_1 (copy, index: 3)
    ]]
    local v36 = setmetatable(BaseOcclusion_upv_1.new(), u5)
    v36.focusExtrapolator = tbl_upv_1.new()
    return v36
end
function u5.GetOcclusionMode(a1)
    --[[
      name: GetOcclusionMode
      line: 81
    ]]
    return Enum.DevCameraOcclusionMode.Zoom
end
function u5.Enable(a1, a2)
    --[[
      name: Enable
      line: 85
    ]]
    a1.focusExtrapolator:Reset()
end
function u5.Update(a1, a2, a3, a4, a5)
    --[[
      name: Update
      line: 89
      upvalues:
        ZoomController_upv_1 (copy, index: 1)
    ]]
    local v37 = CFrame.new(a4.p, a3.p) * CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1)
    return v37 * CFrame.new(0, 0, ZoomController_upv_1.Update(a2, v37, a1.focusExtrapolator:Step(a2, v37))), a4
end
function u5.CharacterAdded(a1, a2, a3)
    --[[
      name: CharacterAdded
      line: 102
    ]]
end
function u5.CharacterRemoving(a1, a2, a3)
    --[[
      name: CharacterRemoving
      line: 106
    ]]
end
function u5.OnCameraSubjectChanged(a1, a2)
    --[[
      name: OnCameraSubjectChanged
      line: 109
    ]]
end
return u5