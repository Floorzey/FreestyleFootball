local run_service = game:GetService("RunService")
local attributes = require("../mod/attributes")
local tween = require("../mod/tween")
require("../types")
local utility = require("../mod/utility")
local shake = require("../pkg/Shake")
local items = {}
local c_frame_identity = CFrame.identity

local function update_camera()
    if #items == 0 then
        return
    end

    local workspace_current_camera = workspace.CurrentCamera

    if not run_service:IsRunning() then
        workspace_current_camera.CFrame = workspace_current_camera.CFrame * c_frame_identity:Inverse()
        local c_frame2 = workspace_current_camera.CFrame
        local to_orientation_result, value = c_frame2:ToOrientation()
        workspace_current_camera.CFrame = CFrame.new(c_frame2.Position)
            * CFrame.fromOrientation(to_orientation_result, value, 0)
    end

    local c_frame_identity2 = CFrame.identity
    local vector = Vector3.new(0, 0, 0)
    local items_2 = {}

    for _, item in items do
        if not item.done then
            vector = vector + item.pos
            c_frame_identity2 = c_frame_identity2 * CFrame.Angles(item.rot.x, item.rot.y, item.rot.z)
            table.insert(items_2, item)
        end
    end

    items = items_2
    local product = CFrame.new(vector) * c_frame_identity2

    if not run_service:IsRunning() then
        c_frame_identity = product
    end

    workspace_current_camera.CFrame = workspace_current_camera.CFrame * product
end

local camera_shake = {}
local connection = nil
local cframe = nil

function camera_shake.init()
    if connection then
        return
    end

    if run_service:IsRunning() then
        connection = run_service.Heartbeat:Connect(function()
            if not cframe then
                return
            end

            workspace.CurrentCamera.CFrame = cframe
        end)
    end

    run_service:BindToRenderStep("forge_updateCameraShake", Enum.RenderPriority.Last.Value + 1, update_camera)
end

function camera_shake.deinit()
    if connection then
        connection:Disconnect()
        connection = nil
    end

    run_service:UnbindFromRenderStep("forge_updateCameraShake")
end

function camera_shake.emit(argument: userdata, items_2: any)
    local get_result = attributes.get(argument, "EmitDelay", 0)
    local get_result_2 = attributes.get(argument, "EmitDuration", 0)
    local get_result_3 = attributes.get(argument, "Falloff", 30)
    local amplitude = attributes.get(argument, "Amplitude", 2.5)
    local frequency = attributes.get(argument, "Frequency", 0.2)
    local fade_in_time = attributes.get(argument, "FadeInTime", 0.3)
    local fade_out_time = attributes.get(argument, "FadeOutTime", 2)
    local sustain_time = attributes.get(argument, "SustainTime", 1)
    local position_influence = attributes.get(argument, "PositionInfluence", Vector3.new(1, 1, 1))
    local rotation_influence = attributes.get(argument, "RotationInfluence", Vector3.new(0.2, 0.2, 0.2))
    local get_result_4 = attributes.get(argument, "Speed_Start", 1)
    local get_result_5 = attributes.get(argument, "Speed_End", 1)
    local sustain = get_result_2 > 0
    local shake_2 = shake.new()
    shake_2.Sustain = sustain
    shake_2.Amplitude = amplitude
    shake_2.Frequency = frequency
    shake_2.FadeInTime = fade_in_time
    shake_2.FadeOutTime = fade_out_time
    shake_2.SustainTime = sustain_time
    shake_2.PositionInfluence = position_influence
    shake_2.RotationInfluence = rotation_influence
    local number = 1
    local number_2 = 0

    function shake_2.TimeFunction()
        return number_2
    end

    if get_result_4 ~= get_result_5 then
        local from_params_result = tween.fromParams(
            attributes.get(argument, "Speed_Curve", utility.default_bezier),
            attributes.get(argument, "Speed_Duration", 0.1),
            function(argument_2, argument_3)
                number = utility.lerp(get_result_4, get_result_5, argument_2)

                return argument_3
            end
        )
        table.insert(items_2, from_params_result)
    end

    table.insert(
        items_2,
        run_service.RenderStepped:Connect(function(delta_time)
            number_2 = number_2 + delta_time * number
        end)
    )
    local values = {
        done = false,
        pos = Vector3.new(0, 0, 0),
        rot = Vector3.new(0, 0, 0),
    }
    task.wait(get_result)
    table.insert(items, values)
    local running_result = coroutine.running()

    shake_2:BindToRenderStep(
        shake.NextRenderName(),
        utility.RENDER_PRIORITY + items_2.depth,
        function(delta_time, rot, done)
            local workspace_current_camera = workspace.CurrentCamera
            cframe = workspace_current_camera.CFrame
            local first_ancestor_of_class = argument:FindFirstAncestorOfClass("Attachment")
                or argument:FindFirstAncestorWhichIsA("BasePart")

            if first_ancestor_of_class then
                local transformed_origin_extents = utility.getTransformedOriginExtents(first_ancestor_of_class)
                local difference = 1
                    - math.clamp(
                        (
                            workspace_current_camera.CFrame.Position
                            - (
                                transformed_origin_extents and transformed_origin_extents.Position
                                or first_ancestor_of_class.Position
                            )
                        ).Magnitude / get_result_3,
                        0,
                        1
                    )
                delta_time = delta_time * difference
                rot = rot * difference
            end

            values.pos = delta_time
            values.rot = rot
            values.done = done

            if done then
                cframe = nil
                task.spawn(running_result)
            end
        end
    )

    shake_2:Start()

    if sustain then
        task.wait(get_result_2)
        shake_2:StopSustain()
    end

    if not values.done then
        coroutine.yield()
    end
end

return camera_shake
