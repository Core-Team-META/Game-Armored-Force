--written by AwkwardGameDev

local root = script.parent
local Rotation = script:GetCustomProperty("rotation")
local Rotation2 = script:GetCustomProperty("rotation2")
local pole = script:GetCustomProperty("pole"):WaitForObject()
local bundle = script:GetCustomProperty("bundle"):WaitForObject()
local FlagRoot = script:GetCustomProperty("FlagRoot"):WaitForObject()
local Flag1 = script:GetCustomProperty("Flag1"):WaitForObject()
local Flag2 = script:GetCustomProperty("Flag2"):WaitForObject()
local SFX_door1 = script:GetCustomProperty("SFX_door1"):WaitForObject()
local SFX_door2 = script:GetCustomProperty("SFX_door2"):WaitForObject()
local SFX_door3 = script:GetCustomProperty("SFX_door3"):WaitForObject()
local SFX_pole1 = script:GetCustomProperty("SFX_pole1"):WaitForObject()
local SFX_pole2 = script:GetCustomProperty("SFX_pole2"):WaitForObject()
local SFX_flag1 = script:GetCustomProperty("SFX_flag1"):WaitForObject()
local SFX_flag2 = script:GetCustomProperty("SFX_flag2"):WaitForObject()

local Ease3D = require(script:GetCustomProperty("Ease3D"))

--SFX, VFX, and animation on baby tank's death
        Task.Wait(1)
        pole.visibility = Visibility.FORCE_ON
        bundle.visibility = Visibility.FORCE_ON
        local door = root:FindDescendantByName("door")
        local door1 = root:FindDescendantByName("door1")
        local door2 = root:FindDescendantByName("door2")
        SFX_door1:Play()
        SFX_door2:Play()
        SFX_door3:Play()
        Ease3D.EaseRotation(door, Rotation, 0.8, Ease3D.EasingEquation.BOUNCE, Ease3D.EasingDirection.OUT)
        Ease3D.EaseRotation(door1, Rotation, 0.8, Ease3D.EasingEquation.BOUNCE, Ease3D.EasingDirection.OUT)
        Ease3D.EaseRotation(door2, Rotation2, 0.8, Ease3D.EasingEquation.BOUNCE, Ease3D.EasingDirection.OUT)
        Task.Wait(0.5)
        SFX_pole1:Play()
        Ease3D.EasePosition(pole, Vector3.New(0, 0, 0), 0.8, Ease3D.EasingEquation.BOUNCE, Ease3D.EasingDirection.OUT)
        Task.Wait(0.2)
        SFX_pole2:Play()
        Task.Wait(0.25)
        SFX_pole2.volume = 1
        SFX_pole2:Play()
        Task.Wait(0.35)
        SFX_flag1:Play()
        FlagRoot.visibility = Visibility.FORCE_ON
        Ease3D.EaseScale(FlagRoot, Vector3.New(0.76,0.76,0.76), 0.3, Ease3D.EasingEquation.CIRCULAR, Ease3D.EasingDirection.IN)
        Ease3D.EaseScale(bundle, Vector3.New(0.1, 0.1, 0.1), 0.05, Ease3D.EasingEquation.CIRCULAR, Ease3D.EasingDirection.IN)
        Task.Wait(0.1)
        bundle.visibility = Visibility.FORCE_OFF
        SFX_flag2:Play()

--flag cloth animation by WitcherSilver
function Tick()
	Task.Wait()
	Ease3D.EaseRotation(FlagRoot, Rotation.New(0, 0, 100), 2, Ease3D.EasingEquation.SINE, Ease3D.EasingDirection.INOUT)
	Task.Wait(1)
	Ease3D.EaseRotation(Flag1, Rotation.New(0, 0, -40), 1, Ease3D.EasingEquation.QUADRATIC, Ease3D.EasingDirection.INOUT)
	Task.Wait(.5)
	Ease3D.EaseRotation(Flag2, Rotation.New(0, 0, -20), .5, Ease3D.EasingEquation.CUBIC, Ease3D.EasingDirection.INOUT)
	Task.Wait()
	Ease3D.EaseRotation(FlagRoot, Rotation.New(0, 0, 180), 1, Ease3D.EasingEquation.SINE, Ease3D.EasingDirection.INOUT)
	Task.Wait(.5)
	Ease3D.EaseRotation(Flag1, Rotation.New(0, 0, 40), .5, Ease3D.EasingEquation.QUADRATIC, Ease3D.EasingDirection.INOUT)
	Task.Wait(.25)
	Ease3D.EaseRotation(Flag2, Rotation.New(0, 0, 20), .25, Ease3D.EasingEquation.CUBIC, Ease3D.EasingDirection.INOUT)
	Task.Wait()
end