local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local GUI = Player.PlayerGui
local VirtualInputManager = game:GetService("VirtualInputManager")

local placeUnits = {
    ["AiHoshinoEvo"] = {Placed = false, Cost = 600},
    ["Gogeta"] = {Placed = false, Cost = 3850},
    ["Giorno_GER"] = {Placed = false, Cost = 750},
    ["EscanorGodly"] = {Placed = false, Cost = 3750},
    ["DioOHShiny"] = {Placed = false, Cost = 3500},
    ["ChaeHae"] = {Placed = false, Cost = 1100}
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
                PlaceUnit("AiHoshinoEvo",CFrame.new(-633.967529296875, -57.04720687866211, -376.8282470703125))
            end
        else
            if placeUnits["Giorno_GER"].Placed == false then
                if cash >= placeUnits["Giorno_GER"].Cost then
                    PlaceUnit("Giorno_GER",CFrame.new(-637.9058837890625, -57.04720687866211, -385.64453125))
                end
            else
                if placeUnits["ChaeHae"].Placed == false then
                    if cash >= placeUnits["ChaeHae"].Cost then
                        PlaceUnit("ChaeHae",CFrame.new(-647.4136352539062, -57.04720687866211, -401.79046630859375))
                    end
                else
                    if placeUnits["EscanorGodly"].Placed == false then
                        if cash >= placeUnits["EscanorGodly"].Cost then
                            PlaceUnit("EscanorGodly",CFrame.new(-647.56640625, -57.04720687866211, -397.659423828125))
                        end
                    else
                        if placeUnits["DioOHShiny"].Placed == false then
                            if cash >= placeUnits["DioOHShiny"].Cost then
                                PlaceUnit("DioOHShiny",CFrame.new(-641.1534423828125, -57.04720687866211, -399.4578552246094))
                            end
                        else
                            if placeUnits["Gogeta"].Placed == false then
                                if cash >= placeUnits["Gogeta"].Cost then
                                    PlaceUnit("Gogeta",CFrame.new(-643.4534912109375, -57.04720687866211, -387.2164306640625))
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
