--[[
    Script Path: Game/ReplicatedStorage/Modules/RaycastHitboxV3/HitboxObject
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local _ = game:GetService("Players")
local CollectionService_upv_1 = game:GetService("CollectionService")
local Parent_1 = script.Parent
local CastAttachment_upv_1 = require(Parent_1.CastLogics.CastAttachment)
local CastVectorPoint_upv_1 = require(Parent_1.CastLogics.CastVectorPoint)
local CastLinkAttachment_upv_1 = require(Parent_1.CastLogics.CastLinkAttachment)
local Signal_upv_1 = require(Parent_1.Tools.Signal)
local tbl_1 = {}
local tbl_upv_2 = {}
tbl_upv_2.__index = tbl_upv_2
function tbl_upv_2.__tostring(a1)
    --[[
      name: __tostring
      line: 20
    ]]
    return string.format("Hitbox for instance %s [%s]", a1.object.Name, a1.object.ClassName)
end
function tbl_1.new(a1)
    --[[
      name: new
      line: 24
      upvalues:
        tbl_upv_2 (copy, index: 1)
    ]]
    return (setmetatable({}, tbl_upv_2))
end
function tbl_upv_2.config(a1, a2, a3)
    --[[
      name: config
      line: 28
      upvalues:
        Signal_upv_1 (copy, index: 1)
        CollectionService_upv_1 (copy, index: 2)
    ]]
    a1.active = false
    a1.deleted = false
    a1.partMode = false
    a1.debugMode = false
    a1.points = {}
    a1.targetsHit = {}
    a1.OnHit = Signal_upv_1:Create()
    a1.OnUpdate = Signal_upv_1:Create()
    a1.raycastParams = RaycastParams.new()
    a1.raycastParams.FilterType = Enum.RaycastFilterType.Include
    a1.raycastParams.FilterDescendantsInstances = a3 or {}
    a1.object = a2
    CollectionService_upv_1:AddTag(a1.object, "RaycastModuleManaged")
end
function tbl_upv_2.SetPoints(a1, a2, a3, a4)
    --[[
      name: SetPoints
      line: 45
      upvalues:
        CastVectorPoint_upv_1 (copy, index: 1)
    ]]
    if not a2 then
        return
    end
    if a2:IsA("BasePart") or a2:IsA("MeshPart") then
        for _, value_1 in ipairs(a3) do
            if typeof(value_1) == "Vector3" then
                table.insert(a1.points, {RelativePart = a2, Attachment = value_1, group = a4, solver = CastVectorPoint_upv_1})
            end
        end
    end
end
function tbl_upv_2.RemovePoints(a1, a2, a3)
    --[[
      name: RemovePoints
      line: 62
    ]]
    if not a2 then
        return
    end
    if a2:IsA("BasePart") or a2:IsA("MeshPart") then
        for n_1 = 1, #a1.points do
            local v1 = a1.points[n_1]
            for _, value_2 in ipairs(a3) do
                if typeof(v1.Attachment) ~= "Vector3" or v1.Attachment ~= value_2 then
                    continue
                end
                if v1.RelativePart == a2 then
                    a1.points[n_1] = nil
                end
            end
        end
    end
end
function tbl_upv_2.LinkAttachments(a1, a2, a3)
    --[[
      name: LinkAttachments
      line: 77
      upvalues:
        CastLinkAttachment_upv_1 (copy, index: 1)
    ]]
    if not a2:IsA("Attachment") then
        return
    end
    if a3:IsA("Attachment") then
        local Group_1 = a2:FindFirstChild("Group")
        local tbl_3 = {group = 0, solver = 0}
        tbl_3.Attachment = a2
        tbl_3.Attachment0 = a3
        tbl_3.group = Group_1 and (Group_1.Value)
        tbl_3.solver = CastLinkAttachment_upv_1
        table.insert(a1.points, tbl_3)
    end
end
function tbl_upv_2.UnlinkAttachments(a1, a2)
    --[[
      name: UnlinkAttachments
      line: 92
    ]]
    for key_1, value_3 in ipairs(a1.points) do
        if not (value_3.Attachment) or value_3.Attachment ~= a2 then
            continue
        end
        table.remove(a1.points, key_1)
        return
    end
end
function tbl_upv_2.seekAttachments(a1, a2, a3)
    --[[
      name: seekAttachments
      line: 101
      upvalues:
        CastAttachment_upv_1 (copy, index: 1)
    ]]
    if #a1.points <= 0 then
        table.insert(a1.raycastParams.FilterDescendantsInstances, workspace.Terrain)
    end
    for _, value_4 in ipairs(a1.object:GetDescendants()) do
        if not (value_4:IsA("Attachment")) then
            continue
        end
        if value_4.Name == a2 then
            local Group_2 = value_4:FindFirstChild("Group")
            local tbl_4 = {group = 0, solver = 0}
            tbl_4.Attachment = value_4
            tbl_4.group = Group_2 and (Group_2.Value)
            tbl_4.solver = CastAttachment_upv_1
            table.insert(a1.points, tbl_4)
        end
    end
    if not a3 then
        return
    end
    if #a1.points <= 0 then
        warn(string.format("\n[[RAYCAST WARNING]]\nNo attachments with the name '%s' were found in %s. No raycasts will be drawn. Can be ignored if you are using SetPoints.", a2, a1.object.Name))
    else
        print(string.format("\n[[RAYCAST MESSAGE]]\n\nCreated Hitbox for %s - Attachments found: %s", a1.object.Name, #a1.points))
    end
end
function tbl_upv_2.Destroy(a1)
    --[[
      name: Destroy
      line: 132
    ]]
    if a1.deleted then
        return
    end
    if a1.OnHit then
        a1.OnHit:Delete()
    end
    if a1.OnUpdate then
        a1.OnUpdate:Delete()
    end
    a1.points = nil
    a1.active = false
    a1.deleted = true
end
function tbl_upv_2.HitStart(a1)
    --[[
      name: HitStart
      line: 142
    ]]
    a1.active = true
end
function tbl_upv_2.HitStop(a1)
    --[[
      name: HitStop
      line: 146
    ]]
    if a1.deleted then
        return
    end
    a1.active = false
    table.clear(a1.targetsHit)
end
function tbl_upv_2.PartMode(a1, a2)
    --[[
      name: PartMode
      line: 153
    ]]
    a1.partMode = a2
end
function tbl_upv_2.DebugMode(a1, a2)
    --[[
      name: DebugMode
      line: 157
    ]]
    a1.debugMode = a2
end
return tbl_1