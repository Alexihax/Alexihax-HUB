--// =========================================
--//      ALEXIHAX HUB DEV v1.0.0
--// =========================================

repeat task.wait() until game:IsLoaded()

--// =========================================
--// SERVICES
--// =========================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer

--// =========================================
--// GAME NAME
--// =========================================

local GameName = "Unknown Game"
pcall(function()
	GameName = MarketplaceService:GetProductInfo(game.PlaceId).Name or game.Name
end)

--// =========================================
--// WEBHOOK
--// =========================================

local WEBHOOK_URL = "YOUR_DISCORD_WEBHOOK"

local requestFn = request or http_request or (syn and syn.request)

local function SendWebhook(message)
	if not requestFn then
		return
	end

	if not WEBHOOK_URL or WEBHOOK_URL == "" or WEBHOOK_URL == "YOUR_DISCORD_WEBHOOK" then
		return
	end

	pcall(function()
		requestFn({
			Url = WEBHOOK_URL,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
			},
			Body = HttpService:JSONEncode({
				content = tostring(message),
			}),
		})
	end)
end

--// =========================================
--// RAYFIELD
--// =========================================

local Rayfield = loadstring(game:HttpGet(
	"https://sirius.menu/rayfield"
))()

local Window = Rayfield:CreateWindow({
	Name = "Alexihax HUB DEV v1.0.0",
	LoadingTitle = "Alexihax HUB DEV v1.0.0",
	LoadingSubtitle = GameName,
	ConfigurationSaving = {
		Enabled = false,
	},
	Discord = {
		Enabled = false,
	},
	KeySystem = false,
})

local Main = Window:CreateTab("Main", 4483362458)

--// =========================================
--// STATES
--// =========================================

local AutoCollectOre = false
local AutoBuy = false
local AutoMerge = false
local AutoDeposit = false
local AutoCollectMoney = false
local AutoUpgrade = false
local AutoGroup = false

local DepositMultiplier = 1.5

local OreCooldown = 0.35
local BuyCooldown = 0.5
local MergeCooldown = 0.6
local DepositCooldown = 0.5
local CollectCooldown = 0.5
local UpgradeCooldown = 0.5
local GroupCooldown = 1.5

local LastRun = {
	Ore = 0,
	Buy = 0,
	Merge = 0,
	Deposit = 0,
	Collect = 0,
	Upgrade = 0,
	Group = 0,
}

local function CanRun(name, cooldown)
	local now = os.clock()
	if now - (LastRun[name] or 0) < cooldown then
		return false
	end
	LastRun[name] = now
	return true
end

--// =========================================
--// ROOT / MOVEMENT
--// =========================================

local function getCharacter()
	return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getRoot()
	local char = getCharacter()
	return char:WaitForChild("HumanoidRootPart")
end

local function moveTo(part, speed)
	local root = getRoot()
	if not root or not part or not part:IsA("BasePart") then
		return
	end

	speed = speed or 0.08

	pcall(function()
		root.AssemblyLinearVelocity = Vector3.zero
		local tween = TweenService:Create(
			root,
			TweenInfo.new(speed, Enum.EasingStyle.Linear),
			{
				CFrame = part.CFrame + Vector3.new(0, 3, 0),
			}
		)
		tween:Play()
	end)
end

local function stand(part, duration)
	duration = duration or 0.25
	moveTo(part, 0.08)
	task.wait(duration)
end

--// =========================================
--// PLOT DETECTION
--// =========================================

local function getMyPlot()
	local plots = Workspace:FindFirstChild("Plots")
	local root = getRoot()
	if not plots or not root then
		return nil
	end

	local closestPlot = nil
	local closestDistance = math.huge

	for _, plot in ipairs(plots:GetChildren()) do
		local buttons = plot:FindFirstChild("Buttons")
		if buttons then
			local buttonPart = buttons:FindFirstChild("Button", true)
			if buttonPart and buttonPart:IsA("BasePart") then
				local distance = (buttonPart.Position - root.Position).Magnitude
				if distance < closestDistance then
					closestDistance = distance
					closestPlot = plot
				end
			end
		end
	end

	return closestPlot
end

--// =========================================
--// ORE MULTIPLIER
--// =========================================

local function getOreMultiplier()
	local ore = Workspace:FindFirstChild("OreMultPart", true)
	if not ore then
		return 1
	end

	local text = ""
	for _, obj in ipairs(ore:GetDescendants()) do
		if obj:IsA("TextLabel") or obj:IsA("TextBox") then
			text = obj.Text
			break
		end
	end

	local num = tonumber(string.match(text, "%d+%.?%d*"))
	return num or 1
end

--// =========================================
--// AUTO COLLECT ORE
--// =========================================

