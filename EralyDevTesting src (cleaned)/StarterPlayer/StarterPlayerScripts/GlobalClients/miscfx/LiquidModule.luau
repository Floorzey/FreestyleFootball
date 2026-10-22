local liquid_module = {}

function handleWater(argument)
    local initialize_result =
        require(game.ReplicatedStorage.Modules.RaycastHitboxV3):Initialize(argument, { workspace.gameArea.Field })
    initialize_result:PartMode(true)

    initialize_result.OnHit:Connect(function(instance, argument_2, argument_3)
        if
            instance:IsDescendantOf(game.Workspace.FX)
            or (
                instance.Parent:FindFirstChildOfClass("Humanoid")
                or instance.Transparency > 0.5 and instance.Name ~= "CollisionBaseplate"
            )
        then
            return
        end

        if instance.CanTouch == false or instance.CanCollide == false then
            return
        end

        local position = argument_3.Position
        local _ = argument_3.Normal

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
    end)

    initialize_result:HitStart()

    task.delay(5, function()
        if initialize_result ~= nil and initialize_result.HitStop ~= nil then
            initialize_result:HitStop()
        end
    end)
end

function liquid_module.newWater(position: vector, argument: vector)
    local clone = game.ReplicatedStorage.WaterDrop:Clone()
    clone.Position = position
    clone.Parent = workspace.FX
    clone.Anchored = true
    game.Debris:AddItem(clone, 15)
    game:GetService("TweenService")
        :Create(clone, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {
            Position = position + argument.Unit * 90,
        })
        :Play()
    handleWater(clone)

    return clone
end

return liquid_module
