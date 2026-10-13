local zoom_controller = require(script.Parent:WaitForChild("ZoomController"))
local values = {}
values.__index = values
local cframe = CFrame.new()

local function cframe_to_axis(argument)
    local to_axis_angle_result, value = argument:ToAxisAngle()
    return to_axis_angle_result * value
end

local function axis_to_c_frame(vector)
    local magnitude = vector.Magnitude
    if magnitude > 1e-05 then
        return CFrame.fromAxisAngle(vector, magnitude)
    end
    return cframe
end

local function extract_rotation(argument)
    local _, value, value_2, value_3, value_4, value_5, value_6, value_7, value_8, value_9, value_10, value_11 =
        argument:GetComponents()
    return CFrame.new(0, 0, 0, value_3, value_4, value_5, value_6, value_7, value_8, value_9, value_10, value_11)
end

function values.new()
    return (setmetatable({}, values))
end

function values.Step(self, argument, last_c_frame_2)
    local last_c_frame = self.lastCFrame or last_c_frame_2
    self.lastCFrame = last_c_frame_2
    local position = last_c_frame_2.Position
    local _, value, value_2, value_3, value_4, value_5, value_6, value_7, value_8, value_9, value_10, value_11 =
        last_c_frame_2:GetComponents()
    local cframe_2 =
        CFrame.new(0, 0, 0, value_3, value_4, value_5, value_6, value_7, value_8, value_9, value_10, value_11)
    local p = last_c_frame.p
    local components, value_12, value_13, value_14, value_15, value_16, value_17, value_18, value_19, value_20, value_21, value_22 =
        last_c_frame:GetComponents()
    local pos_velocity = (position - p) / argument
    local to_axis_angle_result, value_23 = (cframe_2 * CFrame.new(
        0,
        0,
        0,
        value_14,
        value_15,
        value_16,
        value_17,
        value_18,
        value_19,
        value_20,
        value_21,
        value_22
    ):inverse()):ToAxisAngle()
    local rot_velocity = to_axis_angle_result * value_23 / argument
    local values_2 = {}
    function values_2.extrapolate(self_2)
        local pos_velocity_offset_offset = pos_velocity * self_2 + position
        local vector = rot_velocity * self_2
        local magnitude = vector.Magnitude
        local from_axis_angle_result
        if magnitude > 1e-05 then
            from_axis_angle_result = CFrame.fromAxisAngle(vector, magnitude)
        else
            from_axis_angle_result = cframe
        end
        return (from_axis_angle_result * cframe_2) + pos_velocity_offset_offset
    end
    values_2.posVelocity = pos_velocity
    values_2.rotVelocity = rot_velocity
    return values_2
end

function values.Reset(self)
    self.lastCFrame = nil
end

local base_occlusion = require(script.Parent:WaitForChild("BaseOcclusion"))
local poppercam = setmetatable({}, base_occlusion)
poppercam.__index = poppercam

function poppercam.new()
    local instance = setmetatable(base_occlusion.new(), poppercam)
    instance.focusExtrapolator = values.new()
    return instance
end

function poppercam.GetOcclusionMode(self)
    return Enum.DevCameraOcclusionMode.Zoom
end

function poppercam.Enable(self, argument)
    self.focusExtrapolator:Reset()
end

function poppercam.Update(self, argument, argument_2, argument_3, argument_4)
    local cframe_offset = CFrame.new(argument_3.p, argument_2.p) * CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1)
    return cframe_offset * CFrame.new(
        0,
        0,
        zoom_controller.Update(argument, cframe_offset, self.focusExtrapolator:Step(argument, cframe_offset))
    ),
        argument_3
end

function poppercam.CharacterAdded(self, argument, argument_2) end

function poppercam.CharacterRemoving(self, argument, argument_2) end

function poppercam.OnCameraSubjectChanged(self, argument) end

return poppercam
