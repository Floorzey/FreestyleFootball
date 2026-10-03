--[[
    Script Path: Game/ReplicatedStorage/Modules/RaycastHitboxV3/MainHandler
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local RunService_1 = game:GetService("RunService")
local CollectionService_1 = game:GetService("CollectionService")
local tbl_upv_1 = {}
local tbl_upv_2 = {}
function tbl_upv_2.add(a1, a2)
    --[[
      name: add
      line: 15
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v1 = typeof(a2) ~= "Instance"
    assert(v1, "Make sure you are initializing from the Raycast module, not from this handler.")
    table.insert(tbl_upv_1, a2)
end
function tbl_upv_2.remove(a1, a2)
    --[[
      name: remove
      line: 20
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    for key_1 in ipairs(tbl_upv_1) do
        if tbl_upv_1[key_1].object == a2 then
            tbl_upv_1[key_1]:Destroy()
            setmetatable(tbl_upv_1[key_1], nil)
            table.remove(tbl_upv_1, key_1)
        end
    end
end
function tbl_upv_2.check(a1, a2)
    --[[
      name: check
      line: 30
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    for _, value_1 in ipairs(tbl_upv_1) do
        if value_1.object ~= a2 then
            continue
        end
        return value_1
    end
end
function OnTagRemoved(a1)
    --[[
      name: OnTagRemoved
      line: 38
      upvalues:
        tbl_upv_2 (copy, index: 1)
    ]]
    tbl_upv_2:remove(a1)
end
CollectionService_1:GetInstanceRemovedSignal("RaycastModuleManaged"):Connect(OnTagRemoved)
RunService_1.Heartbeat:Connect(
    function()
        --[[
          line: 46
          upvalues:
            tbl_upv_1 (copy, index: 1)
            tbl_upv_2 (copy, index: 2)
        ]]
        for _, value_2 in ipairs(tbl_upv_1) do
            if value_2.deleted then
                tbl_upv_2:remove(value_2.object)
                continue
            end
            for v9, value_3 in ipairs(value_2.points) do
                if not (value_2.active) then
                    value_3.LastPosition = nil
                    continue
                end
                local v2, v3, v4 = value_3.solver:solve(value_3, value_2.debugMode)
                local v5 = workspace:Raycast(v2, v3, value_2.raycastParams)
                value_3.solver:lastPosition(value_3, v4)
                if not (v5) then
                    value_2.OnUpdate:Fire(value_3.LastPosition)
                    continue
                end
                local Instance_1 = v5.Instance
                local v6 = not value_2.partMode and (Instance_1:FindFirstAncestorOfClass("Model"))
                local v7 = v6 and (v6:FindFirstChildOfClass("Humanoid"))
                local v8 = v7 or (value_2.partMode and Instance_1)
                if (v8) and not value_2.targetsHit[v8] then
                    value_2.targetsHit[v8] = true
                    value_2.OnHit:Fire(Instance_1, v6, v5, value_3.group)
                end
                value_2.OnUpdate:Fire(value_3.LastPosition)
            end
        end
    end
)
return tbl_upv_2