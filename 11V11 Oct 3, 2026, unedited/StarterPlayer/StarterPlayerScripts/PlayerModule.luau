--[[
    Script Path: Game/StarterPlayer/StarterPlayerScripts/PlayerModule
    Class: ModuleScript
    Time: 2026-10-03 12:27:03
--]]

local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
function tbl_upv_1.new()
    --[[
      name: new
      line: 12
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v1 = setmetatable({}, tbl_upv_1)
    v1.cameras = require(script:WaitForChild("CameraModule"))
    v1.controls = require(script:WaitForChild("ControlModule"))
    return v1
end
function tbl_upv_1.GetCameras(a1)
    --[[
      name: GetCameras
      line: 19
    ]]
    return a1.cameras
end
function tbl_upv_1.GetControls(a1)
    --[[
      name: GetControls
      line: 23
    ]]
    return a1.controls
end
function tbl_upv_1.GetClickToMoveController(a1)
    --[[
      name: GetClickToMoveController
      line: 27
    ]]
    return a1.controls:GetClickToMoveController()
end
return tbl_upv_1.new()