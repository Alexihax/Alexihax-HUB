--// =========================================
--//        PICKAXE TYCOON HUB
--//          SILENT EDITION
--// =========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

--// =========================================
--// KEY
--// =========================================

local KEY = "pickaxehub"

--// =========================================
--// RAYFIELD
--// =========================================

local Rayfield = loadstring(game:HttpGet(
    "https://sirius.menu/rayfield"
))()

local Window = Rayfield:CreateWindow({
    Name = "⛏️ Pickaxe Tycoon Hub",
    LoadingTitle = "Pickaxe Tycoon",
    LoadingSubtitle = "Silent Edition",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = true,
    KeySettings = {
        Title = "Pickaxe Tycoon Hub",
        Subtitle = "Key System",
        Note = "Key: " .. KEY,
        FileName = "PickaxeHubKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {KEY}
    }
})

local Main = Window:CreateTab(
    "Main",
    4483362458
)

local Settings = Window:CreateTab(
    "Settings",
    4483362458
)

--// =========================================
--// STATES
--// =========================================

local AutoBuy = false
local AutoDeposit = false
local AutoCollectMoney = false
local AutoUpgrade = false
local AutoGroup = false
local AutoCollectOre = false
local AutoMerge = false

local DepositMultiplier = 2

--// =========================================
--// ROOT
--// =========================================

local function getRoot()

    local char =
        player.Character
        or player.CharacterAdded:Wait()

    return char:WaitForChild(
        "HumanoidRootPart"
    )
end

--// =========================================
--// SILENT MOVE
--// =========================================

local function moveTo(part, speed)

    local root = getRoot()

    if not root or not part then
        return
    end

    speed = speed or 0.08

    pcall(function()

        root.AssemblyLinearVelocity =
            Vector3.zero

        local tween =
            TweenService:Create(

                root,

                TweenInfo.new(
                    speed,
                    Enum.EasingStyle.Linear
                ),

                {
                    CFrame =
                        part.CFrame
                        + Vector3.new(0,3,0)
                }
            )

        tween:Play()

    end)
end

local function stand(part, duration)

    duration = duration or 0.25

    moveTo(part)

    task.wait(duration)
end

--// =========================================
--// FIND MY PLOT
--// =========================================

local function getMyPlot()

    local plots =
        workspace:FindFirstChild("Plots")

    local root = getRoot()

    if not plots then
        return nil
    end

    local closestPlot
    local closestDistance = math.huge

    for _, plot in ipairs(
        plots:GetChildren()
    ) do

        local buttons =
            plot:FindFirstChild("Buttons")

        if buttons then

            local buttonPart =
                buttons:FindFirstChild(
                    "Button",
                    true
                )

            if buttonPart
            and buttonPart:IsA("BasePart") then

                local distance =
                    (
                        buttonPart.Position
                        - root.Position
                    ).Magnitude

                if distance < closestDistance then

                    closestDistance =
                        distance

                    closestPlot = plot
                end
            end
        end
    end

    return closestPlot
end

--// =========================================
--// GET MULTIPLIER
--// =========================================

local function getOreMultiplier()

    local ore =
        workspace:FindFirstChild(
            "OreMultPart",
            true
        )

    if not ore then
        return 1
    end

    local text = ""

    for _, obj in ipairs(
        ore:GetDescendants()
    ) do

        if obj:IsA("TextLabel")
        or obj:IsA("TextBox") then

            text = obj.Text
            break
        end
    end

    local num =
        tonumber(
            string.match(
                text,
                "%d+%.?%d*"
            )
        )

    return num or 1
end

--// =========================================
--// FAST SILENT ORE COLLECT
--// =========================================

