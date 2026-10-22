local players = game:GetService("Players")
local values =
    { CIRCLE1 = 5, CHAR_OUTLINE = 9, MOVEMENT = 3, CORNERS = 4, LIMBS = 2, SMART_CIRCLE = 8, LIMBMOVE = 7, CIRCLE2 = 6 }
local values_2 = {}
values_2.Head = true
values_2["Left Arm"] = true
values_2["Right Arm"] = true
values_2["Left Leg"] = true
values_2["Right Leg"] = true
values_2.LeftLowerArm = true
values_2.RightLowerArm = true
values_2.LeftUpperLeg = true
values_2.RightUpperLeg = true
local values_3 = { Vector3.new(1, 1, -1), Vector3.new(1, -1, -1), Vector3.new(-1, -1, -1), Vector3.new(-1, 1, -1) }

local function det3x3(
    argument,
    argument_2,
    argument_3,
    argument_4,
    argument_5,
    argument_6,
    argument_7,
    argument_8,
    argument_9
)
    return (
        (argument * ((argument_5 * argument_9) - (argument_6 * argument_8)))
        - (argument_2 * ((argument_4 * argument_9) - (argument_6 * argument_7)))
    ) + (argument_3 * ((argument_4 * argument_8) - (argument_5 * argument_7)))
end

local base_occlusion = require(script.Parent:WaitForChild("BaseOcclusion"))
local invisicam = setmetatable({}, base_occlusion)
invisicam.__index = invisicam

function invisicam.new()
    local instance = setmetatable(base_occlusion.new(), invisicam)
    instance.char = nil
    instance.humanoidRootPart = nil
    instance.torsoPart = nil
    instance.headPart = nil
    instance.childAddedConn = nil
    instance.childRemovedConn = nil
    instance.behaviors = {}
    instance.behaviors[values.LIMBS] = instance.LimbBehavior
    instance.behaviors[values.MOVEMENT] = instance.MoveBehavior
    instance.behaviors[values.CORNERS] = instance.CornerBehavior
    instance.behaviors[values.CIRCLE1] = instance.CircleBehavior
    instance.behaviors[values.CIRCLE2] = instance.CircleBehavior
    instance.behaviors[values.LIMBMOVE] = instance.LimbMoveBehavior
    instance.behaviors[values.SMART_CIRCLE] = instance.SmartCircleBehavior
    instance.behaviors[values.CHAR_OUTLINE] = instance.CharacterOutlineBehavior
    instance.mode = values.SMART_CIRCLE
    instance.behaviorFunction = instance.SmartCircleBehavior
    instance.savedHits = {}
    instance.trackedLimbs = {}
    instance.camera = game.Workspace.CurrentCamera
    instance.enabled = false
    return instance
end

function invisicam.Enable(self, enabled)
    self.enabled = enabled
    if enabled then
        return
    end
    self:Cleanup()
end

function invisicam.GetOcclusionMode(self)
    return Enum.DevCameraOcclusionMode.Invisicam
end

