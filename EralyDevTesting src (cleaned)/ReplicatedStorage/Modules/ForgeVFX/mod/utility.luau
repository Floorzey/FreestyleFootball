local run_service = game:GetService("RunService")
local physics_service = game:GetService("PhysicsService")
local attributes = require("./attributes")
local logger = require("./logger")
local promise = require("../pkg/Promise")
local utility = {}
local plugin_context = script:FindFirstAncestorOfClass("Plugin")
    or run_service:IsStudio() and not run_service:IsRunning()
utility.PLUGIN_CONTEXT = plugin_context
utility.SERVER_CONTEXT = run_service:IsServer() or utility.PLUGIN_CONTEXT
utility.DEG_TO_RAD = 0.017453292519943295
utility.BEZIER_TAG = "BezierParticle"
utility.LIGHTNING_TAG = "LightningBolt"
utility.SHOCKWAVE_TAG = "Shockwave"
utility.SCREENSHAKE_TAG = "CameraShake"
utility.PROPERTY_TWEENER_TAG = "PropertyTweener"
utility.PROPERTY_RANDOMIZER_TAG = "PropertyRandomizer"
utility.ATTRIBUTE_TWEENER_TAG = "AttributeTweener"
utility.ATTRIBUTE_RANDOMIZER_TAG = "AttributeRandomizer"
utility.ENABLED_VFX_TAG = "ConstantVFX"
utility.TEXTURE_LOAD_TAG = "LoadVFXTextures"
utility.CLEANUP_TAG = "__forge__cleanupOnExit"
utility.EMIT_EXCLUDE_TAG = "__forge_excludeFromEmit"
utility.RENDER_PRIORITY = Enum.RenderPriority.Camera.Value + 1
utility.COLLISION_GROUPS = {
    StudioSelectable = {},
    ForgeDebris = {
        ForgeDebris = false,
    },
    ForgeMouseIgnore = {
        StudioSelectable = false,
    },
}
utility.COPY_SPECIALMESH_PROPERTIES = { "MeshId", "MeshType", "Offset", "Scale", "TextureId", "VertexColor" }
utility.COPY_PART_PROPERTIES = {
    "CastShadow",
    "Color",
    "Material",
    "MaterialVariant",
    "Reflectance",
    "Shape",
    "FrontSurface",
    "BackSurface",
    "LeftSurface",
    "RightSurface",
    "TopSurface",
    "BottomSurface",
}
utility.COPY_EXTENDED_PART_PROPERTIES =
    { "Size", "Transparency", "CustomPhysicalProperties", "CanCollide", "CanQuery", "CanTouch", "CollisionGroup" }
local instance = setmetatable({}, {
    __mode = "k",
})

function utility.lock(argument: userdata)
    if instance[argument] then
        return true
    end

    instance[argument] = coroutine.running()

    return false
end

function utility.unlock(argument: userdata, argument_2: thread?)
    local instance_entry = instance[argument]

    if coroutine.running() ~= instance_entry and argument_2 ~= instance_entry then
        logger.error("attempt to unlock an instance owned by a different thread")
    end

    instance[argument] = nil
end

function utility.setCollisionGroups(argument)
    local values = {}

    for key, item in argument do
        physics_service:RegisterCollisionGroup(key)

        if not key:match("Studio") or run_service:IsStudio() then
            values[key] = item
        end
    end

    for key_2, item_2 in values do
        local key_4 = key_2

        for key_3, item_3 in item_2 do
            if not key_3:match("Studio") or run_service:IsStudio() then
                physics_service:CollisionGroupSetCollidable(key_4, key_3, item_3)
            end
        end
    end
end

local number = 0

function utility.getRandomId()
    number = number + 1

    return tostring(number)
end

function utility.copyProperties(argument: userdata, argument_2: userdata, argument_3: table)
    for _, item in argument_3 do
        argument_2[item] = argument[item]
    end
end

function utility.lerp(argument: number, argument_2: number, argument_3: number)
    return argument + (argument_2 - argument) * argument_3
end

function utility.try(argument: string, argument_2: (...any) -> ...any, ...)
    local values = {
        xpcall(argument_2, function(argument_3)
            logger.warn(string.format(argument, argument_3))
        end, ...),
    }

    return values[1], table.unpack(values, 2)
end

