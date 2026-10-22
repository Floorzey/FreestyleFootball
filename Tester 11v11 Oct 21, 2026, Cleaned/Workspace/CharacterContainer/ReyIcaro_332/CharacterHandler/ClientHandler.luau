local local_player = game.Players.LocalPlayer
local character = local_player.Character or local_player.CharacterAdded:Wait()
character:WaitForChild("HumanoidRootPart", 9000000000)
local humanoid = character:WaitForChild("Humanoid", 9000000000)
humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
local control_module = require(local_player:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"))
local humanoid_root_part = character:WaitForChild("HumanoidRootPart")
local mouse = local_player:GetMouse()
local user_input_service = game:GetService("UserInputService")
game:GetService("RunService")

task.spawn(function()
    repeat
        character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    until character.Humanoid.DisplayDistanceType == Enum.HumanoidDisplayDistanceType.None
end)

local look_vector = character.HumanoidRootPart.CFrame.lookVector
local ball_instance = nil
local original_ball_name = nil

repeat
    task.wait()
until local_player:FindFirstChild("dataLoaded")

if game.ReplicatedStorage.MaxStaminaRejoin:FindFirstChild(local_player.UserId) then
    character.Stats.MaxStamina.Value = game.ReplicatedStorage.MaxStaminaRejoin:FindFirstChild(local_player.UserId).Value
end

local animator = character.Humanoid.Animator

repeat
    wait()
until local_player.Data.animationType.Value

local animation_set = game.ReplicatedStorage.AnimFolder:FindFirstChild(local_player.Data.animationType.Value)
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key_handler_service = knit.GetService("KeyHandlerService")
Kick = key_handler_service:GetKey("Kick")
ThrowIn = key_handler_service:GetKey("ThrowIn")
Bicycle = key_handler_service:GetKey("Bicycle")
BicycleHit = key_handler_service:GetKey("BicycleHit")
Header = key_handler_service:GetKey("Header")
SetCollisionGroup = key_handler_service:GetKey("SetCollisionGroup")
StandingTackle = key_handler_service:GetKey("StandingTackle")
TapInHit = key_handler_service:GetKey("TapInHit")
SoleDragHit = key_handler_service:GetKey("SoleDragHit")
PowerShot = key_handler_service:GetKey("PowerShot")
AirSideHit = key_handler_service:GetKey("AirSideHit")
GKDrop = key_handler_service:GetKey("GKDrop")
GKRelease = key_handler_service:GetKey("GKRelease")
SlideFX = key_handler_service:GetKey("SlideFX")
SlideTackleMiss = key_handler_service:GetKey("SlideTackleMiss")
SlideTackleHit = key_handler_service:GetKey("SlideTackleHit")
ShoveCheck = key_handler_service:GetKey("ShoveCheck")
StopBall_GroundBackup = key_handler_service:GetKey("StopBall_GroundBackup")
StopBall_Air = key_handler_service:GetKey("StopBall_Air")
DiveFX = key_handler_service:GetKey("DiveFX")
DiveEndlag = key_handler_service:GetKey("DiveEndlag")
DiveHit = key_handler_service:GetKey("DiveHit")
RequestRunR = key_handler_service:GetKey("RequestRun")
BodyBlock = key_handler_service:GetKey("BodyBlock")
UpdateStamina = key_handler_service:GetKey("UpdateStamina")
GKStandingGrab = key_handler_service:GetKey("GKStandingGrab")
KeyInput = key_handler_service:GetKey("KeyInput")
Reset = key_handler_service:GetKey("Reset")
AnimationReset = key_handler_service:GetKey("AnimationReset")
CancelAnims = key_handler_service:GetKey("CancelAnims")
NutmegSFX = key_handler_service:GetKey("NutmegSFX")
Stumble = key_handler_service:GetKey("Stumble")
MaxStaminaResetClient = key_handler_service:GetKey("MaxStaminaResetClient")
HalftimeClient = key_handler_service:GetKey("HalftimeClient")
BallTrailClient = key_handler_service:GetKey("BallTrailClient")
ClientVelocity = key_handler_service:GetKey("ClientVelocity")
ClientVelocityLock = key_handler_service:GetKey("ClientVelocityLock")
Blur = key_handler_service:GetKey("Blur")
Pushback = key_handler_service:GetKey("Pushback")
GetClientKickInfo = key_handler_service:GetKey("GetClientKickInfo")
local walk = Instance.new("StringValue")
local idle = Instance.new("StringValue")
local run = Instance.new("StringValue")
walk.Name = "walk"
idle.Name = "idle"
run.Name = "run"
local walk_animation = Instance.new("Animation")
local idle_animation = Instance.new("Animation")
local walk_animation_2 = Instance.new("Animation")
walk_animation.Parent = walk
walk_animation.AnimationId = animation_set.Walk.AnimationId
idle_animation.Parent = idle
idle_animation.AnimationId = animation_set.Idle.AnimationId
walk_animation_2.Parent = run
walk_animation_2.AnimationId = animation_set.Walk.AnimationId
walk.Parent = character:FindFirstChild("Animate")
idle.Parent = character:FindFirstChild("Animate")
run.Parent = character:FindFirstChild("Animate")
local run_track = animator:LoadAnimation(animation_set.Run)
run_track.Priority = Enum.AnimationPriority.Movement
local sprint_track = animator:LoadAnimation(animation_set.Sprint)
sprint_track.Priority = Enum.AnimationPriority.Movement
local dribble_left_track = animator:LoadAnimation(animation_set.DribbleLeft)
dribble_left_track.Priority = Enum.AnimationPriority.Movement
local dribble_right_track = animator:LoadAnimation(animation_set.DribbleRight)
dribble_right_track.Priority = Enum.AnimationPriority.Movement
anim_LeftDribble = animator:LoadAnimation(animation_set.LeftDribbleL)
anim_RightDribble = animator:LoadAnimation(animation_set.RightDribbleR)
anim_LeftDribbleTap = animator:LoadAnimation(animation_set.LeftDribbleTap)
anim_RightDribbleTap = animator:LoadAnimation(animation_set.RightDribbleTap)
local tap_left_track = animator:LoadAnimation(animation_set.TapLeft)
tap_left_track.Priority = Enum.AnimationPriority.Action
local tap_right_track = animator:LoadAnimation(animation_set.TapRight)
tap_right_track.Priority = Enum.AnimationPriority.Action
local kick_left_track = animator:LoadAnimation(animation_set.KickLeft)
local kick_right_track = animator:LoadAnimation(animation_set.KickRight)
local power_shot_left_track = animator:LoadAnimation(animation_set.PowerShotLeft)
local power_shot_right_track = animator:LoadAnimation(animation_set.PowerShotRight)
local power_shot_extra_l_track = animator:LoadAnimation(animation_set.PowerShotExtraL)
local power_shot_extra_r_track = animator:LoadAnimation(animation_set.PowerShotExtraR)
local power_shot_extra_ll_track = animator:LoadAnimation(animation_set.PowerShotExtraLL)
local power_shot_extra_rr_track = animator:LoadAnimation(animation_set.PowerShotExtraRR)
local volley_left_track = animator:LoadAnimation(animation_set.VolleyLeft)
local volley_right_track = animator:LoadAnimation(animation_set.VolleyRight)
local tap_in_low_left_track = animator:LoadAnimation(animation_set.TapIn_LowLeft)
local tap_in_low_right_track = animator:LoadAnimation(animation_set.TapIn_LowRight)
local tap_in_chip_left_track = animator:LoadAnimation(animation_set.TapIn_ChipLeft)
local tap_in_chip_right_track = animator:LoadAnimation(animation_set.TapIn_ChipRight)
local curve_shot_l_track = animator:LoadAnimation(animation_set.CurveShotL)
local curve_shot_r_track = animator:LoadAnimation(animation_set.CurveShotR)
local trivela_shot_l_track = animator:LoadAnimation(animation_set.TrivelaShotL)
local trivela_shot_r_track = animator:LoadAnimation(animation_set.TrivelaShotR)
local topspin_shot_l_track = animator:LoadAnimation(animation_set.TopspinShotL)
local topspin_shot_r_track = animator:LoadAnimation(animation_set.TopspinShotR)
local basic_shot_l_track = animator:LoadAnimation(animation_set.BasicShotL)
local basic_shot_r_track = animator:LoadAnimation(animation_set.BasicShotR)
local header_track = animator:LoadAnimation(animation_set.Header)
local bicycle1_track = animator:LoadAnimation(animation_set.Bicycle1)
local bicycle2_track = animator:LoadAnimation(animation_set.Bicycle2)
local scissor_l_track = animator:LoadAnimation(animation_set.ScissorL)
local scissor_r_track = animator:LoadAnimation(animation_set.ScissorR)
local gk_kick_track = animator:LoadAnimation(animation_set.GKKick)
local gk_side_volley_track = animator:LoadAnimation(animation_set.GKSideVolley)
local gk_throw_track = animator:LoadAnimation(animation_set.GKThrow)
gk_throw_track.Priority = Enum.AnimationPriority.Action2
local gk_ground_dive_left_track = animator:LoadAnimation(animation_set.GKGroundDiveLeft)
gk_ground_dive_left_track.Priority = Enum.AnimationPriority.Action2
local gk_ground_dive_right_track = animator:LoadAnimation(animation_set.GKGroundDiveRight)
gk_ground_dive_right_track.Priority = Enum.AnimationPriority.Action2
local gk_dive_forward_track = animator:LoadAnimation(animation_set.GKDiveForward)
gk_dive_forward_track.Priority = Enum.AnimationPriority.Action2
local gk_air_dive_left_track = animator:LoadAnimation(animation_set.GKAirDiveLeft)
gk_air_dive_left_track.Priority = Enum.AnimationPriority.Action2
local gk_air_dive_right_track = animator:LoadAnimation(animation_set.GKAirDiveRight)
gk_air_dive_right_track.Priority = Enum.AnimationPriority.Action2
local gk_dive_up_track = animator:LoadAnimation(animation_set.GKDiveUp)
gk_dive_up_track.Priority = Enum.AnimationPriority.Action2
local gksp_dive_l_track = animator:LoadAnimation(animation_set.GKSPDiveL)
gksp_dive_l_track.Priority = Enum.AnimationPriority.Action2
local gksp_dive_r_track = animator:LoadAnimation(animation_set.GKSPDiveR)
gksp_dive_r_track.Priority = Enum.AnimationPriority.Action2
local gksp_dive_tl_track = animator:LoadAnimation(animation_set.GKSPDiveTL)
gksp_dive_tl_track.Priority = Enum.AnimationPriority.Action2
local gksp_dive_tr_track = animator:LoadAnimation(animation_set.GKSPDiveTR)
gksp_dive_tr_track.Priority = Enum.AnimationPriority.Action2
local standing_catch_start_track = animator:LoadAnimation(animation_set.standingCatchStart)
local standing_catch_low_track = animator:LoadAnimation(animation_set.standingCatchLow)
local standing_catch_mid_track = animator:LoadAnimation(animation_set.standingCatchMid)
local standing_catch_high_track = animator:LoadAnimation(animation_set.standingCatchHigh)
local shove_l_track = animator:LoadAnimation(animation_set.ShoveL)
local shove_r_track = animator:LoadAnimation(animation_set.ShoveR)
local hold_back_l_track = animator:LoadAnimation(animation_set.HoldBackL)
local hold_back_r_track = animator:LoadAnimation(animation_set.HoldBackR)
local pushed_back1_track = animator:LoadAnimation(animation_set.PushedBack1)
local pushed_back2_track = animator:LoadAnimation(animation_set.PushedBack2)
local stumble_track = animator:LoadAnimation(animation_set.Stumble)
local stumble_b_track = animator:LoadAnimation(animation_set.StumbleB)
local stumble_longer_track = animator:LoadAnimation(animation_set.StumbleLonger)
local throw_in_track = animator:LoadAnimation(animation_set.ThrowIn)
local first_touch_left_track = animator:LoadAnimation(animation_set.firstTouchLeft)
local first_touch_right_track = animator:LoadAnimation(animation_set.firstTouchRight)
local ft_from_air_left_track = animator:LoadAnimation(animation_set.FT_FromAirLeft)
local ft_from_air_right_track = animator:LoadAnimation(animation_set.FT_FromAirRight)
local first_touch_running_left_track = animator:LoadAnimation(animation_set.firstTouch_RunningLeft)
local first_touch_running_right_track = animator:LoadAnimation(animation_set.firstTouch_RunningRight)
local first_touch_air_f_track = animator:LoadAnimation(animation_set.firstTouch_AirF)
local first_touch_air_b_track = animator:LoadAnimation(animation_set.firstTouch_AirB)
local first_touch_air_fl_track = animator:LoadAnimation(animation_set.firstTouch_airFL)
local first_touch_air_fr_track = animator:LoadAnimation(animation_set.firstTouch_airFR)
local first_touch_air_lf_track = animator:LoadAnimation(animation_set.firstTouch_airLF)
local first_touch_air_lb_track = animator:LoadAnimation(animation_set.firstTouch_airLB)
local first_touch_air_rf_track = animator:LoadAnimation(animation_set.firstTouch_airRF)
local first_touch_air_rb_track = animator:LoadAnimation(animation_set.firstTouch_airRB)
local first_touch_air_bl_track = animator:LoadAnimation(animation_set.firstTouch_airBL)
local first_touch_air_br_track = animator:LoadAnimation(animation_set.firstTouch_airBR)
local nutmeg_l_track = animator:LoadAnimation(animation_set.NutmegL)
local nutmeg_r_track = animator:LoadAnimation(animation_set.NutmegR)
local standing_tackle_l_track = animator:LoadAnimation(animation_set.StandingTackleL)
local standing_tackle_r_track = animator:LoadAnimation(animation_set.StandingTackleR)
local slide_tackle_l_track = animator:LoadAnimation(animation_set.SlideTackleL)
local slide_tackle_r_track = animator:LoadAnimation(animation_set.SlideTackleR)
local rough_tackle_track = animator:LoadAnimation(animation_set.RoughTackle)
local request_ball_track = animator:LoadAnimation(animation_set.RequestBall)
local testfeint_l_track = animator:LoadAnimation(animation_set.testfeintL)
local testfeint_r_track = animator:LoadAnimation(animation_set.testfeintR)

local function animationreset()
    print("reset animations")
    local first_child = game.ReplicatedStorage.AnimFolder:FindFirstChild(local_player.Data.animationType.Value)

    for _, child in ipairs(character.Animate:GetChildren()) do
        if child.Name == "walk" or (child.Name == "idle" or child.Name == "run") then
            child:Destroy()
        end
    end

    local walk_2 = Instance.new("StringValue")
    local idle_2 = Instance.new("StringValue")
    local run_2 = Instance.new("StringValue")
    walk_2.Name = "walk"
    idle_2.Name = "idle"
    run_2.Name = "run"
    local walk_animation_3 = Instance.new("Animation")
    local idle_animation_2 = Instance.new("Animation")
    local walk_animation_4 = Instance.new("Animation")
    walk_animation_3.Parent = walk_2
    walk_animation_3.AnimationId = first_child.Walk.AnimationId
    idle_animation_2.Parent = idle_2
    idle_animation_2.AnimationId = first_child.Idle.AnimationId
    walk_animation_4.Parent = run_2
    walk_animation_4.AnimationId = first_child.Walk.AnimationId
    walk_2.Parent = character:FindFirstChild("Animate")
    idle_2.Parent = character:FindFirstChild("Animate")
    run_2.Parent = character:FindFirstChild("Animate")
    run_track = animator:LoadAnimation(first_child.Run)
    run_track.Priority = Enum.AnimationPriority.Movement
    sprint_track = animator:LoadAnimation(first_child.Sprint)
    sprint_track.Priority = Enum.AnimationPriority.Movement
    dribble_left_track = animator:LoadAnimation(first_child.DribbleLeft)
    dribble_left_track.Priority = Enum.AnimationPriority.Movement
    dribble_right_track = animator:LoadAnimation(first_child.DribbleRight)
    dribble_right_track.Priority = Enum.AnimationPriority.Movement
    anim_LeftDribble = animator:LoadAnimation(first_child.LeftDribbleL)
    anim_RightDribble = animator:LoadAnimation(first_child.RightDribbleR)
    anim_LeftDribbleTap = animator:LoadAnimation(first_child.LeftDribbleTap)
    anim_RightDribbleTap = animator:LoadAnimation(first_child.RightDribbleTap)
    tap_left_track = animator:LoadAnimation(first_child.TapLeft)
    tap_left_track.Priority = Enum.AnimationPriority.Action
    tap_right_track = animator:LoadAnimation(first_child.TapRight)
    tap_right_track.Priority = Enum.AnimationPriority.Action
    kick_left_track = animator:LoadAnimation(first_child.KickLeft)
    kick_right_track = animator:LoadAnimation(first_child.KickRight)
    power_shot_left_track = animator:LoadAnimation(first_child.PowerShotLeft)
    power_shot_right_track = animator:LoadAnimation(first_child.PowerShotRight)
    power_shot_extra_l_track = animator:LoadAnimation(first_child.PowerShotExtraL)
    power_shot_extra_r_track = animator:LoadAnimation(first_child.PowerShotExtraR)
    power_shot_extra_ll_track = animator:LoadAnimation(first_child.PowerShotExtraLL)
    power_shot_extra_rr_track = animator:LoadAnimation(first_child.PowerShotExtraRR)
    volley_left_track = animator:LoadAnimation(first_child.VolleyLeft)
    volley_right_track = animator:LoadAnimation(first_child.VolleyRight)
    tap_in_low_left_track = animator:LoadAnimation(first_child.TapIn_LowLeft)
    tap_in_low_right_track = animator:LoadAnimation(first_child.TapIn_LowRight)
    tap_in_chip_left_track = animator:LoadAnimation(first_child.TapIn_ChipLeft)
    tap_in_chip_right_track = animator:LoadAnimation(first_child.TapIn_ChipRight)
    curve_shot_l_track = animator:LoadAnimation(first_child.CurveShotL)
    curve_shot_r_track = animator:LoadAnimation(first_child.CurveShotR)
    trivela_shot_l_track = animator:LoadAnimation(first_child.TrivelaShotL)
    trivela_shot_r_track = animator:LoadAnimation(first_child.TrivelaShotR)
    topspin_shot_l_track = animator:LoadAnimation(first_child.TopspinShotL)
    topspin_shot_r_track = animator:LoadAnimation(first_child.TopspinShotR)
    basic_shot_l_track = animator:LoadAnimation(first_child.BasicShotL)
    basic_shot_r_track = animator:LoadAnimation(first_child.BasicShotR)
    header_track = animator:LoadAnimation(first_child.Header)
    bicycle1_track = animator:LoadAnimation(first_child.Bicycle1)
    bicycle2_track = animator:LoadAnimation(first_child.Bicycle2)
    scissor_l_track = animator:LoadAnimation(first_child.ScissorL)
    scissor_r_track = animator:LoadAnimation(first_child.ScissorR)
    gk_kick_track = animator:LoadAnimation(first_child.GKKick)
    gk_side_volley_track = animator:LoadAnimation(first_child.GKSideVolley)
    gk_throw_track = animator:LoadAnimation(first_child.GKThrow)
    gk_throw_track.Priority = Enum.AnimationPriority.Action2
    gk_ground_dive_left_track = animator:LoadAnimation(first_child.GKGroundDiveLeft)
    gk_ground_dive_left_track.Priority = Enum.AnimationPriority.Action2
    gk_ground_dive_right_track = animator:LoadAnimation(first_child.GKGroundDiveRight)
    gk_ground_dive_right_track.Priority = Enum.AnimationPriority.Action2
    gk_dive_forward_track = animator:LoadAnimation(first_child.GKDiveForward)
    gk_dive_forward_track.Priority = Enum.AnimationPriority.Action2
    gk_air_dive_left_track = animator:LoadAnimation(first_child.GKAirDiveLeft)
    gk_air_dive_left_track.Priority = Enum.AnimationPriority.Action2
    gk_air_dive_right_track = animator:LoadAnimation(first_child.GKAirDiveRight)
    gk_air_dive_right_track.Priority = Enum.AnimationPriority.Action2
    gk_dive_up_track = animator:LoadAnimation(first_child.GKDiveUp)
    gk_dive_up_track.Priority = Enum.AnimationPriority.Action2
    gksp_dive_l_track = animator:LoadAnimation(first_child.GKSPDiveL)
    gksp_dive_l_track.Priority = Enum.AnimationPriority.Action2
    gksp_dive_r_track = animator:LoadAnimation(first_child.GKSPDiveR)
    gksp_dive_r_track.Priority = Enum.AnimationPriority.Action2
    gksp_dive_tl_track = animator:LoadAnimation(first_child.GKSPDiveTL)
    gksp_dive_tl_track.Priority = Enum.AnimationPriority.Action2
    gksp_dive_tr_track = animator:LoadAnimation(first_child.GKSPDiveTR)
    gksp_dive_tr_track.Priority = Enum.AnimationPriority.Action2
    standing_catch_start_track = animator:LoadAnimation(first_child.standingCatchStart)
    standing_catch_low_track = animator:LoadAnimation(first_child.standingCatchLow)
    standing_catch_mid_track = animator:LoadAnimation(first_child.standingCatchMid)
    standing_catch_high_track = animator:LoadAnimation(first_child.standingCatchHigh)
    shove_l_track = animator:LoadAnimation(first_child.ShoveL)
    shove_r_track = animator:LoadAnimation(first_child.ShoveR)
    hold_back_l_track = animator:LoadAnimation(first_child.HoldBackL)
    hold_back_r_track = animator:LoadAnimation(first_child.HoldBackR)
    pushed_back1_track = animator:LoadAnimation(first_child.PushedBack1)
    pushed_back2_track = animator:LoadAnimation(first_child.PushedBack2)
    stumble_track = animator:LoadAnimation(first_child.Stumble)
    stumble_b_track = animator:LoadAnimation(first_child.StumbleB)
    stumble_longer_track = animator:LoadAnimation(first_child.StumbleLonger)
    throw_in_track = animator:LoadAnimation(first_child.ThrowIn)
    first_touch_left_track = animator:LoadAnimation(first_child.firstTouchLeft)
    first_touch_right_track = animator:LoadAnimation(first_child.firstTouchRight)
    ft_from_air_left_track = animator:LoadAnimation(first_child.FT_FromAirLeft)
    ft_from_air_right_track = animator:LoadAnimation(first_child.FT_FromAirRight)
    first_touch_running_left_track = animator:LoadAnimation(first_child.firstTouch_RunningLeft)
    first_touch_running_right_track = animator:LoadAnimation(first_child.firstTouch_RunningRight)
    first_touch_air_f_track = animator:LoadAnimation(first_child.firstTouch_AirF)
    first_touch_air_b_track = animator:LoadAnimation(first_child.firstTouch_AirB)
    first_touch_air_fl_track = animator:LoadAnimation(first_child.firstTouch_airFL)
    first_touch_air_fr_track = animator:LoadAnimation(first_child.firstTouch_airFR)
    first_touch_air_lf_track = animator:LoadAnimation(first_child.firstTouch_airLF)
    first_touch_air_lb_track = animator:LoadAnimation(first_child.firstTouch_airLB)
    first_touch_air_rf_track = animator:LoadAnimation(first_child.firstTouch_airRF)
    first_touch_air_rb_track = animator:LoadAnimation(first_child.firstTouch_airRB)
    first_touch_air_bl_track = animator:LoadAnimation(first_child.firstTouch_airBL)
    first_touch_air_br_track = animator:LoadAnimation(first_child.firstTouch_airBR)
    nutmeg_l_track = animator:LoadAnimation(first_child.NutmegL)
    nutmeg_r_track = animator:LoadAnimation(first_child.NutmegR)
    standing_tackle_l_track = animator:LoadAnimation(first_child.StandingTackleL)
    standing_tackle_r_track = animator:LoadAnimation(first_child.StandingTackleR)
    slide_tackle_l_track = animator:LoadAnimation(first_child.SlideTackleL)
    slide_tackle_r_track = animator:LoadAnimation(first_child.SlideTackleR)
    rough_tackle_track = animator:LoadAnimation(first_child.RoughTackle)
    request_ball_track = animator:LoadAnimation(first_child.RequestBall)
    testfeint_l_track = animator:LoadAnimation(first_child.testfeintL)
    testfeint_r_track = animator:LoadAnimation(first_child.testfeintR)
end

animationreset()
game:GetService("ReplicatedStorage")
AnimationReset.OnClientEvent:Connect(animationreset)
game:GetService("StarterGui")
local hitbox_handler = require(game.ReplicatedStorage.Modules.HitboxHandler)
local hitbox_handler_players = require(game.ReplicatedStorage.Modules.HitboxHandlerPlayers)
local charge_gui = humanoid_root_part:WaitForChild("UIAttach"):WaitForChild("ChargeGUI")
local status = character:WaitForChild("Status")
local charge = 0
local number = 0
local charge_2 = 0
local enabled_11 = false
local number_2 = 0
local number_3 = 0
local number_4 = 0
local enabled = false
local enabled_12 = false
local timestamp = tick()
local ball_status = game.Workspace.ballStatus
local controls = local_player.Settings.Controls
local enabled_2 = false

CancelAnims.OnClientEvent:Connect(function()
    for _, item in pairs(animator:GetPlayingAnimationTracks()) do
        if item.Priority ~= Enum.AnimationPriority.Core then
            item:Stop()
        end
    end
end)

UpdateStamina.OnClientEvent:Connect(function(argument)
    local stamina = character.Stats.Stamina
    stamina.Value = stamina.Value - argument
end)

NutmegSFX.OnClientEvent:Connect(function()
    local clone = game.ReplicatedStorage.SFX.Boom:Clone()
    clone.Parent = game.Workspace
    clone:Play()
    game.Debris:AddItem(clone, 10)
end)

local enabled_3 = false

Stumble.OnClientEvent:Connect(function(argument, argument_2)
    local text = argument_2 or "F"

    if text ~= "F" then
        if text == "B" then
            if status:FindFirstChild("SlideTackleAnim") then
                return
            end

            if enabled_3 == true then
                return
            end

            enabled_3 = true

            task.delay(4, function()
                enabled_3 = false
            end)

            local number_7 = argument == nil and 0.7 or argument
            stumble_b_track:Play(0.2, 1, 0.7 / number_7)
            number = number * (1 - number_7 / 2)
            local knockdown = Instance.new("Folder")
            knockdown.Parent = status
            knockdown.Name = "Knockdown"
            game.Debris:AddItem(knockdown, number_7 - 0.05)
            local no_charge = Instance.new("Folder")
            no_charge.Parent = status
            no_charge.Name = "NoCharge"
            game.Debris:AddItem(no_charge, number_7 - 0.05)
            local camera_locked = Instance.new("Folder")
            camera_locked.Parent = status
            camera_locked.Name = "CameraLocked"
            game.Debris:AddItem(camera_locked, number_7 - 0.05)
            local character_2 = game.Players.LocalPlayer.Character

            for _, child in pairs(character_2.HumanoidRootPart:GetChildren()) do
                if child:IsA("BodyVelocity") then
                    child:Destroy()
                end
            end

            local _, value_3, _ =
                CFrame.lookAt(humanoid_root_part.Position, humanoid_root_part.CFrame * CFrame.new(0, 0, -40).Position)
                    :ToOrientation()
            local c_frame2 = character_2.HumanoidRootPart.CFrame
            local body_velocity = Instance.new("BodyVelocity")
            body_velocity.MaxForce = Vector3.new(50000, 0, 50000)
            body_velocity.Velocity = character_2.HumanoidRootPart.CFrame.lookVector * -40
            body_velocity.Parent = character_2.HumanoidRootPart
            game.Debris:AddItem(body_velocity, number_7)
            local connection = game:GetService("RunService").RenderStepped:Connect(function()
                humanoid_root_part.CFrame = CFrame.new(humanoid_root_part.Position) * CFrame.Angles(0, value_3, 0)
            end)

            task.delay(number_7, function()
                connection:Disconnect()
            end)

            game:GetService("TweenService")
                :Create(body_velocity, TweenInfo.new(number_7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Velocity = c_frame2.lookVector * 8,
                })
                :Play()
        end

        return
    end

    if status:FindFirstChild("SlideTackleAnim") then
        return
    end

    if enabled_3 == true then
        return
    end

    enabled_3 = true

    task.delay(4, function()
        enabled_3 = false
    end)

    local number_8 = argument == nil and 0.7 or argument
    stumble_track:Play(0.2, 1, 0.7 / number_8)
    number = number * (1 - number_8 / 2)
    local knockdown_2 = Instance.new("Folder")
    knockdown_2.Parent = status
    knockdown_2.Name = "Knockdown"
    game.Debris:AddItem(knockdown_2, number_8 - 0.05)
    local no_charge_2 = Instance.new("Folder")
    no_charge_2.Parent = status
    no_charge_2.Name = "NoCharge"
    game.Debris:AddItem(no_charge_2, number_8 - 0.05)
    local camera_locked_2 = Instance.new("Folder")
    camera_locked_2.Parent = status
    camera_locked_2.Name = "CameraLocked"
    game.Debris:AddItem(camera_locked_2, number_8 - 0.05)
    local character_3 = game.Players.LocalPlayer.Character

    for _, child_2 in pairs(character_3.HumanoidRootPart:GetChildren()) do
        if child_2:IsA("BodyVelocity") then
            child_2:Destroy()
        end
    end

    local _, value_4, _ =
        CFrame.lookAt(humanoid_root_part.Position, humanoid_root_part.CFrame * CFrame.new(0, 0, -25).Position)
            :ToOrientation()
    local c_frame2_2 = character_3.HumanoidRootPart.CFrame
    local body_velocity_2 = Instance.new("BodyVelocity")
    body_velocity_2.MaxForce = Vector3.new(50000, 0, 50000)
    body_velocity_2.Velocity = character_3.HumanoidRootPart.CFrame.lookVector * 25
    body_velocity_2.Parent = character_3.HumanoidRootPart
    game.Debris:AddItem(body_velocity_2, number_8)
    local connection_2 = game:GetService("RunService").RenderStepped:Connect(function()
        humanoid_root_part.CFrame = CFrame.new(humanoid_root_part.Position) * CFrame.Angles(0, value_4, 0)
    end)

    task.delay(number_8, function()
        connection_2:Disconnect()
    end)

    game:GetService("TweenService")
        :Create(body_velocity_2, TweenInfo.new(number_8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Velocity = c_frame2_2.lookVector * 8,
        })
        :Play()
end)

function isLookPartInFront(argument, argument_2, argument_3)
    return math.pow((argument.CFrame.LookVector - (argument_2.CFrame.p - argument.CFrame.p).Unit).Magnitude / 2, 2)
        < argument_3 / 360
end

function kick(enabled_16)
    if
        game.ReplicatedStorage:FindFirstChild("ActivePenalty")
        or (game.ReplicatedStorage:FindFirstChild("Shootout") or game.ReplicatedStorage:FindFirstChild("FinalShootout"))
    then
        return
    end

    if status:FindFirstChild("TakingPen") then
        return
    end

    if status:FindFirstChild("NoKickFrame") then
        return
    end

    if status:FindFirstChild("SlideTackleAnim") then
        return
    end

    if ball_status:FindFirstChild("NoDribble") then
        return
    end

    if status:FindFirstChild("KickCD") then
        return
    end

    if not local_player:FindFirstChild("InPlay") then
        return
    end

    if status:FindFirstChild("Knockdown") then
        return
    end

    if game.ReplicatedStorage:FindFirstChild("gameStarting") then
        return
    end

    if game.ReplicatedStorage:FindFirstChild("EndScreen") then
        return
    end

    if game.ReplicatedStorage:FindFirstChild("KickDisable") then
        return
    end

    if status:FindFirstChild("TakingPen") then
        return
    end

    local charge_3 = enabled_16 == true and charge_2 or charge

    if charge_3 > 50 and status:FindFirstChild("ShotLowered") then
        charge_3 = charge_3 * 0.5
    end

    if status:FindFirstChild("SlideTackleActive") then
        charge_3 = charge_3 * 0.65
    end

    local charge_4 = status:FindFirstChild("JustUsedSkill") and charge_3 > 50 and 50 or charge_3

    if charge_4 == 0 then
        return
    end

    if status:FindFirstChild("ThrowIn") then
        throw_in_track:Play(0)
        reset_charge()
        task.wait(0.2)
        local product = Vector3.new(
            character.HumanoidRootPart.CFrame.lookVector.X,
            workspace.CurrentCamera.CFrame.lookVector.Y,
            character.HumanoidRootPart.CFrame.lookVector.Z
        ) * (20 + charge_4 * 0.7)

        if product.Y > 50 then
            product = Vector3.new(product.X, 50, product.Z)
        elseif product.Y < 10 then
            product = Vector3.new(product.X, 10, product.Z)
        end

        ThrowIn:FireServer(product)

        return
    end

    local enabled_17 = status:FindFirstChild("spaceCheck") ~= nil

    if enabled_17 == true and (charge_4 < 50 and ball_status.lastKicked.Value ~= local_player) then
        warn("ChestBumpAttempt")
        firstTouch()

        return
    end

    if charge_4 > 25 then
        if enabled_16 == true then
            if enabled_17 == true then
                reset_charge()
                local product_2 = charge_4 * 2.25
                local sum = -character.HumanoidRootPart.CFrame.lookVector
                        * (20 + (product_2 > 120 and 120 or product_2) * 1.15)
                    + Vector3.new(0, -20, 0);
                (math.random(1, 2) == 1 and bicycle1_track or bicycle2_track):Play(0)
                Bicycle:FireServer()

                task.spawn(function()
                    local enabled_22 = false
                    local connection_2 = game:GetService("RunService").RenderStepped:Connect(function()
                        local tween_2 = hitbox_handler.Create({
                            size = Vector3.new(5, 4.5, 6),
                            cframe = character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 1),
                        })

                        if tween_2 and enabled_22 == false then
                            enabled_22 = true
                            BicycleHit:FireServer(sum, tween_2)
                        end
                    end)

                    task.delay(0.2, function()
                        connection_2:Disconnect()
                    end)
                end)

                return
            end
        elseif enabled_16 == false and enabled_17 == true then
            reset_charge()

            task.spawn(function()
                header_track:Play(0, 1)
                local number_value = Instance.new("NumberValue")
                number_value.Name = "SpeedBoost"
                number_value.Parent = status
                number_value.Value = -6
                game.Debris:AddItem(number_value, 0.5)
                local enabled_22 = false
                local connection_2 = game:GetService("RunService").RenderStepped:Connect(function()
                    local tween_2 = hitbox_handler.Create({
                        size = Vector3.new(5, 4, 5),
                        cframe = character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 1),
                    })

                    if not (tween_2 and enabled_22 == false) then
                        return
                    end

                    enabled_22 = true
                    Random.new()
                    local product_5 = Vector3.new(
                        character.HumanoidRootPart.CFrame.lookVector.X,
                        workspace.CurrentCamera.CFrame.lookVector.Y,
                        character.HumanoidRootPart.CFrame.lookVector.Z
                    ) * 120
                    local vector_3

                    if product_5.Y >= 50 then
                        vector_3 = Vector3.new(product_5.X * 0.6, 50, product_5.Z * 0.6)
                    elseif product_5.Y >= 40 then
                        vector_3 = Vector3.new(product_5.X * 0.75, product_5.Y, product_5.Z * 0.75)
                    elseif product_5.Y >= 30 then
                        vector_3 = Vector3.new(product_5.X * 0.9, product_5.Y, product_5.Z * 0.9)
                    elseif product_5.Y >= 20 then
                        vector_3 = Vector3.new(product_5.X * 1, product_5.Y, product_5.Z * 1)
                    elseif product_5.Y < -55 then
                        vector_3 = Vector3.new(product_5.X * 1.05, -55, product_5.Z * 1.05)
                    else
                        vector_3 = Vector3.new(product_5.X * 1.05, product_5.Y, product_5.Z * 1.05)
                    end

                    local product_6 = character.HumanoidRootPart.CFrame.rightVector * math.random(-12, 12)
                    local random_value = math.random(-12, 12)
                    local sum_2 = vector_3 + (product_6 + Vector3.new(0, random_value, 0))
                    Header:FireServer(sum_2, tween_2)
                end)

                task.delay(0.3, function()
                    connection_2:Disconnect()
                end)
            end)

            return
        end
    end

    local enabled_18 = false

    if
        ball_status.lastKicked.Value ~= nil
        and (
            ball_status.lastKicked.Value ~= local_player
            and (
                ball_status.lastKicked.Value.SelectedTeam.Value ~= local_player.SelectedTeam.Value
                and (game.Workspace.Temp:FindFirstChild("Ball") and not status:FindFirstChild("SlideTackleAnim"))
            )
        )
    then
        local character_2 = ball_status.lastKicked.Value.Character
        local ball = game.Workspace.Temp.Ball

        if
            (character_2.HumanoidRootPart.Position - ball.Position).Magnitude < 9
            and (
                (character.HumanoidRootPart.Position - ball.Position).Magnitude < 6
                and isLookPartInFront(character.HumanoidRootPart, character_2.HumanoidRootPart, 180)
            )
        then
            local text = character.HumanoidRootPart.CFrame.RightVector:Dot(
                (character.HumanoidRootPart.Position * Vector3.new(1, 0, 1) - ball.Position * Vector3.new(1, 0, 1)).Unit
            ) > 0 and "Left" or "Right"
            local dot_product = character.HumanoidRootPart.CFrame.LookVector:Dot(
                (character.HumanoidRootPart.Position * Vector3.new(1, 0, 1) - ball.Position * Vector3.new(1, 0, 1)).Unit
            )
            print(dot_product)
            SetCollisionGroup:FireServer(0.5, "NoCharCollide")
            local negated_value = text == "Left" and -8 or 8
            (text == "Left" and standing_tackle_l_track or standing_tackle_r_track):Play(0.1, 1, 1)
            local character2 = game.Players.LocalPlayer.Character

            for _, child in pairs(character2.HumanoidRootPart:GetChildren()) do
                if child:IsA("BodyVelocity") then
                    child:Destroy()
                end
            end

            local _, value_3, _ = character2.HumanoidRootPart.CFrame:ToOrientation()
            local c_frame2 = character2.HumanoidRootPart.CFrame
            local body_velocity = Instance.new("BodyVelocity")
            body_velocity.MaxForce = Vector3.new(50000, 0, 50000)
            body_velocity.Velocity = character2.HumanoidRootPart.CFrame.lookVector * 16
                + character2.HumanoidRootPart.CFrame.rightVector * negated_value
            body_velocity.Parent = character2.HumanoidRootPart
            game.Debris:AddItem(body_velocity, 0.225)
            local connection = game:GetService("RunService").RenderStepped:Connect(function()
                body_velocity.Velocity = c_frame2.lookVector * 16 + c_frame2.rightVector * negated_value
                humanoid_root_part.CFrame = CFrame.new(humanoid_root_part.Position) * CFrame.Angles(0, value_3, 0)
            end)
            local camera_locked = Instance.new("Folder")
            camera_locked.Name = "CameraLocked"
            camera_locked.Parent = character2.Status
            game.Debris:AddItem(camera_locked, 0.25)
            local knockdown = Instance.new("Folder")
            knockdown.Name = "Knockdown"
            knockdown.Parent = character2.Status
            game.Debris:AddItem(knockdown, 0.25)
            local kick_cd = Instance.new("Folder")
            kick_cd.Name = "KickCD"
            kick_cd.Parent = character2.Status
            game.Debris:AddItem(kick_cd, 0.6)
            reset_charge()

            task.delay(0.225, function()
                connection:Disconnect()
            end)

            local charge_5 = charge_4 > 90 and 90 or (charge_4 < 35 and 35 or charge_4)

            task.spawn(function()
                for index_3 = 1, 9 do
                    local product_5 = enabled_16 == true and character.HumanoidRootPart.CFrame.lookVector * 19
                        or character.HumanoidRootPart.CFrame.lookVector * (12 + charge_5)
                            + Vector3.new(0, 10 + charge_5 * 0.5, 0)

                    if enabled_16 == true then
                        product_5 = character.HumanoidRootPart.CFrame.lookVector * (15 + charge_5 * 1.525)
                    elseif charge_5 > 50 then
                        local product_6 = Vector3.new(
                            character.HumanoidRootPart.CFrame.lookVector.X,
                            game.Workspace.CurrentCamera.CFrame.LookVector.Y * 1,
                            character.HumanoidRootPart.CFrame.lookVector.Z
                        ) * (75 + charge_5 * 0.35)

                        if product_6.Y > 82 then
                            product_6 = Vector3.new(product_6.X, 82, product_6.Z)
                        elseif product_6.Y < 35 then
                            product_6 = Vector3.new(product_6.X, 40, product_6.Z)
                        end

                        if product_6.Y >= 72.5 then
                            product_5 = Vector3.new(product_6.X * 0.75, product_6.Y, product_6.Z * 0.75)
                        elseif product_6.Y >= 60 then
                            product_5 = Vector3.new(product_6.X * 0.825, product_6.Y, product_6.Z * 0.825)
                        elseif product_6.Y >= 47.5 then
                            product_5 = Vector3.new(product_6.X * 0.925, product_6.Y, product_6.Z * 0.925)
                        else
                            product_5 = Vector3.new(product_6.X * 1.05, product_6.Y, product_6.Z * 1.05)
                        end
                    end

                    local cframe_2 = CFrame.new(0, -3, 0)
                    local tween_2 = hitbox_handler.Create({
                        size = Vector3.new(6.5, 6.5, 6.5),
                        isSphere = true,
                        cframe = character.HumanoidRootPart.CFrame * cframe_2,
                    })

                    if tween_2 then
                        if kick_cd ~= nil then
                            kick_cd:Destroy()
                        end

                        StandingTackle:FireServer(
                            tween_2,
                            enabled_16,
                            charge_5,
                            product_5,
                            character.HumanoidRootPart.CFrame,
                            tween_2.Position
                        )
                    end

                    game:GetService("RunService").Heartbeat:Wait()
                    local _ = index_3
                end
            end)

            return
        end
    end

    reset_charge()
    local items = {}

    for _, input in pairs(user_input_service:GetKeysPressed()) do
        table.insert(items, input.KeyCode)
    end

    local _ = enabled_16 == true
    local vector_2 = enabled_16 == true
            and character.HumanoidRootPart.CFrame.lookVector * (enabled == true and 17 or 13)
        or character.HumanoidRootPart.CFrame.lookVector * (12 + charge_4 * 0.85)
            + Vector3.new(0, 11 + charge_4 * 0.4, 0)

    if charge_4 < 25 then
        vector_2 = character.HumanoidRootPart.CFrame.lookVector * (enabled == true and 17 or 13)

        if controlledSprinting and number > 10.5 then
            enabled_16 = true
            charge_4 = 33
        end
    end

    local enabled_15 = enabled_16 == false and charge_4 < 25 and true or enabled_16
    local enabled_20 = false
    local enabled_19 = false

    if charge_4 < 80 and ball_status.lastKicked.Value ~= local_player then
        task.spawn(function()
            firstTouch(true, charge_4, enabled_15)
        end)
    end

    task.spawn(function()
        if ball_status.lastKicked.Value == local_player then
            return
        end

        local kick_cd_3 = Instance.new("Folder")
        kick_cd_3.Name = "KickCD"
        kick_cd_3.Parent = character.Status
        game.Debris:AddItem(kick_cd_3, 0.3)
    end)

    for index = 1, status:FindFirstChild("spaceCheck") == nil and (enabled == true and 9 or 6) or 9 do
        local cframe = CFrame.new(0, -1.5, 0)
        local vector

        if status:FindFirstChild("volleyHitbox") then
            enabled_17 = true
            vector = Vector3.new(6.5, 7, 7.5)
        else
            vector = Vector3.new(5.75, 6, 7.25)
        end

        if enabled_15 == true and charge_4 >= 90 then
            enabled_17 = true
            vector = Vector3.new(6.5, 7, 7.5)
        end

        if
            charge_4 >= 25
            and (
                ball_status.lastKicked.Value ~= nil
                and (
                    ball_status.lastKicked.Value.SelectedTeam.Value == local_player.SelectedTeam.Value
                    and ball_status.lastKicked.Value.SelectedTeam.Value ~= local_player
                )
            )
        then
            enabled_17 = true
            vector = Vector3.new(6.5, 6, 7.5)
        end

        if enabled_18 == true then
            cframe = CFrame.new(0, -1.5, -1.5)
            vector = Vector3.new(6.5, 5.5, 6.5)
        end

        local tween = hitbox_handler.Create({
            cframe = character.HumanoidRootPart.CFrame * cframe,
            size = ball_status.lastKicked.Value == local_player and Vector3.new(7.25, 6, 7.25) or vector,
        })
        local index_2

        if tween and enabled_19 == false then
            if enabled_17 == false and ball_status.inAir.Value == true then
                warn("Ball has inAir == true")

                return
            end

            local text_2 = character.HumanoidRootPart.CFrame.RightVector:Dot(
                (character.HumanoidRootPart.Position * Vector3.new(1, 0, 1) - tween.Position * Vector3.new(1, 0, 1)).Unit
            ) > 0 and "Left" or "Right"

            if
                charge_4 < 80
                and (
                    ball_status.lastKicked.Value ~= local_player
                    and firstTouchBackup(tween, charge_4, enabled_15) ~= nil
                )
            then
                print("firstTouchCheck")

                return
            end

            index_2 = index

            for _, child_2 in pairs(ball_status:GetChildren()) do
                if child_2.Name == "JustSlideTackled" and child_2.Value ~= local_player then
                    warn("Ball has SlideTackleIFrame")

                    return
                end

                if child_2.Name == "IFrame" and child_2.Value ~= local_player then
                    warn("Ball has IFrames")

                    return
                end

                if child_2.Name == "TapFrames" and (child_2.Value ~= local_player and enabled_18 == false) then
                    return
                end
            end

            enabled_19 = true

            if charge_4 > 25 then
                local no_skill = Instance.new("Folder")
                no_skill.Name = "NoSkill"
                no_skill.Parent = status
                game.Debris:AddItem(no_skill, 0.2)
            end

            for _, child_3 in pairs(ball_status:GetChildren()) do
                if child_3.Name == "JustChipped" and (child_3.Value == local_player and charge_4 < 50) then
                    enabled_15 = true
                end
            end

            if enabled_15 == true then
                if charge_4 > 90 then
                    local just_shot = Instance.new("Folder")
                    just_shot.Name = "JustShot"
                    just_shot.Parent = status
                    game.Debris:AddItem(just_shot, 0.5)
                    enabled_15 = false
                    enabled_20 = true
                    local product_3 = Vector3.new(
                        character.HumanoidRootPart.CFrame.lookVector.X,
                        workspace.CurrentCamera.CFrame.lookVector.Y,
                        character.HumanoidRootPart.CFrame.lookVector.Z
                    ) * (charge_4 * 1.45)

                    if product_3.Y > 50 then
                        product_3 = Vector3.new(product_3.X, 50, product_3.Z)
                    elseif product_3.Y < 0 then
                        product_3 = Vector3.new(product_3.X, 0, product_3.Z)
                    end

                    if product_3.Y >= 50 then
                        vector_2 = Vector3.new(product_3.X * 0.75, product_3.Y, product_3.Z * 0.75)
                    elseif product_3.Y >= 40 then
                        vector_2 = Vector3.new(product_3.X * 0.825, product_3.Y, product_3.Z * 0.825)
                    elseif product_3.Y >= 30 then
                        vector_2 = Vector3.new(product_3.X * 0.875, product_3.Y, product_3.Z * 0.875)
                    elseif product_3.Y >= 20 then
                        vector_2 = Vector3.new(product_3.X * 0.95, product_3.Y, product_3.Z * 0.95)
                    else
                        vector_2 = Vector3.new(product_3.X * 1.05, product_3.Y, product_3.Z * 1.05)
                    end

                    if not local_player:GetAttribute("Freecam") then
                        game:GetService("TweenService")
                            :Create(
                                game.Lighting.Blur,
                                TweenInfo.new(0.125, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                {
                                    Size = 20,
                                }
                            )
                            :Play()

                        task.delay(0.125, function()
                            game:GetService("TweenService")
                                :Create(
                                    game.Lighting.Blur,
                                    TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                    {
                                        Size = 2,
                                    }
                                )
                                :Play()
                        end)
                    end

                    if ball_status.inAir.Value == true or ball_status:FindFirstChild("JustBounced") then
                        (text_2 == "Left" and volley_right_track or volley_left_track):Play(0, 1)
                    else
                        (text_2 == "Left" and power_shot_left_track or power_shot_right_track):Play(0, 1)
                    end
                elseif charge_4 > 60 then
                    vector_2 = character.HumanoidRootPart.CFrame.lookVector * (25 + charge_4 * 1.625)
                    local enabled_21

                    if
                        (ball_status.inAir.Value == true or ball_status:FindFirstChild("JustBounced"))
                        and (enabled_17 == true and not ball_status:FindFirstChild("NoTapInFrames"))
                    then
                        (text_2 == "Left" and tap_in_low_left_track or tap_in_low_right_track):Play(0, 1)
                        enabled_21 = true
                    else
                        enabled_21 = false
                    end

                    if not (status:FindFirstChild("SlideTackleAnim") or (enabled_18 or enabled_21)) then
                        (text_2 == "Left" and kick_left_track or kick_right_track):Play(0, 1)
                    end
                elseif charge_4 > 45 then
                    vector_2 = character.HumanoidRootPart.CFrame.lookVector * (20 + charge_4 * 1.55)

                    if
                        (ball_status.inAir.Value == true or ball_status:FindFirstChild("JustBounced"))
                        and (enabled_17 == true and not ball_status:FindFirstChild("NoTapInFrames"))
                    then
                        if
                            ball_status.lastKicked.Value == local_player
                            and humanoid.FloorMaterial == Enum.Material.Air
                        then
                            print("tap in");
                            (text_2 == "Left" and tap_in_low_left_track or tap_in_low_right_track):Play(0, 1)
                            TapInHit:FireServer(tween, enabled_15, charge_4, vector_2, text_2)

                            return
                        end

                        if ball_status.lastKicked.Value ~= local_player then
                            print("tap in");
                            (text_2 == "Left" and tap_in_low_left_track or tap_in_low_right_track):Play(0, 1)
                            TapInHit:FireServer(tween, enabled_15, charge_4, vector_2, text_2)

                            return
                        end
                    end

                    if controlledSprinting then
                        vector_2 = vector_2
                            + CFrame.new(
                                    character.HumanoidRootPart.Position,
                                    character.HumanoidRootPart.Position + vector_2
                                ).RightVector
                                * math.random(-3, 3)
                    end

                    if not (status:FindFirstChild("SlideTackleAnim") or enabled_18) then
                        (text_2 == "Left" and kick_left_track or kick_right_track):Play(0, 1)
                    end
                elseif charge_4 > 25 then
                    vector_2 = character.HumanoidRootPart.CFrame.lookVector * (15 + charge_4 * 1.225)

                    if
                        (ball_status.inAir.Value == true or ball_status:FindFirstChild("JustBounced"))
                        and (enabled_17 == true and not ball_status:FindFirstChild("NoTapInFrames"))
                    then
                        if
                            ball_status.lastKicked.Value == local_player
                            and humanoid.FloorMaterial == Enum.Material.Air
                        then
                            print("tap in");
                            (text_2 == "Left" and tap_in_low_left_track or tap_in_low_right_track):Play(0, 1)
                            TapInHit:FireServer(tween, enabled_15, charge_4, vector_2, text_2)

                            return
                        end

                        if ball_status.lastKicked.Value ~= local_player then
                            print("tap in");
                            (text_2 == "Left" and tap_in_low_left_track or tap_in_low_right_track):Play(0, 1)
                            TapInHit:FireServer(tween, enabled_15, charge_4, vector_2, text_2)

                            return
                        end
                    end

                    if controlledSprinting then
                        vector_2 = vector_2
                            + CFrame.new(
                                    character.HumanoidRootPart.Position,
                                    character.HumanoidRootPart.Position + vector_2
                                ).RightVector
                                * math.random(-3, 3)
                    end

                    if not (status:FindFirstChild("SlideTackleAnim") or enabled_18) then
                        (text_2 == "Left" and kick_left_track or kick_right_track):Play(0, 1)
                    end
                elseif not (status:FindFirstChild("SlideTackleAnim") or enabled_18) then
                    if enabled == true then
                        run_track.TimePosition = text_2 == "Left" and 0.467 or 0.15
                        (text_2 == "Left" and dribble_left_track or dribble_right_track):Play()
                    else
                        (text_2 == "Left" and tap_left_track or tap_right_track):Play(0, 1)
                    end
                end

                vector_2 = CFrame.new(
                    tween.Position,
                    character.HumanoidRootPart.Position - Vector3.new(0, 2, 0) + vector_2
                ).lookVector * vector_2.Magnitude
                Kick:FireServer(
                    vector_2,
                    tween,
                    enabled_15,
                    enabled_20,
                    charge_4,
                    text_2,
                    character.HumanoidRootPart.CFrame,
                    items,
                    enabled_18,
                    false
                )
            elseif enabled_15 == false then
                if status:FindFirstChild("spaceCheck") ~= nil then
                    return
                end

                if charge_4 > 50 then
                    local product_4 = Vector3.new(
                        character.HumanoidRootPart.CFrame.lookVector.X,
                        workspace.CurrentCamera.CFrame.lookVector.Y * 1,
                        character.HumanoidRootPart.CFrame.lookVector.Z
                    ) * (65 + charge_4 * 0.5)

                    if product_4.Y > 82 then
                        product_4 = Vector3.new(product_4.X, 82, product_4.Z)
                    elseif product_4.Y < 30 then
                        product_4 = Vector3.new(product_4.X, 30, product_4.Z)
                    end

                    if product_4.Y >= 72.5 then
                        vector_2 = Vector3.new(product_4.X * 0.725, product_4.Y, product_4.Z * 0.725)
                    elseif product_4.Y >= 60 then
                        vector_2 = Vector3.new(product_4.X * 0.8, product_4.Y, product_4.Z * 0.8)
                    elseif product_4.Y >= 47.5 then
                        vector_2 = Vector3.new(product_4.X * 0.9, product_4.Y, product_4.Z * 0.9)
                    else
                        vector_2 = Vector3.new(product_4.X * 1, product_4.Y, product_4.Z * 1)
                    end

                    if not (status:FindFirstChild("SlideTackleAnim") or enabled_18) then
                        local value_4 = nil

                        if controls.SpinToggle.Value == false then
                            for _, item in pairs(items) do
                                if item == Enum.KeyCode[controls.CurveLeft.Value] then
                                    value_4 = "Left"
                                    break
                                end

                                if item == Enum.KeyCode[controls.CurveRight.Value] then
                                    value_4 = "Right"
                                    break
                                end

                                if item == Enum.KeyCode[controls.Topspin.Value] then
                                    value_4 = "Top"
                                    break
                                end
                            end
                        else
                            value_4 = character.Stats.SelectedCurve.Value ~= "" and character.Stats.SelectedCurve.Value
                                or nil

                            if value_4 == "Left" then
                                items = { Enum.KeyCode[controls.CurveLeft.Value] }
                            elseif value_4 == "Right" then
                                items = { Enum.KeyCode[controls.CurveRight.Value] }
                            elseif value_4 == "Top" then
                                items = { Enum.KeyCode[controls.Topspin.Value] }
                            end
                        end

                        if
                            user_input_service.GamepadEnabled
                            or user_input_service:GetLastInputType() == Enum.UserInputType.Touch
                        then
                            if number_4 == 2 then
                                items = { Enum.KeyCode[controls.CurveLeft.Value] }
                                value_4 = "Left"
                            elseif number_4 == 3 then
                                items = { Enum.KeyCode[controls.CurveRight.Value] }
                                value_4 = "Right"
                            elseif number_4 == 1 then
                                items = { Enum.KeyCode[controls.Topspin.Value] }
                                value_4 = "Top"
                            end
                        end

                        if value_4 == nil then
                            (text_2 == "Left" and basic_shot_l_track or basic_shot_r_track):Play(0, 1)
                            vector_2 = Vector3.new(vector_2.X * 1.15, vector_2.Y, vector_2.Z * 1.15)
                        elseif value_4 == "Left" then
                            (text_2 == "Left" and trivela_shot_l_track or curve_shot_r_track):Play(0, 1)
                        elseif value_4 == "Right" then
                            (text_2 == "Right" and trivela_shot_r_track or curve_shot_l_track):Play(0, 1)
                        elseif value_4 == "Top" then
                            (text_2 == "Left" and topspin_shot_l_track or topspin_shot_r_track):Play(0, 1)
                        end
                    end

                    local _ = character.HumanoidRootPart.CFrame.lookVector
                    local _ = vector_2 * Vector3.new(1, 0.2, 1)
                    local just_shot_2 = Instance.new("Folder")
                    just_shot_2.Name = "JustShot"
                    just_shot_2.Parent = status
                    game.Debris:AddItem(just_shot_2, 0.5)
                else
                    if
                        (ball_status.inAir.Value == true or ball_status:FindFirstChild("JustBounced"))
                        and (enabled_17 == true and not ball_status:FindFirstChild("NoTapInFrames"))
                    then
                        if
                            ball_status.lastKicked.Value == local_player
                            and humanoid.FloorMaterial == Enum.Material.Air
                        then
                            print("tap in");
                            (text_2 == "Left" and tap_in_chip_left_track or tap_in_chip_right_track):Play(0, 1)
                            TapInHit:FireServer(tween, enabled_15, charge_4, vector_2, text_2)

                            return
                        end

                        if ball_status.lastKicked.Value ~= local_player then
                            print("tap in");
                            (text_2 == "Left" and tap_in_chip_left_track or tap_in_chip_right_track):Play(0, 1)
                            TapInHit:FireServer(tween, enabled_15, charge_4, vector_2, text_2)

                            return
                        end
                    end

                    if not (status:FindFirstChild("SlideTackleAnim") or enabled_18) then
                        (text_2 == "Left" and kick_left_track or kick_right_track):Play(0, 1)
                    end
                end

                vector_2 = CFrame.new(
                    tween.Position,
                    character.HumanoidRootPart.Position - Vector3.new(0, 2, 0) + vector_2
                ).lookVector * vector_2.Magnitude
                Kick:FireServer(
                    vector_2,
                    tween,
                    enabled_15,
                    enabled_20,
                    charge_4,
                    text_2,
                    character.HumanoidRootPart.CFrame,
                    items,
                    enabled_18,
                    false
                )
            end
        else
            index_2 = index
        end

        game:GetService("RunService").RenderStepped:Wait()
    end

    if not (enabled_19 == false and local_player.Name ~= "kaitoudono") then
        return
    end

    print("Missed, Kick going on CD")
    local number_7 = ball_status.lastKicked.Value == local_player and 0.1 or 0.6
    local kick_cd_2 = Instance.new("Folder")
    kick_cd_2.Name = "KickCD"
    kick_cd_2.Parent = character.Status
    game.Debris:AddItem(kick_cd_2, number_7)
end

function soledrag()
    if
        game.ReplicatedStorage:FindFirstChild("ActivePenalty")
        or (game.ReplicatedStorage:FindFirstChild("Shootout") or game.ReplicatedStorage:FindFirstChild("FinalShootout"))
    then
        return
    end

    if status:FindFirstChild("KickCD") then
        return
    end

    if status:FindFirstChild("NoKickFrame") then
        return
    end

    if not local_player:FindFirstChild("InPlay") then
        return
    end

    if status:FindFirstChild("Knockdown") then
        return
    end

    if status:FindFirstChild("TakingPen") then
        return
    end

    if status:FindFirstChild("OverchargeActive") then
        return
    end

    if status:FindFirstChild("NoCharge") then
        return
    end

    if status:FindFirstChild("SlideTackleAnim") then
        return
    end

    if status:FindFirstChild("JustShot") then
        return
    end

    if game.ReplicatedStorage:FindFirstChild("gameStarting") then
        return
    end

    if game.ReplicatedStorage:FindFirstChild("EndScreen") then
        return
    end

    if ball_status.lastKicked.Value ~= local_player then
        return
    end

    local no_charge = Instance.new("Folder")
    no_charge.Name = "NoCharge"
    no_charge.Parent = character.Status
    game.Debris:AddItem(no_charge, 0.15)
    reset_charge()
    local enabled_15 = false

    for index = 1, 9 do
        if ball_status.inAir.Value == true or enabled_15 == true then
            break
        end

        local cframe = CFrame.new(0, -1.5, 0)
        local tween = hitbox_handler.Create({
            size = Vector3.new(6.5, 6, 6.5),
            cframe = character.HumanoidRootPart.CFrame * cframe,
        })
        local index_2

        if tween then
            index_2 = index
            local items = {}

            for _, input in pairs(user_input_service:GetKeysPressed()) do
                table.insert(items, input.KeyCode)
            end

            if user_input_service.GamepadEnabled or isMobile() then
                if number_4 == 2 then
                    items = { Enum.KeyCode.A }
                elseif number_4 == 3 then
                    items = { Enum.KeyCode.D }
                elseif number_4 == 1 then
                    items = { Enum.KeyCode.S }
                else
                    items = number_4 == 4 and { Enum.KeyCode.W } or items
                end
            end

            local text = character.HumanoidRootPart.CFrame.RightVector:Dot(
                (character.HumanoidRootPart.Position * Vector3.new(1, 0, 1) - tween.Position * Vector3.new(1, 0, 1)).Unit
            ) > 0 and "Left" or "Right"
            local soleroll_l_f_track = character.Humanoid.Animator:LoadAnimation(animation_set.solerollL_F)

            if items then
                local enabled_16 = false

                for _, item in pairs(items) do
                    if item == Enum.KeyCode.D then
                        if text == "Left" then
                            soleroll_l_f_track = character.Humanoid.Animator:LoadAnimation(animation_set.solerollL_R)
                        elseif text == "Right" then
                            soleroll_l_f_track = character.Humanoid.Animator:LoadAnimation(animation_set.solerollR_R)
                        end

                        enabled_16 = true
                        break
                    end

                    if item == Enum.KeyCode.A then
                        if text == "Left" then
                            soleroll_l_f_track = character.Humanoid.Animator:LoadAnimation(animation_set.solerollL_L)
                        elseif text == "Right" then
                            soleroll_l_f_track = character.Humanoid.Animator:LoadAnimation(animation_set.solerollR_L)
                        end

                        enabled_16 = true
                        break
                    end

                    if item == Enum.KeyCode.S then
                        if text == "Left" then
                            soleroll_l_f_track = character.Humanoid.Animator:LoadAnimation(animation_set.solerollL_B)
                        elseif text == "Right" then
                            soleroll_l_f_track = character.Humanoid.Animator:LoadAnimation(animation_set.solerollR_B)
                        end

                        enabled_16 = true
                        break
                    end
                end

                if enabled_16 == false then
                    if text == "Left" then
                        soleroll_l_f_track = character.Humanoid.Animator:LoadAnimation(animation_set.solerollL_F)
                    elseif text == "Right" then
                        soleroll_l_f_track = character.Humanoid.Animator:LoadAnimation(animation_set.solerollR_F)
                    end
                end
            end

            soleroll_l_f_track.Priority = Enum.AnimationPriority.Movement
            enabled_15 = true
            soleroll_l_f_track:Play()
            local calculate_raw_move_vector_result =
                control_module:calculateRawMoveVector(character.Humanoid, control_module:GetMoveVector())

            if calculate_raw_move_vector_result == Vector3.new(0, 0, 0) then
                calculate_raw_move_vector_result = character.HumanoidRootPart.CFrame.lookVector
            end

            local assembly_linear_velocity = character.HumanoidRootPart.AssemblyLinearVelocity

            if assembly_linear_velocity == Vector3.new(0, 0, 0) then
                assembly_linear_velocity = character.HumanoidRootPart.CFrame.lookVector
            end

            SoleDragHit:FireServer(calculate_raw_move_vector_result.Unit, tween, assembly_linear_velocity.Unit)
        else
            index_2 = index
        end

        game:GetService("RunService").Stepped:Wait()
    end

    if enabled_15 ~= false then
        return
    end

    local kick_cd = Instance.new("Folder")
    kick_cd.Name = "KickCD"
    kick_cd.Parent = character.Status
    game.Debris:AddItem(kick_cd, 0.3)
end

local timestamp_2 = tick()

function powerShotOvercharge(argument)
    if tick() - timestamp_2 < 2 then
        return
    end

    if status:FindFirstChild("JustUsedSkill") then
        return
    end

    if status:FindFirstChild("NoCharge") then
        return
    end

    if status:FindFirstChild("NoOverCharge") then
        return
    end

    if status:FindFirstChild("KickDisable") then
        return
    end

    local overcharge_timing = character.HumanoidRootPart:FindFirstChild("OverchargeTiming")

    if not overcharge_timing then
        return
    end

    local ball = game.Workspace.Temp:FindFirstChild("Ball")

    if not ball then
        return
    end

    timestamp_2 = tick()
    local text = character.HumanoidRootPart.CFrame.RightVector:Dot(
        (character.HumanoidRootPart.Position * Vector3.new(1, 0, 1) - ball.Position * Vector3.new(1, 0, 1)).Unit
    ) > 0 and "Left" or "Right"
    reset_charge()
    holdingm2 = false
    local character_2 = game.Players.LocalPlayer.Character
    local number_7 = 150

    for _, child in pairs(character_2.HumanoidRootPart:GetChildren()) do
        if child:IsA("BodyVelocity") then
            child:Destroy()
        end
    end

    local _ = character_2.HumanoidRootPart.CFrame
    local _, _, _ = character_2.HumanoidRootPart.CFrame:ToOrientation()
    local number_8 = 15

    task.spawn(function()
        for index_3 = 1, 12 do
            task.wait(0.03)
            number_8 = number_8 * 0.96
            local _ = index_3
        end
    end)

    local _, value_3, _ =
        CFrame.lookAt(humanoid_root_part.Position, humanoid_root_part.CFrame * CFrame.new(0, 0, -number_8).Position)
            :ToOrientation()
    local value_4 = value_3
    local unit = character_2.HumanoidRootPart.CFrame.lookVector.Unit
    local power_shot_extra_l_track_2 = text == "Left" and power_shot_extra_l_track or power_shot_extra_r_track

    if number_4 == 2 or user_input_service:IsKeyDown(Enum.KeyCode.A) then
        power_shot_extra_l_track_2 = power_shot_extra_ll_track
        unit = (character_2.HumanoidRootPart.CFrame * CFrame.fromEulerAnglesXYZ(0, 0.7853981633974483, 0)).lookVector
        text = "Left"
    elseif number_4 == 3 or user_input_service:IsKeyDown(Enum.KeyCode.D) then
        power_shot_extra_l_track_2 = power_shot_extra_rr_track
        unit = (character_2.HumanoidRootPart.CFrame * CFrame.fromEulerAnglesXYZ(0, -0.7853981633974483, 0)).lookVector
        text = "Right"
    end

    power_shot_extra_l_track_2.Priority = Enum.AnimationPriority.Action2
    power_shot_extra_l_track_2:Play()
    local _ = character_2.HumanoidRootPart.CFrame
    local body_velocity = Instance.new("BodyVelocity")
    body_velocity.MaxForce = Vector3.new(50000, 0, 50000)
    body_velocity.Velocity = unit * number_8
    body_velocity.Parent = character_2.HumanoidRootPart
    game.Debris:AddItem(body_velocity, 0.433)
    local connection = game:GetService("RunService").RenderStepped:Connect(function()
        body_velocity.Velocity = unit * number_8
        humanoid_root_part.CFrame = CFrame.new(humanoid_root_part.Position) * CFrame.Angles(0, value_4, 0)
    end)
    local camera_locked = Instance.new("Folder")
    camera_locked.Name = "CameraLocked"
    camera_locked.Parent = character_2.Status
    game.Debris:AddItem(camera_locked, 0.917)

    task.delay(0.433, function()
        connection:Disconnect()
    end)

    PowerShot:FireServer()
    local number_value = Instance.new("NumberValue")
    number_value.Name = "SpeedBoost"
    number_value.Parent = character_2.Status
    number_value.Value = 0
    game.Debris:AddItem(number_value, 0.917)
    local no_charge = Instance.new("Folder")
    no_charge.Name = "NoCharge"
    no_charge.Parent = character_2.Status
    game.Debris:AddItem(no_charge, 0.917)
    local overcharge_active = Instance.new("Folder")
    overcharge_active.Name = "OverchargeActive"
    overcharge_active.Parent = character_2.Status
    game.Debris:AddItem(overcharge_active, 1.2)
    local fov_override = Instance.new("Folder")
    fov_override.Name = "FOVOverride"
    fov_override.Parent = character_2.Status
    game.Debris:AddItem(fov_override, 0.917)
    SetCollisionGroup:FireServer(0.917, "NoCharCollide")
    local timing_bar = overcharge_timing.OverchargeUI.TimingBar

    if
        (game.Workspace.CurrentCamera.CameraSubject.Position - game.Workspace.CurrentCamera.CFrame.Position).Magnitude
        < 1
    then
        timing_bar = local_player.PlayerGui.FirstPersonChargeBar.TimingBar
    end

    if not game.Players.LocalPlayer:GetAttribute("Freecam") then
        game:GetService("TweenService")
            :Create(
                game.Workspace.CurrentCamera,
                TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                {
                    FieldOfView = 52,
                }
            )
            :Play()
        game:GetService("TweenService")
            :Create(number_value, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                Value = -18,
            })
            :Play()

        task.delay(0.45, function()
            game:GetService("TweenService")
                :Create(
                    game.Workspace.CurrentCamera,
                    TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                    {
                        FieldOfView = 70,
                    }
                )
                :Play()
        end)
    end

    timing_bar.Bar.Position = UDim2.new(0, 0, 0.5, 0)
    game:GetService("TweenService")
        :Create(timing_bar, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.5,
        })
        :Play()
    game:GetService("TweenService")
        :Create(timing_bar.Bar, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0,
        })
        :Play()
    game:GetService("TweenService")
        :Create(timing_bar.COLOR, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0,
        })
        :Play()
    local tween = game:GetService("TweenService")
        :Create(timing_bar.Bar, TweenInfo.new(0.725, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, 0, 0.5, 0),
        })
    tween:Play()
    local enabled_15 = false
    local connection_3 = nil
    connection_3 = user_input_service.InputEnded:Connect(function(input)
        if
            not (
                input.UserInputType == Enum.UserInputType.MouseButton2
                or (input.KeyCode == Enum.KeyCode.ButtonR1 or input.UserInputType == Enum.UserInputType.MouseButton1)
            )
        then
            return
        end

        if timing_bar.Bar.Position.X.Scale >= 0.45 and timing_bar.Bar.Position.X.Scale <= 0.55 then
            local clone = game.ReplicatedStorage.UISounds.ui_achieve:Clone()
            clone.Parent = game.Workspace
            clone:Play()
            game.Debris:AddItem(clone, 3)
            enabled_15 = true
            number_7 = 162.5
        else
            local clone_2 = game.ReplicatedStorage.UISounds["ui-error3"]:Clone()
            clone_2.Parent = game.Workspace
            clone_2:Play()
            game.Debris:AddItem(clone_2, 3)
        end

        connection_3:Disconnect()
        tween:Pause()
    end)

    game.ReplicatedStorage.MobileControlEvents.OverchargeCheck.Event:Once(function()
        if timing_bar.Bar.Position.X.Scale >= 0.45 and timing_bar.Bar.Position.X.Scale <= 0.55 then
            local clone = game.ReplicatedStorage.UISounds.ui_achieve:Clone()
            clone.Parent = game.Workspace
            clone:Play()
            game.Debris:AddItem(clone, 3)
            enabled_15 = true
            number_7 = 162.5
        else
            local clone_2 = game.ReplicatedStorage.UISounds["ui-error3"]:Clone()
            clone_2.Parent = game.Workspace
            clone_2:Play()
            game.Debris:AddItem(clone_2, 3)
        end

        connection_3:Disconnect()
        tween:Pause()
    end)

    task.delay(0.8, function()
        connection_3:Disconnect()
        tween:Cancel()
        game:GetService("TweenService")
            :Create(timing_bar, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1,
            })
            :Play()
        game:GetService("TweenService")
            :Create(timing_bar.Bar, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1,
            })
            :Play()
        game:GetService("TweenService")
            :Create(timing_bar.COLOR, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1,
            })
            :Play()
    end)

    local enabled_16 = false
    local connection_2 = status.ChildAdded:Connect(function(child_3)
        if child_3.Name == "Knockdown" or (child_3.Name == "JustUsedSkill" or child_3.Name == "KickDisable") then
            enabled_16 = true
            power_shot_extra_l_track_2:Stop()
        end
    end)
    task.wait(0.4)
    connection_2:Disconnect()

    if enabled_16 == true then
        return
    end

    local product = workspace.CurrentCamera.CFrame.lookVector * number_7

    if enabled_15 == false then
        local random_value = math.random(-3, 3)
        local random_value_2 = math.random(-3, 3)
        product = product + Vector3.new(random_value, random_value_2, math.random(-3, 3))
    end

    local dot_product = character.HumanoidRootPart.CFrame.LookVector:Dot(
        (character.HumanoidRootPart.CFrame.LookVector * Vector3.new(1, 0, 1) - product.Unit * Vector3.new(1, 0, 1)).Unit
    )

    if dot_product > 0.3 or dot_product < -0.3 then
        product = Vector3.new(
            character.HumanoidRootPart.CFrame.lookVector.X,
            workspace.CurrentCamera.CFrame.lookVector.Y,
            character.HumanoidRootPart.CFrame.lookVector.Z
        ) * number_7
    end

    if product.Y > 50 then
        product = Vector3.new(product.X, 50, product.Z)
    elseif product.Y < 0 then
        product = Vector3.new(product.X, 0, product.Z)
    end

    local vector

    if product.Y >= 50 then
        vector = Vector3.new(product.X * 0.75, product.Y, product.Z * 0.75)
    elseif product.Y >= 40 then
        vector = Vector3.new(product.X * 0.825, product.Y, product.Z * 0.825)
    elseif product.Y >= 30 then
        vector = Vector3.new(product.X * 0.875, product.Y, product.Z * 0.875)
    elseif product.Y >= 20 then
        vector = Vector3.new(product.X * 0.95, product.Y, product.Z * 0.95)
    else
        vector = Vector3.new(product.X * 1.05, product.Y, product.Z * 1.05)
    end

    if vector.Magnitude > 200 then
        vector = Vector3.new(
            character.HumanoidRootPart.CFrame.lookVector.X,
            workspace.CurrentCamera.CFrame.lookVector.Y,
            character.HumanoidRootPart.CFrame.lookVector.Z
        ) * number_7
    end

    body_velocity:Destroy()
    local body_velocity2 = Instance.new("BodyVelocity")
    body_velocity2.Velocity = Vector3.new(0, 12.5, 0)
        + vector.Unit * 30
        + character.HumanoidRootPart.CFrame.rightVector * (text == "Left" and 12 or -12)
    body_velocity2.MaxForce = Vector3.new(100000, 100000, 100000)
    body_velocity2.Parent = character.HumanoidRootPart
    game.Debris:AddItem(body_velocity2, 0.15)
    local enabled_17 = false

    for index = 1, 9 do
        if enabled_17 == true then
            break
        end

        local tween_2 = hitbox_handler.Create({
            size = Vector3.new(6.5, 5.5, 7.5),
            cframe = character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 0),
        })
        local index_2

        if tween_2 then
            local text_2 = character.HumanoidRootPart.CFrame.RightVector:Dot(
                (character.HumanoidRootPart.Position * Vector3.new(1, 0, 1) - tween_2.Position * Vector3.new(1, 0, 1)).Unit
            ) > 0 and "Left" or "Right"
            index_2 = index

            for _, child_2 in pairs(ball_status:GetChildren()) do
                if child_2.Name == "JustSlideTackled" and child_2.Value ~= local_player then
                    warn("Ball has SlideTackleIFrame")

                    return
                end

                if child_2.Name == "IFrame" and child_2.Value ~= local_player then
                    warn("Ball has IFrames")

                    return
                end
            end

            local just_shot = Instance.new("Folder")
            just_shot.Name = "JustShot"
            just_shot.Parent = status
            game.Debris:AddItem(just_shot, 0.5)
            vector = CFrame.new(tween_2.Position, character.HumanoidRootPart.Position - Vector3.new(0, 2, 0) + vector).lookVector
                * vector.Magnitude
            Kick:FireServer(vector, tween_2, false, true, number_7, text_2, character.HumanoidRootPart.CFrame)
            enabled_17 = true
        else
            index_2 = index
        end

        game:GetService("RunService").RenderStepped:Wait()
    end