function invisicam.LimbBehavior(self, argument)
    for key, _ in pairs(self.trackedLimbs) do
        argument[#argument + 1] = key.Position
    end
end

function invisicam.MoveBehavior(self, argument)
    for n = 1, 3 do
        local velocity = self.humanoidRootPart.Velocity
        argument[#argument + 1] = self.humanoidRootPart.Position
            + (
                ((n - 1) * self.humanoidRootPart.CFrame.lookVector)
                * (Vector3.new(velocity.X, 0, velocity.Z).Magnitude / 2)
            )
    end
end

function invisicam.CornerBehavior(self, argument)
    local cframe = self.humanoidRootPart.CFrame
    local position = cframe.Position
    local extents_size_offset = self.char:GetExtentsSize() / 2
    argument[#argument + 1] = position
    for n = 1, #values_3 do
        argument[#argument + 1] = position + ((cframe - position) * (extents_size_offset * values_3[n]))
    end
end

function invisicam.CircleBehavior(self, argument)
    local coordinate_frame_offset_offset
    if self.mode ~= values.CIRCLE1 then
        local _ = self.camera.CoordinateFrame
        coordinate_frame_offset_offset = self.camera.CoordinateFrame
            - self.camera.CoordinateFrame.Position
            + self.humanoidRootPart.Position
    else
        coordinate_frame_offset_offset = self.humanoidRootPart.CFrame
    end
    argument[#argument + 1] = coordinate_frame_offset_offset.Position
    for n = 0, 9 do
        local number_offset = 0.6283185307179586 * n
        argument[#argument + 1] = coordinate_frame_offset_offset
            * (Vector3.new(math.cos(number_offset), math.sin(number_offset), 0) * 3)
    end
end

function invisicam.LimbMoveBehavior(self, argument)
    self:LimbBehavior(argument)
    self:MoveBehavior(argument)
end

function invisicam.CharacterOutlineBehavior(self, argument)
    local unit = self.torsoPart.CFrame.upVector.unit
    local unit_2 = self.torsoPart.CFrame.rightVector.unit
    argument[#argument + 1] = self.torsoPart.CFrame.p
    argument[#argument + 1] = self.torsoPart.CFrame.p + unit
    argument[#argument + 1] = self.torsoPart.CFrame.p - unit
    argument[#argument + 1] = self.torsoPart.CFrame.p + unit_2
    argument[#argument + 1] = self.torsoPart.CFrame.p - unit_2
    if self.headPart then
        argument[#argument + 1] = self.headPart.CFrame.p
    end
    local cframe = CFrame.new(
        Vector3.new(0, 0, 0),
        Vector3.new(self.camera.CoordinateFrame.lookVector.X, 0, self.camera.CoordinateFrame.lookVector.Z)
    )
    local torso_part = (self.torsoPart and self.torsoPart.Position) or self.humanoidRootPart.Position
    local values_4 = { self.torsoPart }
    if self.headPart then
        values_4[#values_4 + 1] = self.headPart
    end
    for n = 1, 24 do
        local tau_offset_offset = math.tau * n / 24
        local cframe_offset = cframe * (Vector3.new(math.cos(tau_offset_offset), math.sin(tau_offset_offset), 0) * 3)
        local vector = Vector3.new(cframe_offset.X, math.max(cframe_offset.Y, -2.25), cframe_offset.Z)
        local part_on_ray_with_whitelist, value =
            game.Workspace:FindPartOnRayWithWhitelist(Ray.new(torso_part + vector, -3 * vector), values_4, false)
        if part_on_ray_with_whitelist then
            argument[#argument + 1] = value + (0.2 * (torso_part - value).unit)
        end
    end
end

local function ray_intersection(argument, argument_2, argument_3, argument_4)
    local cross_product = argument_2:Cross(argument_4)
    local x_offset = argument_3.X - argument.X
    local y_offset = argument_3.Y - argument.Y
    local z_offset = argument_3.Z - argument.Z
    local y = argument_2.Y
    local y_offset_2 = -argument_4.Y
    local y_2 = cross_product.Y
    local z = argument_2.Z
    local z_offset_2 = -argument_4.Z
    local z_2 = cross_product.Z
    local x_offset_offset_offset = (argument_2.X * ((y_offset_2 * z_2) - (y_2 * z_offset_2)))
        - (-argument_4.X * ((y * z_2) - (y_2 * z)))
        + cross_product.X * ((y * z_offset_2) - (y_offset_2 * z))
    if x_offset_offset_offset == 0 then
        return Vector3.new(0, 0, 0)
    end
    local y_offset_3 = -argument_4.Y
    local y_3 = cross_product.Y
    local z_offset_3 = -argument_4.Z
    local z_3 = cross_product.Z
    local y_4 = argument_2.Y
    local y_5 = cross_product.Y
    local z_4 = argument_2.Z
    local z_5 = cross_product.Z
    local argument_offset = argument
        + (
                (
                    (
                        (x_offset * ((y_offset_3 * z_3) - (y_3 * z_offset_3)))
                        - (-argument_4.X * ((y_offset * z_3) - (y_3 * z_offset)))
                    )
                    + (cross_product.X * ((y_offset * z_offset_3) - (y_offset_3 * z_offset)))
                ) / x_offset_offset_offset
            )
            * argument_2
    local argument_offset_2 = argument_3
        + (
                (
                    ((argument_2.X * ((y_offset * z_5) - (y_5 * z_offset))) - (x_offset * ((y_4 * z_5) - (y_5 * z_4))))
                    + (cross_product.X * ((y_4 * z_offset) - (y_offset * z_4)))
                ) / x_offset_offset_offset
            )
            * argument_4
    if (argument_offset_2 - argument_offset).Magnitude < 0.25 then
        return argument_offset + ((argument_offset_2 - argument_offset) * 0.5)
    end
    return Vector3.new(0, 0, 0)
end

function invisicam.SmartCircleBehavior(self, argument)
    local unit = self.torsoPart.CFrame.upVector.unit
    local unit_2 = self.torsoPart.CFrame.rightVector.unit
    argument[#argument + 1] = self.torsoPart.CFrame.p
    argument[#argument + 1] = self.torsoPart.CFrame.p + unit
    argument[#argument + 1] = self.torsoPart.CFrame.p - unit
    argument[#argument + 1] = self.torsoPart.CFrame.p + unit_2
    argument[#argument + 1] = self.torsoPart.CFrame.p - unit_2
    if self.headPart then
        argument[#argument + 1] = self.headPart.CFrame.p
    end
    local vector_offset = Vector3.new(0, 0.5, 0)
        + ((self.torsoPart and self.torsoPart.Position) or self.humanoidRootPart.Position)
    local value, vector = nil, nil
    for n = 1, 24 do
        local number_offset_offset = 0.2617993877991494 * n - 1.5707963267948966
        local vector_offset_offset = vector_offset
            + (self.camera.CFrame - self.camera.CFrame.p)
                * (Vector3.new(math.cos(number_offset_offset), math.sin(number_offset_offset), 0) * 2.5)
        local vector_offset_offset_offset = vector_offset_offset - self.camera.CFrame.p
        local hit_part, value_2, value_3 = game.Workspace:FindPartOnRayWithIgnoreList(
            Ray.new(vector_offset, vector_offset_offset - vector_offset),
            { self.char },
            false,
            false
        )
        if not hit_part then
            vector = vector_offset_offset
            argument[#argument + 1] = vector
            continue
        end
        local computed_value = value_2 + 0.1 * value_3.unit
        local computed_value_offset = computed_value - vector_offset
        local unit_3 = computed_value_offset:Cross(vector_offset_offset_offset).unit:Cross(value_3).unit
        if
            not (
                computed_value_offset.unit:Dot(-unit_3)
                < computed_value_offset.unit:Dot((computed_value - self.camera.CFrame.p).unit)
            )
        then
            vector = computed_value
            local hit_part_2, value_4 = game.Workspace:FindPartOnRayWithIgnoreList(
                Ray.new(vector_offset, vector - vector_offset),
                { self.char },
                false,
                false
            )
            vector = (hit_part_2 and (value_4 - (0.1 * (vector - vector_offset).unit))) or vector
            argument[#argument + 1] = vector
            continue
        end
        vector = ray_intersection(computed_value, unit_3, vector_offset_offset, vector_offset_offset_offset)
        if vector.Magnitude > 0 then
            local value_6, value_7 = nil, nil
            local hit_part_3, value_8, value_9 = game.Workspace:FindPartOnRayWithIgnoreList(
                Ray.new(computed_value, vector - computed_value),
                { self.char },
                false,
                false
            )
            vector = (hit_part_3 and (value_8 + (0.1 * value_9.unit))) or vector
        else
            vector = computed_value
        end
        local hit_part_4, value_10 = game.Workspace:FindPartOnRayWithIgnoreList(
            Ray.new(vector_offset, vector - vector_offset),
            { self.char },
            false,
            false
        )
        vector = (hit_part_4 and (value_10 - (0.1 * (vector - vector_offset).unit))) or vector
        argument[#argument + 1] = vector
    end
end

function invisicam.CheckTorsoReference(self)
    if not self.char then
        return
    end
    self.torsoPart = self.char:FindFirstChild("Torso")
    if not self.torsoPart then
        self.torsoPart = self.char:FindFirstChild("UpperTorso")
        if not self.torsoPart then
            self.torsoPart = self.char:FindFirstChild("HumanoidRootPart")
        end
    end
    self.headPart = self.char:FindFirstChild("Head")
end

function invisicam.CharacterAdded(self, char, argument)
    if argument ~= players.LocalPlayer then
        return
    end
    if self.childAddedConn then
        self.childAddedConn:Disconnect()
        self.childAddedConn = nil
    end
    if self.childRemovedConn then
        self.childRemovedConn:Disconnect()
        self.childRemovedConn = nil
    end
    self.char = char
    self.trackedLimbs = {}
    local function child_removed(argument_2)
        self.trackedLimbs[argument_2] = nil
        self:CheckTorsoReference()
    end
    local function child_added(torso_part_2)
        if not torso_part_2:IsA("BasePart") then
            return
        end
        if values_2[torso_part_2.Name] then
            self.trackedLimbs[torso_part_2] = true
        end
        if torso_part_2.Name == "Torso" or torso_part_2.Name == "UpperTorso" then
            self.torsoPart = torso_part_2
        end
        if torso_part_2.Name ~= "Head" then
            return
        end
        self.headPart = torso_part_2
    end
    self.childAddedConn = char.ChildAdded:Connect(child_added)
    self.childRemovedConn = char.ChildRemoved:Connect(child_removed)
    for _, torso_part in pairs(self.char:GetChildren()) do
        if not (torso_part:IsA("BasePart")) then
            continue
        end
        if values_2[torso_part.Name] then
            self.trackedLimbs[torso_part] = true
        end
        if torso_part.Name == "Torso" or torso_part.Name == "UpperTorso" then
            self.torsoPart = torso_part
        end
        if torso_part.Name == "Head" then
            self.headPart = torso_part
        end
    end
end

local function assert_types(argument, ...)
    local values_4 = {}
    local text = ""
    for _, item in pairs({ ... }) do
        values_4[item] = true
        text ..= (((text ~= "") and " or ") or "") .. item
    end
    local ty = type(argument)
    assert(values_4[ty], text .. " type expected, got: " .. ty)
end

function invisicam.SetMode(self, mode)
    assert_types(mode, "number")
    for _, item in pairs(values) do
        if item ~= mode then
            continue
        end
        self.mode = mode
        self.behaviorFunction = self.behaviors[self.mode]
        return
    end
    error("Invalid mode number")
end

function invisicam.GetObscuredParts(self)
    return self.savedHits
end

function invisicam.Cleanup(self)
    for key, local_transparency_modifier in pairs(self.savedHits) do
        key.LocalTransparencyModifier = local_transparency_modifier
    end
end

function invisicam.Update(self, argument, argument_2, argument_3)
    if not self.enabled or not self.char then
        return argument_2, argument_3
    end
    self.camera = game.Workspace.CurrentCamera
    local value = nil
    if not self.humanoidRootPart then
        value = self.char:FindFirstChildOfClass("Humanoid")
        if value and value.RootPart then
            self.humanoidRootPart = value.RootPart
        else
            self.humanoidRootPart = self.char:FindFirstChild("HumanoidRootPart")
            if not self.humanoidRootPart then
                return argument_2, argument_3
            end
        end
        local connection_2 = nil
        local connection = self.humanoidRootPart.AncestryChanged:Connect(function(argument_4, argument_5)
            if argument_4 ~= self.humanoidRootPart or argument_5 then
                return
            end
            self.humanoidRootPart = nil
            if not connection_2 or not connection_2.Connected then
                return
            end
            connection_2:Disconnect()
            connection_2 = nil
        end)
        connection_2 = connection
    end
    if not self.torsoPart then
        self:CheckTorsoReference()
        if not self.torsoPart then
            return argument_2, argument_3
        end
    end
    local values_4 = {}
    self.behaviorFunction(self, values_4)
    local values_5 = {}
    local values_6 = { self.char }
    local function add(argument_4)
        values_5[argument_4] = true
        if self.savedHits[argument_4] then
            return
        end
        self.savedHits[argument_4] = argument_4.LocalTransparencyModifier
    end
    local number = 0
    local values_7 = {}
    local number_2 = 0.75
    local number_3 = 0.75
    local head_part = (self.headPart and self.headPart.CFrame.p) or values_4[1]
    local parts_obscuring_target = self.camera:GetPartsObscuringTarget(
        { head_part, (self.torsoPart and self.torsoPart.CFrame.p) or values_4[2] },
        values_6
    )
    for n = 1, #parts_obscuring_target do
        local parts_obscuring_target_entry = parts_obscuring_target[n]
        number += 1
        values_7[parts_obscuring_target_entry] = true
        for _, child in pairs(parts_obscuring_target_entry:GetChildren()) do
            local is_a_result = child:IsA("Decal")
            if is_a_result then
                number += 1
            end
        end
        local is_a_result_2 = value_5:IsA("Texture")
        if is_a_result_2 then
            number += 1
        end
    end
    if number > 0 then
        number_2, number_3 =
            math.pow((0.375 / number) + 0.375, 1 / number), math.pow((0.25 / number) + 0.25, 1 / number)
    end
    local parts_obscuring_target_2 = self.camera:GetPartsObscuringTarget(values_4, values_6)
    local values_8 = {}
    values_8 = values_8
    for n_2 = 1, #parts_obscuring_target_2 do
        local parts_obscuring_target_entry_2 = parts_obscuring_target_2[n_2]
        local number_4
        if values_7[parts_obscuring_target_entry_2] and number_2 then
            number_4 = number_2
        else
            number_4 = number_3
        end
        values_8[parts_obscuring_target_entry_2] = number_4
        if parts_obscuring_target_entry_2.Transparency < values_8[parts_obscuring_target_entry_2] then
            values_5[parts_obscuring_target_entry_2] = true
            if not self.savedHits[parts_obscuring_target_entry_2] then
                self.savedHits[parts_obscuring_target_entry_2] =
                    parts_obscuring_target_entry_2.LocalTransparencyModifier
            end
        end
        for _, child_2 in pairs(parts_obscuring_target_entry_2:GetChildren()) do
            if child_2:IsA("Decal") or child_2:IsA("Texture") then
                if not (child_2.Transparency < values_8[parts_obscuring_target_entry_2]) then
                    continue
                end
                values_8[child_2] = values_8[parts_obscuring_target_entry_2]
                values_5[child_2] = true
                if not self.savedHits[child_2] then
                    self.savedHits[child_2] = child_2.LocalTransparencyModifier
                end
            end
        end
    end
    for key, local_transparency_modifier in pairs(self.savedHits) do
        if values_5[key] then
            key.LocalTransparencyModifier = (
                (key.Transparency < 1) and ((values_8[key] - key.Transparency) / (1 - key.Transparency))
            ) or 0
        else
            key.LocalTransparencyModifier = local_transparency_modifier
            self.savedHits[key] = nil
        end
    end
    return argument_2, argument_3
end

return invisicam
