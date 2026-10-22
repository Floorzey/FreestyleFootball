local starter_gui = game:GetService("StarterGui")
local enabled = false
local camera_ui = {}

function camera_ui.setCameraModeToastEnabled(self)
    if self or enabled then
        if not enabled then
            enabled = true
        end
        if not self then
            camera_ui.setCameraModeToastOpen(false)
        end
    end
end

function camera_ui.setCameraModeToastOpen(self)
    assert(enabled)
    if not self then
        return
    end
    starter_gui:SetCore(
        "SendNotification",
        { Text = "Right click to toggle", Title = "Camera Control Enabled", Duration = 3 }
    )
end

return camera_ui
