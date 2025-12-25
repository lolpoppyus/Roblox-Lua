-- If you someone how got this source, please kindly look away :)

if not game:IsLoaded() then
    game.Loaded:Wait()
end

print("Game Loaded!")

if not game.Players.LocalPlayer.Character then
    game.Players.LocalPlayer.CharacterAdded:Wait()
end

print("Character Loaded!")

local MapPortals = {
    ["Giant's Dungeon"] = false,
    ["Alien City"] = false,
    ["Heavens Theatre"] = false,
    ["Soul King Palace"] = false,
    ["Candy Island"] = false,
    ["Love Island"] = false,
    ["Infernal Volcano"] = false,
    ["Easter Castle"] = false,
    ["Babylonia Castle"] = false,
    ["Zenith Arena"] = false,
    ["Candy Bowl"] = false,
}

local Connections = {}

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local GUI = Player.PlayerGui
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local TowerInfo = Modules:WaitForChild("TowerInfo")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Towers = game.Workspace:WaitForChild("Towers")

local PlaceTower = Remotes:WaitForChild("PlaceTower")

local TowerLimit = false;

local PlacableUnits = {}

local ReplayCounter = 0

local Prompt = nil

local portalNames = {"Portal","Place","Palace","Gate","Paradise","Society","Void","Demon"}

local elapsed = 0

local Enemies = game.Workspace:WaitForChild("Enemies")

local Wave = ReplicatedStorage:WaitForChild("Wave")

print("Passed Vars")

function GetMapName()
    local map = workspace:FindFirstChild("Map")
    if not map then
        warn("Map does not exist")
        return GUI:WaitForChild("Right").Frame.Frame:GetChildren()[3]:GetChildren()[3].Text
    end

    local mapName = map:FindFirstChild("MapName")
    if mapName and mapName:IsA("StringValue") then
        return mapName.Value
    end

    return GUI:WaitForChild("Right").Frame.Frame:GetChildren()[3]:GetChildren()[3].Text
end

print(GetMapName())

function IsPortalMap()
    for name,_ in pairs(MapPortals) do
        if name == GetMapName() then
            MapPortals[name] = true
        end
    end
end

IsPortalMap()

-- UI

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

local Window = Library:CreateWindow({
	Title = "ALS Auto Farm",
	Footer = "version: 14.0",
	NotifySide = "Right",
	ShowCustomCursor = false,
	AutoShow = false,
})

Library:Notify({
	Title = "ALS Auto Farm Loaded!",
	Time = 5,
})