function utility.reboundfn(argument: number, callback: (...any) -> ...any)
    local value = nil

    return function(...)
        if value then
            task.cancel(value)
        end

        local values = { ... }
        value = task.delay(argument, function()
            value = nil
            callback(table.unpack(values))
        end)
    end
end

function utility.randomUnitVector(argument: vector, argument_2: vector, argument_3: userdata?)
    local random = argument_3 or Random.new()
    local next_number_result = random:NextNumber(argument.X, argument_2.X)
    local next_number_result_2 = random:NextNumber(argument.Y, argument_2.Y)

    return Vector3.new(next_number_result, next_number_result_2, random:NextNumber(argument.Z, argument_2.Z))
end

function utility.getImpulseForce(argument: vector, argument_2: vector, argument_3: number)
    return (argument_2 - argument) / argument_3 + Vector3.new(0, workspace.Gravity * argument_3 * 0.5, 0)
end

function utility.isMeshVFX(instance_4: userdata)
    return instance_4
        and (instance_4:IsA("Model") and instance_4:FindFirstChild("Start") and (instance_4.Start:IsA("BasePart") and instance_4:FindFirstChild(
            "End"
        )))
        and instance_4.End:IsA("BasePart")
end

function utility.isSpinModelStatic(argument: userdata)
    local condition

    if
        attributes.get(argument, "SpinRotation", Vector3.new(0, 0, 0), true) == Vector3.new(0, 0, 0)
        and (
            attributes.get(argument, "Scale_Start", 1, true) == 1
            and attributes.get(argument, "Scale_End", 1, true) == 1
        )
    then
        condition = attributes.get(argument, "SyncPosition", false, true) == false
    else
        condition = false
    end

    return condition
end

function utility.shouldSkipNested(instance_4: userdata)
    return instance_4:IsA("Beam")
        or instance_4:HasTag(utility.BEZIER_TAG)
        or (instance_4:HasTag(utility.LIGHTNING_TAG) or utility.isMeshVFX(instance_4))
        or instance_4:IsA("BasePart")
            and utility.findFirstClassWithTag(instance_4, "Attachment", utility.SHOCKWAVE_TAG) ~= nil
end

function utility.getTarget(argument: userdata)
    local object_value = argument:FindFirstChildOfClass("ObjectValue")

    if object_value and object_value.Value then
        return object_value.Value
    end

    local parent = argument.Parent

    if not parent then
        return nil
    end

    while parent:IsA("Folder") do
        parent = parent.Parent

        if not parent then
            return nil
        end
    end

    return parent
end

function utility.createEmitPromise(effects: any, argument: userdata, depth: number, callback: any, context: table?)
    local promise_2 = promise.new(function(callback_2, argument_2, callback_3)
        local values = {
            depth = depth,
            effects = effects,
            _context = context,
        }

        callback_3(function()
            if values._onCancel then
                for _, callback_4 in values._onCancel do
                    callback_4()
                end
            end

            utility.cleanupScope(values)
        end)

        callback(values)
        utility.cleanupScope(values)
        callback_2()
    end)

    if context then
        table.insert(context._promises, promise_2)
    end

    return promise_2
end

function utility.onCancel(argument: table, argument_2: (...any) -> ...any)
    if not argument._onCancel then
        argument._onCancel = {}
    end

    table.insert(argument._onCancel, argument_2)
end

local instance_2 = setmetatable({}, {
    __mode = "k",
})
local instance_3 = setmetatable({}, {
    __mode = "k",
})

function utility.forceEmit(argument: userdata, argument_2: boolean)
    instance_3[argument] = argument_2 and true or nil
end

function utility.isForceEmitting(argument: userdata)
    return instance_3[argument] == true
end

function utility.setEnabledCancelToken(argument: userdata, argument_2: table?)
    instance_2[argument] = argument_2
end

function utility.getEnabledCancelToken(argument: userdata)
    return instance_2[argument]
end

function utility.cancelToken(argument: table)
    for _, item in argument._promises do
        item:cancel()
    end

    for _, item_2 in argument._scopes do
        utility.cleanupScope(item_2, true)
    end

    table.clear(argument._promises)
    table.clear(argument._scopes)
end

