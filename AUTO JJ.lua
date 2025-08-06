JJ Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- Durum değişkenleri
local isRunning = false
local stopRequested = false
local currentIndex = 1
local isMinimized = false

-- Sayıyı Türkçe kelimelere çevirme fonksiyonu (1'den 1000'e kadar)
local function numberToTurkish(num)
    local ones = {"BİR", "İKİ", "ÜÇ", "DÖRT", "BEŞ", "ALTI", "YEDİ", "SEKİZ", "DOKUZ"}
    local tens = {"ON", "YİRMİ", "OTUZ", "KIRK", "ELLİ", "ALTMIŞ", "YETMİŞ", "SEKSEN", "DOKSAN"}
    local hundreds = {"YÜZ", "İKİ YÜZ", "ÜÇ YÜZ", "DÖRT YÜZ", "BEŞ YÜZ", "ALTI YÜZ", "YEDİ YÜZ", "SEKİZ YÜZ", "DOKUZ YÜZ"}

    if num == 1000 then return "BİN" end

    local result = ""
    if num >= 100 then
        local hundredIndex = math.floor(num / 100)
        if hundredIndex > 0 then
            result = hundreds[hundredIndex]
        end
        num = num % 100
        if num > 0 and result ~= "" then
            result = result .. " "
        end
    end
    if num >= 10 then
        local tenIndex = math.floor(num / 10)
        if tenIndex > 0 then
            result = result .. tens[tenIndex]
        end
        num = num % 10
        if num > 0 and result ~= "" then
            result = result .. " "
        end
    end
    if num > 0 then
        result = result .. ones[num]
    end

    return result
end

-- Mesaj listesini oluştur (1'den 1000'e kadar)
local messages = {}
for i = 1, 1000 do
    messages[i] = numberToTurkish(i)
end

-- GUI oluştur
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EchelonJJGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Ana Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 160)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25) -- Koyu mavi-siyah
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.ClipsDescendants = true

-- Okyanus teması için gradient
local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 40, 60))
})
uiGradient.Rotation = 90
uiGradient.Parent = mainFrame

-- Yuvarlak kenarlar
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

-- Parlama efekti
local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(100, 200, 255) -- Parlak aqua
uiStroke.Thickness = 1.5
uiStroke.Transparency = 0.2
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Parent = mainFrame

-- Sürükleme için başlık çubuğu
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, -40, 0, 36)
titleBar.Position = UDim2.new(0, 8, 0, 8)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame
titleBar.Active = true

-- Başlık (Echelon JJ)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "JJ"
title.TextColor3 = Color3.fromRGB(100, 200, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBlack
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.Parent = titleBar
local titleStroke = Instance.new("UIStroke")
titleStroke.Color = Color3.fromRGB(150, 220, 255)
titleStroke.Thickness = 0.8
titleStroke.Transparency = 0.3
titleStroke.Parent = title

-- Kapatma Butonu (X)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -36, 0, 6)
closeButton.BackgroundColor3 = Color3.fromRGB(60, 20, 20) -- Hafif kırmızı
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(200, 80, 80)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainFrame
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton
local closeStroke = Instance.new("UIStroke")
closeStroke.Color = Color3.fromRGB(200, 80, 80)
closeStroke.Thickness = 1
closeStroke.Transparency = 0.4
closeStroke.Parent = closeButton

-- Küçültme Butonu (-)
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 28, 0, 28)
minimizeButton.Position = UDim2.new(1, -68, 0, 6)
minimizeButton.BackgroundColor3 = Color3.fromRGB(25, 40, 60) -- Koyu aqua
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(100, 200, 255)
minimizeButton.TextSize = 16
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = mainFrame
local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 8)
minimizeCorner.Parent = minimizeButton
local minimizeStroke = Instance.new("UIStroke")
minimizeStroke.Color = Color3.fromRGB(100, 200, 255)
minimizeStroke.Thickness = 1
minimizeStroke.Transparency = 0.4
minimizeStroke.Parent = minimizeButton

-- Buton Frame'i
local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(1, -16, 0, 80)
buttonFrame.Position = UDim2.new(0, 8, 0, 48)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = mainFrame

-- Butonlar için düzen
local uiListLayout = Instance.new("UIListLayout")
uiListLayout.FillDirection = Enum.FillDirection.Horizontal
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
uiListLayout.Padding = UDim.new(0, 8)
uiListLayout.Parent = buttonFrame

-- Sürükleme işlevi
local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        startPos = mainFrame.Position
    end
end)

titleBar.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local currentPos = Vector2.new(input.Position.X, input.Position.Y)
        local delta = currentPos - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Kapatma butonu işlevi (tüm işlemleri durdurur ve GUI'yi gizler)
closeButton.MouseButton1Click:Connect(function()
    stopRequested = true
    isRunning = false
    currentIndex = 1
    screenGui.Enabled = false
end)

-- Küçültme butonu işlevi (GUI boyutunu değiştirir)
minimizeButton.MouseButton1Click:Connect(function()
    if isMinimized then
        mainFrame.Size = UDim2.new(0, 240, 0, 160)
        buttonFrame.Visible = true
        isMinimized = false
        minimizeButton.Text = "-"
    else
        mainFrame.Size = UDim2.new(0, 240, 0, 40)
        buttonFrame.Visible = false
        isMinimized = true
        minimizeButton.Text = "+"
    end
end)

-- Buton oluşturma fonksiyonu
local function createButton(name, color, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 64, 0, 32)
    button.BackgroundColor3 = color
    button.Text = name
    button.TextColor3 = Color3.fromRGB(100, 200, 255)
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.Parent = buttonFrame
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(100, 200, 255)
    buttonStroke.Thickness = 1
    buttonStroke.Transparency = 0.4
    buttonStroke.Parent = button
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Mesaj Gönderme ve Zıplama Mantığı
local function sendMessageAndJump(index)
    if stopRequested or index > #messages then
        isRunning = false
        currentIndex = 1
        return
    end

    local msg = messages[index]
    local chatChannel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")

    if chatChannel then
        chatChannel:SendAsync(msg)
    else
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
    end

    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end

    wait(2) -- 2 saniye gecikme
    if isRunning then
        currentIndex = index + 1
        sendMessageAndJump(currentIndex)
    end
end

-- Başlat Butonu
createButton("Başlat", Color3.fromRGB(25, 40, 60), function()
    if isRunning then return end
    isRunning = true
    stopRequested = false
    currentIndex = 1
    sendMessageAndJump(currentIndex)
end)

-- Devam Et Butonu
createButton("Devam Et", Color3.fromRGB(25, 40, 60), function()
    if isRunning or currentIndex == 1 then return end
    isRunning = true
    stopRequested = false
    sendMessageAndJump(currentIndex)
end)

-- Durdur Butonu
createButton("Durdur", Color3.fromRGB(60, 20, 20), function()
    stopRequested = true
    isRunning = false

end)
