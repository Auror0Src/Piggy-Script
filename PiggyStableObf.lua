local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Piggy Script",
   Icon = "piggy-bank",
   LoadingTitle = "Piggy Script loading....",
   LoadingSubtitle = "by Aurora",
   Theme = "Amethyst",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "PiggyScript"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

function setmapfolder(callback)
	coroutine.wrap(function()
		while true do
			wait(1)
			if workspace then
				for _, v in ipairs(workspace:GetChildren()) do
					if v:IsA("Model")
						and v.Name ~= "MainMenuScreen"
						and v.Name ~= "Spawns"
						and v.Name ~= "PlayerDummy"
						and not game.Players:GetPlayerFromCharacter(v) then
						callback(v)
						return
					end
				end
			end
		end
	end)()
end

local mapfolder = nil
setmapfolder(function(folder)
	mapfolder = folder
	print(folder.Name)
end)

function setitemfolder(callback)
	coroutine.wrap(function()
		while true do
			wait(1)
			if workspace then
				for _, v in ipairs(workspace:GetChildren()) do
					if v:IsA("Folder") and tonumber(v.Name) then
						warn(v.Name)
						callback(v)
						return
					end
				end
			end
		end
	end)()
end

function detecteventfolder(callback)
	coroutine.wrap(function()
		while true do
			wait(1)
			if mapfolder and mapfolder:IsA("Model") then
				for _, v in ipairs(mapfolder:GetChildren()) do
					if v:IsA("Folder") and tonumber(v.Name) then
						local hasModel = false
						local hasPart = false
						for _, item in ipairs(v:GetChildren()) do
							if item:IsA("Model") then hasModel = true end
							if item:IsA("BasePart") then hasPart = true end
						end
						if hasModel and hasPart then
							callback(v)
							return
						end
					end
				end
			end
		end
	end)()
end

local itemfolder = nil
local selecteditem
local items = {}
local eventfolder = nil
local hips = 2.85

function seteventfolder(folder)
	eventfolder = folder
	print(folder.Name)

	events = {}
	getevents(eventfolder)
	EventsDropdown:Refresh(events)

	eventfolder.ChildAdded:Connect(function(child)
		if child:IsA("Folder") then
			events = {}
			getevents(eventfolder)
			EventsDropdown:Refresh(events)
		end
	end)

	eventfolder.ChildRemoved:Connect(function(child)
		if child:IsA("Folder") then
			events = {}
			getevents(eventfolder)
			EventsDropdown:Refresh(events)
		end
	end)
end

detecteventfolder(seteventfolder)

setitemfolder(function(folder)
	itemfolder = folder
	print(folder.Name)
	getitems(itemfolder)
	ItemsDropdown:Refresh(items)
	itemfolder.ChildAdded:Connect(function()
		items = {}
		getitems(itemfolder)
		ItemsDropdown:Refresh(items)
	end)
	itemfolder.ChildRemoved:Connect(function()
		items = {}
		getitems(itemfolder)
		ItemsDropdown:Refresh(items)
	end)
end)

local selectedevent
local events = {}

local plr = game.Players.LocalPlayer
local character = plr.Character
local humanoid = character.Humanoid
local humanoidConnection
local noclip = false
local connection
local glitches = false
local removebot = false
local cdmanip = true
local itemesp = false
local piggyesp = false
local itemnames = true
local forcehead = false

local setspeed = 15
local setcrouchspeed = 8
local setsprintspeed = 21
local fov = 70
local RunService = game:GetService("RunService")

local function setupCharacter(character)
	local humanoid = character:WaitForChild("Humanoid", 2)

	local function monitorHumanoid()
    while true do
        if humanoid and glitches then
            while humanoid.Parent do  -- Only run the inner loop while humanoid exists
                local offset = humanoid.CameraOffset
                if offset.Z ~= 0 then
                    humanoid.CameraOffset = Vector3.new(offset.X, offset.Y, 0)
                end
                task.wait()
            end
        else
            -- Wait until humanoid is back in the game
            task.wait(1)  -- Adjust the wait time if you want a longer or shorter delay
        end
    end
