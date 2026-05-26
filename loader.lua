--// =========================================
--// PLATOBOOST LOADER
--// =========================================

local HttpService =
    game:GetService("HttpService")

local Players =
    game:GetService("Players")

local player =
    Players.LocalPlayer

-- =====================================
-- CONFIG
-- =====================================

local SERVICE = 25623

-- =====================================
-- HWID
-- =====================================

local HWID =
    game:GetService("RbxAnalyticsService")
    :GetClientId()

-- =====================================
-- KEY FILE
-- =====================================

local KEY_FILE = "AlexihaxKey.txt"

-- =====================================
-- READ KEY
-- =====================================

local key = nil

if isfile(KEY_FILE) then

    key = readfile(KEY_FILE)
end

-- =====================================
-- ASK FOR KEY
-- =====================================

if not key or key == "" then

    key = game:GetService("StarterGui")
        :PromptTextInput(
            "Enter Key",
            "Paste Platoboost Key"
        )
end

-- =====================================
-- VERIFY
-- =====================================

local url =
    "https://api.platoboost.com/public/whitelist/"
    .. SERVICE
    .. "?identifier="
    .. HWID
    .. "&key="
    .. key

local response =
    game:HttpGet(url)

local data =
    HttpService:JSONDecode(response)

if data.success
and data.data
and data.data.valid then

    writefile(KEY_FILE, key)

    loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/Alexihax/Alexihax-HUB/main/main.lua"
    ))()

else

    warn("Invalid Key")

end