end

function reset_charge()
    charge = 0
    charge_2 = 0
    number_2 = 0
    number_3 = 0
end

function sideKick(argument)
    if
        game.ReplicatedStorage:FindFirstChild("ActivePenalty")
        or (game.ReplicatedStorage:FindFirstChild("Shootout") or game.ReplicatedStorage:FindFirstChild("FinalShootout"))
    then
        return
    end

    if status:FindFirstChild("KickCD") then
        return
    end

    if status:FindFirstChild("NoKickFrame") then
        return
    end

    if not local_player:FindFirstChild("InPlay") then
        return
    end

    if status:FindFirstChild("Knockdown") then
        return
    end

    if status:FindFirstChild("OverchargeActive") then
        return
    end

    if status:FindFirstChild("NoCharge") then
        return
    end

    if status:FindFirstChild("TakingPen") then
        return
    end

    if status:FindFirstChild("SlideTackleAnim") then
        return
    end

    if game.ReplicatedStorage:FindFirstChild("gameStarting") then
        return
    end

    if game.ReplicatedStorage:FindFirstChild("EndScreen") then
        return
    end

    local enabled_15 = status:FindFirstChild("spaceCheck") ~= nil
    local number_7 = argument == "Left" and number_2 or number_3

    if enabled_15 == true and (number_7 < 25 and ball_status.lastKicked.Value ~= local_player) then
        firstTouch()

        return
    end

    if enabled_15 == true and number_7 > 25 then
        reset_charge()
        local number_value = Instance.new("NumberValue")
        number_value.Name = "SpeedBoost"
        number_value.Parent = status
        number_value.Value = -6
        game.Debris:AddItem(number_value, 0.5)
        local sum = (
            argument == "Left" and -character.HumanoidRootPart.CFrame.RightVector
            or character.HumanoidRootPart.CFrame.RightVector
        )
                * (30 + number_7 * 0.7)
            + Vector3.new(0, 40 - number_7 * 0.35, 0);
        (argument == "Left" and scissor_l_track or scissor_r_track):Play(0)

        task.spawn(function()
            local enabled_17 = false
            local connection_2 = game:GetService("RunService").RenderStepped:Connect(function()
                local tween_2 = hitbox_handler.Create({
                    size = Vector3.new(7.5, 7, 5),
                    cframe = character.HumanoidRootPart.CFrame * CFrame.new(argument == "Left" and -2 or 2, 1.75, 0),
                })

                if tween_2 and enabled_17 == false then
                    enabled_17 = true
                    AirSideHit:FireServer(sum, tween_2, argument)
                end
            end)

            task.delay(0.2, function()
                connection_2:Disconnect()
            end)
        end)

        return
    end

    local number_8 = number_7 > 85 and 85 or number_7

    if
        ball_status.lastKicked.Value ~= nil
        and (
            ball_status.lastKicked.Value ~= local_player
            and (
                ball_status.lastKicked.Value.SelectedTeam.Value ~= local_player.SelectedTeam.Value
                and (game.Workspace.Temp:FindFirstChild("Ball") and not status:FindFirstChild("SlideTackleAnim"))
            )
        )
    then
        local character_2 = ball_status.lastKicked.Value.Character
        local ball = game.Workspace.Temp.Ball

        if
            (character_2.HumanoidRootPart.Position - ball.Position).Magnitude < 9
            and (
                (character.HumanoidRootPart.Position - ball.Position).Magnitude < 6
                and isLookPartInFront(character.HumanoidRootPart, character_2.HumanoidRootPart, 180)
            )
        then
            local text = character.HumanoidRootPart.CFrame.RightVector:Dot(
                (character.HumanoidRootPart.Position * Vector3.new(1, 0, 1) - ball.Position * Vector3.new(1, 0, 1)).Unit
            ) > 0 and "Left" or "Right"
            local dot_product = character.HumanoidRootPart.CFrame.LookVector:Dot(
                (character.HumanoidRootPart.Position * Vector3.new(1, 0, 1) - ball.Position * Vector3.new(1, 0, 1)).Unit
            )
            print(dot_product)
            SetCollisionGroup:FireServer(0.5, "NoCharCollide")
            local negated_value = text == "Left" and -8 or 8
            (text == "Left" and standing_tackle_l_track or standing_tackle_r_track):Play(0.1, 1, 1)
            local character2 = game.Players.LocalPlayer.Character

            for _, child in pairs(character2.HumanoidRootPart:GetChildren()) do
                if child:IsA("BodyVelocity") then
                    child:Destroy()
                end
            end

            local _, value_3, _ = character2.HumanoidRootPart.CFrame:ToOrientation()
            local c_frame2 = character2.HumanoidRootPart.CFrame
            local body_velocity = Instance.new("BodyVelocity")
            body_velocity.MaxForce = Vector3.new(50000, 0, 50000)
            body_velocity.Velocity = character2.HumanoidRootPart.CFrame.lookVector * 16
                + character2.HumanoidRootPart.CFrame.rightVector * negated_value
            body_velocity.Parent = character2.HumanoidRootPart
            game.Debris:AddItem(body_velocity, 0.225)
            local connection = game:GetService("RunService").RenderStepped:Connect(function()
                body_velocity.Velocity = c_frame2.lookVector * 16 + c_frame2.rightVector * negated_value
                humanoid_root_part.CFrame = CFrame.new(humanoid_root_part.Position) * CFrame.Angles(0, value_3, 0)
            end)
            local camera_locked = Instance.new("Folder")
            camera_locked.Name = "CameraLocked"
            camera_locked.Parent = character2.Status
            game.Debris:AddItem(camera_locked, 0.25)
            local knockdown = Instance.new("Folder")
            knockdown.Name = "Knockdown"
            knockdown.Parent = character2.Status
            game.Debris:AddItem(knockdown, 0.25)
            local kick_cd = Instance.new("Folder")
            kick_cd.Name = "KickCD"
            kick_cd.Parent = character2.Status
            game.Debris:AddItem(kick_cd, 0.6)
            reset_charge()

            task.delay(0.225, function()
                connection:Disconnect()
            end)

            local number_9 = number_8 > 90 and 90 or (number_8 < 35 and 35 or number_8)

            task.spawn(function()
                for index_3 = 1, 12 do
                    local _ = character.HumanoidRootPart.CFrame.lookVector * 19
                    local product = character.HumanoidRootPart.CFrame.lookVector * (15 + number_9 * 1.525)
                    local cframe_2 = CFrame.new(0, -3, 0)
                    local tween_2 = hitbox_handler.Create({
                        size = Vector3.new(6.5, 6.5, 6.5),
                        isSphere = true,
                        cframe = character.HumanoidRootPart.CFrame * cframe_2,
                    })

                    if tween_2 then
                        if kick_cd ~= nil then
                            kick_cd:Destroy()
                        end

                        StandingTackle:FireServer(tween_2, true, number_9, product, character.HumanoidRootPart.CFrame)
                    end

                    game:GetService("RunService").Heartbeat:Wait()
                    local _ = index_3
                end
            end)

            return
        end
    end

    reset_charge()
    local vector_2 = (
        argument == "Left" and -character.HumanoidRootPart.CFrame.RightVector
        or character.HumanoidRootPart.CFrame.RightVector
    ) * (enabled == true and 16.25 or 12.5)

    if number_8 > 60 then
        vector_2 = (
            argument == "Left" and -character.HumanoidRootPart.CFrame.RightVector
            or character.HumanoidRootPart.CFrame.RightVector
        ) * (25 + number_8 * 1.625)
    elseif number_8 > 25 then
        vector_2 = (
            argument == "Left" and -character.HumanoidRootPart.CFrame.RightVector
            or character.HumanoidRootPart.CFrame.RightVector
        ) * (12 + number_8 * 1.45)
    end

    if number_8 <= 35 and number_8 > 25 then
        vector_2 = vector_2 + character.HumanoidRootPart.CFrame.LookVector * (number * 2)
    elseif number_8 <= 25 then
        vector_2 = vector_2 + character.HumanoidRootPart.CFrame.LookVector * number
    end

    if controlledSprinting and (number > 12 and number_8 < 25) then
        local cframe = CFrame.new(character.HumanoidRootPart.Position, character.HumanoidRootPart.Position + vector_2)
        vector_2 = vector_2 * 1.25 + cframe.RightVector * math.random(-2, 2)
        number_8 = 33
    end

    local enabled_16 = false

    task.spawn(function()
        if ball_status.lastKicked.Value == local_player then
            return
        end

        local kick_cd_3 = Instance.new("Folder")
        kick_cd_3.Name = "KickCD"
        kick_cd_3.Parent = character.Status
        game.Debris:AddItem(kick_cd_3, 0.3)
    end)

    if number_8 < 80 and ball_status.lastKicked.Value ~= local_player then
        task.spawn(function()
            firstTouch(true, number_8, true, argument)
        end)
    end

    for index = 1, status:FindFirstChild("spaceCheck") == nil and (enabled == true and 9 or 6) or 9 do
        local vector = ball_status.lastKicked.Value == local_player and Vector3.new(6.75, 6, 6.75)
            or Vector3.new(5.75, 5.5, 7)
        local tween = hitbox_handler.Create({
            cframe = character.HumanoidRootPart.CFrame * CFrame.new(0, -2.5, 0),
            size = vector,
        })
        local index_2

        if tween and enabled_16 == false then
            if ball_status.inAir.Value == true then
                warn("Ball has inAir == true")

                return
            end

            local text_2 = character.HumanoidRootPart.CFrame.RightVector:Dot(
                (character.HumanoidRootPart.Position * Vector3.new(1, 0, 1) - tween.Position * Vector3.new(1, 0, 1)).Unit
            ) > 0 and "Left" or "Right"
            index_2 = index

            for _, child_2 in pairs(ball_status:GetChildren()) do
                if child_2.Name == "JustSlideTackled" and child_2.Value ~= local_player then
                    warn("Ball has SlideTackleIFrame")

                    return
                end

                if child_2.Name == "IFrame" and child_2.Value ~= local_player then
                    warn("Ball has IFrames")

                    return
                end

                if child_2.Name == "TapFrames" and child_2.Value ~= local_player then
                    return
                end
            end

            enabled_16 = true

            if enabled == true then
                run_track.TimePosition = text_2 == "Left" and 0.467 or 0.15
            end

            if enabled == true and (not character.Status:FindFirstChild("DribbleVelocityCD") and number_8 < 35) then
                local body_velocity_2 = Instance.new("BodyVelocity")
                body_velocity_2.MaxForce = Vector3.new(50000, 0, 50000)
                body_velocity_2.Velocity = vector_2.Unit * 25
                body_velocity_2.Parent = character.HumanoidRootPart
                game.Debris:AddItem(body_velocity_2, 0.15)

                if argument == "Left" then
                    anim_LeftDribble:Play()
                    run_track.TimePosition = 0.467
                elseif argument == "Right" then
                    anim_RightDribble:Play()
                    run_track.TimePosition = 0.15
                end
            elseif argument == "Left" then
                anim_LeftDribbleTap:Play()
                run_track.TimePosition = 0.467
            elseif argument == "Right" then
                anim_RightDribbleTap:Play()
                run_track.TimePosition = 0.15
            end

            local dribble_velocity_cd = Instance.new("Folder")
            dribble_velocity_cd.Name = "DribbleVelocityCD"
            dribble_velocity_cd.Parent = character.Status
            game.Debris:AddItem(dribble_velocity_cd, 1)
            vector_2 = CFrame.new(tween.Position, character.HumanoidRootPart.Position - Vector3.new(0, 2, 0) + vector_2).lookVector
                * vector_2.Magnitude
            Kick:FireServer(
                vector_2,
                tween,
                true,
                false,
                number_8,
                text_2,
                character.HumanoidRootPart.CFrame,
                nil,
                false,
                true
            )
        else
            index_2 = index
        end

        game:GetService("RunService").RenderStepped:Wait()
    end

    if enabled_16 ~= false then
        return
    end

    print("Missed, Kick going on CD")
    local number_10 = ball_status.lastKicked.Value == local_player and 0.1 or 0.6
    local kick_cd_2 = Instance.new("Folder")
    kick_cd_2.Name = "KickCD"
    kick_cd_2.Parent = character.Status
    game.Debris:AddItem(kick_cd_2, number_10)