end

-- Start the monitoring in a coroutine
coroutine.wrap(monitorHumanoid)()


	-- Cleanup on character removal
	character.AncestryChanged:Connect(function(_, parent)
		if not parent and heartbeatConn then
			heartbeatConn:Disconnect()
		end
	end)

	-- Existing logic
	humanoid.Changed:Connect(function()
		if glitches then
			humanoid.HipHeight = hips
		end

		if humanoid.WalkSpeed == 15 then 
			humanoid.WalkSpeed = setspeed
		elseif humanoid.WalkSpeed == 8 then 
			humanoid.WalkSpeed = setcrouchspeed
		elseif humanoid.WalkSpeed == 21 then 
			humanoid.WalkSpeed = setsprintspeed
		end

		if glitches then
			if character:FindFirstChild("Head") then
				character.Head.CanCollide = false
			end
			if humanoid.WalkSpeed == setcrouchspeed then
				character.HumanoidRootPart.CanCollide = false
				humanoid.HipHeight = hips
			end
		end
	end)

	if character:FindFirstChild("Head") then
		character.Head.Changed:Connect(function()
			if forcehead == true then
				character.Head.CanCollide = true
			end
		end)
	end
end

-- Character added listener
plr.CharacterAdded:Connect(function(character)
	setupCharacter(character)
end)

-- Setup on first load
if plr.Character then
	setupCharacter(plr.Character)
end


local ExploitsTab = Window:CreateTab("Exploits", "bomb")
local PlayerStuffTab = Window:CreateTab("Player Stuff", "user")
local ItemGiverTab = Window:CreateTab("Item Giver", "key-square")
local ItemUserTab = Window:CreateTab("Item User", "puzzle")
local VisualTab = Window:CreateTab("Visuals", "eye")

local Self = PlayerStuffTab:CreateSection("Self")
local ItemGiver = ItemGiverTab:CreateSection("Item Giver")
local Interface = VisualTab:CreateSection("Interface")

VisualTab:CreateButton({
   Name = "Destroy UI",
   Callback = function()
		Rayfield:Destroy()
   end,
})

PlayerStuffTab:CreateSlider({ Name = "WalkSpeed", Range = {1,300}, Increment = 1, Suffix = "Speed", CurrentValue = 15, Flag = "WalkSpeed", Callback = function(v) plr.Character.Humanoid.WalkSpeed = v setspeed = v end })
PlayerStuffTab:CreateSlider({ Name = "Crouch WalkSpeed", Range = {1,300}, Increment = 1, Suffix = "Crouch Speed", CurrentValue = 8, Flag = "Crouch WalkSpeed", Callback = function(v) setcrouchspeed = v end })
PlayerStuffTab:CreateSlider({ Name = "Sprint WalkSpeed", Range = {1,300}, Increment = 1, Suffix = "Sprint Speed", CurrentValue = 21, Flag = "Sprint WalkSpeed", Callback = function(v) setsprintspeed = v end })
PlayerStuffTab:CreateSlider({ Name = "JumpHeight", Range = {1,60}, Increment = 0.1, Suffix = "JumpHeight", CurrentValue = 7.2, Flag = "JumpPower", Callback = function(v) humanoid.JumpHeight = v end })
PlayerStuffTab:CreateSlider({ Name = "FOV", Range = {1,120}, Increment = 1, Suffix = "FOV", CurrentValue = 70, Flag = "FOV", Callback = function(v) workspace.Camera.FieldOfView = v fov = v end })
local Divider = PlayerStuffTab:CreateDivider()

workspace.Camera.Changed:Connect(function() workspace.Camera.FieldOfView = fov end)