function utility.stopEmitDuration(argument: userdata)
    local enabled_cancel_token = utility.getEnabledCancelToken(argument)
    attributes.trigger(argument, "Enabled", false)
    attributes.clearState(argument)
    utility.forceEmit(argument, false)

    return enabled_cancel_token
end

function utility.awaitEmitDuration(argument: table?)
    if not argument then
        return
    end

    local items = {}

    for _, item in argument._promises do
        table.insert(items, item)
    end

    if #items > 0 then
        promise.all(items):await()
    end
end

function utility.cleanupScope(argument: table, argument_2: boolean?)
    local depth = argument.depth
    local effects = argument.effects
    local context = argument._context
    local on_cancel = argument._onCancel

    for key, connection in argument do
        if key ~= "depth" and (key ~= "effects" and (key ~= "_context" and key ~= "_onCancel")) then
            local value_type = typeof(connection)

            if value_type == "Instance" then
                connection:Destroy()
            elseif value_type == "RBXScriptConnection" then
                connection:Disconnect()
            elseif value_type == "thread" then
                if coroutine.status(connection) ~= "dead" then
                    task.cancel(connection)
                end
            elseif value_type == "function" then
                if argument_2 then
                    connection()
                else
                    task.spawn(connection)
                end
            elseif value_type == "table" then
                utility.cleanupScope(connection)
            end
        end
    end

    table.clear(argument)
    argument.depth = depth
    argument.effects = effects
    argument._context = context
    argument._onCancel = on_cancel
end

function utility.protectParent(items: table, argument: userdata)
    table.insert(
        items,
        argument.AncestryChanged:Connect(function(argument_2, argument_3)
            if argument.Parent == workspace.Terrain then
                return
            end

            argument.Parent = workspace.Terrain
        end)
    )
end

function utility.findFirstClassWithTag(argument: userdata?, argument_2: string, argument_3: string)
    if argument and argument.Parent ~= game then
        if argument.ClassName == argument_2 and argument:HasTag(argument_3) then
            return argument
        end

        return utility.findFirstClassWithTag(argument.Parent, argument_2, argument_3)
    end
end

function utility.cloneParticleAncestry(argument: userdata, argument_2: table)
    if not (argument:FindFirstAncestorWhichIsA("BasePart") or argument:FindFirstAncestorOfClass("Attachment")) then
        return
    end

    local function find_ancestor(result: userdata?)
        if result then
            if result.Parent and (result.Parent:IsA("BasePart") or result.Parent:IsA("Attachment")) then
                result = find_ancestor(result.Parent)
            end

            return result
        end
    end

    local function recurse(argument_3: userdata?)
        if not argument_3 then
            return
        end

        local argument_entry = argument_2[argument_3]

        if argument_entry then
            if argument_3 == argument then
                return argument_entry, argument_2[argument_3.Parent]
            end

            local parent = argument_3.Parent

            if parent then
                if parent.Parent and (parent.Parent:IsA("BasePart") or parent.Parent:IsA("Attachment")) then
                    parent = find_ancestor(parent.Parent)
                end
            else
                parent = nil
            end

            return argument_entry, argument_2[parent] or argument_2[argument_3]
        end

        local from_existing_result = Instance.fromExisting(argument_3)
        from_existing_result.Archivable = false

        if from_existing_result:IsA("BasePart") then
            from_existing_result.Locked = true
        end

        if argument_2 then
            argument_2[argument_3] = from_existing_result
        end

        local from_existing_result_2

        if argument_3.Parent and (argument_3.Parent:IsA("BasePart") or argument_3.Parent:IsA("Attachment")) then
            local parent_2, value = recurse(argument_3.Parent)
            from_existing_result_2 = value or from_existing_result

            if parent_2 then
                from_existing_result.Parent = parent_2
            end
        else
            from_existing_result_2 = from_existing_result
        end

        return from_existing_result, from_existing_result_2
    end

    return recurse(argument.Parent)
end

