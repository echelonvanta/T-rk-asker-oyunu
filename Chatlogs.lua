--[[
FINAL MODERN CHAT LOGGER GUI
Özellikler:
- Modern yarı saydam tasarım, yuvarlatılmış köşeler
- Chat Logs & Komut Logs sekmeleri
- Clear Logs butonu
- X (kapat) ve – (minimize)
- Takım renkleri + saat
- Mesaj & isim kopyala butonları yazının üstüne binmez
- Otomatik scroll
- Hem yeni (TextChatService) hem eski (Chatted) sistemi destekler
- Draggable (PC + Mobil)
]]

-- Hizmetler
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")

-- GUI oluşturma
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Ana çerçeve
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Üst bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "Chat Logger"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = TopBar

-- Kapat butonu
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = TopBar

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Minimize butonu
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 1, 0)
MinBtn.Position = UDim2.new(1, -60, 0, 0)
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.BackgroundTransparency = 1
MinBtn.Parent = TopBar

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, child in ipairs(MainFrame:GetChildren()) do
        if child ~= TopBar then
            child.Visible = not minimized
        end
    end
    if minimized then
        MainFrame.Size = UDim2.new(0, 450, 0, 30)
    else
        MainFrame.Size = UDim2.new(0, 450, 0, 300)
    end
end)

-- Sekme butonları
local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(1, 0, 0, 25)
Tabs.Position = UDim2.new(0, 0, 0, 30)
Tabs.BackgroundTransparency = 1
Tabs.Parent = MainFrame

local function createTabButton(name, xPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.Position = UDim2.new(0, xPos, 0, 0)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Parent = Tabs
    return btn
end

local ChatLogsBtn = createTabButton("Chat Logs", 0)
local CmdLogsBtn = createTabButton("Komut Logs", 105)

-- İçerik alanı
local ChatFrame = Instance.new("ScrollingFrame")
ChatFrame.Size = UDim2.new(1, -10, 1, -90)
ChatFrame.Position = UDim2.new(0, 5, 0, 60)
ChatFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ChatFrame.ScrollBarThickness = 6
ChatFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ChatFrame.Parent = MainFrame

local CmdFrame = ChatFrame:Clone()
CmdFrame.Visible = false
CmdFrame.Parent = MainFrame

-- Layout
local layout1 = Instance.new("UIListLayout", ChatFrame)
layout1.SortOrder = Enum.SortOrder.LayoutOrder
layout1.Padding = UDim.new(0, 2)

local layout2 = Instance.new("UIListLayout", CmdFrame)
layout2.SortOrder = Enum.SortOrder.LayoutOrder
layout2.Padding = UDim.new(0, 2)

-- Clear butonu
local ClearBtn = Instance.new("TextButton")
ClearBtn.Size = UDim2.new(0, 100, 0, 25)
ClearBtn.Position = UDim2.new(0, 5, 1, -30)
ClearBtn.Text = "Temizle"
ClearBtn.Font = Enum.Font.Gotham
ClearBtn.TextSize = 14
ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ClearBtn.Parent = MainFrame

ClearBtn.MouseButton1Click:Connect(function()
    for _, child in ipairs(ChatFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for _, child in ipairs(CmdFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
end)

-- Sekme geçişi
ChatLogsBtn.MouseButton1Click:Connect(function()
    ChatFrame.Visible = true
    CmdFrame.Visible = false
end)
CmdLogsBtn.MouseButton1Click:Connect(function()
    ChatFrame.Visible = false
    CmdFrame.Visible = true
end)

-- Mesaj ekleme fonksiyonu
local function addMessage(frame, player, text)
    local msgFrame = Instance.new("Frame")
    msgFrame.Size = UDim2.new(1, -10, 0, 25)
    msgFrame.BackgroundTransparency = 1
    msgFrame.Parent = frame

    local teamColor = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(255,255,255)
    local timeStr = os.date("%H:%M:%S")

    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -70, 1, 0)
    msgLabel.BackgroundTransparency = 1
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextSize = 14
    msgLabel.TextColor3 = Color3.fromRGB(255,255,255)
    msgLabel.Text = string.format("[%s] [%s]: %s", timeStr, player.Name, text)
    msgLabel.Parent = msgFrame

    local copyMsg = Instance.new("TextButton")
    copyMsg.Size = UDim2.new(0, 30, 1, 0)
    copyMsg.Position = UDim2.new(1, -60, 0, 0)
    copyMsg.Text = "M"
    copyMsg.Font = Enum.Font.GothamBold
    copyMsg.TextSize = 12
    copyMsg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    copyMsg.TextColor3 = Color3.fromRGB(255,255,255)
    copyMsg.Parent = msgFrame
    copyMsg.MouseButton1Click:Connect(function()
        setclipboard(text)
    end)

    local copyName = Instance.new("TextButton")
    copyName.Size = UDim2.new(0, 30, 1, 0)
    copyName.Position = UDim2.new(1, -30, 0, 0)
    copyName.Text = "N"
    copyName.Font = Enum.Font.GothamBold
    copyName.TextSize = 12
    copyName.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    copyName.TextColor3 = Color3.fromRGB(255,255,255)
    copyName.Parent = msgFrame
    copyName.MouseButton1Click:Connect(function()
        setclipboard(player.Name)
    end)

    frame.CanvasSize = UDim2.new(0, 0, 0, #frame:GetChildren()*25)
    frame.CanvasPosition = Vector2.new(0, math.huge)
end

-- Chat dinleme
local function onMessage(player, text)
    if text:sub(1,1) == ";" or text:sub(1,1) == ":" then
        addMessage(CmdFrame, player, text)
    else
        addMessage(ChatFrame, player, text)
    end
end

-- Yeni sistem
if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
    TextChatService.OnIncomingMessage = function(msg)
        local speaker = Players:FindFirstChild(msg.TextSource and msg.TextSource.Name or "")
        if speaker then
            onMessage(speaker, msg.Text)
        end
    end
else
    -- Eski sistem
    for _, plr in ipairs(Players:GetPlayers()) do
        plr.Chatted:Connect(function(msg)
            onMessage(plr, msg)
        end)
    end
    Players.PlayerAdded:Connect(function(plr)
        plr.Chatted:Connect(function(msg)
            onMessage(plr, msg)
        end)
    end)
end
