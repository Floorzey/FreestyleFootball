local collection_service = game:GetService("CollectionService")
local attributes = require("../attributes")
local shape = require("../shape")
local tween = require("../tween")
local utility = require("../utility")
local oklab = require("../color/Oklab")
local bezier_2 = require("../../obj/Bezier")
local bezier = {
    drawFuncMap = {
        Box = {
            Volume = shape.getPointWithinBox,
            Surface = shape.getPointOnBox,
        },
        Cylinder = {
            Volume = function(argument, argument_2, argument_3, argument_4, argument_5)
                return shape.getPointWithinCylinder(argument, 0, argument_5, argument_2, argument_3, argument_4)
            end,

            Surface = function(argument, argument_2, argument_3, argument_4, argument_5)
                return shape.getPointWithinCylinder(argument, 1, argument_5, argument_2, argument_3, argument_4)
            end,
        },
        Sphere = {
            Volume = function(argument, argument_2, argument_3, argument_4, argument_5)
                return shape.getPointWithinSphere(argument, 0, argument_5, argument_2, argument_3, argument_4)
            end,

            Surface = function(argument, argument_2, argument_3, argument_4, argument_5)
                return shape.getPointWithinSphere(argument, 1, argument_5, argument_2, argument_3, argument_4)
            end,
        },
        Disc = {
            Volume = function(argument, argument_2, argument_3, argument_4, argument_5)
                return shape.getPointWithinDisc(argument, 0, argument_5, argument_2, argument_3, argument_4)
            end,

            Surface = function(argument, argument_2, argument_3, argument_4, argument_5)
                return shape.getPointWithinDisc(argument, 1, argument_5, argument_2, argument_3, argument_4)
            end,
        },
    },

    getColorAtTime = function(argument: userdata, argument_2: number)
        local keypoints = argument.Keypoints

        if argument_2 <= keypoints[1].Time then
            return keypoints[1].Value
        end

        if keypoints[#keypoints].Time <= argument_2 then
            return keypoints[#keypoints].Value
        end

        local value = nil
        local value_2 = nil

        for index = 1, #keypoints do
            local keypoint_entry = keypoints[index]

            if keypoint_entry.Time == argument_2 then
                return keypoint_entry.Value
            end

            local index_2

            if keypoint_entry.Time < argument_2 then
                value = keypoint_entry
                index_2 = index
            else
                if argument_2 < keypoint_entry.Time then
                    value_2 = keypoint_entry
                    break
                end

                index_2 = index
            end
        end

        if value and value_2 then
            return value.Value:Lerp(value_2.Value, (argument_2 - value.Time) / (value_2.Time - value.Time))
        end

        return keypoints[1].Value
    end,

    getColorAtTimeOklab = function(argument: userdata, argument_2: number)
        local keypoints = argument.Keypoints

        if argument_2 <= keypoints[1].Time then
            return keypoints[1].Value
        end

        if keypoints[#keypoints].Time <= argument_2 then
            return keypoints[#keypoints].Value
        end

        local value = nil
        local value_2 = nil

        for index = 1, #keypoints do
            local keypoint_entry = keypoints[index]

            if keypoint_entry.Time == argument_2 then
                return keypoint_entry.Value
            end

            local index_2

            if keypoint_entry.Time < argument_2 then
                value = keypoint_entry
                index_2 = index
            else
                if argument_2 < keypoint_entry.Time then
                    value_2 = keypoint_entry
                    break
                end

                index_2 = index
            end
        end

        if not (value and value_2) then
            return keypoints[1].Value
        end

        local quotient = (argument_2 - value.Time) / (value_2.Time - value.Time)
        local interpolated_value = oklab.fromSRGB(value.Value):Lerp(oklab.fromSRGB(value_2.Value), quotient)

        return oklab.toSRGB(interpolated_value)
    end,
}

function bezier.getColorWithEasingOklab(argument: userdata, argument_2: number, argument_3: any)
    local difference = 1 - argument_3:getEase((math.clamp(argument_2, 0, 1))).y

    return bezier.getColorAtTimeOklab(argument, (math.clamp(difference, 0, 1)))
end

function bezier.createHitboxParams(argument: table, argument_2: userdata, first_ancestor_of_class: userdata?)
    local overlap_params = OverlapParams.new()
    overlap_params.MaxParts = 1
    overlap_params.FilterType = Enum.RaycastFilterType[argument.filterType]
    overlap_params.CollisionGroup = argument.collisionGroup
    overlap_params.RespectCanCollide = not argument.ignoreCanCollide
    overlap_params:AddToFilter(collection_service:GetTagged(argument.filterTag))

    if argument.filterType == "Exclude" then
        if first_ancestor_of_class then
            first_ancestor_of_class = first_ancestor_of_class:FindFirstAncestorOfClass("Part")
        end

        overlap_params:AddToFilter({ workspace.Terrain, argument_2, first_ancestor_of_class })
    end

    return overlap_params
end

function bezier.calculateEmissionCFrame(
    argument,
    argument_2: vector,
    argument_3: table,
    callback: ((...any) -> ...any)?,
    argument_4: userdata,
    argument_5: userdata?,
    argument_6: boolean
)
    local product

    if argument_6 then
        product = argument
            * CFrame.new(Vector3.new(0, 0, 0), Vector3.FromNormalId(argument_3.emissionDirection)).Rotation
    elseif callback then
        product = callback(nil, argument, argument_2, argument_3.emissionDirection, argument_3.partial)
    else
        product = argument
    end

    local from_normal_id_result = Vector3.FromNormalId(argument_3.emissionDirection)
    local cross_product = from_normal_id_result:Cross(argument.LookVector)

    if cross_product.Magnitude < 0.001 then
        cross_product = from_normal_id_result:Cross(argument.UpVector)
    end

    local c_frame_from_axis_angle = CFrame.fromAxisAngle
    local next_number_result = argument_4:NextNumber(-argument_3.spreadAngle.X, argument_3.spreadAngle.X)
    local result = c_frame_from_axis_angle(from_normal_id_result, (math.rad(next_number_result)))
    local c_frame_from_axis_angle2 = CFrame.fromAxisAngle
    local next_number_result_2 = argument_4:NextNumber(-argument_3.spreadAngle.Y, argument_3.spreadAngle.Y)
    local product_2 = product * (result * c_frame_from_axis_angle2(cross_product, (math.rad(next_number_result_2))))

    if argument_3.face == "Inward" or argument_3.face == "InAndOut" and argument_4:NextInteger(0, 1) == 1 then
        product_2 *= CFrame.fromOrientation(0, 3.141592653589793, 0)
    end

    if
        argument_5
        and (argument_3.mirror and (product_2.Position - argument_5.WorldPosition).Unit:Dot(product_2.RightVector) >= 0)
    then
        local product_3 = argument_3.mirrorRot * utility.DEG_TO_RAD
        product_2 *= CFrame.fromOrientation(product_3.X, product_3.Y, product_3.Z)
    end

    return product_2
end

function bezier.createBezierWithEndpoint(argument: table, argument_2, argument_3: userdata?, argument_4: userdata?)
    if not argument_3 then
        return bezier_2.new(argument)
    end

    local items = {}

    for key, item in argument do
        local world_position

        if key == #argument - 1 then
            world_position = argument_4 and argument_4.WorldPosition or argument_3.WorldPosition
        elseif key == #argument then
            world_position = argument_3.WorldPosition
        else
            world_position = argument_2 * (item - argument[1])
        end

        table.insert(items, world_position)
    end

    return bezier_2.new(items)
end

function bezier.createPosGetter(argument: any, argument_2: table, argument_3, argument_4: userdata?, enabled: boolean?)
    return function(argument_5: number)
        local get_position_result

        if enabled == false then
            get_position_result = argument:getPosition(argument_5)
        else
            get_position_result = argument:getPositionArcSpace(argument_5)
        end

        if argument_4 then
            return get_position_result
        end

        return argument_3 * (get_position_result - argument_2[1])
    end
end

function bezier.readCommonAttributes(argument: userdata)
    return {
        emitDelay = attributes.get(argument, "EmitDelay", 0),
        emitCount = attributes.get(argument, "EmitCount", 1),
        emitDuration = attributes.get(argument, "EmitDuration", 0),
        destroyDelay = attributes.get(argument, "DestroyDelay", 0),
        duration = attributes.getRange(argument, "Duration", NumberRange.new(1, 1), NumberRange.new(0, (1 / 0))),
        shapeType = attributes.getEnum(argument, "Shape", "Box", { "Box", "Cylinder", "Sphere", "Disc" }),
        shapeStyle = attributes.getEnum(argument, "ShapeStyle", "Volume", { "Volume", "Surface" }),
        emissionDirection = Enum.NormalId[attributes.getEnum(
            argument,
            "EmissionDirection",
            "Top",
            { "Top", "Bottom", "Left", "Right", "Front", "Back" }
        )],
        face = attributes.getEnum(argument, "ShapeFace", "Outward", { "InAndOut", "Inward", "Outward" }),
        spreadAngle = attributes.get(argument, "SpreadAngle", Vector3.new(0, 0, 0)),
        partial = attributes.get(argument, "ShapePartial", 1),
        syncPosition = attributes.get(argument, "SyncPosition", false),
        mirror = attributes.get(argument, "MirrorPaths", true),
        mirrorRot = attributes.get(argument, "MirrorRotation", Vector3.new(0, 0, 180)),
        projectileEnabled = attributes.get(argument, "ProjectileEnabled", false),
        projectileMatchEnd = attributes.get(argument, "MatchEndDirection", false),
        projectileSpeed = attributes.get(argument, "ProjectileSpeed", 30),
        projectileLifetime = attributes.getRange(
            argument,
            "ProjectileLifetime",
            NumberRange.new(1, 1),
            NumberRange.new(0, (1 / 0))
        ),
        hitboxEnabled = attributes.get(argument, "HitboxEnabled", false),
        hitboxCollisionGroup = attributes.get(argument, "HitboxCollisionGroup", "Default"),
        hitboxFilterTag = attributes.get(argument, "HitboxFilterTag", ""),
        hitboxFilterType = attributes.get(argument, "HitboxFilterType", "Exclude"),
        hitboxIgnoreCanCollide = attributes.get(argument, "HitboxIgnoreCanCollide", false),
        speedStart = attributes.get(argument, "Speed_Start", 1),
        speedEnd = attributes.get(argument, "Speed_End", 1),
    }
end

function bezier.getCurrentOriginCFrame(argument: userdata, argument_2)
    if argument:IsA("BasePart") then
        return argument.CFrame
    end

    if argument:IsA("Attachment") then
        return argument.WorldCFrame
    end

    return argument_2
end

function bezier.findEndAttachments(instance: userdata)
    local end_value = instance:FindFirstChild("End")
    local t1

    if end_value then
        t1 = end_value:FindFirstChild("T1")
    else
        t1 = end_value
    end

    if end_value and not end_value:IsA("Attachment") then
        end_value = nil
    end

    if t1 and not t1:IsA("Attachment") then
        t1 = nil
    end

    return end_value, t1
end

function bezier.validateParent(parent_2: userdata)
    local parent = parent_2.Parent

    if not parent then
        return nil
    end

    if parent:IsA("BasePart") then
        parent_2 = parent
    elseif parent:IsA("Attachment") then
        parent_2 = parent
    end

    return parent_2
end

function bezier.getPerpendicularVectors(argument: vector)
    local cross_product = argument:Cross(Vector3.new(0, 1, 0))

    if cross_product.Magnitude < 0.001 then
        cross_product = argument:Cross(Vector3.new(0, 0, 1))
    end

    local unit = cross_product.Unit

    return unit, argument:Cross(unit).Unit
end

function bezier.createPropertyTween(
    items: any,
    argument: userdata,
    argument_2: string,
    argument_3: number,
    argument_4: number,
    argument_5: number,
    callback: (...any) -> ...any,
    callback_2: (...any) -> ...any,
    argument_6: any
)
    if argument_4 == argument_5 then
        return
    end

    local from_params = tween.fromParams
    local get_result = attributes.get(argument, argument_2 .. "_Curve", utility.default_bezier)
    table.insert(
        items,
        from_params(get_result, argument_3, function(argument_7, argument_8)
            callback(utility.lerp(argument_4, argument_5, argument_7))

            return argument_8 * callback_2()
        end, argument_6)
    )
end

return bezier
