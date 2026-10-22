local vr_service = game:GetService("VRService")
local values = { "BasePart", "Decal", "Beam", "ParticleEmitter", "Trail", "Fire", "Smoke", "Sparkles", "Explosion" }
local camera_utils = require(script.Parent:WaitForChild("CameraUtils"))
local success, result = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserHideCharacterParticlesInFirstPerson")
end)
local result_2 = success and result
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

function transparency_controller.HasToolAncestor(argument: table, argument_2: userdata)
    if argument_2.Parent == nil then
        return false
    end

    assert(argument_2.Parent, "")

    return argument_2.Parent:IsA("Tool")
        or (argument_2.Parent:IsA("Accessory") or argument:HasToolAncestor(argument_2.Parent))
end

function transparency_controller.IsValidPartToModify(argument: table, argument_2: userdata)
    if result_2 then
        for _, item in values do
            if argument_2:IsA(item) then
                return argument:HasToolAncestor(argument_2)
            end
        end
    elseif argument_2:IsA("BasePart") or argument_2:IsA("Decal") then
        return argument:HasToolAncestor(argument_2)
    end

    return false
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
        if not argument:IsValidPartToModify(descendant) then
            if descendant:IsA("Tool") then
                if argument.toolDescendantAddedConns[descendant] then
                    argument.toolDescendantAddedConns[descendant]:Disconnect()
                end

                argument.toolDescendantAddedConns[descendant] = descendant.DescendantAdded:Connect(
                    function(descendant_2)
                        argument.cachedParts[descendant_2] = nil

                        if descendant_2:IsA("BasePart") or descendant_2:IsA("Decal") then
                            descendant_2.LocalTransparencyModifier = 0
                        end
                    end
                )

                if argument.toolDescendantRemovingConns[descendant] then
                    argument.toolDescendantRemovingConns[descendant]:disconnect()
                end

                argument.toolDescendantRemovingConns[descendant] = descendant.DescendantRemoving:Connect(
                    function(descendant_2)
                        wait()

                        if
                            argument_2
                            and (
                                descendant_2
                                and (
                                    descendant_2:IsDescendantOf(argument_2)
                                    and argument:IsValidPartToModify(descendant_2)
                                )
                            )
                        then
                            argument.cachedParts[descendant_2] = true
                            argument.transparencyDirty = true
                        end
                    end
                )
            end

            return
        end

        argument.cachedParts[descendant] = true
        argument.transparencyDirty = true
    end)

    if argument.descendantRemovingConn then
        argument.descendantRemovingConn:disconnect()
    end

    argument.descendantRemovingConn = argument_2.DescendantRemoving:connect(function(argument_3)
        if argument.cachedParts[argument_3] then
            argument.cachedParts[argument_3] = nil
            argument_3.LocalTransparencyModifier = 0
        end
    end)
    argument:CachePartsRecursive(argument_2)
end

function transparency_controller.Enable(argument: table, enabled: boolean)
    if argument.enabled ~= enabled then
        argument.enabled = enabled
    end
end

function transparency_controller.SetSubject(argument, argument_2)
    local parent

    if argument_2 and argument_2:IsA("Humanoid") then
        parent = argument_2.Parent
    else
        parent = nil
    end

    if argument_2 and (argument_2:IsA("VehicleSeat") and argument_2.Occupant) then
        parent = argument_2.Occupant.Parent
    end

    if parent then
        argument:SetupTransparency(parent)

        return
    end

    argument:TeardownTransparency()
end

function transparency_controller.Update(argument, argument_2)
    local workspace_current_camera = workspace.CurrentCamera

    if not (workspace_current_camera and argument.enabled) then
        return
    end

    local magnitude = (workspace_current_camera.Focus.p - workspace_current_camera.CoordinateFrame.p).magnitude
    local difference = magnitude < 2 and 1 - (magnitude - 0.5) / 1.5 or 0
    local difference_2 = difference < 0.5 and 0 or difference

    if argument.lastTransparency and (difference_2 < 1 and argument.lastTransparency < 0.95) then
        local product = 2.8 * argument_2
        local clamped_value = math.clamp(difference_2 - argument.lastTransparency, -product, product)
        difference_2 = argument.lastTransparency + clamped_value
    else
        argument.transparencyDirty = true
    end

    local round_result = camera_utils.Round(difference_2, 2)
    local local_transparency_modifier = math.clamp(round_result, 0, 1)

    if not (argument.transparencyDirty or argument.lastTransparency ~= local_transparency_modifier) then
        return
    end

    for key, _ in pairs(argument.cachedParts) do
        if vr_service.VREnabled and vr_service.AvatarGestures then
            local values_2 = {
                [Enum.AccessoryType.Hat] = true,
                [Enum.AccessoryType.Hair] = true,
                [Enum.AccessoryType.Face] = true,
                [Enum.AccessoryType.Eyebrow] = true,
                [Enum.AccessoryType.Eyelash] = true,
            }

            if key.Parent:IsA("Accessory") and values_2[key.Parent.AccessoryType] or key.Name == "Head" then
                key.LocalTransparencyModifier = local_transparency_modifier
            else
                key.LocalTransparencyModifier = 0
            end
        else
            key.LocalTransparencyModifier = local_transparency_modifier
        end
    end

    argument.transparencyDirty = false
    argument.lastTransparency = local_transparency_modifier
end

return transparency_controller
