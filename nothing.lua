local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local GUI = Player.PlayerGui
local VirtualInputManager = game:GetService("VirtualInputManager")

local MacLib = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()

local Window = MacLib:Window({
	Title = "ALS Auto",
	Subtitle = "Mainly meant for Inf.",
	Size = UDim2.fromOffset(600, 400),
	DragStyle = 2,
	DisabledWindowControls = {},
	ShowUserInfo = false,
	Keybind = Enum.KeyCode.RightControl,
	AcrylicBlur = true,
})

local TabGroup = Window:TabGroup()

local MainGroup = TabGroup:Tab({
    Name = "Main"
})

local AutoUnits = MainGroup:Section({
    Side = "Left"
})

local counter = 0

local counterLabel = AutoUnits:Label({Text = "Replayed: 0"},"CounterLabel")

local placeUnits = {
    ["AiHoshinoEvo"] = {Placed = false,Position = CFrame.new(76, 0, -209), Cost = 600},
    ["Giorno_GER"] = {Placed = false,Position = CFrame.new(90, 0, -215), Cost = 750},
    ["ChaeHae"] = {Placed = false,Position = CFrame.new(81, 0, -188), Cost = 1100},
    ["EscanorGodly"] = {Placed = false,Position = CFrame.new(106, 0, -223), Cost = 3750},
    ["DioOHShiny"] = {Placed = false,Position = CFrame.new(90, 0, -222), Cost = 3500},
    ["Gogeta"] = {Placed = false,Position = CFrame.new(79, 0, -226), Cost = 3850}
}

local allPlaced = false

local retrying = false

local vu = game:GetService("VirtualUser")

game:GetService("Players").LocalPlayer.Idled:connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   wait(1)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

function PlaceUnit(unitName,cframe)
    local args = {
        [1] = unitName,
        [2] = cframe * CFrame.Angles(-0, 0, -0)
    }
    
    game:GetService("ReplicatedStorage").Remotes.PlaceTower:FireServer(unpack(args))

    task.wait(1)

    if workspace.Towers:FindFirstChild(unitName) then
        placeUnits[unitName].Placed = true
        AutoUpgrade(unitName)
    end

end

function AutoUpgrade(unitName)
    local args = {
        [1] = workspace.Towers:WaitForChild(unitName),
        [2] = true
    }
    game:GetService("ReplicatedStorage").Remotes.UnitManager.SetAutoUpgrade:FireServer(unpack(args))
end

GUI.ChildAdded:Connect(function(child)
    if child.Name == "EndGameUI" then
        retrying = true
    end
end)

GUI.ChildRemoved:Connect(function(child)
    if child.Name == "EndGameUI" then
        for i,v in pairs(placeUnits) do
            placeUnits[i].Placed = false
        end
    
        allPlaced = false

        retrying = false

        counter = counter + 1
        
        counterLabel:UpdateName("Replayed: "..counter)
    end
end)

function ClickRetry()
    local button = GUI:WaitForChild("EndGameUI"):WaitForChild("BG"):WaitForChild("Buttons"):WaitForChild("Retry")

    VirtualInputManager:SendMouseButtonEvent(button.AbsolutePosition.X + (button.AbsoluteSize.X / 2) + 50,button.AbsolutePosition.Y + (button.AbsoluteSize.Y / 2)+ 50,0,true,game, 0)

    task.wait(0.1)

    VirtualInputManager:SendMouseButtonEvent(button.AbsolutePosition.X + (button.AbsoluteSize.X / 2),button.AbsolutePosition.Y + (button.AbsoluteSize.Y / 2),0,false,game, 0)
end

RunService.RenderStepped:Connect(function()
    if retrying then
        ClickRetry()
    end
    if allPlaced == false then
        local cash = Player:WaitForChild("Cash").Value
        if placeUnits["AiHoshinoEvo"].Placed == false then
            if cash >= placeUnits["AiHoshinoEvo"].Cost then
                PlaceUnit("AiHoshinoEvo",placeUnits["AiHoshinoEvo"].Position)
            end
        else
            if placeUnits["Giorno_GER"].Placed == false then
                if cash >= placeUnits["Giorno_GER"].Cost then
                    PlaceUnit("Giorno_GER",placeUnits["Giorno_GER"].Position)
                end
            else
                if placeUnits["ChaeHae"].Placed == false then
                    if cash >= placeUnits["ChaeHae"].Cost then
                        PlaceUnit("ChaeHae",placeUnits["ChaeHae"].Position)
                    end
                else
                    if placeUnits["EscanorGodly"].Placed == false then
                        if cash >= placeUnits["EscanorGodly"].Cost then
                            PlaceUnit("EscanorGodly",placeUnits["EscanorGodly"].Position)
                        end
                    else
                        if placeUnits["DioOHShiny"].Placed == false then
                            if cash >= placeUnits["DioOHShiny"].Cost then
                                PlaceUnit("DioOHShiny",placeUnits["DioOHShiny"].Position)
                            end
                        else
                            if placeUnits["Gogeta"].Placed == false then
                                if cash >= placeUnits["Gogeta"].Cost then
                                    PlaceUnit("Gogeta",placeUnits["Gogeta"].Position)
                                end
                            else
                                allPlaced = true
                            end
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end)
