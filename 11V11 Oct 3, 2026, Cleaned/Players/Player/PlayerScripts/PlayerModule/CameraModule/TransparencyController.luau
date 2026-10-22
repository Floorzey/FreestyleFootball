local vr_service = game:GetService("VRService")
local values = { "BasePart", "Decal", "Beam", "ParticleEmitter", "Trail", "Fire", "Smoke", "Sparkles", "Explosion" }
local camera_utils = require(script.Parent:WaitForChild("CameraUtils"))
local success, value = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserHideCharacterParticlesInFirstPerson")
end)
local success_2 = success and value
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

function transparency_controller.HasToolAncestor(self, argument)
    if argument.Parent == nil then
        return false
    end
    assert(argument.Parent, "")
    local is_a_result = argument.Parent:IsA("Tool")
        or (argument.Parent:IsA("Accessory") or (self:HasToolAncestor(argument.Parent)))
    return is_a_result
end

function transparency_controller.IsValidPartToModify(self, argument)
    if success_2 then
        for _, item in values do
            if not (argument:IsA(item)) then
                continue
            end
            return self:HasToolAncestor(argument)
        end
        return false
    elseif not (argument:IsA("BasePart")) and not (argument:IsA("Decal")) then
        return false
    else
        return self:HasToolAncestor(argument)
    end
end

function transparency_controller.CachePartsRecursive(self, instance)
    if not instance then
        return
    end
    if self:IsValidPartToModify(instance) then
        self.cachedParts[instance] = true
        self.transparencyDirty = true
    end
    for _, child in pairs(instance:GetChildren()) do
        self:CachePartsRecursive(child)
    end
end

function transparency_controller.TeardownTransparency(self)
    for key, _ in pairs(self.cachedParts) do
        key.LocalTransparencyModifier = 0
    end
    self.cachedParts = {}
    self.transparencyDirty = true
    self.lastTransparency = nil
    if self.descendantAddedConn then
        self.descendantAddedConn:disconnect()
        self.descendantAddedConn = nil
    end
    if self.descendantRemovingConn then
        self.descendantRemovingConn:disconnect()
        self.descendantRemovingConn = nil
    end
    for key_2, connection in pairs(self.toolDescendantAddedConns) do
        connection:Disconnect()
        self.toolDescendantAddedConns[key_2] = nil
    end
    for key_3, connection_2 in pairs(self.toolDescendantRemovingConns) do
        connection_2:Disconnect()
        self.toolDescendantRemovingConns[key_3] = nil
    end
end

function transparency_controller.SetupTransparency(self, argument)
    self:TeardownTransparency()
    if self.descendantAddedConn then
        self.descendantAddedConn:disconnect()
    end
    self.descendantAddedConn = argument.DescendantAdded:Connect(function(descendant)
        if self:IsValidPartToModify(descendant) then
            self.cachedParts[descendant] = true
            self.transparencyDirty = true
        elseif descendant:IsA("Tool") then
            if self.toolDescendantAddedConns[descendant] then
                self.toolDescendantAddedConns[descendant]:Disconnect()
            end
            self.toolDescendantAddedConns[descendant] = descendant.DescendantAdded:Connect(function(descendant_2)
                self.cachedParts[descendant_2] = nil
                if not descendant_2:IsA("BasePart") and not descendant_2:IsA("Decal") then
                    return
                end
                descendant_2.LocalTransparencyModifier = 0
            end)
            if self.toolDescendantRemovingConns[descendant] then
                self.toolDescendantRemovingConns[descendant]:disconnect()
            end
            self.toolDescendantRemovingConns[descendant] = descendant.DescendantRemoving:Connect(function(descendant_2)
                wait()
                if
                    not argument
                    or not descendant_2
                    or not descendant_2:IsDescendantOf(argument)
                    or not self:IsValidPartToModify(descendant_2)
                then
                    return
                end
                self.cachedParts[descendant_2] = true
                self.transparencyDirty = true
            end)
        end
    end)
    if self.descendantRemovingConn then
        self.descendantRemovingConn:disconnect()
    end
    self.descendantRemovingConn = argument.DescendantRemoving:connect(function(argument_2)
        if not self.cachedParts[argument_2] then
            return
        end
        self.cachedParts[argument_2] = nil
        argument_2.LocalTransparencyModifier = 0
    end)
    self:CachePartsRecursive(argument)
end

function transparency_controller.Enable(self, enabled)
    if self.enabled == enabled then
        return
    end
    self.enabled = enabled
end

function transparency_controller.SetSubject(self, argument)
    if argument then
        local _ = (not argument:IsA("Humanoid")) or argument.Parent
    end
    local parent = not argument
        or ((not argument:IsA("VehicleSeat")) or ((not argument.Occupant) or argument.Occupant.Parent))
    if parent then
        self:SetupTransparency(parent)
    else
        self:TeardownTransparency()
    end
end

function transparency_controller.Update(self, argument)
    local current_camera = workspace.CurrentCamera
    if not current_camera then
        return
    end
    if self.enabled then
        local magnitude = (current_camera.Focus.p - current_camera.CoordinateFrame.p).magnitude
        local is_magnitude = ((magnitude < 2) and (1 - (magnitude - 0.5) / 1.5)) or 0
        if is_magnitude < 0.5 then
            is_magnitude = 0
        end
        if self.lastTransparency and is_magnitude < 1 and self.lastTransparency < 0.95 then
            local _ = 2.8 * argument
            is_magnitude = self.lastTransparency
                + math.clamp(is_magnitude - self.lastTransparency, -(2.8 * argument), 2.8 * argument)
        else
            self.transparencyDirty = true
        end
        local local_transparency_modifier = math.clamp(camera_utils.Round(is_magnitude, 2), 0, 1)
        if self.transparencyDirty or self.lastTransparency ~= local_transparency_modifier then
            for key, _ in pairs(self.cachedParts) do
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
            self.transparencyDirty = false
            self.lastTransparency = local_transparency_modifier
        end
    end
end

return transparency_controller