end

function gkKickFunction(enabled_15)
    if enabled_2 == true then
        return
    end

    if local_player.SelectedPosition.Value ~= "GK" then
        return
    end

    if not local_player:FindFirstChild("InPlay") then
        return
    end

    if status:FindFirstChild("Knockdown") then
        return
    end

    local charge_3 = enabled_15 == true and charge_2 or charge

    if not status:FindFirstChild("HasBall") then
        if character.Humanoid.FloorMaterial == Enum.Material.Air then
            local enabled_16 = false

            for index = 1, 8 do
                local tween = hitbox_handler.Create({
                    size = Vector3.new(8, 8, 8),
                    cframe = character.HumanoidRootPart.CFrame * CFrame.new(0, 2.5, -1),
                })

                if tween and enabled_16 == false then
                    local sum = character.HumanoidRootPart.CFrame.lookVector * 90 + Vector3.new(0, 7.5, 0)
                    header_track:Play(0, 1)
                    Header:FireServer(sum, tween)
                    enabled_16 = true
                end

                game:GetService("RunService").RenderStepped:Wait()
                local _ = index
            end
        end

        return
    end

    if charge_3 == 0 then
        return
    end

    local _ = status.HasBall.Value
    local value_3 = nil

    if enabled_15 == false then
        if charge_3 > 50 then
            GKDrop:FireServer(character.HumanoidRootPart.CFrame, true)
            gk_side_volley_track:Play(0, 1)
            local number_7 = 10
            local negated_value = -20
            local body_velocity = Instance.new("BodyVelocity")
            body_velocity.MaxForce = Vector3.new(50000, 0, 50000)
            body_velocity.Velocity = character.HumanoidRootPart.CFrame.lookVector * number_7
                + character.HumanoidRootPart.CFrame.rightVector * negated_value
            body_velocity.Parent = character.HumanoidRootPart
            game.Debris:AddItem(body_velocity, 0.4)
            local connection = game:GetService("RunService").RenderStepped:Connect(function()
                body_velocity.Velocity = character.HumanoidRootPart.CFrame.lookVector * number_7
                    + character.HumanoidRootPart.CFrame.rightVector * negated_value
            end)

            task.delay(0.4, function()
                connection:Disconnect()
            end)

            task.spawn(function()
                for index_2 = 1, 13 do
                    task.wait(0.03)
                    number_7 = number_7 * 0.975
                    negated_value = negated_value * 0.975
                    local _ = index_2
                end
            end)

            task.wait(0.35)
        else
            GKDrop:FireServer(character.HumanoidRootPart.CFrame, false)
            gk_kick_track:Play(0, 1)
            task.wait(0.3)
        end

        value_3 = Vector3.new(
            character.HumanoidRootPart.CFrame.lookVector.X,
            workspace.CurrentCamera.CFrame.lookVector.Y * 1,
            character.HumanoidRootPart.CFrame.lookVector.Z
        ) * (17.5 + charge_3 * 1.6)

        if value_3.Y > 82 then
            value_3 = Vector3.new(value_3.X, 82, value_3.Z)
        elseif value_3.Y < 35 then
            value_3 = Vector3.new(value_3.X, 35, value_3.Z)
        end

        if value_3.Y >= 72.5 then
            value_3 = Vector3.new(value_3.X * 0.75, value_3.Y, value_3.Z * 0.75)
        elseif value_3.Y >= 60 then
            value_3 = Vector3.new(value_3.X * 0.825, value_3.Y, value_3.Z * 0.825)
        elseif value_3.Y >= 47.5 then
            value_3 = Vector3.new(value_3.X * 0.9, value_3.Y, value_3.Z * 0.9)
        end
    elseif enabled_15 == true then
        gk_throw_track:Play(0, 1)
        task.wait(0.275)
        value_3 = character.HumanoidRootPart.CFrame.lookVector * (35 + charge_3 * 1.25)
    end

    GKRelease:FireServer(enabled_15, value_3, character.HumanoidRootPart.CFrame.lookVector, charge_3)
