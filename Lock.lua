--[[

███╗░░░███╗░█████╗░██████╗░███████╗  ██████╗░██╗░░░██╗  ██╗░░░░░░█████╗░░██████╗░
████╗░████║██╔══██╗██╔══██╗██╔════╝  ██╔══██╗╚██╗░██╔╝  ██║░░░░░██╔══██╗██╔════╝░
██╔████╔██║███████║██║░░██║█████╗░░  ██████╦╝░╚████╔╝░  ██║░░░░░╚██████║██║░░██╗░
██║╚██╔╝██║██╔══██║██║░░██║██╔══╝░░  ██╔══██╗░░╚██╔╝░░  ██║░░░░░░╚═══██║██║░░╚██╗
██║░╚═╝░██║██║░░██║██████╔╝███████╗  ██████╦╝░░░██║░░░  ███████╗░█████╔╝╚██████╔╝
╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═════╝░╚══════╝  ╚═════╝░░░░╚═╝░░░  ╚══════╝░╚════╝░░╚═════╝░
]]--

local UserInputService = game:GetService("UserInputService")
local Key = Enum.KeyCode.C
local Enabled = true
local Locking = false
local LocalPlayer = game.Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local LocalMouse = game.Players.LocalPlayer:GetMouse()

local Prediction = 0.11
local AutoPrediction = true

UserInputService.InputBegan:Connect(function(keygo, ok)
    if (not ok) then
        if (keygo.KeyCode == Key) then
            if Enabled then
                Locking = not Locking
                if Locking then
                    TargetPlayer = getClosestPlayerToCursor()
                end
            end
        end
    end
end)

function getClosestPlayerToCursor()
    local closestPlayer
    local shortestDistance = 120

    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and
            v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("LowerTorso") then
            local pos = Camera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(LocalMouse.X, LocalMouse.Y)).magnitude
            if magnitude < shortestDistance then
                closestPlayer = v
                shortestDistance = magnitude
            end
        end
    end
    return closestPlayer
end

game:GetService("RunService").RenderStepped:connect(function()
    if AutoPrediction == true then
        local pingvalue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
        local split = string.split(pingvalue, '(')
        local ping = tonumber(split[1])
        if ping < 130 then
            Prediction = 0.151
        elseif ping < 125 then
            Prediction = 0.149
        elseif ping < 110 then
            Prediction = 0.146
        elseif ping < 105 then
            Prediction = 0.138
        elseif ping < 90 then
            Prediction = 0.136
        elseif ping < 80 then
            Prediction = 0.134
        elseif ping < 70 then
            Prediction = 0.131
        elseif ping < 60 then
            Prediction = 0.160
        elseif ping < 50 then
            Prediction = 0.153
        elseif ping < 40 then
            Prediction = 0.15529888
        end
    end

    local Root = LocalPlayer.Character.HumanoidRootPart
    if Locking == true then
        if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("UpperTorso") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, TargetPlayer.Character.UpperTorso.Position +
                TargetPlayer.Character.UpperTorso.Velocity * Prediction)
        end
    end
end)
