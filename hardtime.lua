local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/thewiiufan/greenpancakehub/refs/heads/main/hardtimeUI.lua"))()
_G.atm_farm = false
_G.register_farm = false
local config = {
    WALKSPEED = 28,
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    task.wait()
    LocalPlayer = Players.LocalPlayer
end

local RunService = game:GetService("RunService")
local ChangedParts = {}
local Noclip = false
local Connection

local function SetNoclip(enabled)
    Noclip = enabled

    if enabled then
        Connection = RunService.Stepped:Connect(function()
            local Character = LocalPlayer.Character
            if not Character then return end

            for _, v in Character:GetDescendants() do
                if v:IsA("BasePart") and v.CanCollide == true and v.Name ~= "Float" then
                    ChangedParts[v] = v.CanCollide
                    v.CanCollide = false
                    
                end
            end
        end)
    else
        if Connection then
            Connection:Disconnect()
            Connection = nil
        end

        local Character = LocalPlayer.Character
        if Character then
            for v, CanCollide in pairs(ChangedParts) do if v.Parent then v.CanCollide = CanCollide end end table.clear(ChangedParts)
        end
    end
end

local floatingFunc

local function SetFloat(state)
    local character = LocalPlayer.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local floatPart = character:FindFirstChild("Float")

    if state == true then
        if floatPart and floatingFunc then
            return
        end

        if floatPart then
            floatPart:Destroy()
        end

        floatPart = Instance.new("Part")
        floatPart.Name = "Float"
        floatPart.Transparency = 1
        floatPart.Size = Vector3.new(2, 0.2, 1.5)
        floatPart.Anchored = true
        floatPart.CanCollide = true
        floatPart.Parent = character

        local floatPoint = -3.1

        floatingFunc = RunService.PreAnimation:Connect(function()
            if character.Parent and root.Parent and floatPart.Parent then
                floatPart.CFrame = root.CFrame * CFrame.new(0, floatPoint, 0)
            else
                floatingFunc:Disconnect()
                floatingFunc = nil

                if floatPart.Parent then
                    floatPart:Destroy()
                end
            end
        end)

    elseif state == false then
        if floatingFunc then
            floatingFunc:Disconnect()
            floatingFunc = nil
        end

        if floatPart then
            floatPart:Destroy()
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    if _G.atm_farm == true or _G.register_farm == true then
        task.wait(1)
        SetFloat(true)
        SetNoclip(true)
    end
    --StartFloat(char)
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Discord",
    Text = "@riplagardoz",
    Icon = "rbxassetid://6033500763",
    Duration = 5
})
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Scriptblox",
    Text = "@thewiiufan",
    Icon = "rbxassetid://6033500763",
    Duration = 5
})

local function NestedFindFirstChild(instance, path)
    local current = instance
    for i, name in string.split(path, "/") do
        current = current:FindFirstChild(name)
        
        if not current then return nil end
    end
    return current
end


local function TweenToPosition(cframe, HumanoidRootPart, prompt)
    if not HumanoidRootPart then return end
    local newcf = CFrame.new(cframe.Position.X, cframe.Position.Y, cframe.Position.Z)
    local Distance = (HumanoidRootPart.Position - cframe.Position).Magnitude
    local Time = Distance / config.WALKSPEED

    local tween = TweenService:Create(HumanoidRootPart, 
        TweenInfo.new(Time, Enum.EasingStyle.Linear), 
        {CFrame = newcf})
    
    tween:Play()
    if not prompt then
        tween.Completed:Wait()
        return
    end

    while tween.PlaybackState == Enum.PlaybackState.Playing do
        task.wait(0.5)
        if prompt and not (_G.register_farm or _G.atm_farm) then tween:Cancel() return end
        if prompt.Enabled == false then
            tween:Cancel()  
            return
        end
     end
end

local function SafeTween(cframe, prompt)
    local Character = LocalPlayer.Character
    if not Character then return end
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then return end

    local newcf = cframe * CFrame.new(0, -8, 0)
    TweenToPosition(CFrame.new(HumanoidRootPart.CFrame.Position.X, newcf.Position.Y, HumanoidRootPart.CFrame.Position.Z),HumanoidRootPart)
    TweenToPosition(newcf, HumanoidRootPart, prompt)
    TweenToPosition(cframe, HumanoidRootPart)
end

local function FarmTween(cframe, prompt)
    local Character = LocalPlayer.Character
    if not Character then return end
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then return end

    local newcf = cframe * CFrame.new(0, -8, 0)
    TweenToPosition(CFrame.new(HumanoidRootPart.CFrame.Position.X, newcf.Position.Y, HumanoidRootPart.CFrame.Position.Z),HumanoidRootPart)
    TweenToPosition(newcf, HumanoidRootPart, prompt)
    fireproximityprompt(prompt)
end

local function GetClosest()
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local ATMS = workspace:FindFirstChild("ATMS")
    local Registers = workspace:FindFirstChild("Registers")
    if not HumanoidRootPart or not ATMS or not Registers then return end

    local Closest
    local ClosestDistance = math.huge

    if _G.atm_farm then
        for _, v in ATMS:GetChildren() do
            local MainPart = v:FindFirstChild("Main")
            local Prompt = NestedFindFirstChild(v, "ClickPart/Attachment/ProximityPrompt")
            if MainPart and Prompt and Prompt.Enabled then
                local Distance = (HumanoidRootPart.Position - MainPart.Position).Magnitude
                if Distance < ClosestDistance then
                    ClosestDistance = Distance
                    Closest = {Prompt, MainPart, "atm"}
                end
            end
        end
    end
    if _G.register_farm then
        for _, v in Registers:GetChildren() do
            local MainPart = v:FindFirstChild("Main")
            local Prompt = NestedFindFirstChild(v, "HumanoidRootPart/Attachment/ProximityPrompt")
            if MainPart and Prompt and Prompt.Enabled then
                local Distance = (HumanoidRootPart.Position - MainPart.Position).Magnitude
                if Distance < ClosestDistance then
                    ClosestDistance = Distance
                    Closest = {Prompt, v:FindFirstChild("Part"), "register"}
                end
            end
        end
    end
    return Closest
end


while true do
    task.wait(0.75)
    
    local ShouldNoclip = _G.atm_farm or _G.register_farm
    if Noclip ~= ShouldNoclip then
        SetNoclip(ShouldNoclip)
        SetFloat(ShouldNoclip)
    end
    local closest = GetClosest()
    if not closest or not closest[1] or not closest[2] then continue end
    if closest[3] == "atm" then
        local one = NestedFindFirstChild(closest[2], "One/Click")
        local two = NestedFindFirstChild(closest[2], "Two/Click")
        if not one or not two then continue end

        FarmTween(closest[2].CFrame, closest[1])
        task.wait(2)
        fireproximityprompt(one)
        task.wait(0.1)
        fireproximityprompt(two)
    elseif closest[3] == "register"then
        local cashprompt = closest[2]:FindFirstChild("ProximityPrompt")
        if not cashprompt then continue end
        FarmTween(closest[2].CFrame, closest[1])
        fireproximityprompt(cashprompt)
    end
end
