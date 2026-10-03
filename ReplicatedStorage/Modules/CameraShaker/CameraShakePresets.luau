--[[
    Script Path: Game/ReplicatedStorage/Modules/CameraShaker/CameraShakePresets
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local CameraShakeInstance_upv_1 = require(script.Parent.CameraShakeInstance)
local tbl_upv_1 = {}
function tbl_upv_1.Bump()
    --[[
      name: Bump
      line: 26
      upvalues:
        CameraShakeInstance_upv_1 (copy, index: 1)
    ]]
    local v1 = CameraShakeInstance_upv_1.new(2.5, 4, 0.1, 0.75)
    v1.PositionInfluence = Vector3.new(0.15000000596046448, 0.15000000596046448, 0.15000000596046448)
    v1.RotationInfluence = Vector3.new(1, 1, 1)
    return v1
end
function tbl_upv_1.Explosion()
    --[[
      name: Explosion
      line: 36
      upvalues:
        CameraShakeInstance_upv_1 (copy, index: 1)
    ]]
    local v2 = CameraShakeInstance_upv_1.new(5, 10, 0, 1.5)
    v2.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
    v2.RotationInfluence = Vector3.new(4, 1, 1)
    return v2
end
function tbl_upv_1.Timestop()
    --[[
      name: Timestop
      line: 43
      upvalues:
        CameraShakeInstance_upv_1 (copy, index: 1)
    ]]
    local v3 = CameraShakeInstance_upv_1.new(2.5, 5, 0, 1.5)
    v3.PositionInfluence = Vector3.new(1, 1, 1)
    v3.RotationInfluence = Vector3.new(1, 1, 1)
    return v3
end
function tbl_upv_1.Earthquake()
    --[[
      name: Earthquake
      line: 52
      upvalues:
        CameraShakeInstance_upv_1 (copy, index: 1)
    ]]
    local v4 = CameraShakeInstance_upv_1.new(0.6, 3.5, 2, 10)
    v4.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
    v4.RotationInfluence = Vector3.new(1, 1, 4)
    return v4
end
function tbl_upv_1.BadTrip()
    --[[
      name: BadTrip
      line: 62
      upvalues:
        CameraShakeInstance_upv_1 (copy, index: 1)
    ]]
    local v5 = CameraShakeInstance_upv_1.new(10, 0.15, 5, 10)
    v5.PositionInfluence = Vector3.new(0, 0, 0.15000000596046448)
    v5.RotationInfluence = Vector3.new(2, 1, 4)
    return v5
end
function tbl_upv_1.HandheldCamera()
    --[[
      name: HandheldCamera
      line: 72
      upvalues:
        CameraShakeInstance_upv_1 (copy, index: 1)
    ]]
    local v6 = CameraShakeInstance_upv_1.new(1, 0.25, 5, 10)
    v6.PositionInfluence = Vector3.new(0, 0, 0)
    v6.RotationInfluence = Vector3.new(1, 0.5, 0.5)
    return v6
end
function tbl_upv_1.Vibration()
    --[[
      name: Vibration
      line: 82
      upvalues:
        CameraShakeInstance_upv_1 (copy, index: 1)
    ]]
    local v7 = CameraShakeInstance_upv_1.new(10, 20, 0, 0.125)
    v7.PositionInfluence = Vector3.new(0, 0.15000000596046448, 0)
    v7.RotationInfluence = Vector3.new(1.25, 0, 4)
    return v7
end
function tbl_upv_1.RoughDriving()
    --[[
      name: RoughDriving
      line: 92
      upvalues:
        CameraShakeInstance_upv_1 (copy, index: 1)
    ]]
    local v8 = CameraShakeInstance_upv_1.new(1, 2, 1, 1)
    v8.PositionInfluence = Vector3.new(0, 0, 0)
    v8.RotationInfluence = Vector3.new(1, 1, 1)
    return v8
end
local tbl_2 = {}
local tbl_3 = {}
function tbl_3.__index(a1, a2)
    --[[
      name: __index
      line: 104
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v9 = tbl_upv_1[a2]
    if type(v9) ~= "function" then
        error("No preset found with index \"" .. a2 .. "\"")
    else
        return v9()
    end
end
return (setmetatable(tbl_2, tbl_3))