function utility.getTransformedOriginExtents(argument: userdata)
    local c_frame_identity = CFrame.identity

    if argument:IsA("BasePart") then
        return argument.CFrame, argument.Size
    end

    if argument:IsA("Attachment") then
        c_frame_identity = argument.WorldCFrame
        local parent = argument.Parent
        local get_result = attributes.get(argument, "PositionScale", Vector3.new(0, 0, 0), true)

        if parent and (parent:IsA("BasePart") and get_result ~= Vector3.new(0, 0, 0)) then
            c_frame_identity = c_frame_identity + parent.Size / 2 * get_result
        end

        local get_result_2 = attributes.get(argument, "OverrideWorldRotation", false, true)
        local get_result_3 = attributes.get(argument, "WorldRotation", Vector3.new(0, 0, 0), true)

        if get_result_2 then
            local product = get_result_3 * utility.DEG_TO_RAD
            c_frame_identity = CFrame.new(c_frame_identity.Position)
                * CFrame.fromOrientation(product.X, product.Y, product.Z)
        end
    end

    return c_frame_identity, Vector3.new(0, 0, 0)
end

function utility.getMeshDecals(instance_4: userdata, instance_5: userdata)
    local items = {}
    local values = {}
    local values_2 = {}

    local function filter(argument: table)
        local items_3 = {}

        for _, item in argument do
            if item:IsA("Decal") then
                table.insert(items_3, item)
            end
        end

        return items_3
    end

    if attributes.get(instance_4, "Flipbook", false, true) then
        return filter(instance_5:GetChildren()), values, values_2
    end

    local end_value = instance_4:FindFirstChild("End")
    local start = instance_4:FindFirstChild("Start")

    if end_value then
        for _, child in instance_5:GetChildren() do
            if child:IsA("Decal") then
                local first_child = end_value:FindFirstChild(child.Name)

                if first_child and first_child:IsA("Decal") then
                    table.insert(items, child)
                    values_2[child] = first_child

                    if attributes.get(child, "FlipbookEnabled", nil) then
                        local get_result = attributes.get(child, "FlipbookTextures", nil)

                        if get_result then
                            values[child] = utility.deserializeFlipbook(get_result)
                        end
                    else
                        table.insert(items, child)
                    end
                end
            end
        end

        for _, child_2 in start:GetChildren() do
            if child_2:IsA("Decal") then
                local children = child_2:GetChildren()
                local child_3 = child_2
                local number_2 = 0

                for index = 1, #children do
                    local difference = index - number_2
                    local index_2

                    if children[difference]:IsA("Decal") then
                        index_2 = index
                    else
                        table.remove(children, difference)
                        number_2 = number_2 + 1
                        index_2 = index
                    end
                end

                if #children ~= 0 then
                    local function idx(argument: string)
                        return tonumber(argument:match("%d+")) or 0
                    end

                    table.sort(children, function(argument, argument_2)
                        return (tonumber(argument.Name:match("%d+")) or 0)
                            < (tonumber(argument_2.Name:match("%d+")) or 0)
                    end)

                    local items_2 = {}

                    for _, instance_6 in children do
                        local tonumber_result = tonumber(instance_6.Texture:match("%d+")) or 0
                        table.insert(items_2, tonumber_result)
                        instance_6:Destroy()
                    end

                    local serialize_flipbook_result = utility.serializeFlipbook(items_2)
                    attributes.set(child_3, "FlipbookEnabled", true)
                    attributes.set(child_3, "FlipbookTextures", buffer.tostring(serialize_flipbook_result))
                end
            end
        end
    end

    return items, values, values_2
end

function utility.assembleMeshVFX(argument: userdata, items: table, argument_2: any)
    local random_id = utility.getRandomId()

    if not argument:IsA("Part") then
        local clone = argument:Clone()
        clone.Archivable = false
        clone.Locked = true
        clone.Parent = workspace.Terrain
        clone:AddTag(utility.CLEANUP_TAG)
        table.insert(items, clone)

        return clone
    end

    local get_result = argument_2:get(random_id)
    get_result.CFrame = argument.CFrame
    local parent = get_result._getReal()
    utility.copyProperties(argument, parent, utility.COPY_PART_PROPERTIES)
    utility.copyProperties(argument, parent, utility.COPY_EXTENDED_PART_PROPERTIES)
    local clone_2 = argument:Clone()

    for _, child in clone_2:GetChildren() do
        child.Parent = parent
    end

    clone_2:Destroy()

    table.insert(items, function()
        argument_2:free(random_id)
    end)

    return get_result
end