end

local enabled_4 = false
local enabled_13 = false

function slideTackle(enabled_15)
    if enabled_15 == true then
        enabled_4 = false
    end

    if local_player.SelectedPosition.Value == "GK" and status:FindFirstChild("InBox") then
        if enabled_13 or status:FindFirstChild("SplitSaveActive") then
            return
        end

        if status:FindFirstChild("NoMovement") then
            return
        end

        enabled_13 = true

        task.delay(5, function()
            enabled_13 = false
        end)

        KeyInput:FireServer(Enum.KeyCode.E, true, {
            look = character.HumanoidRootPart.CFrame.lookVector,
            right = character.HumanoidRootPart.CFrame.rightVector,
            pos = character.HumanoidRootPart.CFrame,
            charge = charge_2 < charge and charge or charge_2,
            cameraLook = game.Workspace.CurrentCamera.CFrame.LookVector,
            isAir = status:FindFirstChild("spaceCheck") ~= nil,
            moveDirection = character.HumanoidRootPart.AssemblyLinearVelocity.Unit,
        })

        return
    end

    if not local_player:FindFirstChild("InPlay") then
        return
    end

    if status:FindFirstChild("Knockdown") then
        return
    end

    if status:FindFirstChild("NoTackle") then
        return
    end

    if status:FindFirstChild("KickDisable") and not status:FindFirstChild("ManMarkActive") then
        return
    end

    if not status:FindFirstChild("ManMarkActive") and status:FindFirstChild("NoCharge") then
        return
    end

    if status:FindFirstChild("spaceCheck") and enabled_15 ~= true then
        return
    end

    if enabled_4 == true and not enabled_15 then
        return
    end

    if status:FindFirstChild("NoMovement") then
        return
    end

    if
        game.ReplicatedStorage:FindFirstChild("Shootout")
        or (
            game.ReplicatedStorage:FindFirstChild("FinalShootout")
            or game.ReplicatedStorage:FindFirstChild("ActivePenalty")
        )
    then
        return
    end

    if
        game.ReplicatedStorage:FindFirstChild("gameStarting") or game.ReplicatedStorage:FindFirstChild("playResetting")
    then
        return
    end

    if game.ReplicatedStorage:FindFirstChild("EndScreen") then
        return
    end

    local ball = game.Workspace.Temp:FindFirstChild("Ball")
    local text = ball
            and (game.Workspace.CurrentCamera.CFrame.RightVector:Dot(
                (game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1) - ball.Position * Vector3.new(
                    1,
                    0,
                    1
                )).Unit
            ) > 0 and "Left" or "Right")
        or "Left"
    enabled_4 = true

    task.delay(6, function()
        enabled_4 = false
    end)

    SlideFX:FireServer()
    local character_2 = game.Players.LocalPlayer.Character

    for _, child in pairs(character_2.HumanoidRootPart:GetChildren()) do
        if child:IsA("BodyVelocity") then
            child:Destroy()
        end
    end

    local difference = 47.5
        - (number == 13.125 and -10 or (number >= 9 and 0 or (number >= 6 and 10 or (number >= 3 and 15 or 20))))
    local enabled_16 = false
    local look_vector2 = character_2.HumanoidRootPart.CFrame.lookVector
    local rough_tackle_track_2

    if status:FindFirstChild("ManMark") then
        rough_tackle_track_2 = rough_tackle_track
        rough_tackle_track_2:Play(0, 1)
        local camera_locked = Instance.new("Folder")
        camera_locked.Name = "CameraLocked"
        camera_locked.Parent = character_2.Status
        game.Debris:AddItem(camera_locked, 1.25)
        local no_jump = Instance.new("Folder")
        no_jump.Name = "NoJump"
        no_jump.Parent = character_2.Status
        game.Debris:AddItem(no_jump, 1.25)
        local no_charge = Instance.new("Folder")
        no_charge.Name = "NoCharge"
        no_charge.Parent = character_2.Status
        game.Debris:AddItem(no_charge, 1.25)
        local knockdown = Instance.new("Folder")
        knockdown.Name = "Knockdown"
        knockdown.Parent = character_2.Status
        game.Debris:AddItem(knockdown, 1.25)
        difference = 62.5
        enabled_16 = true
        text = "BT"
    else
        look_vector2 = text == "Left" and -character_2.HumanoidRootPart.CFrame.rightVector
            or character_2.HumanoidRootPart.CFrame.rightVector
        rough_tackle_track_2 = text == "Left" and slide_tackle_l_track or slide_tackle_r_track
        rough_tackle_track_2:Play(0, 1)
        local camera_locked_2 = Instance.new("Folder")
        camera_locked_2.Name = "CameraLocked"
        camera_locked_2.Parent = character_2.Status
        game.Debris:AddItem(camera_locked_2, 0.55)
        local no_jump_2 = Instance.new("Folder")
        no_jump_2.Name = "NoJump"
        no_jump_2.Parent = character_2.Status
        game.Debris:AddItem(no_jump_2, 0.55)
        local no_charge_2 = Instance.new("Folder")
        no_charge_2.Name = "NoCharge"
        no_charge_2.Parent = character_2.Status
        game.Debris:AddItem(no_charge_2, 0.55)
    end

    local _, value_3, _ = character_2.HumanoidRootPart.CFrame:ToOrientation()
    SetCollisionGroup:FireServer(1.25, "NoCharCollide")
    local slide_tackle_active = Instance.new("Folder")
    slide_tackle_active.Name = "SlideTackleActive"
    slide_tackle_active.Parent = character_2.Status
    game.Debris:AddItem(slide_tackle_active, 1.2)
    local slide_tackle_anim = Instance.new("Folder")
    slide_tackle_anim.Name = "SlideTackleAnim"
    slide_tackle_anim.Parent = character_2.Status
    game.Debris:AddItem(slide_tackle_anim, 0.65)
    local body_velocity = Instance.new("BodyVelocity")
    body_velocity.MaxForce = Vector3.new(50000, 0, 50000)
    body_velocity.Velocity = character_2.HumanoidRootPart.CFrame.lookVector * difference
    body_velocity.Parent = character_2.HumanoidRootPart
    game.Debris:AddItem(body_velocity, 0.55)
    game:GetService("TweenService")
        :Create(body_velocity, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Velocity = character_2.HumanoidRootPart.CFrame.lookVector * 12,
        })
        :Play()
    local enabled_17 = false
    local random_value = math.random(-10, 10)
    local random_value_2 = math.random(-10, 10)
    local sum = look_vector2 * (enabled_16 and 100 or 60)
        + Vector3.new(random_value, random_value_2, math.random(-10, 10))
    local connection_2 = nil
    local connection_3 = nil
    connection_2 = character_2["Left Leg"].Touched:Connect(function(hit)
        if
            not (
                not hit:IsDescendantOf(character_2)
                and (
                    hit:IsDescendantOf(game.Workspace.CharacterContainer)
                    and (hit.Name == "Right Leg" or hit.Name == "Left Leg")
                )
            )
        then
            return
        end

        connection_3:Disconnect()
        connection_2:Disconnect()
        enabled_17 = true
    end)
    connection_3 = character_2["Right Leg"].Touched:Connect(function(hit)
        if
            not (
                not hit:IsDescendantOf(character_2)
                and (
                    hit:IsDescendantOf(game.Workspace.CharacterContainer)
                    and (hit.Name == "Right Leg" or hit.Name == "Left Leg")
                )
            )
        then
            return
        end

        connection_3:Disconnect()
        connection_2:Disconnect()
        enabled_17 = true
    end)

    task.delay(1, function()
        connection_3:Disconnect()
        connection_2:Disconnect()
    end)

    local raycast_params_2 = RaycastParams.new()
    raycast_params_2.RespectCanCollide = false
    raycast_params_2.FilterType = Enum.RaycastFilterType.Include
    raycast_params_2.FilterDescendantsInstances = {
        ball_status.lastKicked.Value ~= nil and ball_status.lastKicked.Value.Character
            or game.Workspace.CharacterContainer,
    }
    local connection_4 = nil
    connection_4 = game:GetService("RunService").RenderStepped:Connect(function(delta_time)
        if status:FindFirstChild("NoTackle") then
            body_velocity:Destroy()
            connection_4:Disconnect()
        end

        difference = difference * (58.5 * delta_time)

        if not ball then
            return
        end

        local position = (character_2.HumanoidRootPart.CFrame * CFrame.new(0, -2, -2)).Position
        local magnitude = (position - ball.Position).Magnitude
        local spherecast_result = workspace:Spherecast(
            position,
            1.6,
            CFrame.new(position, ball.Position).LookVector * (magnitude / 2),
            raycast_params_2
        )

        if
            spherecast_result
            and (
                ball_status.lastKicked.Value ~= nil
                and spherecast_result.Instance.Parent == ball_status.lastKicked.Value.Character
            )
        then
            enabled_17 = true
        end
    end)

    if enabled_16 == true then
        local timestamp_11 = tick()
        local text_2 = "BT"
        connection_4:Disconnect()
        local connection = game:GetService("RunService").RenderStepped:Connect(function(delta_time)
            difference = difference * (58.5 * delta_time)
            humanoid_root_part.CFrame = CFrame.new(humanoid_root_part.Position) * CFrame.Angles(0, value_3, 0)
            local tween = hitbox_handler.Create({
                size = Vector3.new(3.5, 5, 5),
                cframe = character_2.HumanoidRootPart.CFrame * CFrame.new(0, -2, -2.5),
            })

            if not tween then
                return
            end

            local position = (character_2.HumanoidRootPart.CFrame * CFrame.new(0, -2, 0)).Position
            local spherecast_result = workspace:Spherecast(
                position,
                controlledSprinting and 3 or 2.4,
                CFrame.new(position, position + character_2.HumanoidRootPart.CFrame.lookVector).LookVector * 12,
                raycast_params_2
            )

            if
                spherecast_result
                and (
                    ball_status.lastKicked.Value ~= nil
                    and spherecast_result.Instance.Parent == ball_status.lastKicked.Value.Character
                )
            then
                enabled_17 = true
            end

            SlideTackleHit:FireServer(tween, sum, tick() - timestamp_11, enabled_17, text_2, position)
        end)

        task.delay(0.45, function()
            connection:Disconnect()
        end)
    else
        task.delay(0.175, function()
            local timestamp_12 = tick()
            connection_4:Disconnect()
            local negated_value = text == "Left" and -1 or (text == "Right" and 1 or 0)
            local connection_5 = nil
            connection_5 = game:GetService("RunService").RenderStepped:Connect(function(delta_time)
                if status:FindFirstChild("NoTackle") then
                    body_velocity:Destroy()
                    connection_5:Disconnect()
                end

                difference = difference * (58.5 * delta_time)
                humanoid_root_part.CFrame = CFrame.new(humanoid_root_part.Position) * CFrame.Angles(0, value_3, 0)
                local tween = hitbox_handler.Create({
                    size = Vector3.new(4, 5, 6.25),
                    cframe = character_2.HumanoidRootPart.CFrame * CFrame.new(negated_value, -2, -1.75),
                })

                if not tween then
                    return
                end

                local position = (character_2.HumanoidRootPart.CFrame * CFrame.new(0, -2, 0)).Position
                local spherecast_result = workspace:Spherecast(
                    position,
                    controlledSprinting and 3 or 1.6,
                    CFrame.new(position, position + character_2.HumanoidRootPart.CFrame.lookVector).LookVector * 12,
                    raycast_params_2
                )

                if
                    spherecast_result
                    and (
                        ball_status.lastKicked.Value ~= nil
                        and spherecast_result.Instance.Parent == ball_status.lastKicked.Value.Character
                    )
                then
                    enabled_17 = true
                end

                SlideTackleHit:FireServer(tween, sum, tick() - timestamp_12, enabled_17, text, position)
            end)

            task.delay(0.225, function()
                connection_5:Disconnect()
            end)
        end)
    end

    local condition = ball_status.lastKicked.Value == local_player

    task.delay(0.65, function()
        if enabled_15 or enabled_16 then
            return
        end

        if
            not (
                status:FindFirstChild("HasHitSlideTackle")
                and (ball_status.lastKicked.Value == local_player and not condition)
            )
        then
            if not (status:FindFirstChild("HasHitSlideTackle") or condition) then
                SlideTackleMiss:FireServer()
            end

            local camera_locked_3 = Instance.new("Folder")
            camera_locked_3.Name = "CameraLocked"
            camera_locked_3.Parent = character_2.Status
            game.Debris:AddItem(camera_locked_3, 0.6)
            local no_jump_3 = Instance.new("Folder")
            no_jump_3.Name = "NoJump"
            no_jump_3.Parent = character_2.Status
            game.Debris:AddItem(no_jump_3, 0.6)
            local knockdown_2 = Instance.new("Folder")
            knockdown_2.Name = "Knockdown"
            knockdown_2.Parent = character_2.Status
            game.Debris:AddItem(knockdown_2, 0.6)
            local no_charge_3 = Instance.new("Folder")
            no_charge_3.Name = "NoCharge"
            no_charge_3.Parent = character_2.Status
            game.Debris:AddItem(no_charge_3, 0.6)

            return
        end

        rough_tackle_track_2:Stop()
    end)
