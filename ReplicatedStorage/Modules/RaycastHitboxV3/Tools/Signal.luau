--[[
    Script Path: Game/ReplicatedStorage/Modules/RaycastHitboxV3/Tools/Signal
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
function tbl_upv_1.Create(a1)
    --[[
      name: Create
      line: 6
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    return (setmetatable({}, tbl_upv_1))
end
function tbl_upv_1.Connect(a1, a2)
    --[[
      name: Connect
      line: 10
    ]]
    a1[1] = a2
end
function tbl_upv_1.Fire(a1, ...)
    --[[
      name: Fire
      line: 14
    ]]
    if not a1[1] then
        return
    end
    coroutine.resume(coroutine.create(a1[1]), ...)
end
function tbl_upv_1.Delete(a1)
    --[[
      name: Delete
      line: 21
    ]]
    a1[1] = nil
end
return tbl_upv_1