function utility.getBezierPoints(instance_4: userdata, argument: boolean?)
    local children = instance_4:GetChildren()

    table.sort(children, function(argument_2, argument_3)
        return tonumber(argument_2.Name) < tonumber(argument_3.Name)
    end)

    local items = {}
    local items_2 = {}
    local values = {}

    local function vec(argument_2: userdata)
        local point_to_object_space_result_8 = instance_4.WorldCFrame:PointToObjectSpace(argument_2.WorldPosition)
        local create_result_8 = vector.create(
            point_to_object_space_result_8.X,
            point_to_object_space_result_8.Y,
            point_to_object_space_result_8.Z
        )
        table.insert(items, create_result_8)

        if argument then
            values[argument_2] = create_result_8
            table.insert(items_2, argument_2)
        end

        return create_result_8
    end

    for key, instance_5 in children do
        local t0 = instance_5:FindFirstChild("T0")
        local t1 = instance_5:FindFirstChild("T1")

        if key == 1 then
            local point_to_object_space_result = instance_4.WorldCFrame:PointToObjectSpace(instance_5.WorldPosition)
            local create_result = vector.create(
                point_to_object_space_result.X,
                point_to_object_space_result.Y,
                point_to_object_space_result.Z
            )
            table.insert(items, create_result)

            if argument then
                values[instance_5] = create_result
                table.insert(items_2, instance_5)
            end
        end

        if key ~= 1 then
            if t1 then
                local point_to_object_space_result_2 = instance_4.WorldCFrame:PointToObjectSpace(t1.WorldPosition)
                local create_result_2 = vector.create(
                    point_to_object_space_result_2.X,
                    point_to_object_space_result_2.Y,
                    point_to_object_space_result_2.Z
                )
                table.insert(items, create_result_2)

                if argument then
                    values[t1] = create_result_2
                    table.insert(items_2, t1)
                end
            else
                local point_to_object_space_result_3 =
                    instance_4.WorldCFrame:PointToObjectSpace(instance_5.WorldPosition)
                local create_result_3 = vector.create(
                    point_to_object_space_result_3.X,
                    point_to_object_space_result_3.Y,
                    point_to_object_space_result_3.Z
                )
                table.insert(items, create_result_3)

                if argument then
                    values[instance_5] = create_result_3
                    table.insert(items_2, instance_5)
                end
            end
        end

        if key ~= 1 and key ~= #children then
            local point_to_object_space_result_4 = instance_4.WorldCFrame:PointToObjectSpace(instance_5.WorldPosition)
            local create_result_4 = vector.create(
                point_to_object_space_result_4.X,
                point_to_object_space_result_4.Y,
                point_to_object_space_result_4.Z
            )
            table.insert(items, create_result_4)

            if argument then
                values[instance_5] = create_result_4
                table.insert(items_2, instance_5)
            end
        end

        if key ~= #children then
            if t0 then
                local point_to_object_space_result_5 = instance_4.WorldCFrame:PointToObjectSpace(t0.WorldPosition)
                local create_result_5 = vector.create(
                    point_to_object_space_result_5.X,
                    point_to_object_space_result_5.Y,
                    point_to_object_space_result_5.Z
                )
                table.insert(items, create_result_5)

                if argument then
                    values[t0] = create_result_5
                    table.insert(items_2, t0)
                end
            else
                local point_to_object_space_result_6 =
                    instance_4.WorldCFrame:PointToObjectSpace(instance_5.WorldPosition)
                local create_result_6 = vector.create(
                    point_to_object_space_result_6.X,
                    point_to_object_space_result_6.Y,
                    point_to_object_space_result_6.Z
                )
                table.insert(items, create_result_6)

                if argument then
                    values[instance_5] = create_result_6
                    table.insert(items_2, instance_5)
                end
            end
        end

        if key == #children then
            local point_to_object_space_result_7 = instance_4.WorldCFrame:PointToObjectSpace(instance_5.WorldPosition)
            local create_result_7 = vector.create(
                point_to_object_space_result_7.X,
                point_to_object_space_result_7.Y,
                point_to_object_space_result_7.Z
            )
            table.insert(items, create_result_7)

            if argument then
                values[instance_5] = create_result_7
                table.insert(items_2, instance_5)
            end
        end
    end

    return items, items_2, values
end

