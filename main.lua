--// =========================================
--//      ALEXIHAX HUB DEV v1.0.0
--// =========================================

repeat task.wait() until game:IsLoaded()

-- =====================================
-- SERVICES
-- =====================================

local Players =
    game:GetService("Players")

local Workspace =
    game:GetService("Workspace")

local TweenService =
    game:GetService("TweenService")

local HttpService =
    game:GetService("HttpService")

local MarketplaceService =
    game:GetService("MarketplaceService")

local LocalPlayer =
    Players.LocalPlayer

local Character =
    LocalPlayer.Character
    or LocalPlayer.CharacterAdded:Wait()

local HumanoidRootPart =
    Character:WaitForChild(
        "HumanoidRootPart"
    )

-- =====================================
-- WEBHOOK
-- =====================================

local WEBHOOK =
"YOUR_DISCORD_WEBHOOK"

local function SendWebhook(msg)

    pcall(function()

        request({
            Url = WEBHOOK,
            Method = "POST",
            Headers = {
                ["Content-Type"] =
                    "application/json"
            },
            Body =
                HttpService:JSONEncode({
                    content = msg
                })
        })

    end)
end

-- =====================================
-- RAYFIELD
-- =====================================

local Rayfield =
loadstring(game:HttpGet(
"https://sirius.menu/rayfield"
))()

local Window =
Rayfield:CreateWindow({

    Name =
    "Alexihax HUB DEV v1.0.0",

    LoadingTitle =
    "Alexihax HUB DEV v1.0.0",

    LoadingSubtitle =
    MarketplaceService:GetProductInfo(
        game.PlaceId
    ).Name,

    ConfigurationSaving = {
        Enabled = false
    },

    Discord = {
        Enabled = false
    },

    KeySystem = false
})

local MainTab =
Window:CreateTab(
    "Main",
    4483362458
)

-- =====================================
-- VARIABLES
-- =====================================

local AutoOre = false
local AutoDeposit = false
local AutoCollect = false
local AutoBuy = false
local AutoMerge = false

local DepositMultiplier = 1.5

local LastOreTP = 0
local LastDepositTP = 0
local LastCollectTP = 0
local LastBuyTP = 0

local OreCooldown = 0.35
local DepositCooldown = 0.5
local CollectCooldown = 0.5
local BuyCooldown = 0.5

-- =====================================
-- SILENT TP
-- =====================================

local function SilentTP(pos)

    if not Character
    or not HumanoidRootPart then
        return
    end

    local old =
        HumanoidRootPart.CFrame

    HumanoidRootPart.CFrame =
        CFrame.new(pos)

    task.wait(0.08)

    HumanoidRootPart.CFrame =
        old
end

-- =====================================
-- GET PLOT
-- =====================================

local function GetPlot()

    for _, plot in pairs(
        Workspace.Plots:GetChildren()
    ) do

        local owner =
            plot:FindFirstChild(
                "Owner"
            )

        if owner
        and owner.Value == LocalPlayer then

            return plot
        end
    end
end

-- =====================================
-- GET MULTIPLIER
-- =====================================

local function GetMultiplier()

    local mult =
        Workspace:FindFirstChild(
            "OreMultPart"
        )

    if mult
    and mult:FindFirstChild(
        "SurfaceGui"
    ) then

        local txt =
            mult.SurfaceGui
            :FindFirstChildOfClass(
                "TextLabel"
            )

        if txt then

            local num =
                tonumber(
                    txt.Text:gsub(
                        "[^%d%.]",
                        ""
                    )
                )

            return num or 1
        end
    end

    return 1
end

-- =====================================
-- AUTO ORE
-- =====================================

task.spawn(function()

    while task.wait() do

        if AutoOre then

            if tick()
            - LastOreTP
            >= OreCooldown then

                LastOreTP =
                    tick()

                for _, loot in pairs(
                    Workspace:GetDescendants()
                ) do

                    if loot.Name ==
                    "LootMeshPart" then

                        SilentTP(
                            loot.Position
                        )
                    end
                end
            end
        end
    end
end)

-- =====================================
-- AUTO DEPOSIT
-- =====================================

