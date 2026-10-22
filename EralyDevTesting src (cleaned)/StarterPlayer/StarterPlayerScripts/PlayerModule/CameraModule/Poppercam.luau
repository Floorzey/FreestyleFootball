local zoom_controller = require(script.Parent:WaitForChild("ZoomController"))
local values = {}
values.__index = values
local cframe = CFrame.new()

local function cframe_to_axis(argument)
    local to_axis_angle_result, value = argument:ToAxisAngle()

    return to_axis_angle_result * value
end

local function axis_to_c_frame(vector: vector)
    local magnitude = vector.Magnitude

    if magnitude > 0.00001 then
        return CFrame.fromAxisAngle(vector, magnitude)
    end

    return cframe
end

local function extract_rotation(argument)
    local _, _, _, value, value_2, value_3, value_4, value_5, value_6, value_7, value_8, value_9 =
        argument:GetComponents()

    return CFrame.new(0, 0, 0, value, value_2, value_3, value_4, value_5, value_6, value_7, value_8, value_9)
end

function values.new()
    return setmetatable({
        lastCFrame = nil,
    }, values)
end

function values.Step(argument: table, argument_2: number, last_c_frame_2)
    local last_c_frame = argument.lastCFrame or last_c_frame_2
    argument.lastCFrame = last_c_frame_2
    local position = last_c_frame_2.Position
    local _, _, _, value, value_2, value_3, value_4, value_5, value_6, value_7, value_8, value_9 =
        last_c_frame_2:GetComponents()
    local cframe_2 = CFrame.new(0, 0, 0, value, value_2, value_3, value_4, value_5, value_6, value_7, value_8, value_9)
    local p = last_c_frame.p
    local _, _, _, value_10, value_11, value_12, value_13, value_14, value_15, value_16, value_17, value_18 =
        last_c_frame:GetComponents()
    local cframe_3 =
        CFrame.new(0, 0, 0, value_10, value_11, value_12, value_13, value_14, value_15, value_16, value_17, value_18)
    local pos_velocity = (position - p) / argument_2
    local to_axis_angle_result, value_19 = (cframe_2 * cframe_3:inverse()):ToAxisAngle()
    local rot_velocity = to_axis_angle_result * value_19 / argument_2

    return {
        extrapolate = function(argument_3)
            local vector = rot_velocity * argument_3
            local magnitude = vector.Magnitude
            local from_axis_angle_result

            if magnitude > 0.00001 then
                from_axis_angle_result = CFrame.fromAxisAngle(vector, magnitude)
            else
                from_axis_angle_result = cframe
            end

            return from_axis_angle_result * cframe_2 + (pos_velocity * argument_3 + position)
        end,

        posVelocity = pos_velocity,
        rotVelocity = rot_velocity,
    }
end

function values.Reset(argument)
    argument.lastCFrame = nil
end

local base_occlusion = require(script.Parent:WaitForChild("BaseOcclusion"))
local poppercam = setmetatable({}, base_occlusion)
poppercam.__index = poppercam

function poppercam.new()
    local base_occlusion_2 = base_occlusion.new()
    local instance = setmetatable(base_occlusion_2, poppercam)
    instance.focusExtrapolator = values.new()

    return instance
end

function poppercam.GetOcclusionMode(argument)
    return Enum.DevCameraOcclusionMode.Zoom
end

function poppercam.Enable(argument, argument_2)
    argument.focusExtrapolator:Reset()
end

function poppercam.Update(argument, argument_2, argument_3, argument_4, argument_5)
    local product = CFrame.new(argument_4.p, argument_3.p) * CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1)
    local step_result = argument.focusExtrapolator:Step(argument_2, product)
    local update_result = zoom_controller.Update(argument_2, product, step_result)

    return product * CFrame.new(0, 0, update_result), argument_4
end

function poppercam.CharacterAdded(argument, argument_2, argument_3) end

function poppercam.CharacterRemoving(argument, argument_2, argument_3) end

function poppercam.OnCameraSubjectChanged(argument, argument_2) end

return poppercam