function utility.scaleNumberSequence(argument: userdata, callback: any)
    if callback == 1 then
        return argument
    end

    local items = {}

    for _, item in argument.Keypoints do
        local result, product

        if typeof(callback) == "function" then
            result, product = callback(item.Value, item.Envelope)
        else
            result = item.Value * callback
            product = item.Envelope * callback
        end

        table.insert(items, NumberSequenceKeypoint.new(item.Time, result, product))
    end

    return NumberSequence.new(items)
end

function utility.serializePath(argument: table)
    local create_result = buffer.create(#argument * 4 * 6)
    local number_2 = 0

    for key, item in argument do
        local scale = item.Position.X.Scale
        local scale2 = item.Position.Y.Scale

        if key ~= 1 then
            buffer.writef32(create_result, number_2, scale + item.LeftTangent.X.Scale)
            buffer.writef32(create_result, number_2 + 4, scale2 + item.LeftTangent.Y.Scale)
            number_2 = number_2 + 8
        end

        buffer.writef32(create_result, number_2, scale)
        buffer.writef32(create_result, number_2 + 4, scale2)
        number_2 = number_2 + 8

        if key ~= #argument then
            buffer.writef32(create_result, number_2, scale + item.RightTangent.X.Scale)
            buffer.writef32(create_result, number_2 + 4, scale2 + item.RightTangent.Y.Scale)
            number_2 = number_2 + 8
        end
    end

    return create_result
end

function utility.deserializePath(fromstring_result)
    if typeof(fromstring_result) == "string" then
        fromstring_result = buffer.fromstring(fromstring_result) or fromstring_result
    end

    local quotient = buffer.len(fromstring_result) / 24
    local items = {}

    for index = 0, quotient - 1 do
        local product = index * 4 * 6
        local readf32_result = buffer.readf32(fromstring_result, product)
        local readf32_result_2 = buffer.readf32(fromstring_result, product + 4)
        local create_result = vector.create(readf32_result, readf32_result_2)
        table.insert(items, create_result)
        local index_2

        if index == quotient - 1 then
            index_2 = index
        else
            local readf32_result_3 = buffer.readf32(fromstring_result, product + 8)
            local readf32_result_4 = buffer.readf32(fromstring_result, product + 12)
            local readf32_result_5 = buffer.readf32(fromstring_result, product + 16)
            local readf32_result_6 = buffer.readf32(fromstring_result, product + 20)
            local create_result_2 = vector.create(readf32_result_3, readf32_result_4)
            table.insert(items, create_result_2)
            local create_result_3 = vector.create(readf32_result_5, readf32_result_6)
            table.insert(items, create_result_3)
            index_2 = index
        end
    end

    return items
end

local flipbook = require("./common/flipbook")
utility.serializeFlipbook = flipbook.serialize
utility.deserializeFlipbook = flipbook.deserialize
utility.default_bezier = buffer.tostring(utility.serializePath({
    Path2DControlPoint.new(UDim2.fromScale(0, 1), UDim2.new(), UDim2.fromScale(0.215, -0.61)),
    Path2DControlPoint.new(UDim2.fromScale(1, 0), UDim2.fromScale(-0.645, 0), UDim2.new()),
}))
utility.linear_bezier = buffer.tostring(utility.serializePath({
    Path2DControlPoint.new(UDim2.fromScale(0, 1)),
    Path2DControlPoint.new(UDim2.fromScale(1, 0)),
}))

function utility.scaleAttribute(argument: userdata, argument_2: number, argument_3: string)
    local get_result = attributes.get(argument, argument_3, nil)

    if get_result == nil then
        return
    end

    if typeof(get_result) == "number" then
        attributes.set(argument, argument_3, get_result * argument_2)

        return
    end

    if typeof(get_result) == "Vector3" then
        attributes.set(argument, argument_3, get_result * argument_2)

        return
    end

    if typeof(get_result) == "NumberRange" then
        attributes.set(argument, argument_3, NumberRange.new(get_result.Min * argument_2, get_result.Max * argument_2))
    end
end

function utility.scaleAttachmentDistance(argument: userdata?, argument_2: userdata?, argument_3: number)
    if not (argument and argument_2) then
        return
    end

    local quotient = (argument.Position + argument_2.Position) / 2
    argument.Position = quotient + (argument.Position - quotient) * argument_3
    argument_2.Position = quotient + (argument_2.Position - quotient) * argument_3
end

return utility
