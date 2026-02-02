local gui =loadstring(game:HttpGet("https://raw.githubusercontent.com/Pyth0n1zed/GUI-Framework-Roblox/refs/heads/main/script.lua"))()()
local macro = {}
local recording = false
local playing = false
local playIndex = 1
local AllowPlay = true
local ui = Instance.new("ScreenGui",game.Players.LocalPlayer.PlayerGui)
local box = Instance.new("TextBox",ui)
box.Position = UDim2.new(0.374,0,0.887,0)
box.Size = UDim2.new(0.252,0,0.061,0)
box.Text = ""
box.TextScaled = true
box.Visible = false
box.TextWrapped = true
box.TextScaled = false
box.MultiLine = true
box.TextEditable = false
box.ClearTextOnFocus = false
local MacroText = ""
Animate = game.Players.LocalPlayer.Character.Animate
Humanoid = game.Players.LocalPlayer.Character.Humanoid
HumanoidRootPart = game.Players.LocalPlayer.Character.HumanoidRootPart


local function SetRecording(bool)
	Animate.Disabled = false
	playIndex=1
	recording = bool
	if recording then
		Humanoid.Jump = false
		AllowPlay = true
	else
		AllowPlay = true
	end
end
local function SetPlaying(bool)
	Animate.Disabled = false
	AllowPlay = true
	playing = bool
	if playing then
		playIndex = 1
		HumanoidRootPart.CFrame = macro[1][1]
		workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
	else
		
		workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
		game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.Default
		HumanoidRootPart.Anchored = false
		Humanoid.WalkSpeed = 0
		task.wait((0.5))
		Humanoid.WalkSpeed = 16
	end
end

local function SetBoxText() 
	MacroText = "return {" 
	for i,v in pairs(macro) do 
		task.wait() 
		if i < #macro then 
			MacroText = MacroText.."{CFrame.new("..tostring(v[1]).."), CFrame.new("..tostring(v[2]).."), "..tostring(v[3])..", "..tostring(v[4]).."}," 
		else 
			MacroText = MacroText.."{CFrame.new("..tostring(v[1]).."), CFrame.new("..tostring(v[2]).."), "..tostring(v[3])..", "..tostring(v[4]).."}" 
		end 
		print(i.." frames loaded") 
	end 
	MacroText = MacroText.."}" 
	writefile("macro.lua", MacroText) --box.Text = MacroText end
end
local isRunAnimating = false
local runAnim = Humanoid.Animator:LoadAnimation(Animate.run.RunAnim)
game:GetService("RunService").PreRender:Connect(function()
	if recording then
		table.insert(macro, {HumanoidRootPart.CFrame, game.Workspace.CurrentCamera.CFrame, Humanoid:GetState(),game:GetService("UserInputService").MouseBehavior,HumanoidRootPart.AssemblyLinearVelocity})
		playIndex = playIndex + 1
	end
	if playing and macro[playIndex] then
		game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
		--HumanoidRootPart.AssemblyLinearVelocity = macro[playIndex][5]
		--Humanoid:MoveTo((macro[playIndex][1].Position-HumanoidRootPart.Position).Unit,false)
		HumanoidRootPart:PivotTo(  macro[playIndex][1])
		Humanoid:ChangeState(macro[playIndex][3])
		game.Workspace.CurrentCamera.CFrame = macro[playIndex][2]
		game:GetService("UserInputService").MouseBehavior = (macro[playIndex][4])
		if macro[playIndex][4] == Enum.MouseBehavior.LockCenter then
			game.Players.LocalPlayer:GetMouse().Icon = "rbxasset://textures/MouseLockedCursor.png"
		else
			game.Players.LocalPlayer:GetMouse().Icon = ""
		end
		if macro[playIndex-1] then
			if macro[playIndex][3] == Enum.HumanoidStateType.Running and (macro[playIndex][1].Position - macro[playIndex-1][1].Position).Magnitude > 0.01 then
				--Animate.Disabled = true
				runAnim.Priority = Enum.AnimationPriority.Movement
				if isRunAnimating == false then
					runAnim:Play(0.1, 1, 1)
					isRunAnimating = true
				end
				--runAnim:AdjustSpeed(16)
			else
				Animate.Disabled = false
				isRunAnimating = false
				runAnim:Stop()

			end
		end
		if playIndex > #macro then
			SetPlaying(false)
			isRunAnimating = false
			playIndex = 1
		else
			playIndex += 1
		end
	else
		workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
	end
	if AllowPlay then
		HumanoidRootPart.Anchored = false
	else
		HumanoidRootPart.Anchored = true
	end
end)
game.UserInputService.InputBegan:Connect(function(key)
	if key.KeyCode == Enum.KeyCode.V then
		macro = {}
		SetPlaying(false)
		SetRecording(false)
	elseif key.KeyCode == Enum.KeyCode.B then
		SetRecording(true)
	elseif key.KeyCode == Enum.KeyCode.C then
		recording = not AllowPlay
		AllowPlay = not AllowPlay
	elseif key.KeyCode == Enum.KeyCode.N then
		SetRecording(false)
	elseif key.KeyCode == Enum.KeyCode.M then
		SetPlaying(true)
	elseif key.KeyCode == Enum.KeyCode.L then
		SetPlaying(false)
	elseif key.KeyCode == Enum.KeyCode.Z then
		recording = false
		AllowPlay = false
		playIndex = playIndex - 1

		if playIndex > 0 then
			HumanoidRootPart.CFrame = macro[playIndex][1]
			Humanoid:ChangeState(macro[playIndex][3])
			game.Workspace.CurrentCamera.CFrame = macro[playIndex][2]
			game:GetService("UserInputService").MouseBehavior = (macro[playIndex][4])
			macro[playIndex+1] = nil
		end
	elseif key.KeyCode == Enum.KeyCode.X then
		recording = false
		AllowPlay = false
		--playIndex = playIndex + 1

		recording = true
		AllowPlay = true
		task.wait()
		recording = false
		AllowPlay = false
	elseif key.KeyCode == Enum.KeyCode.K then
		SetBoxText()
	end
end)
local main = gui:CreateTab("Ring 0",1)
gui:SetTitle("EToH Macros")
gui:CreateButton(main, "trigger", "Tower of Genesis", "Auto-wins ToG. Make sure you have entered the tower.",1,function()
	macro = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pyth0n1zed/tas/main/ToG.lua"))()
	SetPlaying(true)
end)
gui:FinishLoading()