task.spawn(function()

    while task.wait(1) do

        if AutoDeposit then

            local mult =
                GetMultiplier()

            if mult
            >= DepositMultiplier then

                if tick()
                - LastDepositTP
                >= DepositCooldown then

                    LastDepositTP =
                        tick()

                    local plot =
                        GetPlot()

                    if plot then

                        local button =
                            plot
                            .Sell
                            .DepositButton
                            .Button

                        SilentTP(
                            button.Position
                        )
                    end
                end
            end
        end
    end
end)

-- =====================================
-- AUTO COLLECT
-- =====================================

task.spawn(function()

    while task.wait(1) do

        if AutoCollect then

            if tick()
            - LastCollectTP
            >= CollectCooldown then

                LastCollectTP =
                    tick()

                local plot =
                    GetPlot()

                if plot then

                    local button =
                        plot
                        .Sell
                        .CollectButton
                        .Button

                    SilentTP(
                        button.Position
                    )
                end
            end
        end
    end
end)

-- =====================================
-- AUTO BUY
-- =====================================

task.spawn(function()

    while task.wait(1) do

        if AutoBuy then

            if tick()
            - LastBuyTP
            >= BuyCooldown then

                LastBuyTP =
                    tick()

                local plot =
                    GetPlot()

                if plot then

                    local button =
                        plot
                        .Buttons
                        :FindFirstChild(
                            "ButtonBuy100"
                        )

                    if button
                    and button:FindFirstChild(
                        "Button"
                    ) then

                        SilentTP(
                            button.Button
                            .Position
                        )
                    end
                end
            end
        end
    end
end)

-- =====================================
-- AUTO MERGE
-- =====================================

task.spawn(function()

    while task.wait(2) do

        if AutoMerge then

            local plot =
                GetPlot()

            if plot then

                local button =
                    plot
                    .Buttons
                    :FindFirstChild(
                        "ButtonMerge"
                    )

                if button
                and button:FindFirstChild(
                    "Button"
                ) then

                    SilentTP(
                        button.Button
                        .Position
                    )
                end
            end
        end
    end
end)

-- =====================================
-- WEBHOOK EARNINGS
-- =====================================

local LastMoney = 0

task.spawn(function()

    while task.wait(60) do

        local stats =
            LocalPlayer
            :FindFirstChild(
                "leaderstats"
            )

        if stats then

            local money =
                stats:FindFirstChild(
                    "Money"
                )

            if money then

                local earned =
                    money.Value
                    - LastMoney

                LastMoney =
                    money.Value

                if earned > 0 then

                    SendWebhook(
                        "💰 " ..
                        LocalPlayer.Name ..
                        " earned $" ..
                        tostring(earned)
                    )
                end
            end
        end
    end
end)

-- =====================================
-- TOGGLES
-- =====================================

MainTab:CreateToggle({
    Name = "Auto Ore",
    CurrentValue = false,
    Callback = function(v)
        AutoOre = v
    end
})

MainTab:CreateSlider({
    Name = "Ore TP Cooldown",
    Range = {0.1, 1},
    Increment = 0.05,
    CurrentValue = 0.35,
    Callback = function(v)
        OreCooldown = v
    end
})

MainTab:CreateToggle({
    Name = "Auto Deposit",
    CurrentValue = false,
    Callback = function(v)
        AutoDeposit = v
    end
})

MainTab:CreateSlider({
    Name = "Deposit At Multiplier",
    Range = {1, 1.5},
    Increment = 0.1,
    CurrentValue = 1.5,
    Suffix = "x",
    Callback = function(v)
        DepositMultiplier = v
    end
})

MainTab:CreateToggle({
    Name = "Auto Collect",
    CurrentValue = false,
    Callback = function(v)
        AutoCollect = v
    end
})

MainTab:CreateSlider({
    Name = "Collect Cooldown",
    Range = {0.1, 2},
    Increment = 0.1,
    CurrentValue = 0.5,
    Callback = function(v)
        CollectCooldown = v
    end
})

MainTab:CreateToggle({
    Name = "Auto Buy x100",
    CurrentValue = false,
    Callback = function(v)
        AutoBuy = v
    end
})

MainTab:CreateToggle({
    Name = "Auto Merge",
    CurrentValue = false,
    Callback = function(v)
        AutoMerge = v
    end
})

Rayfield:Notify({
    Title = "Alexihax HUB",
    Content = "Loaded Successfully",
    Duration = 5
})