PlayerStuffTab:CreateButton({
   Name = "Infinity Jump",
   Callback = function()
      _G.infinjump = not _G.infinjump
      if _G.infinJumpStarted == nil then
         _G.infinJumpStarted = true
         local m = plr:GetMouse()
         m.KeyDown:connect(function(k)
            if _G.infinjump and k:byte() == 32 then
               humanoid = plr.Character:FindFirstChildOfClass('Humanoid')
               humanoid:ChangeState('Jumping')
               wait()
               humanoid:ChangeState('Seated')
            end
         end)
      end
      Rayfield:Notify({
         Title = "Infinity Jump",
         Content = _G.infinjump and "Enabled" or "Disabled",
         Duration = 4,
         Image = "chevron-up"
      })
   end
})

local function setCollision(state)
    local char = plr.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                if part.Name == "HumanoidRootPart" then
                    part.CanCollide = false
                else
                    part.CanCollide = state
                end
            end
        end
    end
end

PlayerStuffTab:CreateButton({
    Name = "Noclip",
    Callback = function()
        noclip = not noclip
        if noclip then
            setCollision(false)
            if not connection then
                connection = game:GetService("RunService").Heartbeat:Connect(function()
                    setCollision(false)
                end)
            end
        else
            setCollision(true)
            if connection then connection:Disconnect() connection = nil end
        end
        Rayfield:Notify({
            Title = "Noclip",
            Content = noclip and "Enabled" or "Disabled",
            Duration = 4,
            Image = "move"
        })
    end,
})

PlayerStuffTab:CreateButton({
    Name = "Bring back glitches",
    Callback = function()
        character.Head.CanCollide = false
        character.HumanoidRootPart.CanCollide = false
        glitches = not glitches
        Rayfield:Notify({
            Title = "Glitches",
            Content = glitches and "Glitches enabled." or "Glitches disabled.",
            Duration = 4,
            Image = "activity"
        })
    end
})

local Toggle = PlayerStuffTab:CreateToggle({
   Name = "Force head colission",
   CurrentValue = false,
   Flag = "ForceHead",
   Callback = function(Value)
		forcehead = not forcehead

		if character:FindFirstChild("Head") then
			if forcehead == true then
				character:FindFirstChild("Head").CanCollide = true
			end
		end
		
   end,
})

ExploitsTab:CreateButton({
	Name = "Remove Piggy [Bot]",
	Callback = function()
		removebot = not removebot
		if workspace.PiggyNPC:FindFirstChildOfClass("Model") then
			workspace.PiggyNPC:FindFirstChildOfClass("Model"):Destroy()
		end
		Rayfield:Notify({ Title = "Bot Removed", Content = "Piggy has been removed.", Duration = 4, Image = "trash-2" })
	end
})

ItemsDropdown = ItemGiverTab:CreateDropdown({ Name = "Items", Options = items, CurrentOption = items[1] or "", MultipleOptions = false, Flag = "ItemDropdown", Callback = function(option) selecteditem = option[1] print(selecteditem) end })
EventsDropdown = ItemUserTab:CreateDropdown({ Name = "Events", Options = events, CurrentOption = events[1] or "", MultipleOptions = false, Flag = "EventDropdown", Callback = function(option) selectedevent = option[1] print(selectedevent) end })

function getitems(itemstorage)
	for _,v in ipairs(itemstorage:GetChildren()) do
		table.insert(items, v.Name)
	end
end

function getevents(eventstorage)
	for _,v in ipairs(eventstorage:GetChildren()) do
		table.insert(events, v.Name)
	end
end

function useritemselect()
	local tool = character:FindFirstChildOfClass("Tool")
	if tool then return tool end
	for _, v in ipairs(plr.Backpack:GetChildren()) do
		if v:IsA("Tool") then
			v.Parent = character
			return v
		end
	end
	return nil
end