local function doCollectOre()

    local root = getRoot()

    if not root then
        return
    end

    local loot = {}

    for _, obj in ipairs(
        workspace:GetDescendants()
    ) do

        if obj:IsA("BasePart")
        and obj.Name == "LootMeshPart" then

            table.insert(loot, obj)
        end
    end

    table.sort(loot, function(a,b)

        return
            (a.Position - root.Position).Magnitude
            <
            (b.Position - root.Position).Magnitude

    end)

    for i = 1, math.min(15, #loot) do

        local ore = loot[i]

        moveTo(ore, 0.025)

        task.wait(0.03)
    end
end

--// =========================================
--// AUTO BUY 100x
--// =========================================

local function doBuy()

    local plot = getMyPlot()

    if not plot then
        return
    end

    local buttons =
        plot:FindFirstChild("Buttons")

    if not buttons then
        return
    end

    local buy100 =
        buttons:FindFirstChild(
            "ButtonBuy100"
        )

    if not buy100 then
        return
    end

    local pad =
        buy100:FindFirstChild(
            "Button"
        )

    if pad then

        stand(pad, 0.2)
    end
end

--// =========================================
--// AUTO MERGE
--// =========================================

local function doMerge()

    local plot = getMyPlot()

    if not plot then
        return
    end

    local buttons =
        plot:FindFirstChild("Buttons")

    if not buttons then
        return
    end

    local merge =
        buttons:FindFirstChild(
            "ButtonMerge"
        )

    if not merge then
        return
    end

    local pad =
        merge:FindFirstChild(
            "Button"
        )

    if pad then

        stand(pad, 0.2)
    end
end

--// =========================================
--// AUTO DEPOSIT
--// =========================================

local function doDeposit()

    local mult =
        getOreMultiplier()

    if mult < DepositMultiplier then
        return
    end

    local plot = getMyPlot()

    if not plot then
        return
    end

    local sell =
        plot:FindFirstChild("Sell")

    if not sell then
        return
    end

    local deposit =
        sell:FindFirstChild(
            "DepositButton"
        )

    if not deposit then
        return
    end

    local pad =
        deposit:FindFirstChild(
            "Button"
        )

    if pad then

        stand(pad, 0.25)
    end
end

--// =========================================
--// AUTO MONEY
--// =========================================

local function doCollectMoney()

    local plot = getMyPlot()

    if not plot then
        return
    end

    local sell =
        plot:FindFirstChild("Sell")

    if not sell then
        return
    end

    local collect =
        sell:FindFirstChild(
            "CollectButton"
        )

    if not collect then
        return
    end

    local pad =
        collect:FindFirstChild(
            "Button"
        )

    if pad then

        stand(pad, 0.2)
    end
end

--// =========================================
--// AUTO UPGRADE
--// =========================================

local function doUpgrade()

    local plot = getMyPlot()

    if not plot then
        return
    end

    local sell =
        plot:FindFirstChild("Sell")

    if not sell then
        return
    end

    local upgrade =
        sell:FindFirstChild(
            "UpgradeButton"
        )

    if not upgrade then
        return
    end

    local pad =
        upgrade:FindFirstChild(
            "Button"
        )

    if pad then

        stand(pad, 0.2)
    end
end

--// =========================================
--// AUTO GROUP
--// =========================================

local function doGroup()

    local plot = getMyPlot()

    if not plot then
        return
    end

    local group =
        plot:FindFirstChild(
            "GroupReward"
        )

    if not group then
        return
    end

    local collect =
        group:FindFirstChild(
            "CollectButton"
        )

    if not collect then
        return
    end

    local pad =
        collect:FindFirstChild(
            "Button"
        )

    if pad then

        stand(pad, 0.2)
    end
end

--// =========================================
--// GUI
--// =========================================

local MultiplierParagraph =
    Main:CreateParagraph({
        Title = "Ore Multiplier",
        Content = "1x"
    })

Main:CreateToggle({
    Name = "Auto Collect Ore",
    CurrentValue = false,
    Callback = function(v)
        AutoCollectOre = v
    end
})

Main:CreateToggle({
    Name = "Auto Buy 100x",
    CurrentValue = false,
    Callback = function(v)
        AutoBuy = v
    end
})

Main:CreateToggle({
    Name = "Auto Merge",
    CurrentValue = false,
    Callback = function(v)
        AutoMerge = v
    end
})

Main:CreateToggle({
    Name = "Auto Deposit",
    CurrentValue = false,
    Callback = function(v)
        AutoDeposit = v
    end
})

Main:CreateToggle({
    Name = "Auto Collect Money",
    CurrentValue = false,
    Callback = function(v)
        AutoCollectMoney = v
    end
})

Main:CreateToggle({
    Name = "Auto Upgrade",
    CurrentValue = false,
    Callback = function(v)
        AutoUpgrade = v
    end
})

Main:CreateToggle({
    Name = "Auto Group Reward",
    CurrentValue = false,
    Callback = function(v)
        AutoGroup = v
    end
})

--// =========================================
--// SETTINGS
--// =========================================

Settings:CreateSlider({
    Name = "Deposit Multiplier",
    Range = {1, 2},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 2,
    Callback = function(v)

        DepositMultiplier = v
    end
})

--// =========================================
--// LIVE MULTIPLIER
--// =========================================

task.spawn(function()

    while task.wait(0.2) do

        pcall(function()

            local mult =
                getOreMultiplier()

            MultiplierParagraph:Set({
                Title = "Ore Multiplier",
                Content =
                    tostring(mult)
                    .. "x"
            })

        end)
    end
end)

--// =========================================
--// MAIN LOOP
--// =========================================

task.spawn(function()

    while task.wait(0.08) do

        pcall(function()

            if AutoCollectOre then
                doCollectOre()
            end

            if AutoDeposit then
                doDeposit()
            end

            if AutoCollectMoney then
                doCollectMoney()
            end

            if AutoBuy then
                doBuy()
            end

            if AutoMerge then
                doMerge()
            end

            if AutoUpgrade then
                doUpgrade()
            end

            if AutoGroup then
                doGroup()
            end

        end)
    end
end)

Rayfield:Notify({
    Title = "Loaded",
    Content =
        "Silent Edition Loaded",
    Duration = 6
})