end

status.ChildRemoved:Connect(function(child)
    if child.Name == "ManMarkTackleCheck" then
        slideTackle(true)
    end
end)

local enabled_5 = false

function shove()
    if local_player.SelectedPosition.Value == "GK" and status:FindFirstChild("InBox") then
        return
    end

    if status:FindFirstChild("Knockdown") then
        return
    end

    if not local_player:FindFirstChild("InPlay") then
        return
    end

    if enabled_5 == true then
        return
    end

    local condition = status:FindFirstChild("Walled") ~= nil

    if not condition and ball_status.lastKicked.Value ~= local_player then
        return
    end

    local tween = hitbox_handler_players.Create({
        size = Vector3.new(6, 6, 6),
        cframe = character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2),
    }, character)
    local items = {}
    local value_3 = nil

    for _, item in pairs(tween) do
        local parent = item.Parent
        local player_from_character = game.Players:GetPlayerFromCharacter(parent)

        if
            (not player_from_character or player_from_character.SelectedTeam.Value ~= local_player.SelectedTeam.Value)
            and player_from_character
            and (condition or not (ball_status.lastKicked.Value == player_from_character or parent.HumanoidRootPart.CFrame.LookVector:Dot(
                character.HumanoidRootPart.CFrame.LookVector.Unit
            ) < 0.7 or (type(parent.HumanoidRootPart.AssemblyLinearVelocity.X) == "number" or type(
                parent.HumanoidRootPart.AssemblyLinearVelocity.Z
            ) == "number") and parent.HumanoidRootPart.AssemblyLinearVelocity:Dot(
                character.HumanoidRootPart.AssemblyLinearVelocity
            ) < 0.7 or type(parent.HumanoidRootPart.AssemblyLinearVelocity.X) ~= "number" and type(
                parent.HumanoidRootPart.AssemblyLinearVelocity.Z
            ) ~= "number"))
            and (parent:FindFirstChild("Humanoid") and not table.find(items, parent))
        then
            table.insert(items, parent)
            value_3 = character.HumanoidRootPart.CFrame.RightVector:Dot(
                (
                    character.HumanoidRootPart.Position * Vector3.new(1, 0, 1)
                    - parent.HumanoidRootPart.Position * Vector3.new(1, 0, 1)
                ).Unit
            ) > 0 and "Left" or "Right"
            ShoveCheck:FireServer(parent)
        end
    end

    if not (#items > 0) then
        return
    end

    enabled_5 = true

    task.delay(10, function()
        enabled_5 = false
    end);

    (value_3 == "Left" and shove_l_track or shove_r_track):Play(0, 1, 1)
end

local function get_charge()
    if number_2 ~= 0 then
        return number_2
    end

    if charge ~= 0 then
        return charge
    end

    if charge_2 ~= 0 then
        return charge_2
    end

    if number_3 ~= 0 then
        return number_3
    end
end

function firstTouch(argument, argument_2, enabled_15, argument_3)
    if not local_player:FindFirstChild("InPlay") then
        return
    end

    if status:FindFirstChild("Knockdown") then
        return
    end

    if ball_status.lastKicked.Value == local_player then
        return
    end

    print("function firstTouch activated")
    local enabled_16 = false

    if argument and argument_2 then
        local connection = nil
        connection = game:GetService("RunService").Stepped:Connect(function()
            local tween = hitbox_handler.Create({
                size = Vector3.new(6.5, 5.5, 7.5),
                cframe = character.HumanoidRootPart.CFrame * CFrame.new(0, -2.5, 0),
            })

            if
                not (
                    tween
                    and (
                        tween.Name == "Ball"
                        and (
                            tween.Parent == game.Workspace.Temp
                            and (not tween:FindFirstChild("Scored") and (tween and argument_2))
                        )
                    )
                )
            then
                return
            end

            local text = character.HumanoidRootPart.CFrame.RightVector:Dot(
                (character.HumanoidRootPart.Position * Vector3.new(1, 0, 1) - tween.Position * Vector3.new(1, 0, 1)).Unit
            ) > 0 and "Left" or "Right"

            if ball_status.lastKicked.Value == local_player then
                warn("Touch failed due to having possession of the ball.")
            end

            if tween.AssemblyLinearVelocity.Magnitude >= 25 and local_player.Name ~= "kaitoudono" then
                warn("Touch failed due to the ball being too slow")
            end

            if
                not (
                    tween.AssemblyLinearVelocity.Magnitude >= 25
                    and (
                        ball_status.lastKicked.Value ~= local_player
                        and not (
                            ball_status:FindFirstChild("noFirstTouch")
                            or (status:FindFirstChild("spaceCheck") or local_player.Name == "kaitoudono")
                        )
                    )
                )
            then
                return
            end

            if ball_status:FindFirstChild("IFrame") then
                warn("Touch failed due to the ball having IFrames")

                return
            end

            if ball_status:FindFirstChild("JustShotByGK") and local_player.Name ~= "kaitoudono" then
                warn("Touch failed due to the ball having JustShotByGK")

                return
            end

            if ball_status:FindFirstChild("JustThrown") and local_player.Name ~= "kaitoudono" then
                warn("Touch failed due to the ball having JustThrown")

                return
            end

            for _, child in pairs(ball_status:GetChildren()) do
                if
                    child.Name == "JustSlideTackled"
                    and (child.Value ~= local_player and local_player.Name ~= "kaitoudono")
                then
                    warn("Touch failed due to the ball being slide tackled by another player")

                    return
                end

                if child.Name == "IFrame" and child.Value ~= local_player then
                    return
                end
            end

            if ball_status:FindFirstChild("noFirstTouch") then
                warn("Touch failed due to the ball being unable to be first touched due to being recently hit(?)")

                return
            end

            if
                ball_status.lastKicked.Value ~= nil
                and (tween.Position - ball_status.lastKicked.Value.Character.HumanoidRootPart.Position).Magnitude
                    < 15
            then
                warn("Touch failed due to the person who last kicked it being too close to the ball")

                return
            end

            local vector = Vector3.new(0, 0, 0)

            if argument_2 > 40 then
                if enabled_15 == true and argument_3 == nil then
                    vector = character.HumanoidRootPart.CFrame.lookVector * (15 + argument_2 * 1.3)

                    if argument_2 > 75 then
                        vector = character.HumanoidRootPart.CFrame.lookVector * (15 + argument_2 * 1.525)
                    end
                elseif enabled_15 or argument_3 ~= nil then
                    if argument_3 ~= nil then
                        vector = character.HumanoidRootPart.CFrame.rightVector * argument_3 == "Left"
                                and -(15 + argument_2 * 1.3)
                            or 15 + argument_2 * 1.3
                    end
                else
                    vector = character.HumanoidRootPart.CFrame.lookVector * (15 + argument_2 * 1.4)
                        + Vector3.new(0, 10 + argument_2 * 0.5, 0)
                end

                if argument_3 == nil then
                    (text == "Left" and kick_left_track or kick_right_track):Play()
                else
                    (argument_3 == "Left" and anim_LeftDribble or anim_RightDribble):Play()
                end
            elseif argument_2 > 15 then
                if enabled_15 == true and argument_3 == nil then
                    vector = character.HumanoidRootPart.CFrame.lookVector * 30
                elseif enabled_15 or argument_3 ~= nil then
                    vector = argument_3 ~= nil
                            and (character.HumanoidRootPart.CFrame.rightVector * argument_3 == "Left" and -30 or 30)
                        or vector
                else
                    vector = character.HumanoidRootPart.CFrame.lookVector * 30 + Vector3.new(0, 20, 0)
                end

                if argument_3 == nil then
                    (text == "Left" and ft_from_air_left_track or ft_from_air_right_track):Play()
                else
                    (argument_3 == "Left" and anim_LeftDribble or anim_RightDribble):Play()
                end
            elseif enabled == true then
                if argument_3 == nil then
                    vector = character.HumanoidRootPart.CFrame.lookVector * 30
                else
                    vector = argument_3 ~= nil
                            and (character.HumanoidRootPart.CFrame.rightVector * argument_3 == "Left" and -30 or 30)
                        or vector
                end

                (text == "Left" and first_touch_running_left_track or first_touch_running_right_track):Play()
            elseif argument_3 == nil then
                if ball_status:FindFirstChild("JustBounced") or ball_status.inAir.Value == true then
                    (text == "Left" and ft_from_air_left_track or ft_from_air_right_track):Play()
                else
                    (text == "Left" and first_touch_left_track or first_touch_right_track):Play()
                end
            else
                (argument_3 == "Left" and anim_LeftDribble or anim_RightDribble):Play()
            end

            task.delay(0.1, function()
                for _, child_2 in pairs(character.Status:GetChildren()) do
                    if child_2.Name == "KickCD" then
                        child_2:Destroy()
                    end
                end
            end)

            local product = CFrame.new(
                tween.Position,
                character.HumanoidRootPart.Position - Vector3.new(0, 2, 0) + vector
            ).lookVector * vector.Magnitude
            StopBall_GroundBackup:FireServer(tween, product, text)
            connection:Disconnect()
        end)

        task.delay(0.25, function()
            connection:Disconnect()
        end)
    elseif status:FindFirstChild("spaceCheck") then
        local kick_cd = Instance.new("Folder")
        kick_cd.Name = "KickCD"
        kick_cd.Parent = character.Status
        game.Debris:AddItem(kick_cd, 0.15)
        local value_3

        if number_2 == 0 then
            if charge == 0 then
                if charge_2 == 0 then
                    if number_3 == 0 then
                        value_3 = nil
                    else
                        value_3 = number_3
                    end
                else
                    value_3 = charge_2
                end
            else
                value_3 = charge
            end
        else
            value_3 = number_2
        end

        reset_charge()
        local connection_2 = nil
        connection_2 = game:GetService("RunService").Stepped:Connect(function()
            local tween = hitbox_handler.Create({
                size = Vector3.new(6.5, 6, 6.5),
                cframe = character.HumanoidRootPart.CFrame,
            })

            if
                not (
                    tween
                    and (
                        tween.Name == "Ball"
                        and (tween.Parent == game.Workspace.Temp and (not tween:FindFirstChild("Scored") and tween))
                    )
                )
            then
                return
            end

            if tween.AssemblyLinearVelocity.Magnitude <= 25 and local_player.Name ~= "kaitoudono" then
                warn("Touch failed due to the ball being too slow")

                return
            end

            if ball_status:FindFirstChild("IFrame") and local_player.Name ~= "kaitoudono" then
                warn("Touch failed due to the ball having IFrames")

                return
            end

            if ball_status:FindFirstChild("JustShotByGK") and local_player.Name ~= "kaitoudono" then
                warn("Touch failed due to the ball having JustShotByGK")

                return
            end

            if ball_status:FindFirstChild("JustThrown") and local_player.Name ~= "kaitoudono" then
                warn("Touch failed due to the ball having JustThrown")

                return
            end

            for _, child in pairs(ball_status:GetChildren()) do
                if
                    child.Name == "JustSlideTackled"
                    and (child.Value ~= local_player and local_player.Name ~= "kaitoudono")
                then
                    warn("Touch failed due to the ball being slide tackled by another player")

                    return
                end

                if child.Name == "IFrame" and child.Value ~= local_player then
                    return
                end
            end

            if ball_status:FindFirstChild("noFirstTouch") then
                warn("Touch failed due to the ball being unable to be first touched due to being recently hit(?)")

                return
            end

            if
                ball_status.lastKicked.Value ~= nil
                and (tween.Position - ball_status.lastKicked.Value.Character.HumanoidRootPart.Position).Magnitude
                    < 15
            then
                warn("Touch failed due to the person who last kicked it being too close to the ball")

                return
            end

            enabled_16 = true
            local relative_cframe = character.HumanoidRootPart.CFrame:ToObjectSpace(tween.CFrame)
            local text = character.HumanoidRootPart.CFrame.RightVector:Dot(
                (character.HumanoidRootPart.Position * Vector3.new(1, 0, 1) - tween.Position * Vector3.new(1, 0, 1)).Unit
            ) > 0 and "Left" or "Right"
            local text_2 = character.HumanoidRootPart.CFrame.LookVector:Dot(
                (character.HumanoidRootPart.Position * Vector3.new(1, 0, 1) - tween.Position * Vector3.new(1, 0, 1)).Unit
            ) > 0 and "Back" or "Front"
            local enabled_17 = relative_cframe.X > 1 or relative_cframe.X < -1
            local value_4 = nil
            local text_3 = ""

            if (tween.Position.Y - character.HumanoidRootPart.Position.Y < 1.5 and "Low" or "High") == "Low" then
                if text == "Left" then
                    if text_2 == "Front" then
                        if enabled_17 == false then
                            value_4 = first_touch_air_fl_track
                            text_3 = "FrontL"
                        else
                            value_4 = first_touch_air_lf_track
                            text_3 = "LeftF"
                        end
                    elseif text_2 == "Back" then
                        if enabled_17 == false then
                            value_4 = first_touch_air_bl_track
                            text_3 = "BackL"
                        else
                            value_4 = first_touch_air_lb_track
                            text_3 = "LeftB"
                        end
                    end
                elseif text == "Right" then
                    if text_2 == "Front" then
                        if enabled_17 == false then
                            value_4 = first_touch_air_fr_track
                            text_3 = "FrontR"
                        else
                            value_4 = first_touch_air_rf_track
                            text_3 = "RightF"
                        end
                    elseif text_2 == "Back" then
                        if enabled_17 == false then
                            value_4 = first_touch_air_br_track
                            text_3 = "BackR"
                        else
                            value_4 = first_touch_air_rb_track
                            text_3 = "RightB"
                        end
                    end
                end
            elseif text_2 == "Front" then
                value_4 = first_touch_air_f_track
                text_3 = "Chest"
            elseif text_2 == "Back" then
                value_4 = first_touch_air_b_track
                text_3 = "Back"
            end

            task.delay(0.1, function()
                for _, child_2 in pairs(character.Status:GetChildren()) do
                    if child_2.Name == "KickCD" then
                        child_2:Destroy()
                    end
                end
            end)

            value_4:Play(0, 1, 1)
            local look_vector2 = character.HumanoidRootPart.CFrame.lookVector
            local right_vector = character.HumanoidRootPart.CFrame.rightVector

            if argument_3 ~= nil then
                right_vector = character.HumanoidRootPart.CFrame.lookVector
            end

            if argument_3 == "Left" then
                look_vector2 = -character.HumanoidRootPart.CFrame.rightVector
            elseif argument_3 == "Right" then
                look_vector2 = character.HumanoidRootPart.CFrame.rightVector
            end

            connection_2:Disconnect()
            StopBall_Air:FireServer(tween, text_3, look_vector2, right_vector, value_3)
        end)

        task.delay(0.15, function()
            connection_2:Disconnect()
        end)

        if enabled_16 == false then
            print("Missed, Kick going on CD")
            local number_7 = ball_status.lastKicked.Value == local_player and 0.1 or 0.6
            local kick_cd_2 = Instance.new("Folder")
            kick_cd_2.Name = "KickCD"
            kick_cd_2.Parent = character.Status
            game.Debris:AddItem(kick_cd_2, number_7)
        end
    end
end

function firstTouchBackup(argument, argument_2, enabled_15, argument_3)
    if not local_player:FindFirstChild("InPlay") then
        return
    end

    if status:FindFirstChild("Knockdown") then
        return
    end

    if ball_status.lastKicked.Value == local_player then
        return
    end

    print("function firstTouchBackup activated")

    if not (argument and argument_2) then
        return
    end

    local text = character.HumanoidRootPart.CFrame.RightVector:Dot(
        (character.HumanoidRootPart.Position * Vector3.new(1, 0, 1) - argument.Position * Vector3.new(1, 0, 1)).Unit
    ) > 0 and "Left" or "Right"

    if ball_status.lastKicked.Value == local_player then
        warn("Touch failed due to having possession of the ball.")
    end

    if argument.AssemblyLinearVelocity.Magnitude >= 25 and local_player.Name ~= "kaitoudono" then
        warn("Touch failed due to the ball being too slow")
    end

    if
        not (
            argument.AssemblyLinearVelocity.Magnitude >= 25
            and (
                ball_status.lastKicked.Value ~= local_player
                and not (ball_status:FindFirstChild("noFirstTouch") or status:FindFirstChild("spaceCheck"))
            )
        )
    then
        return
    end

    if ball_status:FindFirstChild("IFrame") and local_player.Name ~= "kaitoudono" then
        warn("Touch failed due to the ball having IFrames")

        return
    end

    if ball_status:FindFirstChild("JustShotByGK") and local_player.Name ~= "kaitoudono" then
        warn("Touch failed due to the ball having JustShotByGK")

        return
    end

    if ball_status:FindFirstChild("JustThrown") and local_player.Name ~= "kaitoudono" then
        warn("Touch failed due to the ball having JustThrown")

        return
    end

    for _, child in pairs(ball_status:GetChildren()) do
        if child.Name == "JustSlideTackled" and (child.Value ~= local_player and local_player.Name ~= "kaitoudono") then
            warn("Touch failed due to the ball being slide tackled by another player")

            return
        end

        if child.Name == "IFrame" and child.Value ~= local_player then
            return
        end
    end

    if ball_status:FindFirstChild("noFirstTouch") then
        warn("Touch failed due to the ball being unable to be first touched due to being recently hit(?)")

        return
    end

    if
        ball_status.lastKicked.Value == nil
        or (argument.Position - ball_status.lastKicked.Value.Character.HumanoidRootPart.Position).Magnitude >= 15
    then
        local vector = Vector3.new(0, 0, 0)

        if argument_2 > 40 then
            if enabled_15 == true and argument_3 == nil then
                vector = character.HumanoidRootPart.CFrame.lookVector * (15 + argument_2 * 1.3)

                if argument_2 > 75 then
                    vector = character.HumanoidRootPart.CFrame.lookVector * (15 + argument_2 * 1.525)
                end
            elseif enabled_15 or argument_3 ~= nil then
                if argument_3 ~= nil then
                    vector = character.HumanoidRootPart.CFrame.rightVector * argument_3 == "Left"
                            and -(15 + argument_2 * 1.3)
                        or 15 + argument_2 * 1.3
                end
            else
                vector = character.HumanoidRootPart.CFrame.lookVector * (15 + argument_2 * 1.4)
                    + Vector3.new(0, 10 + argument_2 * 0.5, 0)
            end

            if argument_3 == nil then
                (text == "Left" and kick_left_track or kick_right_track):Play()
            else
                (argument_3 == "Left" and anim_LeftDribble or anim_RightDribble):Play()
            end
        elseif argument_2 > 15 then
            if enabled_15 == true and argument_3 == nil then
                vector = character.HumanoidRootPart.CFrame.lookVector * 30
            elseif enabled_15 or argument_3 ~= nil then
                vector = argument_3 ~= nil
                        and (character.HumanoidRootPart.CFrame.rightVector * argument_3 == "Left" and -30 or 30)
                    or vector
            else
                vector = character.HumanoidRootPart.CFrame.lookVector * 30 + Vector3.new(0, 20, 0)
            end

            if argument_3 == nil then
                (text == "Left" and ft_from_air_left_track or ft_from_air_right_track):Play()
            else
                (argument_3 == "Left" and anim_LeftDribble or anim_RightDribble):Play()
            end
        elseif enabled == true then
            if argument_3 == nil then
                vector = character.HumanoidRootPart.CFrame.lookVector * 16
            else
                vector = argument_3 ~= nil
                        and (character.HumanoidRootPart.CFrame.rightVector * argument_3 == "Left" and -14 or 14)
                    or vector
            end

            (text == "Left" and first_touch_running_left_track or first_touch_running_right_track):Play()
        elseif argument_3 == nil then
            if ball_status:FindFirstChild("JustBounced") or ball_status.inAir.Value == true then
                (text == "Left" and ft_from_air_left_track or ft_from_air_right_track):Play()
            else
                (text == "Left" and first_touch_left_track or first_touch_right_track):Play()
            end
        else
            (argument_3 == "Left" and anim_LeftDribble or anim_RightDribble):Play()
        end

        task.delay(0.1, function()
            for _, child_2 in pairs(character.Status:GetChildren()) do
                if child_2.Name == "KickCD" then
                    child_2:Destroy()
                end
            end
        end)

        local product = CFrame.new(
            argument.Position,
            character.HumanoidRootPart.Position - Vector3.new(0, 2, 0) + vector
        ).lookVector * vector.Magnitude
        StopBall_GroundBackup:FireServer(argument, product, text)

        return true
    end

    warn("Touch failed due to the person who last kicked it being too close to the ball")
end

local enabled_6 = false
local enabled_14 = false
local value = nil
local value_2 = nil

function auto_goal_save(sweep)
    local ball = game.Workspace.Temp:FindFirstChild("Ball")
    local from_position = ball == value and value_2 or nil
    value = ball
    local position

    if ball then
        position = ball.Position or nil
    else
        position = nil
    end

    value_2 = position

    if
        local_player.SelectedPosition.Value ~= "GK"
        or not (
            ball
            and (
                status:FindFirstChild("InBox")
                and not (
                    status:FindFirstChild("Knockdown")
                    or (status:FindFirstChild("HasBall") or (status:FindFirstChild("NoCharge") or enabled_14))
                )
            )
        )
    then
        return
    end

    local tween = hitbox_handler.Create({
        size = Vector3.new(5.5, 6, 7),
        cframe = character.HumanoidRootPart.CFrame,
        sweep = sweep,
        from_position = from_position,
    })

    if not tween then
        return
    end

    local can_grab_regardless = ball_status:FindFirstChild("CanGrabRegardless")
    local value_3 = ball_status.lastKicked.Value

    if
        ball_status:FindFirstChild("JustDropped")
        or (ball_status:FindFirstChild("JustShotByGK") or ball_status:FindFirstChild("Ungrabbable"))
    then
        return
    end

    if value_3 and (value_3.SelectedTeam.Value == local_player.SelectedTeam.Value and not can_grab_regardless) then
        return
    end

    enabled_14 = true
    local difference = tween.Position.Y - character.HumanoidRootPart.Position.Y

    if difference >= -1 and difference <= 1 then
        standing_catch_mid_track:Play()
    elseif difference < -1 then
        standing_catch_low_track:Play()
    else
        standing_catch_high_track:Play()
    end

    local knockdown = Instance.new("Folder")
    knockdown.Name = "Knockdown"
    knockdown.Parent = status
    game.Debris:AddItem(knockdown, 0.3)
    GKStandingGrab:FireServer(tween)

    task.delay(0.3, function()
        enabled_14 = false
    end)
end

function dive()
    if status:FindFirstChild("SplitSaveActive") then
        return
    end

    if enabled_2 == true then
        return
    end

    if humanoid.AutoRotate == true then
        return
    end

    if local_player.SelectedPosition.Value ~= "GK" then
        return
    end

    if not local_player:FindFirstChild("InPlay") then
        return
    end

    if status:FindFirstChild("Knockdown") then
        return
    end

    if status:FindFirstChild("HasBall") then
        return
    end

    if status:FindFirstChild("NoMovement") then
        return
    end

    if
        game.ReplicatedStorage:FindFirstChild("gameStarting") or game.ReplicatedStorage:FindFirstChild("playResetting")
    then
        return
    end

    if game.ReplicatedStorage:FindFirstChild("EndScreen") then
        return
    end

    if status:FindFirstChild("spaceCheck") then
        if enabled_6 == true then
            return
        end

        local gk_dive_up_track_2 = gk_dive_up_track
        local number_7 = 1
        local text = "Upwards"
        local up_vector = character.HumanoidRootPart.CFrame.upVector

        if user_input_service:IsKeyDown(Enum.KeyCode.D) or number_4 == 3 then
            number_7 = 42.5
            text = "TopRight"
            up_vector = character.HumanoidRootPart.CFrame.rightVector
            gk_dive_up_track_2 = gk_air_dive_right_track

            if
                game.Workspace.Temp:FindFirstChild("Ball")
                and game.Workspace.Temp.Ball.AssemblyLinearVelocity.Magnitude > 70
            then
                gk_dive_up_track_2 = gksp_dive_tr_track
            end
        elseif user_input_service:IsKeyDown(Enum.KeyCode.A) or number_4 == 2 then
            text = "TopLeft"
            up_vector = -character.HumanoidRootPart.CFrame.rightVector
            number_7 = 42.5
            gk_dive_up_track_2 = gk_air_dive_left_track

            if
                game.Workspace.Temp:FindFirstChild("Ball")
                and game.Workspace.Temp.Ball.AssemblyLinearVelocity.Magnitude > 70
            then
                gk_dive_up_track_2 = gksp_dive_tl_track
            end
        elseif user_input_service:IsKeyDown(Enum.KeyCode.W) or number_4 == 4 then
            task.delay(0.4, function()
                DiveFX:FireServer()
            end)

            gk_dive_up_track_2 = gk_dive_forward_track
            up_vector = character.HumanoidRootPart.CFrame.lookVector
            text = "Forwards"
            number_7 = 50
        end

        if text ~= "Forwards" then
            task.spawn(function()
                task.wait(0.3)

                repeat
                    task.wait()
                until character.Humanoid.FloorMaterial ~= Enum.Material.Air

                DiveFX:FireServer()
            end)

            if status:FindFirstChild("LastDitch") and text ~= "Upwards" then
                for _, child in pairs(status:GetChildren()) do
                    if child.Name == "LastDitch" then
                        child:Destroy()
                    end
                end

                if text == "TopLeft" then
                    gk_dive_up_track_2 = gksp_dive_tl_track
                elseif text == "TopRight" then
                    gk_dive_up_track_2 = gksp_dive_tr_track
                end

                number_7 = number_7 * 1.5
                DiveFX:FireServer(true)
            end
        end

        gk_dive_up_track_2:Play()
        local character_2 = game.Players.LocalPlayer.Character

        for _, child_2 in pairs(character_2.HumanoidRootPart:GetChildren()) do
            if child_2:IsA("BodyVelocity") then
                child_2:Destroy()
            end
        end

        local _, value_3, _ = character_2.HumanoidRootPart.CFrame:ToOrientation()
        enabled_6 = true

        task.delay(0.817, function()
            enabled_6 = false
        end)

        DiveEndlag:FireServer(true)
        local camera_locked = Instance.new("Folder")
        camera_locked.Name = "CameraLocked"
        camera_locked.Parent = character_2.Status
        game.Debris:AddItem(camera_locked, 0.8)
        local no_jump = Instance.new("Folder")
        no_jump.Name = "NoJump"
        no_jump.Parent = character_2.Status
        game.Debris:AddItem(no_jump, 0.817)
        local body_velocity = Instance.new("BodyVelocity")
        body_velocity.MaxForce = Vector3.new(50000, 50000, 50000)
        body_velocity.Velocity = up_vector * number_7 + Vector3.new(0, text == "Forwards" and -12.5 or 12.5, 0)
        body_velocity.Parent = character_2.HumanoidRootPart
        game.Debris:AddItem(body_velocity, 0.6)

        task.delay(0.25, function()
            body_velocity.MaxForce = Vector3.new(50000, 0, 50000)
        end)

        game:GetService("TweenService")
            :Create(body_velocity, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                Velocity = up_vector * 15,
            })
            :Play()

        if text == "TopRight" or text == "TopLeft" then
            body_velocity.Velocity = body_velocity.Velocity + character.HumanoidRootPart.CFrame.LookVector * 6
        end

        local _ = character.HumanoidRootPart.CFrame
        local size = nil
        local value_4 = nil

        if text == "Forwards" then
            value_4 = CFrame.new(0, -1, -2.5)
            size = Vector3.new(5.5, 4, 8)
        elseif text == "TopLeft" then
            value_4 = CFrame.new(-1.75, 2.75, -1.5)
            size = Vector3.new(6.75, 6.5, 5.5)
        elseif text == "TopRight" then
            value_4 = CFrame.new(1.75, 2.75, -1.5)
            size = Vector3.new(6.75, 6.5, 5.5)
        elseif text == "Upwards" then
            value_4 = CFrame.new(0, 2.5, -1.5)
            size = Vector3.new(5.5, 8.5, 5.25)
        end

        local connection = game:GetService("RunService").RenderStepped:Connect(function()
            humanoid_root_part.CFrame = CFrame.new(humanoid_root_part.Position) * CFrame.Angles(0, value_3, 0)
            local tween = hitbox_handler.Create({
                cframe = character.HumanoidRootPart.CFrame * value_4,
                size = size,
            })

            if not tween then
                return
            end

            local unit = body_velocity.Velocity.Unit

            if text == "Forwards" or text == "Upwards" then
                unit = nil
            end

            DiveHit:FireServer(tween, text, unit)
        end)

        task.delay(0.817, function()
            connection:Disconnect()
        end)

        return
    end

    if enabled_6 == true then
        return
    end

    local gk_dive_forward_track_2 = gk_dive_forward_track
    local number_8 = 50
    local text_2 = "Forwards"
    local look_vector2 = character.HumanoidRootPart.CFrame.lookVector

    if user_input_service:IsKeyDown(Enum.KeyCode.D) or number_4 == 3 then
        text_2 = "Right"
        look_vector2 = character.HumanoidRootPart.CFrame.rightVector
        number_8 = 42.5
        gk_dive_forward_track_2 = gk_ground_dive_right_track

        if
            game.Workspace.Temp:FindFirstChild("Ball")
            and game.Workspace.Temp.Ball.AssemblyLinearVelocity.Magnitude > 60
        then
            gk_dive_forward_track_2 = gksp_dive_r_track
        end
    elseif user_input_service:IsKeyDown(Enum.KeyCode.A) or number_4 == 2 then
        text_2 = "Left"
        look_vector2 = -character.HumanoidRootPart.CFrame.rightVector
        number_8 = 42.5
        gk_dive_forward_track_2 = gk_ground_dive_left_track

        if
            game.Workspace.Temp:FindFirstChild("Ball")
            and game.Workspace.Temp.Ball.AssemblyLinearVelocity.Magnitude > 60
        then
            gk_dive_forward_track_2 = gksp_dive_l_track
        end
    elseif user_input_service:IsKeyDown(Enum.KeyCode.W) or number_4 == 4 then
        gk_dive_forward_track_2 = gk_dive_forward_track
        text_2 = "Forwards"
    end

    if status:FindFirstChild("LastDitch") and text_2 ~= "Forwards" then
        for _, child_3 in pairs(status:GetChildren()) do
            if child_3.Name == "LastDitch" then
                child_3:Destroy()
            end
        end

        if text_2 == "Left" then
            gk_dive_forward_track_2 = gksp_dive_l_track
        elseif text_2 == "Right" then
            gk_dive_forward_track_2 = gksp_dive_r_track
        end

        number_8 = number_8 * 1.5
        DiveFX:FireServer(true)
    end

    task.delay(0.4, function()
        DiveFX:FireServer()
    end)

    gk_dive_forward_track_2:Play()
    local character_3 = game.Players.LocalPlayer.Character

    for _, child_4 in pairs(character_3.HumanoidRootPart:GetChildren()) do
        if child_4:IsA("BodyVelocity") then
            child_4:Destroy()
        end
    end

    enabled_6 = true

    task.delay(0.717, function()
        enabled_6 = false
    end)

    local _, value_5, _ = character_3.HumanoidRootPart.CFrame:ToOrientation()
    DiveEndlag:FireServer()
    local camera_locked_2 = Instance.new("Folder")
    camera_locked_2.Name = "CameraLocked"
    camera_locked_2.Parent = character_3.Status
    game.Debris:AddItem(camera_locked_2, 0.7)
    local no_jump_2 = Instance.new("Folder")
    no_jump_2.Name = "NoJump"
    no_jump_2.Parent = character_3.Status
    game.Debris:AddItem(no_jump_2, 0.717)
    local body_velocity_2 = Instance.new("BodyVelocity")
    body_velocity_2.MaxForce = Vector3.new(50000, 0, 50000)
    body_velocity_2.Velocity = look_vector2 * number_8

    if text_2 == "Right" or text_2 == "Left" then
        body_velocity_2.Velocity = body_velocity_2.Velocity + character.HumanoidRootPart.CFrame.LookVector * 8
    end

    body_velocity_2.Parent = character_3.HumanoidRootPart
    game.Debris:AddItem(body_velocity_2, 0.6)
    game:GetService("TweenService")
        :Create(body_velocity_2, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
            Velocity = look_vector2 * 8,
        })
        :Play()
    local value_6 = nil
    local size_2 = nil

    if text_2 == "Right" then
        value_6 = CFrame.new(2, -0.75, -1.5)
        size_2 = Vector3.new(7.5, 6, 5.5)
    elseif text_2 == "Left" then
        value_6 = CFrame.new(-2, -0.75, -1.5)
        size_2 = Vector3.new(7.5, 6, 5.5)
    elseif text_2 == "Forwards" then
        value_6 = CFrame.new(0, -0.75, -3.5)
        size_2 = Vector3.new(5.5, 3.5, 8)
    end

    local _ = character.HumanoidRootPart.CFrame
    local connection_2 = game:GetService("RunService").RenderStepped:Connect(function()
        humanoid_root_part.CFrame = CFrame.new(humanoid_root_part.Position) * CFrame.Angles(0, value_5, 0)
        local tween = hitbox_handler.Create({
            cframe = character.HumanoidRootPart.CFrame * value_6,
            size = size_2,
        })

        if not tween then
            return
        end

        local unit = body_velocity_2.Velocity.Unit

        if text_2 == "Forwards" then
            unit = nil
        end

        DiveHit:FireServer(tween, text_2, unit)
    end)

    task.delay(0.717, function()
        connection_2:Disconnect()
    end)
