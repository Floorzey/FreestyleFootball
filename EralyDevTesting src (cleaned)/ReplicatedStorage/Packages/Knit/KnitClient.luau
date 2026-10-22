local values = {
    ServicePromises = true,
    Middleware = nil,
    PerServiceMiddleware = {},
}
local value = nil
local knit_client = {
    Player = game:GetService("Players").LocalPlayer,
    Util = script.Parent.Parent,
}
local promise = require(knit_client.Util.Promise)
local client_comm = require(knit_client.Util.Comm).ClientComm
local values_2 = {}
local values_3 = {}
local value_2 = nil
local enabled = false
local enabled_2 = false
local bindable_event = Instance.new("BindableEvent")

local function does_controller_exist(argument: string)
    return values_2[argument] ~= nil
end

local function get_services_folder()
    if not value_2 then
        value_2 = script.Parent:WaitForChild("Services")
    end

    return value_2
end

local function get_middleware_for_service(argument: string)
    local middleware = value.Middleware == nil and {} or value.Middleware
    local per_service_middleware_entry = value.PerServiceMiddleware[argument]

    if per_service_middleware_entry == nil then
        return middleware
    end

    return per_service_middleware_entry
end

local function build_service(argument: string)
    if not value_2 then
        value_2 = script.Parent:WaitForChild("Services")
    end

    local middleware = value.Middleware == nil and {} or value.Middleware
    local per_service_middleware_entry = value.PerServiceMiddleware[argument]

    if per_service_middleware_entry == nil then
        per_service_middleware_entry = middleware
    end

    local build_object_result = client_comm.new(value_2, value.ServicePromises, argument):BuildObject(
        per_service_middleware_entry.Inbound,
        per_service_middleware_entry.Outbound
    )
    values_3[argument] = build_object_result

    return build_object_result
end

function knit_client.CreateController(argument: table)
    local is_table = type(argument) == "table"
    local value_3 = `Controller must be a table; got {type(argument)}`
    assert(is_table, value_3)
    local is_string = type(argument.Name) == "string"
    local value_4 = `Controller.Name must be a string; got {type(argument.Name)}`
    assert(is_string, value_4)
    assert(#argument.Name > 0, "Controller.Name must be a non-empty string")
    local condition = values_2[argument.Name] == nil
    local value_5 = `Controller {argument.Name} already exists`
    assert(condition, value_5)
    assert(not enabled, 'Controllers cannot be created after calling "Knit.Start()"')
    values_2[argument.Name] = argument

    return argument
end

function knit_client.AddControllers(instance: userdata)
    assert(not enabled, 'Controllers cannot be added after calling "Knit.Start()"')
    local items = {}

    for _, child in instance:GetChildren() do
        if child:IsA("ModuleScript") then
            table.insert(items, require(child))
        end
    end

    return items
end

function knit_client.AddControllersDeep(argument: userdata)
    assert(not enabled, 'Controllers cannot be added after calling "Knit.Start()"')
    local items = {}

    for _, descendant in argument:GetDescendants() do
        if descendant:IsA("ModuleScript") then
            table.insert(items, require(descendant))
        end
    end

    return items
end

function knit_client.GetService(argument: string)
    local value_entry = values_3[argument]

    if value_entry then
        return value_entry
    end

    assert(enabled, "Cannot call GetService until Knit has been started")
    local is_string = type(argument) == "string"
    local value_3 = `ServiceName must be a string; got {type(argument)}`
    assert(is_string, value_3)

    if not value_2 then
        value_2 = script.Parent:WaitForChild("Services")
    end

    local middleware = value.Middleware == nil and {} or value.Middleware
    local per_service_middleware_entry = value.PerServiceMiddleware[argument]

    if per_service_middleware_entry == nil then
        per_service_middleware_entry = middleware
    end

    local build_object_result = client_comm.new(value_2, value.ServicePromises, argument):BuildObject(
        per_service_middleware_entry.Inbound,
        per_service_middleware_entry.Outbound
    )
    values_3[argument] = build_object_result

    return build_object_result
end

function knit_client.GetController(argument: string)
    local value_entry = values_2[argument]

    if value_entry then
        return value_entry
    end

    assert(enabled, "Cannot call GetController until Knit has been started")
    local is_string = type(argument) == "string"
    local value_3 = `ControllerName must be a string; got {type(argument)}`
    assert(is_string, value_3)
    error(`Could not find controller "{argument}". Check to verify a controller with this name exists.`, 2)
end

function knit_client.GetControllers()
    assert(enabled, "Cannot call GetControllers until Knit has been started")

    return values_2
end

function knit_client.Start(argument: table?)
    if enabled then
        return promise.reject("Knit already started")
    end

    enabled = true
    table.freeze(values_2)

    if argument == nil then
        value = values
    else
        local is_table = typeof(argument) == "table"
        local value_3 = `KnitOptions should be a table or nil; got {typeof(argument)}`
        assert(is_table, value_3)
        value = argument

        for key, item in values do
            if value[key] == nil then
                value[key] = item
            end
        end
    end

    if type(value.PerServiceMiddleware) ~= "table" then
        value.PerServiceMiddleware = {}
    end

    return promise
        .new(function(callback)
            local items = {}

            for _, item_2 in values_2 do
                if type(item_2.KnitInit) == "function" then
                    table.insert(
                        items,
                        promise.new(function(callback_2)
                            debug.setmemorycategory(item_2.Name)
                            item_2:KnitInit()
                            callback_2()
                        end)
                    )
                end
            end

            callback(promise.all(items))
        end)
        :andThen(function()
            for _, item_2 in values_2 do
                if type(item_2.KnitStart) == "function" then
                    task.spawn(function()
                        debug.setmemorycategory(item_2.Name)
                        item_2:KnitStart()
                    end)
                end
            end

            enabled_2 = true
            bindable_event:Fire()

            task.defer(function()
                bindable_event:Destroy()
            end)
        end)
end

function knit_client.OnStart()
    if enabled_2 then
        return promise.resolve()
    end

    return promise.fromEvent(bindable_event.Event)
end

return knit_client
