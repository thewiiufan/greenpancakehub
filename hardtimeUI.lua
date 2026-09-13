local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Green Pancake Hub - Hard Time",
    Icon = "door-open",
    Author = "by @thewiiufan on scriptblox | @riplagardoz on discord",
})

local Tabs = {
    ["Autofarm"] = Window:Tab({
        Title = "Autofarm",
    })
}

Tabs["Autofarm"]:Select()

Tabs["Autofarm"]:Paragraph({
    Title = "Autofarm",
    Desc = "You can have multiple autofarms toggled at once."
})
local autofarmgroup1 = Tabs["Autofarm"]:Group({})

autofarmgroup1:Toggle({
    Title = "ATM Farm",
    Callback = function(state)
        _G.atm_farm = state
    end
})

autofarmgroup1:Toggle({
    Title = "Register Farm",
    Callback = function(state)
        _G.register_farm = state
    end
})

Tabs["Autofarm"]:Slider({
    Title = "Speed",
    Desc = "High ping should be lower\n(24 & under safest!)",
    Step = 1,
    Value = {
        Min = 10,
        Max = 35,
        Default = 24,
    },
    Callback = function(value)
        _G.Speed = value
    end
})
