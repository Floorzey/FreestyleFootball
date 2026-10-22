local utility = require("./utility")
local retime = {
    apply = function(argument: userdata, argument_2: number, argument_3: number)
        if argument:IsA("ParticleEmitter") then
            utility.scaleAttribute(argument, argument_3, "EmitDelay")
            utility.scaleAttribute(argument, argument_3, "EmitDuration")
            utility.scaleAttribute(argument, argument_3, "TimeScale_Duration")
            argument.Speed = NumberRange.new(argument.Speed.Min * argument_2, argument.Speed.Max * argument_2)
            argument.RotSpeed = NumberRange.new(argument.RotSpeed.Min * argument_2, argument.RotSpeed.Max * argument_2)
            argument.Lifetime = NumberRange.new(argument.Lifetime.Min / argument_2, argument.Lifetime.Max / argument_2)
            argument.Acceleration = argument.Acceleration * argument_2 ^ 2
            argument.Drag = argument.Drag * argument_2
            argument.Rate = argument.Rate * argument_2

            return
        end

        if argument:IsA("Beam") then
            utility.scaleAttribute(argument, argument_3, "EmitDelay")
            utility.scaleAttribute(argument, argument_3, "EmitDuration")
            utility.scaleAttribute(argument, argument_3, "EffectDuration")
            utility.scaleAttribute(argument, argument_3, "Speed_Duration")
            utility.scaleAttribute(argument, argument_3, "Duration")
            argument.TextureSpeed = argument.TextureSpeed * argument_2

            return
        end

        if argument:IsA("Trail") then
            argument.Lifetime = argument.Lifetime * argument_3

            return
        end

        if argument:IsA("Sound") then
            utility.scaleAttribute(argument, argument_3, "EmitDelay")
            utility.scaleAttribute(argument, argument_3, "EmitDuration")
            utility.scaleAttribute(argument, argument_3, "EmitInterval")
            utility.scaleAttribute(argument, argument_3, "RepeatInterval")
            utility.scaleAttribute(argument, argument_3, "FadeOutTime")
            utility.scaleAttribute(argument, argument_3, "Volume_Duration")
            utility.scaleAttribute(argument, argument_3, "Speed_Duration")
            utility.scaleAttribute(argument, argument_3, "RollOff_Duration")

            return
        end

        if argument:IsA("Model") then
            if not utility.isMeshVFX(argument) then
                utility.scaleAttribute(argument, argument_2, "SpinRotation")
                utility.scaleAttribute(argument, argument_3, "EmitDelay")
                utility.scaleAttribute(argument, argument_3, "ResetDelay")
                utility.scaleAttribute(argument, argument_3, "SpinDuration")
                utility.scaleAttribute(argument, argument_3, "Scale_Duration")
                utility.scaleAttribute(argument, argument_3, "SpinSpeed_Duration")

                return
            end

            utility.scaleAttribute(argument, argument_3, "EmitDelay")
            utility.scaleAttribute(argument, argument_3, "DestroyDelay")
            utility.scaleAttribute(argument, argument_3, "EmitDuration")
            utility.scaleAttribute(argument, argument_3, "EffectDuration")
            utility.scaleAttribute(argument, argument_3, "Speed_Duration")
            utility.scaleAttribute(argument, argument_3, "Duration")
            utility.scaleAttribute(argument, argument_2, "Rate")
            utility.scaleAttribute(argument, argument_2, "Part_RotSpeed_Start")
            utility.scaleAttribute(argument, argument_2, "Part_RotSpeed_End")

            return
        end

        if argument:IsA("Attachment") and argument:HasTag(utility.BEZIER_TAG) then
            utility.scaleAttribute(argument, argument_3, "EmitDelay")
            utility.scaleAttribute(argument, argument_3, "DestroyDelay")
            utility.scaleAttribute(argument, argument_3, "EmitDuration")
            utility.scaleAttribute(argument, argument_3, "Duration")
            utility.scaleAttribute(argument, argument_3, "Speed_Duration")
            utility.scaleAttribute(argument, argument_2, "ProjectileSpeed")
            utility.scaleAttribute(argument, argument_3, "ProjectileLifetime")
            utility.scaleAttribute(argument, argument_2, "Rate")
            utility.scaleAttribute(argument, argument_2, "Part_RotSpeed_Start")
            utility.scaleAttribute(argument, argument_2, "Part_RotSpeed_End")

            return
        end

        if not (argument:IsA("Attachment") and argument:HasTag(utility.LIGHTNING_TAG)) then
            if
                not (
                    argument:IsA("BasePart")
                    and (
                        argument.Parent
                        and utility.findFirstClassWithTag(argument.Parent, "Attachment", utility.SHOCKWAVE_TAG)
                    )
                )
            then
                if not (argument:IsA("RayValue") and argument:HasTag(utility.SCREENSHAKE_TAG)) then
                    if argument:IsA("RayValue") then
                        utility.scaleAttribute(argument, argument_3, "Duration")
                        utility.scaleAttribute(argument, argument_3, "Speed_Duration")
                        utility.scaleAttribute(argument, argument_3, "EmitDelay")
                    end

                    return
                end

                utility.scaleAttribute(argument, argument_3, "EmitDelay")
                utility.scaleAttribute(argument, argument_3, "EmitDuration")
                utility.scaleAttribute(argument, argument_3, "Scale_Duration")

                return
            end

            utility.scaleAttribute(argument, argument_3, "EmitDelay")
            utility.scaleAttribute(argument, argument_3, "Size_Duration")
            utility.scaleAttribute(argument, argument_3, "Transparency_Duration")
            utility.scaleAttribute(argument, argument_3, "Lifetime")
            utility.scaleAttribute(argument, argument_3, "Duration")
            utility.scaleAttribute(argument, argument_2, "Rate_Start")
            utility.scaleAttribute(argument, argument_2, "Rate_End")

            return
        end

        utility.scaleAttribute(argument, argument_3, "EmitDelay")
        utility.scaleAttribute(argument, argument_3, "DestroyDelay")
        utility.scaleAttribute(argument, argument_3, "EmitDuration")
        utility.scaleAttribute(argument, argument_3, "Duration")
        utility.scaleAttribute(argument, argument_3, "Speed_Duration")
        utility.scaleAttribute(argument, argument_3, "Color_Duration")
        utility.scaleAttribute(argument, argument_3, "Fill_Color_Duration")
        utility.scaleAttribute(argument, argument_3, "Fade_In_Duration")
        utility.scaleAttribute(argument, argument_3, "Fade_Out_Duration")
        utility.scaleAttribute(argument, argument_3, "Dissipate_Duration")
        utility.scaleAttribute(argument, argument_2, "ProjectileSpeed")
        utility.scaleAttribute(argument, argument_3, "ProjectileLifetime")
        utility.scaleAttribute(argument, argument_2, "Rate")
        utility.scaleAttribute(argument, argument_2, "RefreshRate")
    end,
}

function retime.batch(argument: number, ...)
    local quotient = 1 / argument

    for _, item in { ... } do
        retime.apply(item, argument, quotient)

        for _, descendant in item:GetDescendants() do
            retime.apply(descendant, argument, quotient)
        end
    end
end

return retime