local Tabs = {
	Main = Window:AddTab("Main", "user"),
    Event = Window:AddTab("Event","event"),
	["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Auto")

local ReplayLabel = LeftGroupBox:AddLabel("Replayed: 0")

local StopWatch = LeftGroupBox:AddLabel("Stop Watch [0]")

local CopyUnits = LeftGroupBox:AddButton({
	Text = "Save Placed Units",
	Func = function()
        table.clear(PlacableUnits)
        for i,v in pairs(GetTowers()) do
            if v:WaitForChild("Owner").Value == Player then
                table.insert(PlacableUnits,{Unit = v.Name, Placed = false, Position = v.PrimaryPart.CFrame,AutoAbility = false})
                AutoUpgrade(v)
            end
        end

        SaveJson(GetMapName():gsub("[,' ]", "").."Auto")

		Library:Notify({
			Title = "Saved Units",
			Description = "Stored Data In ALS Folder.",
			Time = 5,
		})
	end,
})

local CopyUnitsInfinityCastle = LeftGroupBox:AddButton({
	Text = "Save Placed Units (Infinity Castle)",
	Func = function()
        table.clear(PlacableUnits)
        for i,v in pairs(GetTowers()) do
            if v:WaitForChild("Owner").Value == Player then
                table.insert(PlacableUnits,{Unit = v.Name, Placed = false, Position = v.PrimaryPart.CFrame,AutoAbility = false})
                AutoUpgrade(v)
            end
        end

        SaveJson("IC/"..GetMapName():gsub("[,' ]", "").."Auto")

		Library:Notify({
			Title = "Saved Units",
			Description = "Stored Data In ALS Folder.",
			Time = 5,
		})
	end,
})

local CopyUnitsFinalExp = LeftGroupBox:AddButton({
	Text = "Save Placed Units (Final Exp)",
	Func = function()
        table.clear(PlacableUnits)
        for i,v in pairs(GetTowers()) do
            if v:WaitForChild("Owner").Value == Player then
                table.insert(PlacableUnits,{Unit = v.Name, Placed = false, Position = v.PrimaryPart.CFrame,AutoAbility = false})
                AutoUpgrade(v)
            end
        end

        SaveJson("FE/"..GetMapName():gsub("[,' ]", "").."Auto")

		Library:Notify({
			Title = "Saved Units",
			Description = "Stored Data In ALS Folder.",
			Time = 5,
		})
	end,
})

--local LeftEventGroupBox = Tabs.Event:AddLeftGroupbox("Event")

local tpToOrbs = false

--[[
local orbs = LeftEventGroupBox:AddToggle("Orbs", {
    Text = "TP To Orbs",
    Default = false,
})

orbs:OnChanged(function(state)
    tpToOrbs = state
end)
]]

local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")

MenuGroup:AddDropdown("DPIDropdown", {
	Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
	Default = "100%",

	Text = "DPI Scale",

	Callback = function(Value)
		Value = Value:gsub("%%", "")
		local DPI = tonumber(Value)

		Library:SetDPIScale(DPI)
	end,
})

MenuGroup:AddDivider()

MenuGroup:AddButton("Unload", function()
	Library:Unload()
end)

print("Passed Library")

-- OBJECT CONNECTIONS

-- FUNCTIONS

function EnterPortal()
    for i =1,10 do
        Click()
    end
    task.wait(3)
    SelectPortal()
    task.wait(.5)
end

function SelectPortal()
    GuiService.GuiNavigationEnabled = true

    for i,v in pairs(Prompt:GetDescendants()) do
        if v:IsA("TextLabel") then
            for index,names in ipairs(portalNames) do
                if string.find(v.Text,names) then
                    SpawnPortal = v.Parent.Parent
                    break
                end
            end
        end
    end

    GuiService.SelectedObject = SpawnPortal

    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)

    task.wait(.5)

    for i,v in pairs(Prompt:GetDescendants()) do
        if v:IsA("TextLabel") then
            if v.Text == "Confirm" then
                SpawnPortal = v.Parent
                break
            end
        end
    end

    GuiService.SelectedObject = SpawnPortal
    
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)

end

function Click()
    VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game, 0)
    task.wait(.1)
    VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game, 0)
end

function ClickRetry()
    task.spawn(function()
        task.wait(1)
        if GUI:FindFirstChild("EndGameUI") then
            while GUI:FindFirstChild("EndGameUI").Enabled == false do
                Click()
                task.wait(1)
            end

            GuiService.GuiNavigationEnabled = true

            local button = GUI:WaitForChild("EndGameUI"):WaitForChild("BG"):WaitForChild("Buttons"):WaitForChild("Retry")
            if ReplicatedStorage.Gamemode.Value == "Infinity Castle" then
                button = GUI:WaitForChild("EndGameUI"):WaitForChild("BG"):WaitForChild("Buttons"):WaitForChild("Next")
            end
            button.Visible = true

            local connectedButton = button.MouseButton1Click:Connect(function()
                if MapPortals[GetMapName()] == true then
                    if ReplicatedStorage.Gamemode.Value ~= "Survival" then
                        return;
                    end
                end
                if ReplicatedStorage.Gamemode.Value == "Dungeon" then
                    return;
                end
                if GetGamemode() ~= "MidnightHunt" then
                    RunAllConnections()
                end
            end)

            GuiService.SelectedObject = button

            task.wait(0.1)

            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)

            task.wait(0.1)

            GuiService.SelectedObject = nil
            GuiService.GuiNavigationEnabled = false

            connectedButton:Disconnect()
        end
    end)
end

function ClickNext()
    task.wait(3)
    for i = 1,50 do
        if GUI:FindFirstChild("EndGameUI") then
            local button = GUI:WaitForChild("EndGameUI"):WaitForChild("BG"):WaitForChild("Buttons"):WaitForChild("Next")
            button.Visible = true
    
            VirtualInputManager:SendMouseButtonEvent(button.AbsolutePosition.X + (button.AbsoluteSize.X / 2) + 50,button.AbsolutePosition.Y + (button.AbsoluteSize.Y / 2)+ 50,0,true,game, 0)
    
            task.wait(0.1)
    
            VirtualInputManager:SendMouseButtonEvent(button.AbsolutePosition.X + (button.AbsoluteSize.X / 2) + 50,button.AbsolutePosition.Y + (button.AbsoluteSize.Y / 2)+ 50,0,false,game, 0)
        end
    end
