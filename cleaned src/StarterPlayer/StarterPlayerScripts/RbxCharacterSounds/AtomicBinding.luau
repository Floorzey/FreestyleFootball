local function is_manifest_resolved(argument, argument_2)
    local number = 0
    for _ in pairs(argument) do
        number += 1
    end
    assert(number <= argument_2, number)
    return number == argument_2
end

local function unbind_node_descend(argument, argument_2)
    if argument.instance == nil then
        return
    end
    argument.instance = nil
    local connections = argument.connections
    if connections then
        for _, connection in ipairs(connections) do
            connection:Disconnect()
        end
        table.clear(connections)
    end
    if argument_2 and argument.alias then
        argument_2[argument.alias] = nil
    end
    local children = argument.children
    if not children then
        return
    end
    for _, child in pairs(children) do
        unbind_node_descend(child, argument_2)
    end
end

local atomic_binding = {}
atomic_binding.__index = atomic_binding

local function parse_path(argument)
    local parts = string.split(argument, "/")
    for n = #parts, 1, -1 do
        if parts[n] == "" then
            table.remove(parts, n)
        end
    end
    return parts
end

function atomic_binding.new(argument, bound_fn)
    local dtor_map = {}
    local connections = {}
    local root_inst_to_root_node = {}
    local root_inst_to_manifest = {}
    local parsed_manifest = {}
    local manifest_size_target = 1
    for key, item in pairs(argument) do
        parsed_manifest[key] = parse_path(item)
        manifest_size_target += 1
    end
    return (
        setmetatable({
            _boundFn = bound_fn,
            _parsedManifest = parsed_manifest,
            _manifestSizeTarget = manifest_size_target,
            _dtorMap = dtor_map,
            _connections = connections,
            _rootInstToRootNode = root_inst_to_root_node,
            _rootInstToManifest = root_inst_to_manifest,
        }, atomic_binding)
    )
end

function atomic_binding._startBoundFn(self, argument, argument_2)
    local bound_fn = self._boundFn
    local dtor_map = self._dtorMap
    local callback = dtor_map[argument]
    if callback then
        callback()
        dtor_map[argument] = nil
    end
    local result = bound_fn(argument_2)
    if not result then
        return
    end
    dtor_map[argument] = result
end

function atomic_binding._stopBoundFn(self, argument)
    local dtor_map = self._dtorMap
    local callback = dtor_map[argument]
    if not callback then
        return
    end
    callback()
    dtor_map[argument] = nil
end

function atomic_binding.bindRoot(self, instance)
    debug.profilebegin("AtomicBinding:BindRoot")
    local parsed_manifest = self._parsedManifest
    local root_inst_to_root_node = self._rootInstToRootNode
    local root_inst_to_manifest = self._rootInstToManifest
    local manifest_size_target = self._manifestSizeTarget
    assert(root_inst_to_manifest[instance] == nil)
    local values = {}
    root_inst_to_manifest[instance] = values
    debug.profilebegin("BuildTree")
    local values_2 = {}
    values_2.alias = "root"
    values_2.instance = instance
    if next(parsed_manifest) then
        values_2.children = {}
        values_2.connections = {}
    end
    root_inst_to_root_node[instance] = values_2
    local pairs_2 = pairs
    for alias, item in pairs_2(parsed_manifest) do
        local values_3 = values_2
        for index, item_2 in ipairs(item) do
            local is_index = index == #item
            local children_entry = values_3.children[item_2] or {}
            if not is_index then
                children_entry.children = children_entry.children or {}
                children_entry.connections = children_entry.connections or {}
                values_3.children[item_2] = children_entry
                values_3 = children_entry
                continue
            end
            if children_entry.alias ~= nil then
                error("Multiple aliases assigned to one instance")
            end
            children_entry.alias = alias
            values_3.children[item_2] = children_entry
            values_3 = children_entry
        end
    end
    debug.profileend()
    local function process_node(argument)
        local assert_result = assert(argument.instance)
        local children = argument.children
        local alias_2 = argument.alias
        local is_children = not children
        if alias_2 then
            processDeleteChild_1[alias_2] = assert_result
        end
        if not is_children then
            local function process_delete_child(argument_2)
                local name = argument_2.Name
                local children_entry_3 = children[name]
                if not children_entry_3 or children_entry_3.instance ~= argument_2 then
                    return
                end
                self:_stopBoundFn(instance)
                unbind_node_descend(children_entry_3, values)
                assert(children_entry_3.instance == nil)
                local instance_3 = assert_result:FindFirstChild(name)
                if instance_3 then
                    local children_entry_4 = children[instance_3.Name]
                    if not children_entry_4 or children_entry_4.instance ~= nil then
                        return
                    end
                    children_entry_4.instance = instance_3
                    process_node(children_entry_4)
                end
            end
            for _, instance_2 in ipairs(assert_result:GetChildren()) do
                local children_entry_2 = children[instance_2.Name]
                if not children_entry_2 then
                    continue
                end
                if children_entry_2.instance == nil then
                    children_entry_2.instance = instance_2
                    process_node(children_entry_2)
                end
            end
            local function process_add_child(instance_3)
                local children_entry_3 = children[instance_3.Name]
                if not children_entry_3 or children_entry_3.instance ~= nil then
                    return
                end
                children_entry_3.instance = instance_3
                process_node(children_entry_3)
            end
            table.insert(argument.connections, assert_result.ChildAdded:Connect(process_add_child))
            table.insert(argument.connections, assert_result.ChildRemoved:Connect(process_delete_child))
        end
        if is_children then
            local number = 0
            for _ in pairs(processDeleteChild_1) do
                number += 1
            end
            assert(number <= manifest_size_target, number)
            if number ~= manifest_size_target then
                return
            end
            self:_startBoundFn(instance, processDeleteChild_1)
        end
    end
    debug.profilebegin("ResolveTree")
    process_node(values_2)
    debug.profileend()
    debug.profileend()
end

function atomic_binding.unbindRoot(self, argument)
    local root_inst_to_root_node = self._rootInstToRootNode
    local root_inst_to_manifest = self._rootInstToManifest
    self:_stopBoundFn(argument)
    local root_inst_to_root_node_entry = root_inst_to_root_node[argument]
    if root_inst_to_root_node_entry then
        unbind_node_descend(root_inst_to_root_node_entry, (assert(root_inst_to_manifest[argument])))
        root_inst_to_root_node[argument] = nil
    end
    root_inst_to_manifest[argument] = nil
end

function atomic_binding.destroy(self)
    debug.profilebegin("AtomicBinding:destroy")
    for _, item in pairs(self._dtorMap) do
        item:destroy()
    end
    table.clear(self._dtorMap)
    for _, connection in ipairs(self._connections) do
        connection:Disconnect()
    end
    table.clear(self._connections)
    local root_inst_to_manifest = self._rootInstToManifest
    for key, item_2 in pairs(self._rootInstToRootNode) do
        unbind_node_descend(item_2, (assert(root_inst_to_manifest[key])))
    end
    table.clear(self._rootInstToManifest)
    table.clear(self._rootInstToRootNode)
    debug.profileend()
end

return atomic_binding