ItemGiverTab:CreateButton({
   Name = "Get Item",
   Callback = function()
       local oldcf = character:GetPivot()
       local target = itemfolder and itemfolder:FindFirstChild(selecteditem)
       if target then
           local cf = target:IsA("Model") and target:GetPivot() or target:IsA("BasePart") and target.CFrame
           if cf then
               character:PivotTo(cf)
			   if cdmanip == true then
               fireclickdetector(target:FindFirstChildOfClass("ClickDetector"), 15)
               task.wait(0.25)
               character:PivotTo(oldcf)
			   end
               Rayfield:Notify({
                   Title = "Item Grabbed",
                   Content = "You received: " .. selecteditem,
                   Duration = 4,
                   Image = "key"
               })
           else
               warn("Could not get a valid CFrame from the selected item.")
           end
       else
           warn("Target item not found.")
       end
   end
})

local Section = ItemGiverTab:CreateSection("Disable this if item giver breaks your game")

local Toggle = ItemGiverTab:CreateToggle({
   Name = "Exploit Supports click detector Manipulation",
   CurrentValue = true,
   Flag = "CDManip", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
		cdmanip = not cdmanip
   end,
})

local Section = ItemGiverTab:CreateSection("Not supported by Xeno,JJSploit,more")


ItemUserTab:CreateButton({
   Name = "Use Event [Requires item]",
   Callback = function()
      local useritem = useritemselect()
      if useritem == nil then return end
      for _,v in ipairs(selectedevent:GetDescendants()) do
         if v:IsA("TouchInterest") then
            firetouchinterest(useritem, v.Parent, 0)
         end
      end
      Rayfield:Notify({
         Title = "Event Triggered",
         Content = "Event: " .. selectedevent.Name .. " used.",
         Duration = 4,
         Image = "zap"
      })
   end
})

local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

-- Utility function to clear ESP elements
local function clearESP()
	if not itemfolder then return end
	for _, v in itemfolder:GetChildren() do
		if v:FindFirstChild("ExploitOutline") then
			v.ExploitOutline:Destroy()
		end
		if v:FindFirstChild("ExploitBillboard") then
			v.ExploitBillboard:Destroy()
		end
	end
end

-- Main drawing function
local function drawESP()
	if not itemfolder or not itemesp then return end
	for _, v in itemfolder:GetChildren() do
		if not v:IsA("BasePart") then continue end

		local outline = Instance.new("Highlight")
		outline.Parent = v
		outline.FillColor = v.Color
		outline.OutlineColor = v.Color
		outline.Name = "ExploitOutline"

		if itemnames then
			local billboard = Instance.new("BillboardGui")
			billboard.AlwaysOnTop = true
			billboard.Size = UDim2.new(0, 100, 0, 40)
			billboard.ExtentsOffset = Vector3.new(0, 2, 0)
			billboard.Name = "ExploitBillboard"
			billboard.Adornee = v
			billboard.Parent = v

			local newtext = Instance.new("TextLabel")
			newtext.Parent = billboard
			newtext.Size = UDim2.new(1, 0, 1, 0)
			newtext.Text = v.Name
			newtext.BackgroundTransparency = 1
			newtext.TextColor3 = v.Color
			newtext.TextScaled = true
			newtext.Font = Enum.Font.SourceSans
		end
	end
end

-- Debounced ESP refresher
local debounce = false
local function refreshESP()
	if debounce then return end
	debounce = true
	clearESP()
	drawESP()
	task.delay(0.1, function() debounce = false end)
end

-- Monitors for the itemfolder and sets up ESP
task.spawn(function()
	while not itemfolder do
		RunService.Heartbeat:Wait()
	end

	-- Initial draw
	refreshESP()

	itemfolder.ChildAdded:Connect(function()
		if itemesp then refreshESP() end
	end)

	itemfolder.ChildRemoved:Connect(function()
		if itemesp then refreshESP() end
	end)
end)

