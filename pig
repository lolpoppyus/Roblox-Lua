local library = loadstring(game:HttpGet("https://pastebin.com/raw/2xDTKdpV", true))()

local bypass = library:CreateTab("Bypass", "Bypass the encryption.", true)

bypass:CreateButton("Bypass", function()
    game.Workspace.ItemFolder.Name = "Items"
end)

local itemlist = library:CreateTab("Items", "Teleport to items.", true)

itemlist:CreateDropDown("House", {"Red Key", "Blue Key", "Yellow Key", "Purple Key", "Green Key", "Orange Key", "White Key", "Wrench", "Board", "Hammer"},function(arg)
    if arg == "Red Key" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Items.RedKey.CFrame
    elseif arg == "Blue Key" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Items.BlueKey.CFrame
    elseif arg == "Yellow Key" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Items.YellowKey.CFrame
    elseif arg == "Purple Key" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Items.PurpleKey.CFrame
    elseif arg == "Green Key" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Items.GreenKey.CFrame
    elseif arg == "Orange Key" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Items.OrangeKey.CFrame
    elseif arg == "White Key" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Items.WhiteKey.CFrame
    elseif arg == "Wrench" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Items.Wrench.CFrame
    elseif arg == "Board" then
        print("Wooden Board")
    elseif arg == "Hammer" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Items.Hammer.CFrame
    end
end)

itemlist:CreateDropDown("Outpost", {"Red Key", "Blue Key", "Yellow Key", "Purple Key", "Green Key", "Orange Key", "White Key", "Wrench", "Board", "Hammer"},function(arg)
    if arg == "Red Key" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Items.RedKey.CFrame
    elseif arg == "Blue Key" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Items.BlueKey.CFrame
    elseif arg == "Yellow Key" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Items.YellowKey.CFrame
    elseif arg == "Purple Key" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Items.PurpleKey.CFrame
    elseif arg == "Green Key" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Items.GreenKey.CFrame
    elseif arg == "Orange Key" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Items.OrangeKey.CFrame
    elseif arg == "White Key" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Items.WhiteKey.CFrame
    elseif arg == "Wrench" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Items.Wrench.CFrame
    elseif arg == "Board" then
        print("Wooden Board")
    elseif arg == "Hammer" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Items.Hammer.CFrame
    end
end)


local playerCheats = library:CreateTab("Local Player", "Cheats for you only.", true)

playerCheats:CreateSlider("Walk Speed", 0, 250, function(arg)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(arg)
end)

playerCheats:CreateToggle("Inf Jump", function(gg)
    local InfiniteJumpEnabled = true
    local arg = ( gg and true or false )
    if gg then
      _G.infj = game:GetService("UserInputService").JumpRequest:connect(function()
            if InfiniteJumpEnabled then
            game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
        end
    end)
    elseif not gg then
      _G.infj:Disconnect()
    end
end)