local function doCollectOre()
	if not CanRun("Ore", OreCooldown) then
		return
	end

	local root = getRoot()
	if not root then
		return
	end

	local loot = {}
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name == "LootMeshPart" then
			table.insert(loot, obj)
		end
	end

	table.sort(loot, function(a, b)
		return (a.Position - root.Position).Magnitude < (b.Position - root.Position).Magnitude
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
	if not CanRun("Buy", BuyCooldown) then
		return
	end

	local plot = getMyPlot()
	if not plot then
		return
	end

	local buttons = plot:FindFirstChild("Buttons")
	if not buttons then
		return
	end

	local buy100 = buttons:FindFirstChild("ButtonBuy100")
	if not buy100 then
		return
	end

	local pad = buy100:FindFirstChild("Button")
	if pad and pad:IsA("BasePart") then
		stand(pad, 0.2)
	end
end

--// =========================================
--// AUTO MERGE
--// =========================================

local function doMerge()
	if not CanRun("Merge", MergeCooldown) then
		return
	end

	local plot = getMyPlot()
	if not plot then
		return
	end

	local buttons = plot:FindFirstChild("Buttons")
	if not buttons then
		return
	end

	local merge = buttons:FindFirstChild("ButtonMerge")
	if not merge then
		return
	end

	local pad = merge:FindFirstChild("Button")
	if pad and pad:IsA("BasePart") then
		stand(pad, 0.2)
	end
end

--// =========================================
--// AUTO DEPOSIT
--// =========================================

local function doDeposit()
	if not CanRun("Deposit", DepositCooldown) then
		return
	end

	local mult = getOreMultiplier()
	if mult < DepositMultiplier then
		return
	end

	local plot = getMyPlot()
	if not plot then
		return
	end

	local sell = plot:FindFirstChild("Sell")
	if not sell then
		return
	end

	local deposit = sell:FindFirstChild("DepositButton")
	if not deposit then
		return
	end

	local pad = deposit:FindFirstChild("Button")
	if pad and pad:IsA("BasePart") then
		stand(pad, 0.25)
	end
end

--// =========================================
--// AUTO COLLECT MONEY
--// =========================================

local function doCollectMoney()
	if not CanRun("Collect", CollectCooldown) then
		return
	end

	local plot = getMyPlot()
	if not plot then
		return
	end

	local sell = plot:FindFirstChild("Sell")
	if not sell then
		return
	end

	local collect = sell:FindFirstChild("CollectButton")
	if not collect then
		return
	end

	local pad = collect:FindFirstChild("Button")
	if pad and pad:IsA("BasePart") then
		stand(pad, 0.2)
	end
end

--// =========================================
--// AUTO UPGRADE
--// =========================================

local function doUpgrade()
	if not CanRun("Upgrade", UpgradeCooldown) then
		return
	end

	local plot = getMyPlot()
	if not plot then
		return
	end

	local sell = plot:FindFirstChild("Sell")
	if not sell then
		return
	end

	local upgrade = sell:FindFirstChild("UpgradeButton")
	if not upgrade then
		return
	end

	local pad = upgrade:FindFirstChild("Button")
	if pad and pad:IsA("BasePart") then
		stand(pad, 0.2)
	end
end

--// =========================================
--// AUTO GROUP
--// =========================================

local function doGroup()
	if not CanRun("Group", GroupCooldown) then
		return
	end

	local plot = getMyPlot()
	if not plot then
		return
	end

	local group = plot:FindFirstChild("GroupReward")
	if not group then
		return
	end

	local collect = group:FindFirstChild("CollectButton")
	if not collect then
		return
	end

	local pad = collect:FindFirstChild("Button")
	if pad and pad:IsA("BasePart") then
		stand(pad, 0.2)
	end
end

--// =========================================
--// GUI
--// =========================================

Main:CreateParagraph({
	Title = "Game",
	Content = GameName,
})

local MultiplierParagraph = Main:CreateParagraph({
	Title = "Ore Multiplier",
	Content = "1x",
})

Main:CreateToggle({
	Name = "Auto Collect Ore",
	CurrentValue = false,
	Callback = function(v)
		AutoCollectOre = v
	end,
})

Main:CreateSlider({
	Name = "Ore TP Cooldown",
	Range = {0.1, 1},
	Increment = 0.05,
	Suffix = "s",
	CurrentValue = OreCooldown,
	Callback = function(v)
		OreCooldown = v
	end,
})

Main:CreateToggle({
	Name = "Auto Buy 100x",
	CurrentValue = false,
	Callback = function(v)
		AutoBuy = v
	end,
})

Main:CreateSlider({
	Name = "Buy TP Cooldown",
	Range = {0.1, 2},
	Increment = 0.05,
	Suffix = "s",
	CurrentValue = BuyCooldown,
	Callback = function(v)
		BuyCooldown = v
	end,
})

Main:CreateToggle({
	Name = "Auto Merge",
	CurrentValue = false,
	Callback = function(v)
		AutoMerge = v
	end,
})

Main:CreateSlider({
	Name = "Merge TP Cooldown",
	Range = {0.1, 2},
	Increment = 0.05,
	Suffix = "s",
	CurrentValue = MergeCooldown,
	Callback = function(v)
		MergeCooldown = v
	end,
})

Main:CreateToggle({
	Name = "Auto Deposit",
	CurrentValue = false,
	Callback = function(v)
		AutoDeposit = v
	end,
})

Main:CreateSlider({
	Name = "Deposit At Multiplier",
	Range = {1, 1.5},
	Increment = 0.1,
	Suffix = "x",
	CurrentValue = DepositMultiplier,
	Callback = function(v)
		DepositMultiplier = math.clamp(v, 1, 1.5)
	end,
})

Main:CreateSlider({
	Name = "Deposit TP Cooldown",
	Range = {0.1, 2},
	Increment = 0.05,
	Suffix = "s",
	CurrentValue = DepositCooldown,
	Callback = function(v)
		DepositCooldown = v
	end,
})

Main:CreateToggle({
	Name = "Auto Collect Money",
	CurrentValue = false,
	Callback = function(v)
		AutoCollectMoney = v
	end,
})

Main:CreateSlider({
	Name = "Collect TP Cooldown",
	Range = {0.1, 2},
	Increment = 0.05,
	Suffix = "s",
	CurrentValue = CollectCooldown,
	Callback = function(v)
		CollectCooldown = v
	end,
})

Main:CreateToggle({
	Name = "Auto Upgrade",
	CurrentValue = false,
	Callback = function(v)
		AutoUpgrade = v
	end,
})

Main:CreateSlider({
	Name = "Upgrade TP Cooldown",
	Range = {0.1, 2},
	Increment = 0.05,
	Suffix = "s",
	CurrentValue = UpgradeCooldown,
	Callback = function(v)
		UpgradeCooldown = v
	end,
})

Main:CreateToggle({
	Name = "Auto Group Reward",
	CurrentValue = false,
	Callback = function(v)
		AutoGroup = v
	end,
})

Main:CreateSlider({
	Name = "Group TP Cooldown",
	Range = {0.1, 3},
	Increment = 0.05,
	Suffix = "s",
	CurrentValue = GroupCooldown,
	Callback = function(v)
		GroupCooldown = v
	end,
})

Main:CreateParagraph({
	Title = "Discord Webhook",
	Content = WEBHOOK_URL == "YOUR_DISCORD_WEBHOOK" and "Set your webhook URL at the top of the script" or "Webhook enabled",
})

--// =========================================
--// LIVE MULTIPLIER
--// =========================================

task.spawn(function()
	while task.wait(0.2) do
		pcall(function()
			local mult = getOreMultiplier()
			MultiplierParagraph:Set({
				Title = "Ore Multiplier",
				Content = tostring(mult) .. "x",
			})
		end)
	end
end)

--// =========================================
--// WEBHOOK EARNINGS
--// =========================================

task.spawn(function()
	local baselineSet = false
	local lastMoney = 0

	while task.wait(30) do
		local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
		if leaderstats then
			local moneyStat

			local preferredNames = {
				"Money",
				"Cash",
				"Coins",
				"Balance",
				"Funds",
				"Currency",
				"Points",
			}

			for _, name in ipairs(preferredNames) do
				local stat = leaderstats:FindFirstChild(name)
				if stat and (stat:IsA("IntValue") or stat:IsA("NumberValue")) then
					moneyStat = stat
					break
				end
			end

			if not moneyStat then
				for _, obj in ipairs(leaderstats:GetChildren()) do
					if obj:IsA("IntValue") or obj:IsA("NumberValue") then
						moneyStat = obj
						break
					end
				end
			end

			if moneyStat then
				if not baselineSet then
					lastMoney = moneyStat.Value
					baselineSet = true
				else
					local current = moneyStat.Value
					local earned = current - lastMoney

					if earned > 0 then
						SendWebhook((
							"💰 %s earned +%s in %s (balance: %s)"
						):format(
							LocalPlayer.Name,
							tostring(earned),
							GameName,
							tostring(current)
						))
					end

					lastMoney = current
				end
			end
		end
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
	Title = "Alexihax HUB DEV v1.0.0",
	Content = "Loaded Successfully",
	Duration = 6,
})