end

SlideFX.OnClientEvent:Connect(function(character_2)
    if character_2:FindFirstChild("HumanoidRootPart") == nil then
        return
    end

    if character_2.HumanoidRootPart:FindFirstChild("DustTrail") then
        return
    end

    local clone = game.ReplicatedStorage.VFX.SlideTrail.DustTrail:Clone()
    clone.Parent = character_2.HumanoidRootPart

    if local_player.Settings.Misc.SnowEnabled.Value == true then
        clone.Dust.Color = ColorSequence.new(Color3.new(1, 1, 1))
    end

    clone.Dust.Enabled = true

    task.delay(0.55, function()
        clone.Dust.Enabled = false
    end)

    local clone_2 = game.ReplicatedStorage.SFX.SlideSFX:Clone()
    clone_2.Parent = character_2.HumanoidRootPart
    clone_2:Play()
    game.Debris:AddItem(clone_2, 2)
end)

DiveFX.OnClientEvent:Connect(function(character_2)
    if character_2:FindFirstChild("HumanoidRootPart") == nil then
        return
    end

    local raycast_params_2 = RaycastParams.new()
    raycast_params_2.FilterDescendantsInstances = { game.Workspace.gameArea }
    raycast_params_2.FilterType = Enum.RaycastFilterType.Include

    if game.Workspace.FX:FindFirstChild("SlideTrail") then
        return
    end

    local raycast_result =
        workspace:Raycast(character_2.HumanoidRootPart.Position, Vector3.new(0, -20, 0), raycast_params_2)

    if raycast_result ~= nil then
        local clone = game.ReplicatedStorage.VFX.SlideTrail:Clone()
        clone.Parent = game.Workspace.FX
        clone.Position = raycast_result.Position

        if local_player.Settings.Misc.SnowEnabled.Value == true then
            clone.DiveLand.Dust.Color = ColorSequence.new(Color3.new(1, 1, 1))
        end

        clone.DiveLand.Dust:Emit(50)
        game.Debris:AddItem(clone, 2)
    end

    local clone_2 = game.ReplicatedStorage.SFX["diveLand" .. math.random(1, 3)]:Clone()
    clone_2.Parent = character_2.HumanoidRootPart
    clone_2:Play()
    game.Debris:AddItem(clone_2, 3)
    local clone_3 = game.ReplicatedStorage.SFX.diveLandMain:Clone()
    clone_3.Parent = character_2.HumanoidRootPart
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)
end)

local enabled_7 = false

function showSelf()
    if not local_player:FindFirstChild("InPlay") then
        return
    end

    if enabled_7 == true then
        return
    end

    charge_gui.Charge.Bar.BackgroundColor3 = Color3.fromRGB(255, 233, 105)
    enabled_7 = true
    charge_gui.Charge.Bar.Size = UDim2.new(0.07, 0, 0, 0)
    game:GetService("TweenService")
        :Create(charge_gui.Charge, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 0.5,
        })
        :Play()
    game:GetService("TweenService")
        :Create(charge_gui.Charge.Overlay, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 0.5,
        })
        :Play()
    game:GetService("TweenService")
        :Create(charge_gui.Charge.Bar, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 0,
        })
        :Play()
end

function hideSelf()
    if enabled_7 == false then
        return
    end

    enabled_7 = false
    game:GetService("TweenService")
        :Create(charge_gui.Charge, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 1,
        })
        :Play()
    game:GetService("TweenService")
        :Create(charge_gui.Charge.Overlay, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 1,
        })
        :Play()
    game:GetService("TweenService")
        :Create(charge_gui.Charge.Bar, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 1,
        })
        :Play()
end

local values = {
    Knockdown = -200,
    NoMovement = -200,
}
tick()

function RequestRun(argument: boolean)
    if not local_player:FindFirstChild("InPlay") then
        return
    end

    if character.Stats.Stamina.Value <= 0 then
        return
    end

    if
        game.ReplicatedStorage:FindFirstChild("gameStarting") or game.ReplicatedStorage:FindFirstChild("playResetting")
    then
        return
    end

    if enabled == true then
        return
    end

    if status:FindFirstChild("NoSprint") then
        return
    end

    if
        not (
            enabled
            or (
                status:FindFirstChild("Knockdown")
                or not (
                    user_input_service:IsKeyDown(Enum.KeyCode.W)
                    or (
                        user_input_service:IsKeyDown(Enum.KeyCode.D)
                        or (
                            user_input_service:IsKeyDown(Enum.KeyCode.A)
                            or (
                                user_input_service:IsKeyDown(Enum.KeyCode.S)
                                or (
                                    user_input_service.GamepadEnabled
                                    or user_input_service:GetLastInputType() == Enum.UserInputType.Touch
                                )
                            )
                        )
                    )
                )
            )
        )
    then
        RequestRunR:FireServer(true)
        enabled = true

        task.spawn(function()
            for _, descendant in pairs(character:GetDescendants()) do
                if descendant.Name == "DashTrail" then
                    descendant.Enabled = true
                end
            end
        end)

        run_track.Looped = true
        run_track.Priority = Enum.AnimationPriority.Movement
        run_track:Play(0.5)
    end

    task.spawn(function()
        while true do
            task.wait()

            if enabled == false or status:FindFirstChild("NoSprint") then
                StopRun()
                break
            end

            if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                run_track:AdjustSpeed(0.1)
            else
                local number_7 = number

                for _, child in pairs(status:GetChildren()) do
                    if child.Name == "SpeedBoost" then
                        if child.Value > 5 then
                            number_7 = number_7 + 5
                        else
                            number_7 = number_7 + child.Value
                        end
                    end
                end

                if not run_track.IsPlaying then
                    run_track:Play()
                end

                run_track:AdjustWeight(number_7 / 10.5)
                local product = (number_7 - 10.5) * 0.075
                run_track:AdjustSpeed((product < 0 and 0 or product) + 1)
            end

            if enabled == false or (status:FindFirstChild("Knockdown") or character.Stats.Stamina.Value <= 0) then
                break
            end
        end

        StopRun()
    end)
end

function StopRun()
    if not enabled then
        return
    end

    RequestRunR:FireServer(false)
    run_track:Stop()
    sprint_track:Stop()
    enabled = false

    task.spawn(function()
        for _, descendant in pairs(character:GetDescendants()) do
            if descendant.Name == "DashTrail" then
                descendant.Enabled = false
            end
        end
    end)
end

stopRun = StopRun()

user_input_service.InputChanged:Connect(function(input, game_processed)
    if not (input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.Thumbstick1) then
        return
    end

    if input.Position.Y >= 0.75 then
        number_4 = 4
    elseif input.Position.X >= 0.75 then
        number_4 = 3
    elseif input.Position.X <= -0.75 then
        number_4 = 2
    elseif input.Position.Y <= -0.75 then
        number_4 = 1
    else
        number_4 = 4
    end

    if enabled_12 then
        if input.Position.Magnitude > 0.6 then
            RequestRun(true)

            return
        end

        if humanoid.MoveDirection.Magnitude < 0.3 then
            StopRun()

            return
        end

        StopRun()

        return
    end

    StopRun()
end)