local function clearPigESP()
	for _, v in workspace:GetDescendants() do
		if v.Name == "ExploitOutlinePig" or v.Name == "ExploitBillboardPig" then
			v:Destroy()
		end
	end
end

local function drawPigESP()
	if not piggyesp then return end

	local function createESP(v)
		if v:FindFirstChild("ExploitOutline") then v.ExploitOutline:Destroy() end
		local outline = Instance.new("Highlight")
		outline.Parent = v
		outline.FillColor = Color3.fromRGB(161, 54, 78)
		outline.OutlineColor = Color3.fromRGB(255, 255, 255)
		outline.Name = "ExploitOutlinePig"

		local hrp = v:FindFirstChild("HumanoidRootPart")
		if hrp then
			if hrp:FindFirstChild("ExploitBillboard") then hrp.ExploitBillboard:Destroy() end

			local billboard = Instance.new("BillboardGui")
			billboard.AlwaysOnTop = true
			billboard.Size = UDim2.new(0, 100, 0, 40)
			billboard.ExtentsOffset = Vector3.new(0, 1, 0)
			billboard.Name = "ExploitBillboardPig"
			billboard.Adornee = hrp
			billboard.Parent = hrp

			local newtext = Instance.new("TextLabel")
			newtext.Parent = billboard
			newtext.Size = UDim2.new(1, 0, 1, 0)
			newtext.Text = "Piggy"
			newtext.BackgroundTransparency = 1
			newtext.TextColor3 = Color3.new(1, 0, 0)
			newtext.TextScaled = true
			newtext.Font = Enum.Font.SourceSans
		end
	end

	if #workspace.PiggyNPC:GetChildren() ~= 0 then
		for _, v in ipairs(workspace.PiggyNPC:GetChildren()) do
			createESP(v)
		end
	else
		for _, va in ipairs(workspace:GetDescendants()) do
			if va:IsA("BoolValue") and va.Name == "Enemy" then
				local v = va.Parent
				createESP(v)
			end
		end
	end
end

workspace.PiggyNPC.ChildAdded:Connect(drawPigESP)

local function clearPlayerESP()
	for _, v in workspace:GetDescendants() do
		if v.Name == "ExploitOutlinePlayer" or v.Name == "PlayerESPGui" then
			v:Destroy()
		end
	end
end

local function getEquippedOrBackpackTool(plr)
	if plr.Character then
		for _, tool in pairs(plr.Character:GetChildren()) do
			if tool:IsA("Tool") then return tool end
		end
	end
	if plr:FindFirstChild("Backpack") then
		for _, tool in pairs(plr.Backpack:GetChildren()) do
			if tool:IsA("Tool") then return tool end
		end
	end
	return nil
end

local function updatePlayerESP(plr)
	if plr.Character and plr.Character:FindFirstChild("Enemy") and plr.Character.Enemy:IsA("BoolValue") then
		return
	end

	if plr == game.Players.LocalPlayer then return end
	if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end

	local hrp = plr.Character.HumanoidRootPart
	if hrp:FindFirstChild("PlayerESPGui") then
		hrp.PlayerESPGui:Destroy()
	end
	if plr.Character:FindFirstChild("ExploitOutlinePlayer") then
		plr.Character.ExploitOutlinePlayer:Destroy()
	end

	local outline = Instance.new("Highlight")
	outline.Name = "ExploitOutlinePlayer"
	outline.Parent = plr.Character
	outline.FillColor = Color3.fromRGB(0, 255, 255)
	outline.OutlineColor = Color3.new(1, 1, 1)

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "PlayerESPGui"
	billboard.Parent = hrp
	billboard.Adornee = hrp
	billboard.AlwaysOnTop = true
	billboard.Size = UDim2.new(0, 100, 0, 100)
	billboard.StudsOffset = Vector3.new(0, 3, 0)

	local tool = getEquippedOrBackpackTool(plr)

	if tool and tool:FindFirstChildOfClass("Decal") then
		local decal = tool:FindFirstChildOfClass("Decal")
		local image = Instance.new("ImageLabel")
		image.Parent = billboard
		image.BackgroundTransparency = 1
		image.Size = UDim2.new(1, 0, 1, 0)
		image.Image = decal.Texture
	else
		local label = Instance.new("TextLabel")
		label.Parent = billboard
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.new(1, 1, 1)
		label.TextScaled = true
		label.Font = Enum.Font.SourceSans
		label.Text = tool and tool.Name or "No Tool"
	end
