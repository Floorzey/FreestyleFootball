--[[
    Script Path: Game/ReplicatedStorage/Modules/RaycastHitboxV3
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local tbl_upv_1 = {WarningMessage = false, AttachmentName = "DmgPoint", Version = "3.2", DebugMode = false}
local MainHandler_upv_1 = require(script.MainHandler)
local HitboxObject_upv_1 = require(script.HitboxObject)
function tbl_upv_1.Initialize(a1, a2, a3)
    --[[
      name: Initialize
      line: 142
      upvalues:
        MainHandler_upv_1 (copy, index: 1)
        HitboxObject_upv_1 (copy, index: 2)
        tbl_upv_1 (copy, index: 3)
    ]]
    assert(a2, "You must provide an object instance.")
    local v1 = MainHandler_upv_1:check(a2)
    if not (v1) then
        local v2 = HitboxObject_upv_1:new()
        v2:config(a2, a3)
        v2:seekAttachments(tbl_upv_1.AttachmentName, tbl_upv_1.WarningMessage)
        v2.debugMode = tbl_upv_1.DebugMode
        MainHandler_upv_1:add(v2)
        v1 = v2
    end
    return v1
end
function tbl_upv_1.Deinitialize(a1, a2)
    --[[
      name: Deinitialize
      line: 156
      upvalues:
        MainHandler_upv_1 (copy, index: 1)
    ]]
    MainHandler_upv_1:remove(a2)
end
function tbl_upv_1.GetHitbox(a1, a2)
    --[[
      name: GetHitbox
      line: 160
      upvalues:
        MainHandler_upv_1 (copy, index: 1)
    ]]
    return MainHandler_upv_1:check(a2)
end
return tbl_upv_1