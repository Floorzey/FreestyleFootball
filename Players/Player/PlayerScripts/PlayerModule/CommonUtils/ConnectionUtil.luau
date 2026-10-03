--[[
    Script Path: Game/Players/Player/PlayerScripts/PlayerModule/CommonUtils/ConnectionUtil
    Class: ModuleScript
    Time: 2026-10-03 12:27:02
--]]

local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
function tbl_upv_1.new()
    --[[
      name: new
      line: 25
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v1 = setmetatable({}, tbl_upv_1)
    v1._connections = {}
    return v1
end
function tbl_upv_1.connect(a1, a2, a3, a4)
    --[[
      name: connect
      line: 33
    ]]
    if a1._connections[a2] then
        a1._connections[a2]()
    end
    local u1 = a3:Connect(a4)
    a1._connections[a2] = function()
        --[[
          line: 39
          upvalues:
            u1 (copy, index: 1)
        ]]
        u1:Disconnect()
    end
end
function tbl_upv_1.connectManual(a1, a2, a3)
    --[[
      name: connectManual
      line: 42
    ]]
    if a1._connections[a2] then
        a1._connections[a2]()
    end
    a1._connections[a2] = a3
end
function tbl_upv_1.disconnect(a1, a2)
    --[[
      name: disconnect
      line: 49
    ]]
    if not a1._connections[a2] then
        return
    end
    a1._connections[a2]()
    a1._connections[a2] = nil
end
function tbl_upv_1.disconnectAll(a1)
    --[[
      name: disconnectAll
      line: 56
    ]]
    for _, value_1 in pairs(a1._connections) do
        value_1()
    end
    a1._connections = {}
end
return tbl_upv_1