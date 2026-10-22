local values = { ServicePromises = true }
values.PerServiceMiddleware = {}
local value = nil
local knit_client = {}
knit_client.Player = game:GetService("Players").LocalPlayer
knit_client.Util = script.Parent.Parent
local promise = require(knit_client.Util.Promise)
local client_comm = require(knit_client.Util.Comm).ClientComm
local values_2 = {}
local values_3 = {}
local services = nil
local enabled = false
local enabled_2 = false
local bindable_event = Instance.new("BindableEvent")

local function does_controller_exist(argument)
    return values_2[argument] ~= nil
end

local function get_services_folder()
    if not services then
        services = script.Parent:WaitForChild("Services")
    end
    return services
end

local function get_middleware_for_service(argument)
    local middleware = ((value.Middleware == nil) and {}) or value.Middleware
    local per_service_middleware_entry = value.PerServiceMiddleware[argument]
    if per_service_middleware_entry == nil then
        return middleware
    end
    return per_service_middleware_entry
end

local function build_service(argument)
    if not services then
        services = script.Parent:WaitForChild("Services")
    end
    local middleware = ((value.Middleware == nil) and {}) or value.Middleware
    local per_service_middleware_entry = value.PerServiceMiddleware[argument]
    local middleware_2
    if per_service_middleware_entry == nil then
        middleware_2 = middleware
    else
        middleware_2 = per_service_middleware_entry
    end
    local build_object_result = client_comm
        .new(services, value.ServicePromises, argument)
        :BuildObject(middleware_2.Inbound, middleware_2.Outbound)
    values_3[argument] = build_object_result
    return build_object_result
end

function knit_client.CreateController(self)
    local is_table = type(self) == "table"
    assert(is_table, (("Controller must be a table; got %*"):format(type(self))))
    local is_string = type(self.Name) == "string"
    assert(is_string, (("Controller.Name must be a string; got %*"):format(type(self.Name))))
    assert(#self.Name > 0, "Controller.Name must be a non-empty string")
    assert(values_2[self.Name] == nil, (("Controller %* already exists"):format(self.Name)))
    assert(not enabled, "Controllers cannot be created after calling \"Knit.Start()\"")
    values_2[self.Name] = self
    return self
end

function knit_client.AddControllers(self)
    assert(not enabled, "Controllers cannot be added after calling \"Knit.Start()\"")
    local items = {}
    for _, item in self:GetChildren() do
        if item:IsA("ModuleScript") then
            table.insert(items, require(item))
        end
    end
    return items
end

function knit_client.AddControllersDeep(self)
    assert(not enabled, "Controllers cannot be added after calling \"Knit.Start()\"")
    local items = {}
    for _, item in self:GetDescendants() do
        if item:IsA("ModuleScript") then
            table.insert(items, require(item))
        end
    end
    return items
end

function knit_client.GetService(self)
    local value_entry = values_3[self]
    if value_entry then
        return value_entry
    end
    assert(enabled, "Cannot call GetService until Knit has been started")
    local is_string = type(self) == "string"
    assert(is_string, (("ServiceName must be a string; got %*"):format(type(self))))
    if not services then
        services = script.Parent:WaitForChild("Services")
    end
    local middleware = ((value.Middleware == nil) and {}) or value.Middleware
    local per_service_middleware_entry = value.PerServiceMiddleware[self]
    local middleware_2
    if per_service_middleware_entry == nil then
        middleware_2 = middleware
    else
        middleware_2 = per_service_middleware_entry
    end
    local build_object_result =
        client_comm.new(services, value.ServicePromises, self):BuildObject(middleware_2.Inbound, middleware_2.Outbound)
    values_3[self] = build_object_result
    return build_object_result
end

function knit_client.GetController(self)
    local value_entry = values_2[self]
    if value_entry then
        return value_entry
    end
    assert(enabled, "Cannot call GetController until Knit has been started")
    local is_string = type(self) == "string"
    assert(is_string, (("ControllerName must be a string; got %*"):format(type(self))))
    error(("Could not find controller \"%*\". Check to verify a controller with this name exists."):format(self), 2)
end

function knit_client.GetControllers()
    assert(enabled, "Cannot call GetControllers until Knit has been started")
    return values_2
end

function knit_client.Start(self)
    if enabled then
        return promise.reject("Knit already started")
    end
    enabled = true
    table.freeze(values_2)
    if self ~= nil then
        local is_table = typeof(self) == "table"
        assert(is_table, (("KnitOptions should be a table or nil; got %*"):format(typeof(self))))
        value = self
        for key, item in values do
            if value[key] == nil then
                value[key] = item
            end
        end
    else
        value = values
    end
    if type(value.PerServiceMiddleware) ~= "table" then
        value.PerServiceMiddleware = {}
    end
    return promise
        .new(function(callback)
            local items = {}
            for _, value_2 in values_2 do
                if type(value_2.KnitInit) == "function" then
                    table.insert(
                        items,
                        promise.new(function(callback_2)
                            debug.setmemorycategory(value_2.Name)
                            value_2:KnitInit()
                            callback_2()
                        end)
                    )
                end
            end
            callback(promise.all(items))
        end)
        :andThen(function()
            for _, value_2 in values_2 do
                if type(value_2.KnitStart) == "function" then
                    task.spawn(function()
                        debug.setmemorycategory(value_2.Name)
                        value_2:KnitStart()
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
