--[[
    Script Path: Game/ReplicatedStorage/Packages/Knit/KnitClient
    Class: ModuleScript
    Time: 2026-10-03 12:27:10
--]]

local tbl_upv_1 = {ServicePromises = true}
tbl_upv_1.PerServiceMiddleware = {}
local u1 = nil
local tbl_2 = {}
tbl_2.Player = game:GetService("Players").LocalPlayer
tbl_2.Util = script.Parent.Parent
local Promise_upv_1 = require(tbl_2.Util.Promise)
local ClientComm_upv_1 = require(tbl_2.Util.Comm).ClientComm
local tbl_upv_3 = {}
local tbl_upv_4 = {}
local Services_upv_1 = nil
local u2 = false
local u3 = false
local u4 = Instance.new("BindableEvent")
local function DoesControllerExist(a1)
    --[[
      name: DoesControllerExist
      line: 127
      upvalues:
        tbl_upv_3 (copy, index: 1)
    ]]
    return tbl_upv_3[a1] ~= nil
end
local function GetServicesFolder()
    --[[
      name: GetServicesFolder
      line: 133
      upvalues:
        Services_upv_1 (ref, index: 1)
    ]]
    if not (Services_upv_1) then
        Services_upv_1 = script.Parent:WaitForChild("Services")
    end
    return Services_upv_1
end
local function GetMiddlewareForService(a1)
    --[[
      name: GetMiddlewareForService
      line: 141
      upvalues:
        u1 (ref, index: 1)
    ]]
    local v1 = ((u1.Middleware == nil) and {}) or (u1.Middleware)
    local v2 = u1.PerServiceMiddleware[a1]
    if v2 == nil then
        return v1
    end
    return v2
end
local function BuildService(a1)
    --[[
      name: BuildService
      line: 148
      upvalues:
        Services_upv_1 (ref,  index: 1)
        u1 (ref,  index: 2)
        ClientComm_upv_1 (copy, index: 3)
        tbl_upv_4 (copy, index: 4)
    ]]
    if not (Services_upv_1) then
        Services_upv_1 = script.Parent:WaitForChild("Services")
    end
    local v3 = ((u1.Middleware == nil) and {}) or (u1.Middleware)
    local v4 = u1.PerServiceMiddleware[a1]
    local v5
    if v4 == nil then
        v5 = v3
    else
        v5 = v4
    end
    local v6 = ClientComm_upv_1.new(Services_upv_1, u1.ServicePromises, a1):BuildObject(v5.Inbound, v5.Outbound)
    tbl_upv_4[a1] = v6
    return v6
