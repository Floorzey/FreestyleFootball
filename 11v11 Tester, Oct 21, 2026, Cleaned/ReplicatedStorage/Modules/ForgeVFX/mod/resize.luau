local utility = require("./utility")
local resize = {
    apply = function(instance: userdata, argument: number)
        if instance:IsA("ParticleEmitter") then
            instance.Size = utility.scaleNumberSequence(instance.Size, argument)
            instance.Speed = NumberRange.new(instance.Speed.Min * argument, instance.Speed.Max * argument)
            instance.Acceleration = instance.Acceleration * argument

            return
        end

        if not instance:IsA("Beam") then
            if instance:IsA("Trail") then
                utility.scaleAttachmentDistance(instance.Attachment0, instance.Attachment1, argument)

                return
            end

            if not instance:IsA("Sound") then
                if instance:IsA("Model") then
                    if not utility.isMeshVFX(instance) then
                        utility.scaleAttribute(instance, argument, "Scale_Start")
                        utility.scaleAttribute(instance, argument, "Scale_End")

                        return
                    end

                    local start = instance:FindFirstChild("Start")
                    local end_value = instance:FindFirstChild("End")

                    if start and end_value then
                        start.Size = start.Size * argument
                        end_value.Size = end_value.Size * argument
                        local special_mesh = start:FindFirstChildOfClass("SpecialMesh")
                        local special_mesh_2 = end_value:FindFirstChildOfClass("SpecialMesh")

                        if special_mesh and special_mesh_2 then
                            special_mesh.Scale = special_mesh.Scale * argument
                            special_mesh_2.Scale = special_mesh_2.Scale * argument

                            return
                        end
                    end
                else
                    if instance:IsA("Attachment") and instance:HasTag(utility.LIGHTNING_TAG) then
                        utility.scaleAttribute(instance, argument, "OffsetScale")
                        utility.scaleAttribute(instance, argument, "Width_Start")
                        utility.scaleAttribute(instance, argument, "Width_End")

                        return
                    end

                    if
                        instance:IsA("BasePart")
                        and (
                            instance.Parent
                            and utility.findFirstClassWithTag(instance.Parent, "Attachment", utility.SHOCKWAVE_TAG)
                        )
                    then
                        utility.scaleAttribute(instance, argument, "Radius")
                        utility.scaleAttribute(instance, argument, "Length")
                        utility.scaleAttribute(instance, argument, "MinSize")
                        utility.scaleAttribute(instance, argument, "MaxSize")

                        if instance:GetAttribute("LinearMagnitude") then
                            instance.Size = instance.Size * argument
                            utility.scaleAttribute(instance, argument, "LinearMagnitude")
                            utility.scaleAttribute(instance, argument, "AngularMagnitude")

                            return
                        end
                    elseif instance:IsA("RayValue") and instance:HasTag(utility.SCREENSHAKE_TAG) then
                        utility.scaleAttribute(instance, argument, "Falloff")
                    end
                end

                return
            end

            instance.RollOffMinDistance = instance.RollOffMinDistance * argument
            instance.RollOffMaxDistance = instance.RollOffMaxDistance * argument
            utility.scaleAttribute(instance, argument, "RollOff_Start")
            utility.scaleAttribute(instance, argument, "RollOff_End")

            return
        end

        utility.scaleAttribute(instance, argument, "Width0_Start")
        utility.scaleAttribute(instance, argument, "Width1_Start")
        utility.scaleAttribute(instance, argument, "Width0_End")
        utility.scaleAttribute(instance, argument, "Width1_End")
        utility.scaleAttribute(instance, argument, "CurveSize0_Start")
        utility.scaleAttribute(instance, argument, "CurveSize1_Start")
        utility.scaleAttribute(instance, argument, "CurveSize0_End")
        utility.scaleAttribute(instance, argument, "CurveSize1_End")
        utility.scaleAttribute(instance, argument, "Length_Scale_Start")
        utility.scaleAttribute(instance, argument, "Length_Scale_End")
        instance.Width0 = instance.Width0 * argument
        instance.Width1 = instance.Width1 * argument
        instance.CurveSize0 = instance.CurveSize0 * argument
        instance.CurveSize1 = instance.CurveSize1 * argument
        utility.scaleAttachmentDistance(instance.Attachment0, instance.Attachment1, argument)
    end,
}

function resize.batch(argument: number, ...)
    for _, item in { ... } do
        resize.apply(item, argument)

        for _, descendant in item:GetDescendants() do
            resize.apply(descendant, argument)
        end
    end
end

return resize
