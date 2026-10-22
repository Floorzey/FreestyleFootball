local starter_gui = game:GetService("StarterGui")
local enabled = false
local camera_ui = {}

function camera_ui.setCameraModeToastEnabled(argument: boolean)
    if not (argument or enabled) then
        return
    end

    if not enabled then
        enabled = true
    end

    if not argument then
        camera_ui.setCameraModeToastOpen(false)
    end
end

function camera_ui.setCameraModeToastOpen(argument: boolean)
    assert(enabled)

    if argument then
        starter_gui:SetCore("SendNotification", {
            Title = "Camera Control Enabled",
            Text = "Right click to toggle",
            Duration = 3,
        })
    end
end

return camera_ui