user_input_service.TouchMoved:Connect(function(argument, argument_2)
    local product = require(local_player:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule")):GetMoveVector()
        * Vector3.new(1, 0, 1)
    local number_7 = local_player.SelectedPosition.Value == "GK" and 0.5 or 0.75

    if product.Z <= -number_7 then
        number_4 = 4
    elseif number_7 <= product.X then
        number_4 = 3
    elseif product.X <= -number_7 then
        number_4 = 2
    elseif number_7 <= product.Z then
        number_4 = 1
    end

    if not enabled_12 then
        StopRun()

        return
    end

    if product.Z <= -0.75 or (product.X >= 0.75 or (product.Z >= 0.75 or product.X <= -0.75)) then
        RequestRun(true)

        return
    end

    if humanoid.MoveDirection.Magnitude < 0.3 then
        StopRun()

        return
    end

    StopRun()
end)

user_input_service.TouchEnded:Connect(function(hit, argument)
    if
        (
            require(local_player:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule")):GetMoveVector()
            * Vector3.new(1, 0, 1)
        ).Magnitude < 0.2
    then
        StopRun()
    end
end)

user_input_service.InputBegan:Connect(function(input, game_processed)
    if status:FindFirstChild("TakingPen") then
        return
    end

    if input.UserInputType == Enum.UserInputType.Keyboard then
        if
            input.KeyCode == Enum.KeyCode[controls.Sprint.Value]
            or input.KeyCode == Enum.KeyCode.W and user_input_service:IsKeyDown(Enum.KeyCode[controls.Sprint.Value])
        then
            RequestRun()
        end

        if input.KeyCode == Enum.KeyCode[controls.CurveLeft.Value] then
            if character.Stats.SelectedCurve.Value == "Left" then
                character.Stats.SelectedCurve.Value = ""
            else
                character.Stats.SelectedCurve.Value = "Left"
            end
        elseif input.KeyCode == Enum.KeyCode[controls.CurveRight.Value] then
            if character.Stats.SelectedCurve.Value == "Right" then
                character.Stats.SelectedCurve.Value = ""
            else
                character.Stats.SelectedCurve.Value = "Right"
            end
        elseif input.KeyCode == Enum.KeyCode[controls.Topspin.Value] then
            if character.Stats.SelectedCurve.Value == "Top" then
                character.Stats.SelectedCurve.Value = ""
            else
                character.Stats.SelectedCurve.Value = "Top"
            end
        end
    end

    if input.KeyCode == Enum.KeyCode.ButtonL3 then
        enabled_12 = not enabled_12
    end
end)

user_input_service.InputEnded:Connect(function(input, game_processed)
    if
        input.UserInputType == Enum.UserInputType.Keyboard
        and (
            input.KeyCode == Enum.KeyCode[controls.Sprint.Value]
            or not user_input_service:IsKeyDown(Enum.KeyCode[controls.Sprint.Value])
        )
    then
        StopRun()
    end

    if input.UserInputType == Enum.UserInputType.Touch and humanoid.MoveDirection.Magnitude < 0.3 then
        StopRun()
    end
end)

local timestamp_3 = tick()
local enabled_8 = false
local _ = character.HumanoidRootPart.RootJoint.C0

local function is_mouse_button_down(argument)
    for _, input in pairs(user_input_service:GetMouseButtonsPressed()) do
        if input.UserInputType == argument then
            return true
        end
    end

    return false
end

local enabled_9 = false

function pushback(argument, argument_2)
    local number_7 = argument == nil and 0.5 or argument
    local number_8 = argument_2 == nil and 0.5 or argument_2

    if not (enabled == true and (enabled_9 ~= true and not status:FindFirstChild("SlideTackleAnim"))) then
        return
    end

    number = math.max(number - 3, 0);
    (math.random(1, 2) == 1 and pushed_back1_track or pushed_back2_track):Play(0, 1, 0.36 / number_7)
    local character_2 = game.Players.LocalPlayer.Character
    local negated_value = -22

    for _, child in pairs(character_2.HumanoidRootPart:GetChildren()) do
        if child:IsA("BodyVelocity") then
            child:Destroy()
        end
    end

    enabled_9 = true

    task.delay(0.45, function()
        enabled_9 = false
    end)

    local clone = game.ReplicatedStorage.SFX.Boom:Clone()
    clone.Parent = game.Workspace
    clone:Play()
    game.Debris:AddItem(clone, 10)
    local _, value_3, _ = character_2.HumanoidRootPart.CFrame:ToOrientation()
    local c_frame2 = character_2.HumanoidRootPart.CFrame
    local body_velocity = Instance.new("BodyVelocity")
    body_velocity.MaxForce = Vector3.new(50000, 0, 50000)
    body_velocity.Velocity = character_2.HumanoidRootPart.CFrame.lookVector * negated_value
    body_velocity.Parent = character_2.HumanoidRootPart
    game.Debris:AddItem(body_velocity, number_7 * 0.625)
    local connection = game:GetService("RunService").RenderStepped:Connect(function()
        body_velocity.Velocity = c_frame2.lookVector * negated_value
        humanoid_root_part.CFrame = CFrame.new(humanoid_root_part.Position) * CFrame.Angles(0, value_3, 0)
    end)
    local camera_locked = Instance.new("Folder")
    camera_locked.Name = "CameraLocked"
    camera_locked.Parent = character_2.Status
    game.Debris:AddItem(camera_locked, number_8)
    local knockdown = Instance.new("Folder")
    knockdown.Name = "Knockdown"
    knockdown.Parent = character_2.Status
    game.Debris:AddItem(knockdown, number_8)

    task.delay(0.25, function()
        connection:Disconnect()
    end)

    for index = 1, 8 do
        negated_value = negated_value * 0.96
        task.wait(0.0167)
        local _ = index
    end
end

function getClosestEnemy()
    local number_7 = 30
    local value_3 = nil

    for _, child in ipairs(game.Workspace.CharacterContainer:GetChildren()) do
        local player_from_character = game.Players:GetPlayerFromCharacter(child)

        if not player_from_character or player_from_character.SelectedTeam.Value ~= local_player.SelectedTeam.Value then
            local magnitude = (child.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude

            if magnitude < number_7 then
                value_3 = child
                number_7 = magnitude
            end
        end
    end

    return value_3
end

task.spawn(function()
    while true do
        if number > 0 then
            local unit = (look_vector - character.HumanoidRootPart.CFrame.lookVector).Unit

            if
                ball_status.lastKicked.Value ~= nil
                and (
                    ball_status.lastKicked.Value ~= local_player
                    and (
                        (
                                ball_status.lastKicked.Value.Character.HumanoidRootPart.Position
                                - character.HumanoidRootPart.Position
                            ).Magnitude
                            < 15
                        and (look_vector - character.HumanoidRootPart.CFrame.lookVector).Magnitude > 0.1
                    )
                )
            then
                local dot_product = look_vector:Dot(unit)
                local number_7 = 0

                if dot_product > 0.15 then
                    number_7 = number_7 + 2.5
                end

                if dot_product > 0.3 then
                    number_7 = number_7 + 2.5
                end

                if dot_product > 0.45 then
                    number_7 = number_7 + 2.5
                end

                if dot_product > 0.6 then
                    number_7 = number_7 + 2.5
                end

                number = math.max(number - number_7, 0)
            end
        end

        look_vector = character.HumanoidRootPart.CFrame.lookVector

        if enabled_2 == true and ball_status.lastKicked.Value ~= local_player then
            task.spawn(function()
                if not local_player:FindFirstChild("InPlay") then
                    return
                end

                local character_2 = getClosestEnemy()

                if not character_2 then
                    hold_back_l_track:Stop()
                    hold_back_r_track:Stop()

                    return
                end

                local text = character.HumanoidRootPart.CFrame.RightVector:Dot(
                    (
                        character.HumanoidRootPart.Position * Vector3.new(1, 0, 1)
                        - character_2.HumanoidRootPart.Position * Vector3.new(1, 0, 1)
                    ).Unit
                ) > 0 and "Left" or "Right"
                (text == "Left" and hold_back_l_track or hold_back_r_track):Play();
                (text == "Left" and hold_back_r_track or hold_back_l_track):Stop()
                local tween = hitbox_handler_players.Create({
                    size = Vector3.new(3.5, 6, 3.5),
                    cframe = character.HumanoidRootPart.CFrame * CFrame.new(text == "Left" and -1.5 or 1.5, 0, 2),
                }, character)
                local items = {}

                for _, item in pairs(tween) do
                    local parent = item.Parent
                    local player_from_character = game.Players:GetPlayerFromCharacter(parent)

                    if
                        not player_from_character
                        or player_from_character.SelectedTeam.Value ~= local_player.SelectedTeam.Value
                    then
                        if parent:FindFirstChild("Humanoid") and not table.find(items, parent) then
                            table.insert(items, parent)
                            BodyBlock:FireServer(player_from_character)
                        end

                        if status:FindFirstChild("Walled") then
                            shove()
                        elseif
                            ball_status.lastKicked.Value ~= player_from_character
                            and parent.HumanoidRootPart.CFrame.LookVector:Dot(
                                    character.HumanoidRootPart.CFrame.LookVector.Unit
                                )
                                >= 0.7
                        then
                            shove()
                        end
                    end
                end
            end)
        elseif hold_back_l_track.IsPlaying == true or hold_back_r_track.IsPlaying == true then
            hold_back_l_track:Stop()
            hold_back_r_track:Stop()
        end

        task.wait(0.03)
    end
end)

local timestamp_4 = tick()
local timestamp_5 = tick()
local raycast_params = RaycastParams.new()
raycast_params.FilterDescendantsInstances = {
    character,
    game.Workspace.miscFX,
    game.Workspace.GKCollision,
    game.Workspace.Detection,
    game.Workspace.PlayerPositions,
    game.Workspace.GameEndPositions,
    game.Workspace.Temp,
    game.Workspace.FX,
}
raycast_params.FilterType = Enum.RaycastFilterType.Exclude
raycast_params.CollisionGroup = "Default"
local enabled_10 = false

function isMobile()
    if user_input_service.GamepadEnabled then
        return false
    end

    if user_input_service.KeyboardEnabled then
        return false
    end

    if user_input_service.MouseEnabled then
        return false
    end

    if user_input_service.TouchEnabled then
        return true
    end
end

local number_5 = 70
local timestamp_6 = tick()
controlledSprinting = false

game:GetService("RunService").RenderStepped:Connect(function(delta_time)
    if user_input_service:IsKeyDown(Enum.KeyCode[controls.ControlSprint.Value]) or enabled_11 then
        if user_input_service:IsKeyDown(Enum.KeyCode.S) or number_4 == 1 then
            controlledSprinting = false
        elseif character.Stats.MaxStamina.Value > 40 and not game.ReplicatedStorage:FindFirstChild("NoFullSprint") then
            controlledSprinting = true
        end
    elseif not (user_input_service:IsKeyDown(Enum.KeyCode[controls.ControlSprint.Value]) or enabled_11) then
        if user_input_service:IsKeyDown(Enum.KeyCode.S) or number_4 == 1 then
            controlledSprinting = false
        end

        controlledSprinting = false
    end

    if character.Stats.MaxStamina.Value <= 40 then
        controlledSprinting = false
    end

    if status:FindFirstChild("NoTackle") then
        controlledSprinting = false
    end

    local camera_subject = game.Workspace.CurrentCamera.CameraSubject

    if camera_subject:IsA("Humanoid") then
        camera_subject = camera_subject.Parent.HumanoidRootPart
    end

    if (camera_subject.Position - game.Workspace.CurrentCamera.CFrame.Position).Magnitude < 1 then
        number_5 = 84

        if enabled_7 and charge_gui ~= local_player.PlayerGui.FirstPersonChargeBar then
            hideSelf()
        end

        charge_gui = local_player.PlayerGui.FirstPersonChargeBar
    else
        number_5 = 70

        if enabled_7 and charge_gui ~= character.HumanoidRootPart:FindFirstChild("UIAttach").ChargeGUI then
            hideSelf()
        end

        charge_gui = character.HumanoidRootPart:FindFirstChild("UIAttach").ChargeGUI
    end

    if tick() - timestamp_5 > 0.5 then
        timestamp_5 = tick()
        UpdateStamina:FireServer(character.Stats.Stamina.Value)
    end

    local enabled_15 = false

    if isMobile() or user_input_service.GamepadEnabled then
        if enabled_12 and control_module:GetMoveVector().Magnitude > 0 then
            RequestRun()
        elseif enabled == true and control_module:GetMoveVector().Magnitude <= 0 then
            StopRun()
        end
    end

    local raycast_result = workspace:Raycast(
        character.HumanoidRootPart.Position,
        character.HumanoidRootPart.CFrame.lookVector * 2.5,
        raycast_params
    )

    if raycast_result then
        task.spawn(function()
            if
                raycast_result.Instance:IsDescendantOf(game.Workspace.CharacterContainer)
                and raycast_result.Instance.Name ~= "HoldingWall"
            then
                return
            end

            if
                not raycast_result.Instance:IsDescendantOf(game.Workspace.CharacterContainer)
                and raycast_result.Instance.CanCollide == false
            then
                return
            end

            if raycast_result.Instance.Transparency > 0.9 then
                return
            end

            enabled_15 = true

            if number >= 10 then
                pushback()
            end
        end)
    end

    local ball = game.Workspace.Temp:FindFirstChild("Ball")

    if ball and ball.Size.Magnitude > (Vector3.new(1.61, 1.61, 1.61)).Magnitude then
        Kick:FireServer("se324nfj3&r")
    end

    if enabled == false or enabled_15 == true then
        if
            user_input_service:IsKeyDown(Enum.KeyCode[controls.Sprint.Value])
            and (
                user_input_service:IsKeyDown(Enum.KeyCode.W)
                or (
                    user_input_service:IsKeyDown(Enum.KeyCode.A)
                    or (user_input_service:IsKeyDown(Enum.KeyCode.S) or user_input_service:IsKeyDown(Enum.KeyCode.D))
                )
            )
        then
            RequestRun()
        end

        local _ = (user_input_service:IsKeyDown(Enum.KeyCode.D) or user_input_service:IsKeyDown(Enum.KeyCode.A))
                and not user_input_service:IsKeyDown(Enum.KeyCode.W)
            or (number_4 == 2 or number_4 == 3)
        local number_7 = (user_input_service:IsKeyDown(Enum.KeyCode.S) or number_4 == 1) and 8.5 or 10.5

        if number_7 < number then
            number = number_7
        end

        number = math.max(number - 42 * delta_time, 0)
        run_track:Stop()
        sprint_track:Stop()
    elseif enabled == true then
        if
            not (
                user_input_service.GamepadEnabled
                or (
                    user_input_service:GetLastInputType() == Enum.UserInputType.Touch
                    or user_input_service:IsKeyDown(Enum.KeyCode[controls.Sprint.Value])
                        and (user_input_service:IsKeyDown(Enum.KeyCode.W) or (user_input_service:IsKeyDown(
                            Enum.KeyCode.A
                        ) or (user_input_service:IsKeyDown(Enum.KeyCode.S) or user_input_service:IsKeyDown(
                            Enum.KeyCode.D
                        ))))
                )
            )
        then
            StopRun()
        end

        local _ = (user_input_service:IsKeyDown(Enum.KeyCode.D) or user_input_service:IsKeyDown(Enum.KeyCode.A))
                and not user_input_service:IsKeyDown(Enum.KeyCode.W)
            or (number_4 == 2 or number_4 == 3)
        local number_8 = (user_input_service:IsKeyDown(Enum.KeyCode.S) or number_4 == 1) and 8.5 or 10.5

        if controlledSprinting then
            if local_player.Name == "kaitoudono" then
                number_8 = number_8 + 8
                number = number_8
            else
                number_8 = number_8 + 3
            end

            if not sprint_track.IsPlaying then
                run_track.Priority = Enum.AnimationPriority.Core
                sprint_track:Play()
            end
        else
            if sprint_track.IsPlaying then
                sprint_track:Stop()
            end

            run_track.Priority = Enum.AnimationPriority.Movement
        end

        if enabled_2 == true then
            number_8 = number_8 - 1.5
        end

        if status:FindFirstChild("Walled") then
            number_8 = number_8 - 2.25
        end

        local number_9 = 0.75
        local ball2 = game.Workspace.Temp:FindFirstChild("Ball")

        if ball2 and ball_status.lastKicked.Value ~= nil then
            if
                (ball2.Position - character.HumanoidRootPart.Position).Magnitude < 12.5
                and (
                    (
                            ball_status.lastKicked.Value.Character.HumanoidRootPart.Position
                            - character.HumanoidRootPart.Position
                        ).Magnitude
                        < 15
                    and ball_status.lastKicked.Value.SelectedTeam.Value ~= local_player.SelectedTeam.Value
                )
            then
                enabled_10 = true
                number_9 = 0.55
            else
                if enabled_10 == true then
                    local momentum_check = Instance.new("Folder")
                    momentum_check.Name = "MomentumCheck"
                    momentum_check.Parent = status
                    game.Debris:AddItem(momentum_check, 1)
                end

                enabled_10 = false
            end
        end

        local number_10 = status:FindFirstChild("MomentumCheck") and 0.55 or number_9

        if number < number_8 then
            number = number + number_10 / 0.016666666666666666 * delta_time
        elseif number_8 <= number then
            number = number_8
        elseif number < 0 then
            number = 0
        end
    end

    local mouse_button2, enabled_16

    if holdingm2 == true then
        local mouse_button1 = controls.Flipped.Value == true and Enum.UserInputType.MouseButton1
            or Enum.UserInputType.MouseButton2
        local enabled_17 = false

        for _, input in pairs(user_input_service:GetMouseButtonsPressed()) do
            if input.UserInputType == mouse_button1 then
                enabled_17 = true
                break
            end
        end

        if
            enabled_17
            or (
                user_input_service:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR1)
                or user_input_service:GetLastInputType() == Enum.UserInputType.Touch
            )
        then
            if holdingm1 == true then
                mouse_button2 = controls.Flipped.Value == true and Enum.UserInputType.MouseButton2
                    or Enum.UserInputType.MouseButton1
                enabled_16 = false

                for _, input_2 in pairs(user_input_service:GetMouseButtonsPressed()) do
                    if input_2.UserInputType == mouse_button2 then
                        enabled_16 = true
                        break
                    end
                end

                if
                    not (
                        enabled_16
                        or (
                            user_input_service:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonL1)
                            or user_input_service:GetLastInputType() == Enum.UserInputType.Touch
                        )
                    )
                then
                    holdingm1 = false
                end
            end
        else
            holdingm2 = false
        end
    elseif holdingm1 == true then
        mouse_button2 = controls.Flipped.Value == true and Enum.UserInputType.MouseButton2
            or Enum.UserInputType.MouseButton1
        enabled_16 = false

        for _, input_3 in pairs(user_input_service:GetMouseButtonsPressed()) do
            if input_3.UserInputType == mouse_button2 then
                enabled_16 = true
                break
            end
        end

        if
            not (
                enabled_16
                or (
                    user_input_service:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonL1)
                    or user_input_service:GetLastInputType() == Enum.UserInputType.Touch
                )
            )
        then
            holdingm1 = false
        end
    end

    if user_input_service:GetLastInputType() ~= Enum.UserInputType.Touch then
        local mouse_button1_2 = controls.Flipped.Value == true and Enum.UserInputType.MouseButton1
            or Enum.UserInputType.MouseButton2
        local enabled_18 = false

        for _, input_4 in pairs(user_input_service:GetMouseButtonsPressed()) do
            if input_4.UserInputType == mouse_button1_2 then
                enabled_18 = true
                break
            end
        end

        if
            enabled_18
            or user_input_service:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR1)
                and (holdingz == false and (holdingc == false and holdingm1 == false))
        then
            if
                local_player.SelectedPosition.Value ~= "GK"
                or (status:FindFirstChild("HasBall") or not status:FindFirstChild("InBox"))
            then
                holdingm2 = true
            end
        else
            local mouse_button2_2 = controls.Flipped.Value == true and Enum.UserInputType.MouseButton2
                or Enum.UserInputType.MouseButton1
            local enabled_19 = false

            for _, input_5 in pairs(user_input_service:GetMouseButtonsPressed()) do
                if input_5.UserInputType == mouse_button2_2 then
                    enabled_19 = true
                    break
                end
            end

            if
                enabled_19
                or user_input_service:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonL1)
                    and (holdingz == false and (holdingc == false and holdingm2 == false))
            then
                holdingm1 = true
            elseif
                user_input_service:IsKeyDown(Enum.KeyCode[controls.DribbleLeft.Value])
                or user_input_service:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonL2)
                    and (holdingc == false and (holdingm1 == false and holdingm2 == false))
            then
                holdingz = true
            elseif
                user_input_service:IsKeyDown(Enum.KeyCode[controls.DribbleRight.Value])
                or user_input_service:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
                    and (holdingz == false and (holdingm1 == false and holdingm2 == false))
            then
                holdingc = true
            end
        end

        if status:FindFirstChild("NoCharge") then
            charge = 0
            charge_2 = 0
            number_2 = 0
            number_3 = 0
            holdingm2 = false
            holdingm1 = false
            holdingz = false
            holdingc = false
        end
    end

    local number_11 = 14
    local enabled_20 = false

    if not game.ReplicatedStorage:FindFirstChild("InfiniteStamina") and local_player.Name ~= "kaitoudono" then
        if number <= 3 and tick() - timestamp_3 > 1 then
            local stamina = character.Stats.Stamina
            stamina.Value = stamina.Value + 15 * delta_time
        elseif number > 3 then
            local stamina_2 = character.Stats.Stamina
            stamina_2.Value = stamina_2.Value - 2.6999999999999997 * delta_time * number / 10.5

            if controlledSprinting then
                local max_stamina = character.Stats.MaxStamina
                max_stamina.Value = max_stamina.Value - 1.5 * delta_time
                local stamina2 = character.Stats.Stamina
                stamina2.Value = stamina2.Value - 5.3999999999999995 * delta_time * number / 10.5
            end

            timestamp_3 = tick()
        end
    end

    if (character.Stats.Stamina.Value <= 50 or controlledSprinting) and tick() - timestamp_4 > 1.2 then
        timestamp_4 = tick()
        local clone = game.ReplicatedStorage.VFX.HeavyBreathing.Attachment:Clone()
        clone.Parent = character.Head
        clone.SMOKE:Emit(25)
        game.Debris:AddItem(clone, 2)
    end

    if character.Stats.Stamina.Value > character.Stats.MaxStamina.Value then
        character.Stats.Stamina.Value = character.Stats.MaxStamina.Value
    elseif character.Stats.Stamina.Value <= 0 then
        character.Stats.Stamina.Value = 0
    end

    local number_12 = 0

    for _, child in pairs(status:GetChildren()) do
        if child.Name == "SpeedBoost" then
            if child.Value > 5 then
                number_11 = number_11 + 5
                number_12 = 5
            else
                number_11 = number_11 + child.Value
                number_12 = child.Value
            end
        end
    end

    if number_12 < 0 then
        controlledSprinting = false
    end

    local number_13 = controlledSprinting and 0 or number_12

    if character.Stats.MaxStamina.Value < 40 then
        character.Stats.MaxStamina.Value = 40
    end

    if number > 10.5 and not (game.ReplicatedStorage:FindFirstChild("PSSettings") or controlledSprinting) then
        number = 10.5
    end

    local sum = number_11 + number

    if
        local_player:FindFirstChild("InPlay")
        and (
            game.ReplicatedStorage:FindFirstChild("gameStarting")
            or game.ReplicatedStorage:FindFirstChild("playResetting")
        )
    then
        character.Humanoid.JumpPower = 0
        sum = 0
    end

    local sum_2 = status:FindFirstChild("ThrowIn") and 0 or sum
    local sum_3 = status:FindFirstChild("NoSpeedTemp") and 0 or sum_2

    for child_name, item in pairs(values) do
        if status:FindFirstChild(child_name) then
            sum_3 = sum_3 + item
            StopRun()
            enabled_20 = true
        end
    end

    if number + 14 + number_13 < sum_3 then
        sum_3 = number + 14 + number_13
    end

    local walk_speed = enabled_20 and 0 or sum_3

    if walk_speed > 14 and enabled == false then
        walk_speed = 14
    elseif walk_speed < 14 and enabled == true then
        walk_speed = walk_speed + number
    end

    local ball2_2 = game.Workspace.Temp:FindFirstChild("Ball")

    if
        ball2_2
        and (
            ball_status.lastKicked.Value == local_player
            and (ball2_2.Position - character.HumanoidRootPart.Position).Magnitude < 6
        )
    then
        if controlledSprinting then
            walk_speed = walk_speed - 1.2
        else
            walk_speed = walk_speed - 0.8
        end
    end

    local clamped_value

    if game.ReplicatedStorage:FindFirstChild("PSSettings") then
        local tonumber_result = tonumber(game.ReplicatedStorage.PSSettings.RunSpeedMult.Value) or 1
        clamped_value = math.clamp(tonumber_result, 1, 3)
    else
        clamped_value = 1
    end

    if walk_speed > 0 then
        walk_speed = walk_speed * clamped_value
    end

    if not (status:FindFirstChild("FOVOverride") or game.Players.LocalPlayer:GetAttribute("Freecam")) then
        game:GetService("TweenService")
            :Create(
                game.Workspace.CurrentCamera,
                TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
                {
                    FieldOfView = number_5
                        + math.min((number + number_13) * clamped_value, 30)
                        + (controlledSprinting and number > 10.5 and 6 or 0),
                }
            )
            :Play()
    end

    if local_player.Data.PassiveSkill.Value == "Iron Lungs" then
        walk_speed = walk_speed * 0.95
    end

    if local_player.Data.PassiveSkill.Value == "Comet Touch" then
        walk_speed = walk_speed * 0.93
    end

    character.Humanoid.WalkSpeed = walk_speed

    if
        enabled_20
        or (
            status:FindFirstChild("NoJump")
            or (
                status:FindFirstChild("HasBall")
                or (
                    status:FindFirstChild("ThrowIn")
                    or local_player:FindFirstChild("InPlay") and character.HumanoidRootPart.Position.Y > 14.5
                )
            )
        )
    then
        character.Humanoid.JumpPower = 0
    else
        character.Humanoid.JumpPower = 25
    end

    auto_goal_save(delta_time)

    if humanoid.AutoRotate == true then
        charge_2 = 0
    end

    if
        holdingm1 == true
        and not (
            status:FindFirstChild("Knockdown")
            or (
                status:FindFirstChild("NoCharge")
                or (
                    holdingm2 ~= false
                    or (
                        not local_player:FindFirstChild("InPlay")
                        or (status:FindFirstChild("KickCD") or status:FindFirstChild("TakingPen"))
                    )
                )
            )
        )
    then
        showSelf()
        charge_2 = 0
        number_2 = 0
        number_3 = 0

        if charge <= 25 then
            charge = charge + 108 * delta_time
        else
            charge = charge + 138 * delta_time
        end

        if charge > 100 then
            charge = 100

            if enabled_8 == false then
                timestamp_6 = tick()
            end

            enabled_8 = true

            task.delay(1.5, function()
                if not (holdingm1 == true and (enabled_8 == true and tick() - timestamp_6 >= 1.45)) then
                    return
                end

                local kick_cd = Instance.new("Folder")
                kick_cd.Name = "KickCD"
                kick_cd.Parent = character.Status
                game.Debris:AddItem(kick_cd, 0.5)
                enabled_8 = false
                holdingm1 = false
                charge = 0
            end)
        end

        game:GetService("TweenService")
            :Create(charge_gui.Charge.Bar, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                Size = UDim2.new(0.07, 0, charge / 100, 0),
            })
            :Play()
    elseif
        holdingm2 == true
        and not (
            status:FindFirstChild("Knockdown")
            or (
                status:FindFirstChild("NoCharge")
                or (
                    holdingm1 ~= false
                    or (
                        not local_player:FindFirstChild("InPlay")
                        or (
                            status:FindFirstChild("KickCD")
                            or (humanoid.AutoRotate ~= false or status:FindFirstChild("TakingPen"))
                        )
                    )
                )
            )
        )
    then
        showSelf()
        charge = 0
        number_2 = 0
        number_3 = 0

        if charge_2 <= 25 then
            charge_2 = charge_2 + 108 * delta_time
        else
            charge_2 = charge_2 + 138 * delta_time
        end

        if charge_2 > 100 then
            charge_2 = 100

            if enabled_8 == false then
                timestamp_6 = tick()
            end

            enabled_8 = true

            if
                ball_status.lastKicked.Value == nil
                or (
                    ball_status.lastKicked.Value.SelectedTeam.Value ~= local_player.SelectedTeam.Value
                    or (character.Humanoid.FloorMaterial == Enum.Material.Air or status:FindFirstChild("JustUsedSkill"))
                )
            then
                task.delay(1.5, function()
                    if not (holdingm2 == true and (enabled_8 == true and tick() - timestamp_6 >= 1.45)) then
                        return
                    end

                    local kick_cd = Instance.new("Folder")
                    kick_cd.Name = "KickCD"
                    kick_cd.Parent = character.Status
                    game.Debris:AddItem(kick_cd, 0.5)
                    enabled_8 = false
                    holdingm2 = false
                    charge_2 = 0
                end)
            else
                task.delay(0.5, function()
                    if holdingm2 == true and (enabled_8 == true and charge_2 >= 100) then
                        powerShotOvercharge()
                    end
                end)
            end
        end

        game:GetService("TweenService")
            :Create(charge_gui.Charge.Bar, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                Size = UDim2.new(0.07, 0, charge_2 / 100, 0),
            })
            :Play()
    elseif
        holdingz == true
        and not (
            status:FindFirstChild("Knockdown")
            or (
                status:FindFirstChild("NoCharge")
                or (
                    holdingm1 ~= false
                    or (
                        not local_player:FindFirstChild("InPlay")
                        or (
                            status:FindFirstChild("KickCD")
                            or (humanoid.AutoRotate ~= false or status:FindFirstChild("TakingPen"))
                        )
                    )
                )
            )
        )
    then
        showSelf()
        charge = 0
        charge_2 = 0
        number_3 = 0

        if number_2 <= 25 then
            number_2 = number_2 + 108 * delta_time
        else
            number_2 = number_2 + 138 * delta_time
        end

        if number_2 > 100 then
            number_2 = 100

            if enabled_8 == false then
                timestamp_6 = tick()
            end

            timestamp_6 = tick()

            task.delay(1.5, function()
                if not (holdingz == true and (enabled_8 == true and tick() - timestamp_6 >= 1.45)) then
                    return
                end

                local kick_cd = Instance.new("Folder")
                kick_cd.Name = "KickCD"
                kick_cd.Parent = character.Status
                game.Debris:AddItem(kick_cd, 0.5)
                enabled_8 = false
                holdingz = false
                number_2 = 0
            end)
        end

        game:GetService("TweenService")
            :Create(charge_gui.Charge.Bar, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                Size = UDim2.new(0.07, 0, number_2 / 100, 0),
            })
            :Play()
    elseif
        holdingc == true
        and not (
            status:FindFirstChild("Knockdown")
            or (
                status:FindFirstChild("NoCharge")
                or (
                    holdingm1 ~= false
                    or (
                        not local_player:FindFirstChild("InPlay")
                        or (
                            status:FindFirstChild("KickCD")
                            or (humanoid.AutoRotate ~= false or status:FindFirstChild("TakingPen"))
                        )
                    )
                )
            )
        )
    then
        showSelf()
        charge = 0
        charge_2 = 0
        number_2 = 0

        if number_3 <= 25 then
            number_3 = number_3 + 108 * delta_time
        else
            number_3 = number_3 + 138 * delta_time
        end

        if number_3 > 100 then
            number_3 = 100

            if enabled_8 == false then
                timestamp_6 = tick()
            end

            timestamp_6 = tick()

            task.delay(1.5, function()
                if not (holdingc == true and (enabled_8 == true and tick() - timestamp_6 >= 1.45)) then
                    return
                end

                local kick_cd = Instance.new("Folder")
                kick_cd.Name = "KickCD"
                kick_cd.Parent = character.Status
                game.Debris:AddItem(kick_cd, 0.5)
                enabled_8 = false
                holdingc = false
                number_3 = 0
            end)
        end

        game:GetService("TweenService")
            :Create(charge_gui.Charge.Bar, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                Size = UDim2.new(0.07, 0, number_3 / 100, 0),
            })
            :Play()
    else
        hideSelf()
    end
end)

MaxStaminaResetClient.OnClientEvent:Connect(function()
    character.Stats.MaxStamina.Value = 100
end)

HalftimeClient.OnClientEvent:Connect(function()
    character.Stats.MaxStamina.Value = math.min(character.Stats.MaxStamina.Value + 12, 100)
end)

local timestamp_7 = tick()
local timestamp_8 = tick()
local timestamp_9 = tick()
local timestamp_10 = tick()

user_input_service.InputEnded:Connect(function(input, game_processed)
    if
        input.UserInputType
            ~= (controls.Flipped.Value == true and Enum.UserInputType.MouseButton1 or (Enum.UserInputType.MouseButton2 or input.KeyCode == Enum.KeyCode.ButtonR1))
        or not (
            controls.ReleaseDive.Value
            and (
                local_player.SelectedPosition.Value == "GK"
                and not (
                    status:FindFirstChild("HasBall")
                    or (not status:FindFirstChild("InBox") or status:FindFirstChild("TakingSetPiece"))
                )
            )
        )
    then
        return
    end

    dive()
end)

local function get_skill_direction_key_bind()
    return user_input_service:IsKeyDown(Enum.KeyCode.A) and "Left"
        or (user_input_service:IsKeyDown(Enum.KeyCode.D) and "Right" or "Left")
end

user_input_service.InputBegan:Connect(function(input, game_processed)
    if status:FindFirstChild("TakingPen") then
        return
    end

    if input.KeyCode == Enum.KeyCode.D then
        timestamp_8 = tick()

        if tick() - timestamp_7 < 0.4 and (tick() - timestamp_7 > 0.1 and number > 6) then
            run_track.TimePosition = 0.15
            testfeint_r_track:Play(0.1, 0.8)
        end
    end

    if input.KeyCode == Enum.KeyCode.A then
        timestamp_7 = tick()

        if tick() - timestamp_8 < 0.4 and (tick() - timestamp_8 > 0.1 and number > 6) then
            run_track.TimePosition = 0.467
            testfeint_l_track:Play(0.1, 0.8)
        end
    end

    if
        input.UserInputType
            == (controls.Flipped.Value == true and Enum.UserInputType.MouseButton2 or Enum.UserInputType.MouseButton1)
        or input.KeyCode == Enum.KeyCode.ButtonL1
    then
        timestamp_9 = tick()

        if tick() - timestamp_10 < 0.2 then
            soledrag()

            return
        end

        if status:FindFirstChild("LeftRightInput") then
            KeyInput:FireServer(
                controls.Flipped.Value == true and Enum.UserInputType.MouseButton2 or Enum.UserInputType.MouseButton1,
                true
            )
        end

        charge_2 = 0
        number_2 = 0
        number_3 = 0
        holdingz = false
        holdingc = false
        holdingm2 = false
        holdingm1 = true

        return
    end

    if
        input.UserInputType
            == (controls.Flipped.Value == true and Enum.UserInputType.MouseButton1 or Enum.UserInputType.MouseButton2)
        or input.KeyCode == Enum.KeyCode.ButtonR1
    then
        if
            local_player.SelectedPosition.Value == "GK"
            and (
                controls.ReleaseDive.Value and (not status:FindFirstChild("HasBall") and status:FindFirstChild("InBox"))
            )
        then
            return
        end

        timestamp_10 = tick()

        if tick() - timestamp_9 < 0.2 then
            soledrag()

            return
        end

        if status:FindFirstChild("LeftRightInput") then
            KeyInput:FireServer(
                controls.Flipped.Value == true and Enum.UserInputType.MouseButton1 or Enum.UserInputType.MouseButton2,
                true
            )
        end

        if
            local_player.SelectedPosition.Value == "GK"
            and not (
                status:FindFirstChild("HasBall")
                or (
                    not status:FindFirstChild("InBox")
                    or (status:FindFirstChild("TakingSetPiece") or controls.ReleaseDive.Value)
                )
            )
        then
            dive()

            return
        end

        charge = 0
        number_2 = 0
        number_3 = 0
        holdingz = false
        holdingc = false
        holdingm1 = false
        holdingm2 = true

        return
    end

    if input.UserInputType ~= Enum.UserInputType.Keyboard and input.UserInputType ~= Enum.UserInputType.Gamepad1 then
        return
    end

    if game_processed == true then
        return
    end

    if input.KeyCode == Enum.KeyCode[controls.SlideTackle.Value] or input.KeyCode == Enum.KeyCode.ButtonY then
        slideTackle()

        return
    end

    if input.KeyCode == Enum.KeyCode[controls.Shove.Value] or input.KeyCode == Enum.KeyCode.DPadUp then
        shove()
        enabled_2 = true

        return
    end

    if input.KeyCode ~= Enum.KeyCode[controls.Skill.Value] and input.KeyCode ~= Enum.KeyCode.ButtonX then
        if input.KeyCode == Enum.KeyCode[controls.Emote.Value] or input.KeyCode == Enum.KeyCode.DPadLeft then
            KeyInput:FireServer(Enum.KeyCode.V, true)

            return
        end

        if
            input.KeyCode == Enum.KeyCode.W
            or (input.KeyCode == Enum.KeyCode.D or (input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.S))
        then
            if status:FindFirstChild("Emoting") then
                KeyInput:FireServer(Enum.KeyCode.V, false)

                return
            end
        elseif input.KeyCode == Enum.KeyCode[controls.MarkPass.Value] or input.KeyCode == Enum.KeyCode.ButtonB then
            local raycast_params_2 = RaycastParams.new()
            raycast_params_2.FilterDescendantsInstances = { game.Workspace.gameArea }
            raycast_params_2.FilterType = Enum.RaycastFilterType.Include
            local raycast_result = workspace:Raycast(
                game.Workspace.CurrentCamera.CFrame.Position,
                mouse.UnitRay.Direction * 250,
                raycast_params_2
            )

            if raycast_result ~= nil then
                KeyInput:FireServer(Enum.KeyCode.F, true, raycast_result.Position)

                return
            end
        else
            if input.KeyCode == Enum.KeyCode[controls.DribbleLeft.Value] or input.KeyCode == Enum.KeyCode.ButtonL2 then
                if game_processed == true then
                    return
                end

                holdingz = true
                charge = 0
                charge_2 = 0
                number_3 = 0
                holdingc = false
                holdingm2 = false
                holdingm1 = false

                return
            end

            if input.KeyCode == Enum.KeyCode[controls.DribbleRight.Value] or input.KeyCode == Enum.KeyCode.ButtonR2 then
                if game_processed == true then
                    return
                end

                holdingz = false
                charge = 0
                charge_2 = 0
                number_2 = 0
                holdingc = true
                holdingm2 = false
                holdingm1 = false
            end
        end

        return
    end

    if status:FindFirstChild("JustShot") then
        return
    end

    if status:FindFirstChild("SlideTackleActive") then
        return
    end

    if status:FindFirstChild("NoSkill") then
        return
    end

    if status:FindFirstChild("Knockdown") then
        return
    end

    local ball = game.Workspace.Temp:FindFirstChild("Ball")
    local kick_disable = Instance.new("Folder")
    kick_disable.Name = "KickDisable"
    kick_disable.Parent = status
    game.Debris:AddItem(kick_disable, 0.3)
    local side = ball ~= nil
            and (character.HumanoidRootPart.CFrame.RightVector:Dot(
                (character.HumanoidRootPart.Position * Vector3.new(1, 0, 1) - ball.Position * Vector3.new(1, 0, 1)).Unit
            ) > 0 and "Left" or "Right")
        or nil
    local keys_down = {}

    for _, input_2 in pairs(user_input_service:GetKeysPressed()) do
        table.insert(keys_down, input_2.KeyCode)
    end

    if user_input_service.GamepadEnabled then
        if number_4 == 2 then
            keys_down = { Enum.KeyCode.A }
        elseif number_4 == 3 then
            keys_down = { Enum.KeyCode.D }
        elseif number_4 == 1 then
            keys_down = { Enum.KeyCode.S }
        else
            keys_down = number_4 == 4 and { Enum.KeyCode.W } or keys_down
        end
    end

    for index = 1, 6 do
        local is_near_ball = hitbox_handler.Create({
            size = Vector3.new(5.75, 5.5, 7),
            cframe = character.HumanoidRootPart.CFrame * CFrame.new(0, -2.5, 0),
        }) ~= nil and true or nil

        if ball_status:FindFirstChild("JustDropped") then
            is_near_ball = nil
        end

        local skill_direction = user_input_service:IsKeyDown(Enum.KeyCode.A) and "Left"
            or (user_input_service:IsKeyDown(Enum.KeyCode.D) and "Right" or "Left")
        KeyInput:FireServer(Enum.KeyCode.Q, true, {
            look = character.HumanoidRootPart.CFrame.lookVector,
            right = character.HumanoidRootPart.CFrame.rightVector,
            pos = character.HumanoidRootPart.CFrame,
            side = side,
            skillDirection = skill_direction,
            charge = charge_2 < charge and charge or charge_2,
            cameraLook = game.Workspace.CurrentCamera.CFrame.LookVector,
            keysDown = keys_down,
            isAir = status:FindFirstChild("spaceCheck") ~= nil,
            isNearBall = is_near_ball,
            moveDirection = character.HumanoidRootPart.AssemblyLinearVelocity.Unit,
        })

        if is_near_ball then
            return
        end

        task.wait(0.016666666666666666)
        local _ = index
    end
end)

humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
    if
        not (
            humanoid.Jump == true
            and not (
                status:FindFirstChild("spaceCheck")
                or (
                    status:FindFirstChild("Knockdown")
                    or (
                        status:FindFirstChild("NoMovement")
                        or (status:FindFirstChild("NoJump") or character.Humanoid.FloorMaterial == Enum.Material.Air)
                    )
                )
            )
        )
    then
        return
    end

    local space_check = Instance.new("Folder")
    space_check.Name = "spaceCheck"
    space_check.Parent = status
    game.Debris:AddItem(space_check, 0.3)

    if not game.ReplicatedStorage:FindFirstChild("InfiniteStamina") and local_player.Name ~= "kaitoudono" then
        local stamina = character.Stats.Stamina
        stamina.Value = stamina.Value - 4
    end

    if not (isMobile()) then
        return
    end

    task.wait(0.1)
    local mobile_control_events_2 = game.ReplicatedStorage.MobileControlEvents

    if charge > 0 then
        mobile_control_events_2.M1:Fire(false)

        return
    end

    if charge_2 > 0 then
        mobile_control_events_2.M2:Fire(false)

        return
    end

    if number_2 > 0 then
        mobile_control_events_2.DribbleLeft:Fire(false)

        return
    end

    if number_3 > 0 then
        mobile_control_events_2.DribbleRight:Fire(false)
    end
end)

user_input_service.InputEnded:Connect(function(input, game_processed)
    if
        input.UserInputType
            == (controls.Flipped.Value == true and Enum.UserInputType.MouseButton2 or Enum.UserInputType.MouseButton1)
        or input.KeyCode == Enum.KeyCode.ButtonL1
    then
        if tick() - timestamp < 0.1 then
            return
        end

        timestamp = tick()
        holdingm1 = false
        holdingm2 = false
        holdingz = false
        holdingc = false
        hideSelf()

        if
            local_player.SelectedPosition.Value == "GK"
            and (
                status:FindFirstChild("InBox")
                and (status:FindFirstChild("HasBall") and not status:FindFirstChild("TakingSetPiece"))
            )
        then
            gkKickFunction(false)
        elseif not (status:FindFirstChild("NoCharge") or status:FindFirstChild("KickCD")) then
            kick(false)
        end

        charge = 0
        enabled_8 = false

        return
    end

    if
        input.UserInputType
            == (controls.Flipped.Value == true and Enum.UserInputType.MouseButton1 or Enum.UserInputType.MouseButton2)
        or input.KeyCode == Enum.KeyCode.ButtonR1
    then
        if
            local_player.SelectedPosition.Value == "GK"
            and not (
                status:FindFirstChild("HasBall")
                or (not status:FindFirstChild("InBox") or status:FindFirstChild("TakingSetPiece"))
            )
        then
            return
        end

        if tick() - timestamp < 0.1 then
            return
        end

        timestamp = tick()
        holdingm2 = false
        holdingm1 = false
        holdingz = false
        holdingc = false
        hideSelf()

        if
            local_player.SelectedPosition.Value == "GK"
            and (status:FindFirstChild("InBox") and not status:FindFirstChild("TakingSetPiece"))
        then
            gkKickFunction(true)
        elseif not (status:FindFirstChild("NoCharge") or status:FindFirstChild("KickCD")) then
            kick(true)
        end

        charge_2 = 0
        enabled_8 = false

        return
    end

    if input.KeyCode == Enum.KeyCode[controls.Shove.Value] or input.KeyCode == Enum.KeyCode.DPadUp then
        enabled_2 = false

        return
    end

    if input.KeyCode ~= Enum.KeyCode[controls.DribbleLeft.Value] and input.KeyCode ~= Enum.KeyCode.ButtonL2 then
        if input.KeyCode == Enum.KeyCode[controls.DribbleRight.Value] or input.KeyCode == Enum.KeyCode.ButtonR2 then
            if game_processed == true then
                return
            end

            holdingm2 = false
            holdingm1 = false
            holdingz = false
            holdingc = false
            hideSelf()

            if
                local_player.SelectedPosition.Value == "GK"
                and (
                    status:FindFirstChild("InBox")
                    and (status:FindFirstChild("HasBall") and not status:FindFirstChild("-"))
                )
            then
                gkKickFunction(false)
            elseif not (status:FindFirstChild("NoCharge") or status:FindFirstChild("KickCD")) then
                sideKick("Right")
            end

            number_3 = 0
            enabled_8 = false
        end

        return
    end

    if game_processed == true then
        return
    end

    holdingm2 = false
    holdingm1 = false
    holdingz = false
    holdingc = false
    hideSelf()

    if
        local_player.SelectedPosition.Value == "GK"
        and (
            status:FindFirstChild("InBox")
            and (status:FindFirstChild("HasBall") and not status:FindFirstChild("TakingSetPiece"))
        )
    then
        gkKickFunction(false)
    elseif not (status:FindFirstChild("NoCharge") or status:FindFirstChild("KickCD")) then
        sideKick("Left")
    end

    number_2 = 0
    enabled_8 = false
end)

function GetClientKickInfo.OnClientInvoke()
    local keys_down = {}

    for _, input in pairs(user_input_service:GetKeysPressed()) do
        table.insert(keys_down, input.KeyCode)
    end

    local ball = game.Workspace.Temp:FindFirstChild("Ball")

    if user_input_service.GamepadEnabled then
        if number_4 == 2 then
            keys_down = { Enum.KeyCode.A }
        elseif number_4 == 3 then
            keys_down = { Enum.KeyCode.D }
        elseif number_4 == 1 then
            keys_down = { Enum.KeyCode.S }
        else
            keys_down = number_4 == 4 and { Enum.KeyCode.W } or keys_down
        end
    end

    local side = ball ~= nil
            and (character.HumanoidRootPart.CFrame.RightVector:Dot(
                (character.HumanoidRootPart.Position * Vector3.new(1, 0, 1) - ball.Position * Vector3.new(1, 0, 1)).Unit
            ) > 0 and "Left" or "Right")
        or nil

    return {
        look = character.HumanoidRootPart.CFrame.lookVector,
        right = character.HumanoidRootPart.CFrame.rightVector,
        pos = character.HumanoidRootPart.CFrame,
        charge = charge_2 < charge and charge or charge_2,
        cameraLook = game.Workspace.CurrentCamera.CFrame.LookVector,
        isAir = status:FindFirstChild("spaceCheck") ~= nil,
        moveDirection = character.HumanoidRootPart.AssemblyLinearVelocity.Unit,
        keysDown = keys_down,
        side = side,
    }
end

BallTrailClient.OnClientEvent:Connect(function(parent)
    local clone = game.ReplicatedStorage.VFX.SlideTrail.ballTrail:Clone()

    if local_player.Settings.Misc.SnowEnabled.Value == true then
        clone.Dust.Color = ColorSequence.new(Color3.new(1, 1, 1))
    end

    clone.Parent = parent
    local connection = game:GetService("RunService").RenderStepped:Connect(function()
        local raycast_params_2 = RaycastParams.new()
        raycast_params_2.FilterDescendantsInstances = { game.Workspace.gameArea, game.Workspace.Temp }
        raycast_params_2.FilterType = Enum.RaycastFilterType.Include
        local raycast_result = workspace:Raycast(parent.Position, Vector3.new(0, -2, 0), raycast_params_2)

        if raycast_result == nil or raycast_result.Instance == nil then
            clone.Dust.Enabled = false

            return
        end

        clone.Dust.Enabled = true
    end)
    local clone_2 = game.ReplicatedStorage.SFX.SlideSFX:Clone()
    clone_2.Parent = parent
    clone_2:Play()
    game.Debris:AddItem(clone_2, 3)
    local clone_3 = game.ReplicatedStorage.SFX.rollSFX:Clone()
    clone_3.Parent = parent
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)

    task.delay(0.75, function()
        connection:Disconnect()
        clone.Dust.Enabled = false
        game.Debris:AddItem(clone, 4)
    end)
end)

ClientVelocity.OnClientEvent:Connect(function(product, argument, enabled_15, argument_2)
    local number_7 = argument_2 == nil and 0 or argument_2
    local character_2 = game.Players.LocalPlayer.Character

    for _, child in pairs(character_2.HumanoidRootPart:GetChildren()) do
        if child:IsA("BodyVelocity") then
            child:Destroy()
        end
    end

    local body_velocity = Instance.new("BodyVelocity")
    body_velocity.MaxForce = Vector3.new(50000, 0, 50000)
    body_velocity.Velocity = character_2.HumanoidRootPart.CFrame.lookVector * product
    body_velocity.Parent = character_2.HumanoidRootPart
    game.Debris:AddItem(body_velocity, argument)
    local connection = game:GetService("RunService").RenderStepped:Connect(function()
        body_velocity.Velocity = character_2.HumanoidRootPart.CFrame.lookVector * product
    end)

    task.delay(argument, function()
        connection:Disconnect()
    end)

    if enabled_15 == true then
        return
    end

    for index = 1, math.floor(argument * 30) do
        product = product * 0.975
        number_7 = number_7 * 0.975
        task.wait(0.0167)
        local _ = index
    end
end)

ClientVelocityLock.OnClientEvent:Connect(function(argument, product, argument_2, enabled_15)
    local number_7 = argument_2 == nil and 0 or argument_2
    local character_2 = game.Players.LocalPlayer.Character

    for _, child in pairs(character_2.HumanoidRootPart:GetChildren()) do
        if child:IsA("BodyVelocity") then
            child:Destroy()
        end
    end

    local _, value_3, _ = character_2.HumanoidRootPart.CFrame:ToOrientation()

    if enabled_15 == true then
        local to_orientation_result, value_4
        to_orientation_result, value_3, value_4 = CFrame.lookAt(
            humanoid_root_part.Position,
            humanoid_root_part.CFrame * CFrame.new(number_7, 0, -product).Position
        ):ToOrientation()
    end

    local c_frame2 = character_2.HumanoidRootPart.CFrame
    local body_velocity = Instance.new("BodyVelocity")
    body_velocity.MaxForce = Vector3.new(50000, 0, 50000)
    body_velocity.Velocity = character_2.HumanoidRootPart.CFrame.lookVector * product
        + character_2.HumanoidRootPart.CFrame.rightVector * number_7
    body_velocity.Parent = character_2.HumanoidRootPart
    game.Debris:AddItem(body_velocity, argument)
    local connection = game:GetService("RunService").RenderStepped:Connect(function()
        body_velocity.Velocity = c_frame2.lookVector * product + c_frame2.rightVector * number_7
        humanoid_root_part.CFrame = CFrame.new(humanoid_root_part.Position) * CFrame.Angles(0, value_3, 0)
    end)
    local camera_locked = Instance.new("Folder")
    camera_locked.Name = "CameraLocked"
    camera_locked.Parent = character_2.Status
    game.Debris:AddItem(camera_locked, argument)

    body_velocity.Destroying:Connect(function()
        camera_locked:Destroy()
    end)

    task.delay(argument, function()
        connection:Disconnect()
    end)

    for index = 1, math.floor(argument * 30) do
        product = product * 0.975
        number_7 = number_7 * 0.975
        task.wait(0.0167)
        local _ = index
    end
end)

Blur.OnClientEvent:Connect(function(argument)
    if local_player:GetAttribute("Freecam") then
        return
    end

    game:GetService("TweenService")
        :Create(game.Lighting.Blur, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = 20,
        })
        :Play()

    task.delay(argument, function()
        game:GetService("TweenService")
            :Create(game.Lighting.Blur, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = 2,
            })
            :Play()
    end)
end)

local_player:WaitForChild("SelectedPosition").Changed:Connect(function()
    if local_player.SelectedPosition.Value == "GK" then
        for _, descendant in pairs(game.Workspace.gameArea.Field.GoalboxAway.Goal:GetDescendants()) do
            if descendant:IsA("Texture") and descendant.Name == "TextureBack" then
                descendant.Transparency = 0.9
            end
        end

        for _, descendant_2 in pairs(game.Workspace.gameArea.Field.GoalboxHome.Goal:GetDescendants()) do
            if descendant_2:IsA("Texture") and descendant_2.Name == "TextureBack" then
                descendant_2.Transparency = 0.9
            end
        end

        return
    end

    for _, descendant_3 in pairs(game.Workspace.gameArea.Field.GoalboxAway.Goal:GetDescendants()) do
        if descendant_3:IsA("Texture") and descendant_3.Name == "TextureBack" then
            descendant_3.Transparency = 0
        end
    end

    for _, descendant_4 in pairs(game.Workspace.gameArea.Field.GoalboxHome.Goal:GetDescendants()) do
        if descendant_4:IsA("Texture") and descendant_4.Name == "TextureBack" then
            descendant_4.Transparency = 0
        end
    end
end)

Pushback.OnClientEvent:Connect(pushback)

status.ChildAdded:Connect(function(child)
    if child.Name == "NoCharge" then
        charge = 0
        charge_2 = 0
    end
end)

local number_6 = 0

task.spawn(function()
    while wait(1) do
        if
            local_player:FindFirstChild("InPlay")
            and not (
                game.ReplicatedStorage:FindFirstChild("Shootout")
                or game.ReplicatedStorage:FindFirstChild("FinalShootoutF")
            )
        then
            number_6 = number_6 + 1

            if number_6 > 60 then
                Reset:FireServer(true)
            end
        end
    end
end)

user_input_service.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.DPadRight then
        enabled_11 = not enabled_11
    end

    if input.UserInputType ~= Enum.UserInputType.MouseMovement then
        number_6 = 0
    end
end)

local mobile_control_events = game.ReplicatedStorage.MobileControlEvents

mobile_control_events.M1.Event:Connect(function(enabled_15)
    if enabled_15 ~= true then
        if enabled_15 == false then
            if tick() - timestamp < 0.1 then
                return
            end

            timestamp = tick()
            holdingm1 = false
            holdingm2 = false
            hideSelf()

            if
                local_player.SelectedPosition.Value == "GK"
                and (
                    status:FindFirstChild("InBox")
                    and (status:FindFirstChild("HasBall") and not status:FindFirstChild("TakingSetPiece"))
                )
            then
                gkKickFunction(false)
            elseif not (status:FindFirstChild("NoCharge") or status:FindFirstChild("KickCD")) then
                kick(false)
            end

            charge = 0
            enabled_8 = false
        end

        return
    end

    timestamp_9 = tick()

    if tick() - timestamp_10 < 0.2 then
        soledrag()

        return
    end

    if status:FindFirstChild("LeftRightInput") then
        KeyInput:FireServer(
            controls.Flipped.Value == true and Enum.UserInputType.MouseButton2 or Enum.UserInputType.MouseButton1,
            true
        )
    end

    charge_2 = 0
    holdingm2 = false
    holdingm1 = true
end)

mobile_control_events.M2.Event:Connect(function(enabled_15)
    if enabled_15 ~= true then
        if enabled_15 == false then
            if
                local_player.SelectedPosition.Value == "GK"
                and not (
                    status:FindFirstChild("HasBall")
                    or (not status:FindFirstChild("InBox") or status:FindFirstChild("TakingSetPiece"))
                )
            then
                return
            end

            if tick() - timestamp < 0.1 then
                return
            end

            game.ReplicatedStorage.MobileControlEvents.OverchargeCheck:Fire()
            timestamp = tick()
            holdingm2 = false
            holdingm1 = false
            hideSelf()

            if
                local_player.SelectedPosition.Value == "GK"
                and (status:FindFirstChild("InBox") and not status:FindFirstChild("TakingSetPiece"))
            then
                gkKickFunction(true)
            elseif not (status:FindFirstChild("NoCharge") or status:FindFirstChild("KickCD")) then
                kick(true)
            end

            charge_2 = 0
            enabled_8 = false
        end

        return
    end

    timestamp_10 = tick()

    if tick() - timestamp_9 < 0.2 then
        soledrag()

        return
    end

    if status:FindFirstChild("LeftRightInput") then
        KeyInput:FireServer(
            controls.Flipped.Value == true and Enum.UserInputType.MouseButton1 or Enum.UserInputType.MouseButton2,
            true
        )
    end

    if
        local_player.SelectedPosition.Value == "GK"
        and not (
            status:FindFirstChild("HasBall")
            or (not status:FindFirstChild("InBox") or status:FindFirstChild("TakingSetPiece"))
        )
    then
        dive()

        return
    end

    charge = 0
    holdingm1 = false
    holdingz = false
    holdingc = false
    holdingm2 = true
end)

mobile_control_events.SlideTackle.Event:Connect(slideTackle)

mobile_control_events.Physical.Event:Connect(function(enabled_15)
    if enabled_15 == true then
        shove()
    end

    enabled_2 = enabled_15
end)

mobile_control_events.UseSkill.Event:Connect(function()
    if status:FindFirstChild("JustShot") then
        return
    end

    if status:FindFirstChild("SlideTackleActive") then
        return
    end

    if status:FindFirstChild("NoSkill") then
        return
    end

    if status:FindFirstChild("Knockdown") then
        return
    end

    local ball = game.Workspace.Temp:FindFirstChild("Ball")
    local kick_disable = Instance.new("Folder")
    kick_disable.Name = "KickDisable"
    kick_disable.Parent = status
    game.Debris:AddItem(kick_disable, 0.3)
    local side = ball ~= nil
            and (character.HumanoidRootPart.CFrame.RightVector:Dot(
                (character.HumanoidRootPart.Position * Vector3.new(1, 0, 1) - ball.Position * Vector3.new(1, 0, 1)).Unit
            ) > 0 and "Left" or "Right")
        or nil
    print(number_4)
    local keys_down

    if number_4 == 2 then
        keys_down = { Enum.KeyCode.A }
    elseif number_4 == 3 then
        keys_down = { Enum.KeyCode.D }
    elseif number_4 == 1 then
        keys_down = { Enum.KeyCode.S }
    else
        keys_down = { Enum.KeyCode.W }
    end

    for index = 1, 6 do
        local is_near_ball = hitbox_handler.Create({
            size = Vector3.new(5.75, 5.5, 7),
            cframe = character.HumanoidRootPart.CFrame * CFrame.new(0, -2.5, 0),
        }) ~= nil and true or nil

        if ball_status:FindFirstChild("JustDropped") then
            is_near_ball = nil
        end

        KeyInput:FireServer(Enum.KeyCode.Q, true, {
            look = character.HumanoidRootPart.CFrame.lookVector,
            right = character.HumanoidRootPart.CFrame.rightVector,
            pos = character.HumanoidRootPart.CFrame,
            side = side,
            charge = charge_2 < charge and charge or charge_2,
            cameraLook = game.Workspace.CurrentCamera.CFrame.LookVector,
            keysDown = keys_down,
            isAir = status:FindFirstChild("spaceCheck") ~= nil,
            isNearBall = is_near_ball,
            moveDirection = character.HumanoidRootPart.AssemblyLinearVelocity.Unit,
        })

        if is_near_ball then
            break
        end

        task.wait(0.016666666666666666)
        local _ = index
    end
end)

mobile_control_events.Emote.Event:Connect(function()
    KeyInput:FireServer(Enum.KeyCode.V, true)
    local connection = nil
    connection = user_input_service.InputChanged:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local vector = require(local_player:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule")):GetMoveVector().Unit
            * Vector3.new(1, 0, 1)

        if status:FindFirstChild("Emoting") and vector.Magnitude > 0.4 then
            KeyInput:FireServer(Enum.KeyCode.V, false)
            connection:Disconnect()
        end
    end)

    task.delay(5, function()
        connection:Disconnect()
    end)
end)

mobile_control_events.MarkPass.Event:Connect(function()
    local raycast_params_2 = RaycastParams.new()
    raycast_params_2.FilterDescendantsInstances = { game.Workspace.gameArea }
    raycast_params_2.FilterType = Enum.RaycastFilterType.Include
    local raycast_result = workspace:Raycast(
        game.Workspace.CurrentCamera.CFrame.Position,
        game.Workspace.CurrentCamera.CFrame.LookVector * 250,
        raycast_params_2
    )

    if raycast_result ~= nil then
        KeyInput:FireServer(Enum.KeyCode.F, true, raycast_result.Position)
    end
end)

mobile_control_events.SprintToggle.Event:Connect(function(argument)
    enabled_12 = argument
end)

mobile_control_events.DribbleLeft.Event:Connect(function(enabled_15)
    if enabled_15 ~= true then
        if enabled_15 == false then
            holdingm2 = false
            holdingm1 = false
            holdingz = false
            holdingc = false
            hideSelf()

            if
                local_player.SelectedPosition.Value == "GK"
                and (status:FindFirstChild("InBox") and status:FindFirstChild("HasBall"))
            then
                gkKickFunction(false)
            elseif not (status:FindFirstChild("NoCharge") or status:FindFirstChild("KickCD")) then
                sideKick("Left")
            end

            number_2 = 0
            enabled_8 = false
        end

        return
    end

    holdingc = false
    charge = 0
    charge_2 = 0
    number_3 = 0
    holdingz = true
    holdingm2 = false
    holdingm1 = false
end)

mobile_control_events.DribbleRight.Event:Connect(function(enabled_15)
    if enabled_15 ~= true then
        if enabled_15 == false then
            holdingm2 = false
            holdingm1 = false
            holdingz = false
            holdingc = false
            hideSelf()

            if
                local_player.SelectedPosition.Value == "GK"
                and (status:FindFirstChild("InBox") and status:FindFirstChild("HasBall"))
            then
                gkKickFunction(false)
            elseif not (status:FindFirstChild("NoCharge") or status:FindFirstChild("KickCD")) then
                sideKick("Right")
            end

            number_3 = 0
            enabled_8 = false
        end

        return
    end

    holdingz = false
    charge = 0
    charge_2 = 0
    number_2 = 0
    holdingc = true
    holdingm2 = false
    holdingm1 = false
end)

mobile_control_events.ControlSprintToggle.Event:Connect(function(argument)
    enabled_11 = argument
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if game.Workspace.Temp:FindFirstChild("Ball") and (ball_instance == nil and original_ball_name == nil) then
        if ball_instance == nil then
            for _, child in pairs(game.Workspace.Temp:GetChildren()) do
                if child:FindFirstChild("ballHandler") then
                    ball_instance = child
                end
            end
        end

        if original_ball_name == nil then
            original_ball_name = game.Workspace.Temp:FindFirstChild("Ball").Name
        end
    elseif game.Workspace.Temp:FindFirstChild("Ball") == nil and (ball_instance and original_ball_name) then
        for _, child_2 in pairs(game.Workspace.Temp:GetChildren()) do
            if child_2:FindFirstChild("ballHandler") then
                ball_instance = child_2

                if ball_instance.Name ~= original_ball_name then
                    ball_instance.Name = original_ball_name
                end
            end
        end
    end
end)