end

function CurrentCash()
    local currentCash = Player:WaitForChild("Cash").Value
    return currentCash
end

function GetGamemode()
    return ReplicatedStorage:WaitForChild("Gamemode").Value
end

function GetTowers()
    return workspace.Towers:GetChildren()
end

function cframePositionToString(cframe)
	local pos = cframe.Position
	local x = math.floor(pos.X)
	local y = math.floor(pos.Y)
	local z = math.floor(pos.Z)
	return string.format("(%d, %d, %d)", x, y, z)
end

function SaveJson(profile)
    local savedData = {}
	savedData["Map"] = GetMapName()
	local unitsToSave = {}
	for i,v in ipairs(workspace.Towers:GetChildren()) do
		if v.Owner.Value == Player then
				table.insert(unitsToSave,{Unit = v.Name, Placed = false, Position = cframePositionToString(v.PrimaryPart.CFrame), Order = i})
		end
	end
	savedData["Units"] = unitsToSave
					
	local savedJson = HttpService:JSONEncode(savedData)
					
	writefile("ALS/"..profile..".json",savedJson)
end

function PlaceUnit(unit,position)
    local unitName = string.gsub(unit,"EZA","")
    unitName = string.gsub(unitName,"_Light","")
    unitName = string.gsub(unitName,"_Water","")

    local args = {
        [1] = unitName,
        [2] = position * CFrame.Angles(-0, 0, -0)
    }

    PlaceTower:FireServer(unpack(args))
end

function AutoUpgrade(unit)
    if unit:WaitForChild("Owner").Value == Player then
        local args = {
            [1] = unit,
            [2] = true
        }
        game:GetService("ReplicatedStorage").Remotes.UnitManager.SetAutoUpgrade:FireServer(unpack(args))
    end
end

function DecodeCFrame(cf)
    local pos = cf.Position
    local newText = string.gsub(pos, "[%(%)]", "")
    local values = newText:split(",")
    local x, y, z = tonumber(values[1]), tonumber(values[2]), tonumber(values[3])
    local decodedCf = CFrame.new(x, y, z)
    return decodedCf
end

function LoadProfile(profile)
    if ReplicatedStorage.Gamemode.Value == "Infinity Castle" then
        local file = readfile("ALS/IC/"..profile..".json")

        local decoded = HttpService:JSONDecode(file)

        PlacableUnits = {}
        for i,v in ipairs(decoded["Units"]) do
            table.insert(PlacableUnits,{Unit = v.Unit, Placed = false, Position = DecodeCFrame(v), Order = v.Order})
        end
        print("Infinity Castle Units Loaded")
        return
    elseif ReplicatedStorage.Gamemode.Value == "Final Expediton" then
        local file = readfile("ALS/FE/"..profile..".json")

        local decoded = HttpService:JSONDecode(file)

        PlacableUnits = {}
        for i,v in ipairs(decoded["Units"]) do
            table.insert(PlacableUnits,{Unit = v.Unit, Placed = false, Position = DecodeCFrame(v), Order = v.Order})
        end
        print("Final Expedition Units Loaded")
        return
    end
    local file = readfile("ALS/"..profile..".json")

    local decoded = HttpService:JSONDecode(file)

    for i,v in ipairs(decoded["Units"]) do
        table.insert(PlacableUnits,{Unit = v.Unit, Placed = false, Position = DecodeCFrame(v), Order = v.Order})
    end
    print("Units Loaded")
end

function SendRewardsWebhook(child)
    local rewards = child:WaitForChild("BG"):WaitForChild("Container"):WaitForChild("Rewards"):WaitForChild("Holder")
    task.wait(1)
    local rewardString = "```"
    for i,v in pairs(rewards:GetChildren()) do
        if v:IsA("TextButton") then
            local itemName = v:FindFirstChild("ItemName")

            if itemName then
                rewardString = rewardString..itemName.Text..":"
            else
                rewardString = rewardString..v.Name..":"
            end

            local amountText = v:FindFirstChild("Amount")
            
            if amountText then
                rewardString = rewardString..v.Amount.Text.."|"
            else
                rewardString = rewardString.."1x|"
            end
        end
    end
    rewardString = rewardString.."```"
    if rewardString == "``````" then
        rewardString = "```You Failed This Run...```"
    end
    SendMessage(getgenv().webhookUrl,rewardString)