end

local function drawPlayerESP()
	for _, plr in pairs(game.Players:GetPlayers()) do
		if plr.Character and plr.Character:FindFirstChild("Enemy") and plr.Character.Enemy:IsA("BoolValue") then
			continue
		end
		updatePlayerESP(plr)
	end
end

local function monitorToolChanges(plr)
	local function connectToolListeners(container)
		container.ChildAdded:Connect(function()
			if playeresp then updatePlayerESP(plr) end
		end)
		container.ChildRemoved:Connect(function()
			if playeresp then updatePlayerESP(plr) end
		end)
	end

	if plr:FindFirstChild("Backpack") then
		connectToolListeners(plr.Backpack)
	end

	if plr.Character then
		connectToolListeners(plr.Character)
	end

	plr.CharacterAdded:Connect(function(char)
		task.wait(1)
		connectToolListeners(char)
		if playeresp then updatePlayerESP(plr) end
	end)
end

for _, plr in pairs(game.Players:GetPlayers()) do
	monitorToolChanges(plr)
end

game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		task.wait(1)
		if playeresp then updatePlayerESP(plr) end
	end)
	monitorToolChanges(plr)
end)

-- GUI Buttons

local Button = VisualTab:CreateButton({
	Name = "Item Esp",
	Callback = function()
		itemesp = not itemesp
		if not itemesp then
			clearESP()
		else
			clearESP()
			drawESP()
		end
		Rayfield:Notify({
			Title = "Item Esp",
			Content = "Set item esp to " .. tostring(itemesp),
			Duration = 4,
			Image = "scan-eye",
		})
	end,
})

local Toggle = VisualTab:CreateToggle({
	Name = "Show item names",
	CurrentValue = true,
	Flag = "itemnames",
	Callback = function(Value)
		itemnames = not itemnames
	end,
})

VisualTab:CreateButton({
	Name = "Piggy Esp",
	Callback = function()
		piggyesp = not piggyesp
		if not piggyesp then
			clearPigESP()
		else
			clearPigESP()
			drawPigESP()
		end
		Rayfield:Notify({
			Title = "Piggy Esp",
			Content = "Set piggy esp to " .. tostring(piggyesp),
			Duration = 4,
			Image = "scan-eye",
		})
	end,
})

VisualTab:CreateButton({
	Name = "Player ESP",
	Callback = function()
		playeresp = not playeresp
		if not playeresp then
			clearPlayerESP()
		else
			clearPlayerESP()
			drawPlayerESP()
		end
		Rayfield:Notify({
			Title = "Player ESP",
			Content = "Set player esp to " .. tostring(playeresp),
			Duration = 4,
			Image = "scan-eye",
		})
	end,
})

ExploitsTab:CreateButton({
	Name = "Dex Explorer",
	Callback = function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
		Rayfield:Notify({
			Title = "Dex Explorer",
			Content = "Loaded",
			Duration = 4,
			Image = "scan-eye",
		})
	end,
})

ExploitsTab:CreateButton({
	Name = "Place Explorer",
	Callback = function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/ACEtheSOLID/NoobyHub-Reborn/refs/heads/main/PlaceFinder-v0.1.lua"))()
		Rayfield:Notify({
			Title = "Place Explorer",
			Content = "Loaded",
			Duration = 4,
			Image = "scan-eye",
		})
	end,
})
