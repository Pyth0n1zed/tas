local gui =loadstring(game:HttpGet("https://raw.githubusercontent.com/Pyth0n1zed/GUI-Framework-Roblox/refs/heads/main/script.lua"))()()
local macro = {}
local plr = game.Players.LocalPlayer
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
local function round2(n)
	return math.floor(n * 100 + 0.5) / 100
end
local function cframeToRoundedString(cf)
	local x, y, z,
		r00, r01, r02,
		r10, r11, r12,
		r20, r21, r22 = cf:GetComponents()
	return string.format(
		"CFrame.new(%.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f)",
		round2(x), round2(y), round2(z),
		round2(r00), round2(r01), round2(r02),
		round2(r10), round2(r11), round2(r12),
		round2(r20), round2(r21), round2(r22)
	)
end
local function SetBoxText()
	MacroText = "return {"
	for i, v in ipairs(macro) do
		task.wait()
		local rootCF = cframeToRoundedString(v[1])
		local camCF  = cframeToRoundedString(v[2])
		if i < #macro then
			MacroText ..= "{" ..rootCF .. ", " ..camCF .. ", " ..tostring(v[3]) .. ", " ..tostring(v[4]) .."},"
		else
			MacroText ..= "{" ..rootCF .. ", " ..camCF .. ", " ..tostring(v[3]) .. ", " ..tostring(v[4]) .."}"
		end
		print(i .. " frames processed")
	end
	MacroText ..= "}"
	writefile("macro.lua", MacroText)
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
game.UserInputService.InputEnded:Connect(function(key)
	if key.KeyCode == Enum.KeyCode.Z then
		zHold = false
	end
end)
game.UserInputService.InputBegan:Connect(function(key)
	if key.KeyCode == Enum.KeyCode.V then
		macro = {}
		SetPlaying(false)
		SetRecording(false)
	elseif key.KeyCode == Enum.KeyCode.B then
		SetRecording(true)
		recording = false
		workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
		AllowPlay = false
		if macro[#macro] then  
			HumanoidRootPart:PivotTo(macro[#macro][1])
			workspace.CurrentCamera.CFrame = macro[#macro][2]
			playIndex = #macro
		end
	elseif key.KeyCode == Enum.KeyCode.C then
		recording = not AllowPlay
		AllowPlay = not AllowPlay
	elseif key.KeyCode == Enum.KeyCode.N then
		SetRecording(false)
		SetBoxText()
	elseif key.KeyCode == Enum.KeyCode.M then
		SetPlaying(true)
	elseif key.KeyCode == Enum.KeyCode.L then
		SetPlaying(false)
	elseif key.KeyCode == Enum.KeyCode.Z then
		zHold = true
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
task.spawn(function()
	while task.wait() do
		if zHold then
			recording = false
		AllowPlay = false
		playIndex = playIndex - 1

		if playIndex > 0 then
			HumanoidRootPart.CFrame = macro[playIndex][1]
			Humanoid:ChangeState(macro[playIndex][3])
			game.Workspace.CurrentCamera.CFrame = macro[playIndex][2]
			game:GetService("UserInputService").MouseBehavior = (macro[playIndex][4])
			macro[playIndex+1] = nil
			macro[playIndex+2] = nil
		end
		end
	end
end)
local read = gui:CreateTab("README",1)
gui:CreateLabel(read,"Tutorial on how to use this properly",1)
gui:CreateLabel(read,"Before running the macro, ensure you are in the lobby.",2)
gui:CreateLabel(read,"Also, make sure your fps is set to a value between the reccomended ones listed in the button's description.",4)
gui:CreateLabel(read,"You can only use a macro once per session, otherwise it breaks for some reason. To use a macro again or use a different one, rejoin.",5)
local main = gui:CreateTab("Ring 0",2)
local r1 = gui:CreateTab("Ring 1", 3)
gui:SetTitle("EToH Macros")
gui:CreateButton(main, "trigger", "Tower of Genesis", "FPS: 60-120",1,function()
	gui:Notify("TASing ToG... Please wait",5)
	if plr.PlayerGui.Timer.Timer.Timer.inner.Digits.Text ~= "00:00.00" then
		macro = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pyth0n1zed/tas/main/ToG.lua"))()
		SetPlaying(true)
	else
		HumanoidRootPart:PivotTo(game.Workspace.Towers.ToG.Teleporter.Teleporter.TPFRAME.CFrame)
		task.wait(1)
		while task.wait((0.5)) do
			if plr.PlayerGui.towerLoading.Enabled == false then break end
		end
		macro = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pyth0n1zed/tas/main/ToG.lua"))()
		SetPlaying(true)
	end
end)
gui:CreateButton(main, "trigger", "Tower of Motion Evolution", "FPS: 60-120",2,function()
	gui:Notify("TASing ToME... Please wait",5)
	if plr.PlayerGui.Timer.Timer.Timer.inner.Digits.Text ~= "00:00.00" then
		macro = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pyth0n1zed/tas/main/ToME.lua"))()
		SetPlaying(true)
	else
		HumanoidRootPart:PivotTo(game.Workspace.Towers.ToME.Teleporter.Teleporter.TPFRAME.CFrame)
		task.wait(1)
		while task.wait((0.5)) do
			if plr.PlayerGui.towerLoading.Enabled == false then break end
		end
		macro = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pyth0n1zed/tas/main/ToME.lua"))()
		SetPlaying(true)
	end
end)
gui:CreateButton(main, "trigger", "Tower of Buttons", "FPS: 60-120",3,function()
	gui:Notify("TASing ToB... Please wait",5)
	if plr.PlayerGui.Timer.Timer.Timer.inner.Digits.Text ~= "00:00.00" then
		macro = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pyth0n1zed/tas/main/ToB.lua"))()
		SetPlaying(true)
	else
		HumanoidRootPart:PivotTo(game.Workspace.Towers.ToB.Teleporter.Teleporter.TPFRAME.CFrame)
		task.wait(1)
		while task.wait((0.5)) do
			if plr.PlayerGui.towerLoading.Enabled == false then break end
		end
		macro = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pyth0n1zed/tas/main/ToB.lua"))()
		SetPlaying(true)
	end
end)
gui:CreateButton(r1, "trigger", "Tower of True Skill", "FPS: 60-240",1,function()
	gui:Notify("TASing ToTS... Please wait",5)
	if plr.PlayerGui.Timer.Timer.Timer.inner.Digits.Text ~= "00:00.00" then
		macro = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pyth0n1zed/tas/main/ToTS.lua"))()
		SetPlaying(true)
	else
		HumanoidRootPart:PivotTo(game.Workspace.Towers.ToTS.Teleporter.Teleporter.TPFRAME.CFrame)
		task.wait(1)
		while task.wait((0.5)) do
			if plr.PlayerGui.towerLoading.Enabled == false then break end
		end
		macro = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pyth0n1zed/tas/main/ToTS.lua"))()
		SetPlaying(true)
	end
end)
gui:FinishLoading()
