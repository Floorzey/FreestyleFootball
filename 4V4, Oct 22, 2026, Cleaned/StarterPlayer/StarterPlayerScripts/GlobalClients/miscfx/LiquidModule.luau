local liquid_module = {}

function handleWater(argument)
    local initialize_result =
        require(game.ReplicatedStorage.Modules.RaycastHitboxV3):Initialize(argument, { workspace.gameArea.Field })
    initialize_result:PartMode(true)

    initialize_result.OnHit:Connect(function(instance, argument_2, argument_3)
        if instance:IsDescendantOf(game.Workspace.FX) or instance.Parent:FindFirstChildOfClass("Humanoid") then
            return
        end

        if not (not (instance.Transparency > 0.5) or instance.Name == "CollisionBaseplate") then
            return
        end

        if not (instance.CanTouch ~= false and instance.CanCollide ~= false) then
            return
        end

        local position = argument_3.Position

        if not instance then
            return
        end

        local clone = game.ReplicatedStorage.VFX.RainDrop:Clone()
        clone.Parent = game.Workspace.FX
        clone.Position = position
        clone.MIDDLE.BLOOD02:Emit(1)
        clone.MIDDLE["WATER SPRAY"]:Emit(math.random(5, 10))
        game.Debris:AddItem(clone, 4)
        game.Debris:AddItem(argument, 0.05)

        return
    end)

    initialize_result:HitStart()

    task.delay(5, function()
        if initialize_result == nil or initialize_result.HitStop == nil then
            return
        end

        initialize_result:HitStop()
    end)
end

function liquid_module.newWater(position, argument)
    local clone = game.ReplicatedStorage.WaterDrop:Clone()
    clone.Position = position
    clone.Parent = workspace.FX
    clone.Anchored = true
    game.Debris:AddItem(clone, 15)
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)
    local tween_properties = {}
    tween_properties.Position = position + (argument.Unit * 90)
    tween_service:Create(clone, tween_info, tween_properties):Play()
    handleWater(clone)

    return clone
end

return liquid_module
