local vr_service = game:GetService("VRService")
local values = { "BasePart", "Decal", "Beam", "ParticleEmitter", "Trail", "Fire", "Smoke", "Sparkles", "Explosion" }
local camera_utils = require(script.Parent:WaitForChild("CameraUtils"))
local success, value = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserHideCharacterParticlesInFirstPerson")
end)
local value_2 = success and value
local transparency_controller = {}
transparency_controller.__index = transparency_controller

function transparency_controller.new()
    local instance = setmetatable({}, transparency_controller)
    instance.transparencyDirty = false
    instance.enabled = false
    instance.lastTransparency = nil
    instance.descendantAddedConn = nil
    instance.descendantRemovingConn = nil
    instance.toolDescendantAddedConns = {}
    instance.toolDescendantRemovingConns = {}
    instance.cachedParts = {}

    return instance
end

function transparency_controller.HasToolAncestor(argument, argument_2)
    if argument_2.Parent == nil then
        return false
    end

    assert(argument_2.Parent, "")

    return argument_2.Parent:IsA("Tool") or argument:HasToolAncestor(argument_2.Parent)
end

function transparency_controller.IsValidPartToModify(argument, argument_2)
    if value_2 then
        for _, item in values do
            if not (argument_2:IsA(item)) then
                continue
            end

            return not argument:HasToolAncestor(argument_2)
        end

        return false
    elseif not (argument_2:IsA("BasePart")) and not (argument_2:IsA("Decal")) then
        return false
    else
        return not argument:HasToolAncestor(argument_2)
    end
end

function transparency_controller.CachePartsRecursive(argument, instance)
    if not instance then
        return
    end

    if argument:IsValidPartToModify(instance) then
        argument.cachedParts[instance] = true
        argument.transparencyDirty = true
    end

    for _, child in pairs(instance:GetChildren()) do
        argument:CachePartsRecursive(child)
    end
end

function transparency_controller.TeardownTransparency(argument)
    for key, _ in pairs(argument.cachedParts) do
        key.LocalTransparencyModifier = 0
    end

    argument.cachedParts = {}
    argument.transparencyDirty = true
    argument.lastTransparency = nil

    if argument.descendantAddedConn then
        argument.descendantAddedConn:disconnect()
        argument.descendantAddedConn = nil
    end

    if argument.descendantRemovingConn then
        argument.descendantRemovingConn:disconnect()
        argument.descendantRemovingConn = nil
    end

    for key_2, connection in pairs(argument.toolDescendantAddedConns) do
        connection:Disconnect()
        argument.toolDescendantAddedConns[key_2] = nil
    end

    for key_3, connection_2 in pairs(argument.toolDescendantRemovingConns) do
        connection_2:Disconnect()
        argument.toolDescendantRemovingConns[key_3] = nil
    end
end

function transparency_controller.SetupTransparency(argument, argument_2)
    argument:TeardownTransparency()

    if argument.descendantAddedConn then
        argument.descendantAddedConn:disconnect()
    end

    argument.descendantAddedConn = argument_2.DescendantAdded:Connect(function(descendant)
        if argument:IsValidPartToModify(descendant) then
            argument.cachedParts[descendant] = true
            argument.transparencyDirty = true
        elseif descendant:IsA("Tool") then
            if argument.toolDescendantAddedConns[descendant] then
                argument.toolDescendantAddedConns[descendant]:Disconnect()
            end

            argument.toolDescendantAddedConns[descendant] = descendant.DescendantAdded:Connect(function(descendant_2)
                argument.cachedParts[descendant_2] = nil

                if not descendant_2:IsA("BasePart") and not descendant_2:IsA("Decal") then
                    return
                end

                descendant_2.LocalTransparencyModifier = 0
            end)

            if argument.toolDescendantRemovingConns[descendant] then
                argument.toolDescendantRemovingConns[descendant]:disconnect()
            end

            argument.toolDescendantRemovingConns[descendant] = descendant.DescendantRemoving:Connect(
                function(descendant_2)
                    wait()

                    if
                        not argument_2
                        or not descendant_2
                        or not descendant_2:IsDescendantOf(argument_2)
                        or not argument:IsValidPartToModify(descendant_2)
                    then
                        return
                    end

                    argument.cachedParts[descendant_2] = true
                    argument.transparencyDirty = true
                end
            )
        end
    end)

    if argument.descendantRemovingConn then
        argument.descendantRemovingConn:disconnect()
    end

    argument.descendantRemovingConn = argument_2.DescendantRemoving:connect(function(argument_3)
        if not argument.cachedParts[argument_3] then
            return
        end

        argument.cachedParts[argument_3] = nil
        argument_3.LocalTransparencyModifier = 0
    end)
    argument:CachePartsRecursive(argument_2)
end

function transparency_controller.Enable(argument, enabled)
    if argument.enabled == enabled then
        return
    end

    argument.enabled = enabled
end

function transparency_controller.SetSubject(argument, argument_2)
    if argument_2 then
        local _ = (not argument_2:IsA("Humanoid")) or argument_2.Parent
    end

    local result = not argument_2
        or ((not argument_2:IsA("VehicleSeat")) or ((not argument_2.Occupant) or argument_2.Occupant.Parent))

    if result then
        argument:SetupTransparency(result)
    else
        argument:TeardownTransparency()
    end
end

function transparency_controller.Update(argument, argument_2)
    local current_camera = workspace.CurrentCamera

    if not current_camera then
        return
    end

    if not argument.enabled then
        return
    end

    local magnitude = (current_camera.Focus.p - current_camera.CoordinateFrame.p).magnitude
    local difference = ((magnitude < 2) and (1 - (magnitude - 0.5) / 1.5)) or 0

    if difference < 0.5 then
        difference = 0
    end

    if argument.lastTransparency and difference < 1 and argument.lastTransparency < 0.95 then
        local _ = 2.8 * argument_2
        difference = argument.lastTransparency
            + math.clamp(difference - argument.lastTransparency, -(2.8 * argument_2), 2.8 * argument_2)
    else
        argument.transparencyDirty = true
    end

    local local_transparency_modifier = math.clamp(camera_utils.Round(difference, 2), 0, 1)

    if not (argument.transparencyDirty or argument.lastTransparency ~= local_transparency_modifier) then
        return
    end

    for key, _ in pairs(argument.cachedParts) do
        if not vr_service.VREnabled or not vr_service.AvatarGestures then
            key.LocalTransparencyModifier = local_transparency_modifier
            continue
        end

        local values_2 = {}
        values_2[Enum.AccessoryType.Hat] = true
        values_2[Enum.AccessoryType.Hair] = true
        values_2[Enum.AccessoryType.Face] = true
        values_2[Enum.AccessoryType.Eyebrow] = true
        values_2[Enum.AccessoryType.Eyelash] = true

        if key.Parent:IsA("Accessory") and values_2[key.Parent.AccessoryType] or key.Name == "Head" then
            key.LocalTransparencyModifier = local_transparency_modifier
            continue
        end

        key.LocalTransparencyModifier = 0
    end

    argument.transparencyDirty = false
    argument.lastTransparency = local_transparency_modifier
end

return transparency_controller
