--// =========================================
--//      ALEXIHAX HUB LOADER
--// =========================================

local HttpService =
    game:GetService("HttpService")

local Players =
    game:GetService("Players")

local CoreGui =
    game:GetService("CoreGui")

local RbxAnalyticsService =
    game:GetService("RbxAnalyticsService")

local player =
    Players.LocalPlayer

-- =====================================
-- CONFIG
-- =====================================

local SERVICE = 25623

local MAIN_SCRIPT =
"https://raw.githubusercontent.com/Alexihax/Alexihax-HUB/main/main.lua"

local HWID =
    RbxAnalyticsService:GetClientId()

-- =====================================
-- DELETE OLD GUI
-- =====================================

pcall(function()

    CoreGui:FindFirstChild(
        "AlexihaxKeySystem"
    ):Destroy()

end)

-- =====================================
-- GUI
-- =====================================

local gui = Instance.new("ScreenGui")
gui.Name = "AlexihaxKeySystem"
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 180)
frame.Position = UDim2.new(0.5, -160, 0.5, -90)
frame.BackgroundColor3 =
    Color3.fromRGB(20,20,30)
frame.BorderSizePixel = 0
frame.Parent = gui

Instance.new(
    "UICorner",
    frame
).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "Alexihax Hub"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = frame

local box = Instance.new("TextBox")
box.Size = UDim2.new(0.85,0,0,40)
box.Position = UDim2.new(0.075,0,0.35,0)
box.PlaceholderText = "Enter Platoboost Key"
box.Text = ""
box.TextColor3 = Color3.new(1,1,1)
box.BackgroundColor3 =
    Color3.fromRGB(35,35,45)
box.Font = Enum.Font.Gotham
box.TextScaled = true
box.Parent = frame

Instance.new(
    "UICorner",
    box
).CornerRadius = UDim.new(0,8)

local verify = Instance.new("TextButton")
verify.Size = UDim2.new(0.85,0,0,40)
verify.Position = UDim2.new(0.075,0,0.67,0)
verify.Text = "Verify Key"
verify.TextScaled = true
verify.Font = Enum.Font.GothamBold
verify.TextColor3 =
    Color3.new(1,1,1)
verify.BackgroundColor3 =
    Color3.fromRGB(255,120,0)
verify.Parent = frame

Instance.new(
    "UICorner",
    verify
).CornerRadius = UDim.new(0,8)

-- =====================================
-- VERIFY
-- =====================================

local function verifyKey(key)

    local url =
        "https://api.platoboost.com/public/whitelist/"
        .. SERVICE
        .. "?identifier="
        .. HWID
        .. "&key="
        .. key

    local success, response =
        pcall(function()

            return game:HttpGet(url)

        end)

    if not success then
        warn("Request failed")
        return false
    end

    local decoded

    success, decoded =
        pcall(function()

            return HttpService:JSONDecode(
                response
            )

        end)

    if not success then
        warn("JSON failed")
        return false
    end

    if decoded.success
    and decoded.data
    and decoded.data.valid then

        return true
    end

    return false
end

-- =====================================
-- BUTTON
-- =====================================

verify.MouseButton1Click:Connect(function()

    verify.Text = "Checking..."

    local key = box.Text

    local valid =
        verifyKey(key)

    if valid then

        verify.Text = "Success!"

        task.wait(0.5)

        gui:Destroy()

        loadstring(game:HttpGet(
            MAIN_SCRIPT
        ))()

    else

        verify.Text = "Invalid Key"

        task.wait(2)

        verify.Text = "Verify Key"
    end
end)
