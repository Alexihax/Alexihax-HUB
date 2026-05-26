--// =========================================
--// PLATOBOOST + RAYFIELD LOADER
--// =========================================

local HttpService =
    game:GetService("HttpService")

local RbxAnalyticsService =
    game:GetService("RbxAnalyticsService")

-- =====================================
-- CONFIG
-- =====================================

local SERVICE = 25623

local MAIN_SCRIPT =
"https://raw.githubusercontent.com/Alexihax/Alexihax-HUB/main/main.lua"

-- =====================================
-- HWID
-- =====================================

local HWID =
    RbxAnalyticsService:GetClientId()

-- =====================================
-- RAYFIELD
-- =====================================

local Rayfield = loadstring(game:HttpGet(
    "https://sirius.menu/rayfield"
))()

-- =====================================
-- VERIFY FUNCTION
-- =====================================

local function verify_key(key)

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
-- WINDOW
-- =====================================

local Window = Rayfield:CreateWindow({
    Name = "Alexihax Hub",
    LoadingTitle = "Alexihax Hub",
    LoadingSubtitle = "Platoboost",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AlexihaxHub",
        FileName = "Key"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = true,
    KeySettings = {
        Title = "Alexihax Hub",
        Subtitle = "Key System",
        Note = "Get your key from Platoboost",
        FileName = "AlexihaxKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {
            "temporary"
        }
    }
})

-- =====================================
-- CUSTOM KEY CHECK
-- =====================================

local enteredKey =
    Rayfield.LoadConfiguration()

if enteredKey
and verify_key(enteredKey) then

    loadstring(game:HttpGet(
        MAIN_SCRIPT
    ))()

else

    Rayfield:Notify({
        Title = "Invalid Key",
        Content = "Please enter a valid Platoboost key.",
        Duration = 6
    })
end