end
function tbl_2.CreateController(a1)
    --[[
      name: CreateController
      line: 180
      upvalues:
        tbl_upv_3 (copy, index: 1)
        u2 (ref,  index: 2)
    ]]
    local v7 = type(a1) == "table"
    assert(v7, (("Controller must be a table; got %*"):format(type(a1))))
    local v8 = type(a1.Name) == "string"
    assert(v8, (("Controller.Name must be a string; got %*"):format(type(a1.Name))))
    assert(#a1.Name > 0, "Controller.Name must be a non-empty string")
    assert(tbl_upv_3[a1.Name] == nil, (("Controller %* already exists"):format(a1.Name)))
    assert(not u2, "Controllers cannot be created after calling \"Knit.Start()\"")
    tbl_upv_3[a1.Name] = a1
    return a1
end
function tbl_2.AddControllers(a1)
    --[[
      name: AddControllers
      line: 200
      upvalues:
        u2 (ref, index: 1)
    ]]
    assert(not u2, "Controllers cannot be added after calling \"Knit.Start()\"")
    local tbl_5 = {}
    for _, value_1 in a1:GetChildren() do
        if value_1:IsA("ModuleScript") then
            table.insert(tbl_5, require(value_1))
        end
    end
    return tbl_5
end
function tbl_2.AddControllersDeep(a1)
    --[[
      name: AddControllersDeep
      line: 218
      upvalues:
        u2 (ref, index: 1)
    ]]
    assert(not u2, "Controllers cannot be added after calling \"Knit.Start()\"")
    local tbl_6 = {}
    for _, value_2 in a1:GetDescendants() do
        if value_2:IsA("ModuleScript") then
            table.insert(tbl_6, require(value_2))
        end
    end
    return tbl_6
end
function tbl_2.GetService(a1)
    --[[
      name: GetService
      line: 285
      upvalues:
        tbl_upv_4 (copy, index: 1)
        u2 (ref,  index: 2)
        Services_upv_1 (ref,  index: 3)
        u1 (ref,  index: 4)
        ClientComm_upv_1 (copy, index: 5)
    ]]
    local v9 = tbl_upv_4[a1]
    if v9 then
        return v9
    end
    assert(u2, "Cannot call GetService until Knit has been started")
    local v10 = type(a1) == "string"
    assert(v10, (("ServiceName must be a string; got %*"):format(type(a1))))
    if not (Services_upv_1) then
        Services_upv_1 = script.Parent:WaitForChild("Services")
    end
    local v11 = ((u1.Middleware == nil) and {}) or (u1.Middleware)
    local v12 = u1.PerServiceMiddleware[a1]
    local v13
    if v12 == nil then
        v13 = v11
    else
        v13 = v12
    end
    local v14 = ClientComm_upv_1.new(Services_upv_1, u1.ServicePromises, a1):BuildObject(v13.Inbound, v13.Outbound)
    tbl_upv_4[a1] = v14
    return v14
end
function tbl_2.GetController(a1)
    --[[
      name: GetController
      line: 301
      upvalues:
        tbl_upv_3 (copy, index: 1)
        u2 (ref,  index: 2)
    ]]
    local v15 = tbl_upv_3[a1]
    if v15 then
        return v15
    end
    assert(u2, "Cannot call GetController until Knit has been started")
    local v16 = type(a1) == "string"
    assert(v16, (("ControllerName must be a string; got %*"):format(type(a1))))
    error(("Could not find controller \"%*\". Check to verify a controller with this name exists."):format(a1), 2)
end
function tbl_2.GetControllers()
    --[[
      name: GetControllers
      line: 315
      upvalues:
        u2 (ref,  index: 1)
        tbl_upv_3 (copy, index: 2)
    ]]
    assert(u2, "Cannot call GetControllers until Knit has been started")
    return tbl_upv_3
end
function tbl_2.Start(a1)
    --[[
      name: Start
      line: 338
      upvalues:
        u2 (ref,  index: 1)
        Promise_upv_1 (copy, index: 2)
        tbl_upv_3 (copy, index: 3)
        u1 (ref,  index: 4)
        tbl_upv_1 (copy, index: 5)
        u3 (ref,  index: 6)
        u4 (copy, index: 7)
    ]]
    if u2 then
        return Promise_upv_1.reject("Knit already started")
    end
    u2 = true
    table.freeze(tbl_upv_3)
    if a1 ~= nil then
        local v17 = typeof(a1) == "table"
        assert(v17, (("KnitOptions should be a table or nil; got %*"):format(typeof(a1))))
        u1 = a1
        for key_1, value_3 in tbl_upv_1 do
            if u1[key_1] == nil then
                u1[key_1] = value_3
            end
        end
    else
        u1 = tbl_upv_1
    end
    if type(u1.PerServiceMiddleware) ~= "table" then
        u1.PerServiceMiddleware = {}
    end
    return Promise_upv_1.new(
        function(a2)
            --[[
              line: 362
              upvalues:
                tbl_upv_3 (copy, index: 1)
                Promise_upv_1 (copy, index: 2)
            ]]
            local tbl_7 = {}
            for _, value_upv_4 in tbl_upv_3 do
                if type(value_upv_4.KnitInit) == "function" then
                    table.insert(
                        tbl_7,
                        Promise_upv_1.new(
                            function(a3)
                                --[[
                                  line: 370
                                  upvalues:
                                    value_upv_4 (copy, index: 1)
                                ]]
                                debug.setmemorycategory(value_upv_4.Name)
                                value_upv_4:KnitInit()
                                a3()
                            end
                        )
                    )
                end
            end
            a2(Promise_upv_1.all(tbl_7))
        end
    ):andThen(
        function()
            --[[
              line: 380
              upvalues:
                tbl_upv_3 (copy, index: 1)
                u3 (ref,  index: 2)
                u4 (copy, index: 3)
            ]]
            for _, value_upv_5 in tbl_upv_3 do
                if type(value_upv_5.KnitStart) == "function" then
                    task.spawn(
                        function()
                            --[[
                              line: 384
                              upvalues:
                                value_upv_5 (copy, index: 1)
                            ]]
                            debug.setmemorycategory(value_upv_5.Name)
                            value_upv_5:KnitStart()
                        end
                    )
                end
            end
            u3 = true
            u4:Fire()
            task.defer(
                function()
                    --[[
                      line: 394
                      upvalues:
                        u4 (copy, index: 1)
                    ]]
                    u4:Destroy()
                end
            )
        end
    )
end
function tbl_2.OnStart()
    --[[
      name: OnStart
      line: 412
      upvalues:
        u3 (ref,  index: 1)
        Promise_upv_1 (copy, index: 2)
        u4 (copy, index: 3)
    ]]
    if u3 then
        return Promise_upv_1.resolve()
    end
    return Promise_upv_1.fromEvent(u4.Event)
end
return tbl_2