end

function SendMessage(url, message)
    local http = game:GetService("HttpService")
    local headers = {
        ["Content-Type"] = "application/json"
    }
    local data = {
        ["content"] = message
    }
    local body = http:JSONEncode(data)
    local response = request({
        Url = url,
        Method = "POST",
        Headers = headers,
        Body = body
    })
end

function TP(obj)
    Player.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0,3,0)
end

function AutoPlay()
    if isfile("ALS/"..GetMapName():gsub("[,' ]", "").."Auto.json") then
        LoadProfile(GetMapName():gsub("[,' ]", "").."Auto")
    end
    if MapPortals["Infernal Volcano"] then
        Connections["VolcanoesAdded"] = game.Workspace.Map.Volcanoes.ChildAdded:Connect(function(child)
            for i,v in pairs(child:GetChildren()) do
                if v:IsA("ProximityPrompt") then
                    local args = {
                        [1] = v.Parent
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("VolcanoRemote"):FireServer(unpack(args))
                end
            end
        end)
    end
    if MapPortals["Babylonia Castle"] then
       Connections["EffectZonesAdded"] =  game.Workspace.EffectZones.ChildAdded:Connect(function(child)
            if child.Name == "ZoneHitbox" then
                Player.Character.HumanoidRootPart.CFrame = child.CFrame + Vector3.new(0,3,0)
            end
        end)
        task.spawn(function()
            while true do
                task.wait(0.1)
                local connections = workspace.Map.ActiveOrbs:GetDescendants()
                for i,v in pairs(connections) do
                    if v:IsA("ProximityPrompt") then
                        Player.Character.HumanoidRootPart.CFrame = v.Parent.CFrame + Vector3.new(0,3,0)
                        fireproximityprompt(v,1,true)
                        task.wait(1)
                    end
                end
            end
        end)
    end
    if MapPortals["Zenith Arena"] then
        local GameAction = ReplicatedStorage.Remotes.GameAction -- RemoteEvent 

        Connections["ZoneHitboxChanged"] = workspace.EffectZones.ChildAdded:Connect(function(child)
            if child.Name == "ZoneHitbox" then
                TP(child)
            end
        end)
        Connections["EffectsAdded"] = workspace.Effects.ChildAdded:Connect(function()
            for i,v in pairs(GetTowers()) do
                if v.Name == "AiHoshinoEvo" then
                    GameAction:FireServer(
                        "ManaRush_Defend",
                        v.HumanoidRootPart.CFrame
                    )
                end
            end
        end)
        task.spawn(function()
            while true do
                task.wait(.1)
                for i,v in pairs(GetTowers()) do
                    if v.Name == "AiHoshinoEvo" then
                        GameAction:FireServer(
                            "ManaRush_Rally",
                            v.HumanoidRootPart.CFrame
                        )
                    end
                end
                task.wait(5)
            end
        end)
    end
    if MapPortals["Candy Bowl"] then
        task.spawn(function()

            local candy = workspace.Collectibles

            while true do
                if tpToOrbs then
                    for _,v in pairs(candy:GetChildren()) do
                        if v:IsA("Part") then
                            TP(v)
                            task.wait(0.05)
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
end

function isTableEmpty(t)
    return next(t) == nil
end

function FirstJoin()
    if isTableEmpty(PlacableUnits) then
        return
    end
    if not PlacableUnits[1].Placed then
        local currentUnit = require(TowerInfo:FindFirstChild(PlacableUnits[1].Unit))
        if CurrentCash() >= currentUnit[0].Cost then
            PlaceUnit(PlacableUnits[1].Unit,PlacableUnits[1].Position)
        end
    end
end

function formatTime(seconds)
    local mins = math.floor(seconds / 60)
    local secs = seconds % 60
    return string.format("%02d:%05.2f", mins, secs)
end

function AutoToggleUnits(child)
    if child.Name == "SungMonarch" then
        if child:WaitForChild("Owner").Value == Player then
            Connections["SungMonarchMax"] = child:GetAttributeChangedSignal("SL_System_AvailablePoints"):Connect(function()
                if child:GetAttribute("SL_System_Str") < child:GetAttribute("SL_System_MaxStr") then
                    local SJWStats = ReplicatedStorage.Remotes.AbilityRemotes.SJWStats -- RemoteEvent 
                    SJWStats:FireServer(
                        "AddStatMax",
                        "Strength"
                    )
                else
                    local SJWStats = ReplicatedStorage.Remotes.AbilityRemotes.SJWStats -- RemoteEvent 
                    SJWStats:FireServer(
                        "AddStatMax",
                        "Intelligence"
                    )
                end
            end)

            local args = {
                [1] = child,
                [2] = "System",
                [3] = true
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ToggleAutoUse"):FireServer(unpack(args))
        end
    end
    if child.Name == "AiHoshinoEvo" then
        if child:WaitForChild("Owner").Value == Player then
            Connections["AiUpgrade"] = child:WaitForChild("Upgrade").Changed:Connect(function(val)
                if val >= 6 then
                    local args = {
                        [1] = child,
                        [2] = "Concert",
                        [3] = true
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ToggleAutoUse"):FireServer(unpack(args))
                end
            end)
        end
    end
    if child.Name == "Mugetsu" then
        if child:WaitForChild("Owner").Value == Player then
            local ToggleAutoUse = ReplicatedStorage.Remotes.ToggleAutoUse

            ToggleAutoUse:FireServer(
                child,
                "Kai Release",
                true
            )

        end
    end
    if child.Name == "Bulma" then
        if child:WaitForChild("Owner").Value == Player then
            Connections["BulmaWishBalls"] = child:WaitForChild("Meters"):WaitForChild("Wish Balls"):GetAttributeChangedSignal("Value"):Connect(function(val)
                if val == child:WaitForChild("Meters"):WaitForChild("Wish Balls"):GetAttribute("MaxValue") then
                    local ReplicatedStorage = game:GetService("ReplicatedStorage")

                    local Ability = ReplicatedStorage.Remotes.Ability

                    local Bulma = child

                    Ability:FireServer(
                        Bulma,
                        "Summon Wish Dragon"
                    )

                    Ability:InvokeServer(
                        Bulma,
                        "Wish: Power"
                    )
                end
            end)
        end
    end
    if child.Name == "KurumiEvo" then
        if child:WaitForChild("Owner").Value == Player then
            Connections["KurumiUpgrade"] = child:WaitForChild("Upgrade").Changed:Connect(function(val)
                if val >= 8 then
                    local args = {
                        [1] = child,
                        [2] = "Zaphkol"
                    }
                    
                    game:GetService("ReplicatedStorage").Remotes.Ability:InvokeServer(unpack(args))
                    
                    task.wait(1)
        
                    local args = {
                        [1] = "DPS"
                    }
                    
                    game:GetService("ReplicatedStorage").Remotes.AbilityRemotes.Zaphkol:FireServer(unpack(args))
                end
            end)
        end
    end
    if child.Name == "GojoEvo2EZA" then
        if child:WaitForChild("Owner").Value == Player then
            Connections["GojoUpgrade"] = child:WaitForChild("Upgrade").Changed:Connect(function(val)
                if val >= 3 then
                    local args = {
                        [1] = child,
                        [2] = "Unlimited Void",
                        [3] = true
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ToggleAutoUse"):FireServer(unpack(args))
                end
            end)
        end
    end
    if child.Name == "CosmicGarou" then
        if child:WaitForChild("Owner").Value == Player then
            Connections["GarouUpgrade"] = child:WaitForChild("Upgrade").Changed:Connect(function(val)
                if val >= 2 then
                    local args = {
                        [1] = child,
                        [2] = 1
                    }
                    
                    game:GetService("ReplicatedStorage").Remotes.Ability:InvokeServer(unpack(args))

                    task.wait(1)

                    local args = {
                        [1] = "Cosmic"
                    }
                    
                    game:GetService("ReplicatedStorage").Remotes.AbilityRemotes:FindFirstChild("Mode Swap"):FireServer(unpack(args))

                end
            end)
        end
    end
end

function Challenge()
    if ReplicatedStorage:WaitForChild("Challenge").Value == "Tower Limit" or ReplicatedStorage:WaitForChild("Challenge").Value == "TowerLimit" then
        TowerLimit = true
    end
end

function SelectDamageCard(obj)
    task.spawn(function()
        GuiService.GuiNavigationEnabled = true

        GuiService.SelectedObject = obj

        task.wait(0.1)

        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)

        local ui = game:GetService("Players").LocalPlayer.PlayerGui.Prompt.Frame.Frame:GetChildren()
        local child = ui[5]:WaitForChild("TextButton")

        task.wait(0.1)
        GuiService.SelectedObject = child

        task.wait(0.1)

        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        task.wait(0.1)

        GuiService.SelectedObject = nil

        GuiService.GuiNavigationEnabled = false
    end)
end

function RunAllConnections()
    Connections["TowersAdded"] = Towers.ChildAdded:Connect(function(child)
        if child:WaitForChild("Owner").Value == Player then
            for i,v in pairs(PlacableUnits) do
                if v.Unit == child.Name then
                    v.Placed = true
                    AutoUpgrade(child)
                end
            end
            AutoToggleUnits(child)
        end
    end)

    Connections["TowersRemoved"] = Towers.ChildRemoved:Connect(function(child)
        if MapPortals["Giant's Dungeon"] then
            if child.Owner.Value == Player then
                local UnitInfo = require(TowerInfo:FindFirstChild(child.Name))
                for i,v in pairs(PlacableUnits) do
                    if v.Unit == child.Name then
                        v.Placed = false
                        while not v.Placed do
                            if CurrentCash() >= UnitInfo[0].Cost then
                                PlaceUnit(child,v.Position)
                            end
                            task.wait(1)
                        end
                    end
                end
            end
        end
    end)

    Connections["Cash"] = Player:WaitForChild("Cash").Changed:Connect(function(val)
        if PlacableUnits ~= nil then
            for i,v in ipairs(PlacableUnits) do
                if TowerLimit then
                    if v.Order >= 6 then
                        return
                    end
                end
                local UnitInfo = require(TowerInfo:FindFirstChild(v.Unit))
                if v.Placed == false then
                    if val >= UnitInfo[0].Cost then
                        PlaceUnit(v.Unit,v.Position)
                    end
                    return
                end
            end
        end
    end)

    Connections["GUIAdded"] = GUI.ChildAdded:Connect(function(child)
        if child.Name == "Prompt" then
            if ReplicatedStorage.Gamemode.Value == "BossRush" then
                task.spawn(function()
                    task.wait(1)
                    
                    local ui = game:GetService("Players").LocalPlayer.PlayerGui.Prompt.Frame.Frame:GetChildren()
                    local index = 4
                    local child = ui[index]:GetChildren()

                    for i, v in ipairs(child) do
                        print(v.Name)
                        for _, p in ipairs(v:GetDescendants()) do
                            if p:IsA("TextLabel") and string.find(p.Text:lower(), "damage") then

                                if string.find(p.Text,"-") then continue end
                                SelectDamageCard(v)
                                --[[
                                if i == 1 then
                                    print("FOund 1")
                                    SelectDamageCard(v)
                                    print(p.Text)
                                elseif i == 2 then
                                    print("FOund 2")
                                    SelectDamageCard(v)
                                    print(p.Text)
                                elseif i == 3 then
                                    print("FOund 3")
                                    SelectDamageCard(v)
                                    print(p.Text)
                                elseif i == 4 then
                                    print("FOund 4")
                                    SelectDamageCard(v)
                                    print(p.Text)
                                end]]
                                break
                            end
                        end
                    end
                end)
            else
                task.spawn(function()
                    while child do
                        Click()
                        task.wait(1)
                    end
                end)
            end
            --Prompt = child
            --EnterPortal()
        end
        if child.Name == "EndGameUI" then
            if GetGamemode() ~= "MidnightHunt" then
                if MapPortals["Candy Bowl"] ~= true then
                    EndAllConnections()
                end
            end
            if GetGamemode() ~= "InfiniteCastle" then
                for i,v in pairs(PlacableUnits) do
                    PlacableUnits[i].Placed = false
                end
            
                SendRewardsWebhook(child)
        
                ClickRetry()
            else
                SendRewardsWebhook(child)

                ClickNext()
            end
        end
    end)

    Connections["GUIRemoved"] = GUI.ChildRemoved:Connect(function(child)
        if child.Name == "Prompt" then
            if MapPortals["Candy Island"] or MapPortals["Love Island"] then
                ClickRetry()
            end
        end
        if child.Name == "EndGameUI" then
            if GetGamemode() ~= "InfiniteCastle" then
                for i,v in pairs(PlacableUnits) do
                    PlacableUnits[i].Placed = false
                end
        
                ReplayCounter = ReplayCounter + 1
                
                --ReplayLabel:UpdateName("Replayed: "..ReplayCounter)
        
                ReplayLabel:SetText("Replayed: "..ReplayCounter)
        
        
                if ReplayCounter == 50 then
                    if not MapPortals["Easter Castle"] then
                        Remotes.RestartMatch:FireServer()
                        SendMessage(getgenv().webhookUrl,"```50 Matches Restarted At "..formatTime(elapsed).."```")
                    end
                end
            else
                SendRewardsWebhook(child)

                ClickNext()
            end
        end
    end)

    Connections["Waves"] = Wave.Changed:Connect(function(val)
        if MapPortals["Candy Bowl"] then
            if val >= 70 then
                local candy = GUI:FindFirstChild("CandyBowlDefenseHUD"):FindFirstChild("TopLeftCurrencies"):FindFirstChild("Frame"):FindFirstChild("TextLabel")

                SendMessage(getgenv().webhookUrl,"```Halloween Cookies Obtained: "..candy.Text.."```")
                
                Remotes.RestartMatch:FireServer()

                for i,v in pairs(PlacableUnits) do
                    PlacableUnits[i].Placed = false
                end
            end
        end
    end)

    Connections["EnemiesAdded"] = Enemies.ChildAdded:Connect(function(child)
        if MapPortals["Easter Castle"] then
            if Wave.Value >= 35 then
                if child.Name == "Boss" then
                    for i,v in pairs(GetTowers()) do
                        if v.Name == "GojoEvo2EZA" then
                            if v.Owner.Value == Player then
                                local args = {
                                    [1] = v,
                                    [2] = 2;
                                }
                                
                                Remotes:WaitForChild("Ability"):InvokeServer(unpack(args))
                            end
                        end
                        if v.Name == "MadokaEvo" then
                            if v.Owner.Value == Player then
                                local args = {
                                    [1] = v,
                                    [2] = 1;
                                }
                                
                                Remotes:WaitForChild("Ability"):InvokeServer(unpack(args))
                            end
                        end
                    end
                end
            end
        end
        if GetGamemode() == "MidnightHunt" then
            if Wave.Value == 50 then
                if child.Name == "Boss" then
                    for i,v in pairs(GetTowers()) do
                        if v.Name == "MobEvo" then
                            if v.Owner.Value == Player then
                                local Ability = Remotes.Ability 

                                Ability:InvokeServer(
                                    v,
                                    "100%..."
                                )

                                task.wait(1)

                                local AbilitySelection = Remotes.AbilitySelection

                                AbilitySelection:FireServer(
                                    1,
                                    "Obsession"
                                )
                            end
                        end
                        if v.Name == "LelouchEvo" then
                            if v.Owner.Value == Player then
                                local Ability = Remotes.Ability

                                Ability:InvokeServer(
                                    v,
                                    "All of you, Die!"
                                )
                            end
                        end
                        if v.Name == "AsuraEvo" then
                            if v.Owner.Value == Player then
                                task.wait(1)
                                local Ability = Remotes.Ability

                                Ability:InvokeServer(
                                    v,
                                    "Lines of Sanzu"
                                )
                            end
                        end
                    end
                end
            end
        end
        if MapPortals["Zenith Arena"] then
            if child.Name == "Shadow Frieran" then
                
            end
        end
    end)

    Connections["RunService"] = RunService.RenderStepped:Connect(function(deltaTime)
        elapsed = elapsed + deltaTime
        --StopWatch:UpdateName("Stopwatch ["..formatTime(elapsed).."]")

        StopWatch:SetText("Stopwatch ["..formatTime(elapsed).."]")
    end)

    AutoPlay()
end

function EndAllConnections()
    for i,v in pairs(Connections) do
        v:Disconnect()
    end
end

RunAllConnections()

-- ACTIVE FUNCTIONS

Challenge()

FirstJoin()

--MainGroup:Select()

local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

