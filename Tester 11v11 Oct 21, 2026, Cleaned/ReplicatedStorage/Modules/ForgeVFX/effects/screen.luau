local run_service = game:GetService("RunService")
local attributes = require("../mod/attributes")
require("../types")
local utility = require("../mod/utility")

return {
    emit = function(argument: userdata, items: any)
        if not (argument:GetAttribute("Enabled")) then
            return
        end

        local get_result = attributes.get(argument, "PartScale", Vector3.new(1, 1, 1))
        local get_result_2 = attributes.get(argument, "PartDistance", 1.5)
        local get_result_3 = attributes.get(argument, "OffsetPosition", Vector3.new(0, 0, 0))
        local product = attributes.get(argument, "OffsetRotation", Vector3.new(0, 0, 0)) * utility.DEG_TO_RAD
        local c_frame2 = argument.CFrame
        local size = argument.Size
        local collision_group = argument.CollisionGroup
        argument.CollisionGroup = "ForgeMouseIgnore"

        table.insert(items, function()
            argument.Size = size
            argument.CFrame = c_frame2
            argument.CollisionGroup = collision_group == "" and "Default" or (collision_group or "Default")
        end)

        local function frame()
            local workspace_current_camera = workspace.CurrentCamera
            local radians = math.rad(workspace_current_camera.FieldOfView / 2)
            local product_2 = math.tan(radians) * get_result_2 * 2
            local product_3 = workspace_current_camera.ViewportSize.X
                / workspace_current_camera.ViewportSize.Y
                * product_2
            local product_4 = workspace_current_camera.CFrame * CFrame.new(0, 0, -get_result_2)
            argument.Size = Vector3.new(product_3, product_2, argument.Size.Z) * get_result
            argument.CFrame = product_4
                * CFrame.new(get_result_3)
                * CFrame.fromOrientation(product.x, product.y, product.z)
        end

        if run_service:IsRunning() then
            local random_id = utility.getRandomId()
            run_service:BindToRenderStep(random_id, Enum.RenderPriority.Last.Value + 2 + items.depth, frame)

            table.insert(items, function()
                run_service:UnbindFromRenderStep(random_id)
            end)
        else
            table.insert(items, run_service.RenderStepped:Connect(frame))
        end

        return true
    end,
}
