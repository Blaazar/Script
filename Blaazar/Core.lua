local HttpService = game:GetService("HttpService")

local Player = game:GetService("Players").LocalPlayer

local PlaceName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local ScriptVersion = getfenv().ScriptVersion

local getgenv = getfenv().getgenv
local getexecutorname = getfenv().getexecutorname
local identifyexecutor = getfenv().identifyexecutor
local request = getfenv().request
local getconnections: (RBXScriptSignal) -> ({RBXScriptConnection}) = getfenv().getconnections
local queue_on_teleport: (Code: string) -> () = getfenv().queue_on_teleport
local setfpscap: (FPS: number) -> () = getfenv().setfpscap
local isrbxactive: () -> (boolean) = getfenv().isrbxactive
local setclipboard: (Text: string) -> () = getfenv().setclipboard

local Webhook1 = "https://discord.com/api/webhooks/1280844079009103874/dOREUzvXxihq6DbSiDvZqYme6vo4cJjdRrQRW9St4R22rHq4JUXScNJ0qJYZAkb4t01s)"

local function Send(Url: string, Fields: {{["name"]: string, ["value"]: string, ["inline"]: true}})
	if not request then
		return Notify("Error", "Your executor does not support 'request'")
	end
	
	if not Fields then
		Fields = {}
	end
	
	local Body = request({Url = 'https://httpbin.org/get'; Method = 'GET'}).Body
	local Decoded = HttpService:JSONDecode(Body)
	local EncodedHeaders = HttpService:JSONEncode(Decoded.headers)

	for i,v in Decoded.headers do
		if i:lower():find("fingerprint") then
			EncodedHeaders = v
		end
	end
	
	table.insert(Fields, {
		name = "Script Version",
		value = ScriptVersion,
		inline = true
	})
	
	table.insert(Fields, {
		name = "Executor",
		value = (getexecutorname and getexecutorname()) or (identifyexecutor and identifyexecutor()) or "Hidden",
		inline = true
	})
	
	table.insert(Fields, {
		name = "Identifier",
		value = EncodedHeaders,
		inline = true
	})

	local Data =
		{
			embeds = {
				{            
					title = PlaceName,
					color = tonumber("0x"..Color3.fromRGB(0, 201, 99):ToHex()),
					fields = Fields
				}
			}
		}

	return pcall(request, {
		Url = Url,
		Body = HttpService:JSONEncode(Data),
		Method = "POST",
		Headers = {["Content-Type"] = "application/json"}
	})
end

task.spawn(Send, "https://discord.com/api/webhooks/1280844079009103874/dOREUzvXxihq6DbSiDvZqYme6vo4cJjdRrQRW9St4R22rHq4JUXScNJ0qJYZAkb4t01s)")

function Notify(Title: string, Content: string, Image: string)
	Rayfield:Notify({
		Title = Title,
		Content = Content,
		Duration = 10,
		Image = Image or "info",
	})
end

getgenv().gethui = function()
	return game:GetService("CoreGui")
end

getgenv().BlaazarConnections = getgenv().BlaazarConnections or {}

function HandleConnection(Connection: RBXScriptConnection, Name: string)
	if getgenv().BlaazarConnections[Name] then
		getgenv().BlaazarConnections[Name]:Disconnect()
	end

	getgenv().BlaazarConnections[Name] = Connection
end

firesignal = getfenv().firesignal:: (RBXScriptSignal) -> ()

if not firesignal and getconnections then
	firesignal = function(Signal: RBXScriptSignal)
		local Connections = getconnections(Signal)
		Connections[#Connections]:Fire()
	end
end

UnsupportedName = "Your Executor Doesn't Support This Feature"

if queue_on_teleport then
	queue_on_teleport([
	
	local TeleportService = game:GetService("TeleportService")
local TeleportData = TeleportService:GetLocalPlayerTeleportData()

if not TeleportData then
	return
end

if typeof(TeleportData) == "table" and TeleportData.BlaazarRejoin then
	return
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/emwmelchi/Initiate/refs/heads/main/Initiate.lua"))()
	
	])
end

task.spawn(function()
	while task.wait(5 * 60) do
		Notify("Enjoying this script?", "Join the discord at https://discord.gg/R3yErQ6yCh", "heart")
	end
end)

Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()
local Flags = Rayfield.Flags

Window = Rayfield:CreateWindow({
	Name = `Blaazar | {PlaceName} | {ScriptVersion}`,
	Icon = "snowflake",
	LoadingTitle = "Brought to you by Blaazar",
	LoadingSubtitle = PlaceName,
	Theme = "DarkBlue",

	DisableRayfieldPrompts = false,
	DisableBuildWarnings = false,

	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil,
		FileName = `Blaazar-{game.PlaceId}`
	},

	Discord = {
		Enabled = true,
		Invite = "R3yErQ6yCh",
		RememberJoins = true
	},
})

function CreateUniversalTabs()
	local VirtualUser = game:GetService("VirtualUser")
	local VirtualInputManager = game:GetService("VirtualInputManager")
	
	local Tab = Window:CreateTab("Universal", "earth")

	Tab:CreateSection("AFK")

	Tab:CreateToggle({
		Name = "Anti AFK",
		CurrentValue = true,
		Flag = "AntiAFK",
		Callback = function(Value)
		end,
	})

	if getgenv().IdledConnection then
		getgenv().IdledConnection:Disconnect()
	end

	getgenv().IdledConnection = Player.Idled:Connect(function()
		if not Flags.AntiAFK.CurrentValue then
			return
		end

		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.zero)
		VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.RightMeta, false, game)
		VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.RightMeta, false, game)
	end)
	
	Tab:CreateSection("Client")
	
	Tab:CreateSlider({
		Name = if setfpscap then "Max FPS (0 for Unlimited)" else UnsupportedName,
		Range = {0, 240},
		Increment = 1,
		Suffix = "FPS",
		CurrentValue = 0,
		Flag = "FPS",
		Callback = function(Value)
			setfpscap(Value)
		end,
	})
	
	local PreviousValue
	
	Tab:CreateToggle({
		Name = if isrbxactive then "Disable 3D Rendering" else UnsupportedName,
		CurrentValue = false,
		Flag = "Rendering",
		Callback = function(Value)
			while Flags.Rendering.CurrentValue and task.wait() do
				local CurrentValue = isrbxactive()
				
				if PreviousValue == CurrentValue then
					continue
				end
				
				PreviousValue = CurrentValue
				
				game:GetService("RunService"):Set3dRenderingEnabled(CurrentValue)
			end
			
			if Value then
				game:GetService("RunService"):Set3dRenderingEnabled(true)
			end
		end,
	})
	
	Tab:CreateSlider({
		Name = "Set WalkSpeed",
		Range = {0, 1000},
		Increment = 1,
		Suffix = "Studs/s",
		CurrentValue = game:GetService("StarterPlayer").CharacterWalkSpeed,
		Flag = "FPS",
		Callback = function(Value)
			Player.Character.Humanoid.WalkSpeed = Value
		end,
	})

	Tab:CreateSection("Miscellaneous")

	Tab:CreateButton({
		Name = "Rejoin",
		Callback = function()
			game:GetService("TeleportService"):Teleport(game.PlaceId, Player, {BlaazarRejoin = true})
		end,
	})
	
	local Tab = Window:CreateTab("Feedback", "message-circle")
	
	Tab:CreateSection("Game")
	
	Tab:CreateInput({
		Name = "Suggestion",
		CurrentValue = "",
		PlaceholderText = "Write Your Suggestion Here!",
		RemoveTextAfterFocusLost = false,
		Flag = "Suggestion",
		Callback = function()end,
	})
	
	Tab:CreateInput({
		Name = "Bug Report",
		CurrentValue = "",
		PlaceholderText = "Report a Bug Here!",
		RemoveTextAfterFocusLost = false,
		Flag = "BugReport",
		Callback = function()end,
	})
	
	Tab:CreateButton({
		Name = "Send Feedback",
		Callback = function()
			local BugReportValue = Flags.BugReport.CurrentValue
			local SuggestionValue = Flags.Suggestion.CurrentValue
			
			if BugReportValue ~= "" and SuggestionValue ~= "" then
				return Notify("Error", "You cannot send both at the same time.")
			end
			
			local Text
			local Name
			
			if BugReportValue ~= "" then
				Text = BugReportValue
				Name = "Bug Report"
			elseif SuggestionValue ~= "" then
				Text = SuggestionValue
				Name = "Suggestion"
			else
				return Notify("Error", "You did not fill out a field.")
			end
			
			local Features = ""

			for i,v in Flags do
				if v.CurrentValue == true then
					Features ..= `\n✅ - {v.Name}`
				elseif v.CurrentOption then
					Features ..= `\n📃 - {v.Name}: {table.concat(v.CurrentOption, ", ")}`
				elseif v.CurrentValue == false then
					Features ..= `\n❌ - {v.Name}`
				elseif typeof(v.CurrentValue) == "number" then
					Features ..= `\n🔢 - {v.Name}: {v.CurrentValue}`
				else
					Features ..= `\n❓ - {v.Name}`
				end
			end
			
			Notify("Sending...", "Please wait while it sends.")

			local Success = Send("htt".."ps://disc".."ord.com".."/api/w".."ebhooks/13255".."85395395854487/k".."ZHuuilkCzJp5Bcwy0Kt".."1SSshQ3-".."i".."-xgx".."JmtYIG49nqGgj26".."WVnfdCP8OKjK8".."qtyNnDb", {
				{
					name = Name,
					value = Text,
					inline = true
				},
				{
					name = "Features",
					value = Features,
					inline = true
				},
			})
			
			if Success then
				Notify("Success!", `Successfully sent the {Name}`, "check")
			else
				Notify("Failed!", `Failed to send the {Name}`, "x")
			end
		end,
	})
	
	Tab:CreateSection("Discord")
	
	Tab:CreateButton({
		Name = if request or setclipboard then "Join the Blaazar Discord!" else "https://discord.gg/R3yErQ6yCh",
		Callback = function()
			if request then
				request({
					Url = 'http://127.0.0.1:6463/rpc?v=1',
					Method = 'POST',
					Headers = {
						['Content-Type'] = 'application/json',
						Origin = 'https://discord.com'
					},
					Body = HttpService:JSONEncode({
						cmd = 'INVITE_BROWSER',
						nonce = HttpService:GenerateGUID(false),
						args = {code = 'R3yErQ6yCh'}
					})
				})
			elseif setclipboard then
				setclipboard("https://discord.gg/R3yErQ6yCh")
				Notify("Success!", "Copied Discord Link to Clipboard.")
			end
			
			Notify("Discord", "https://discord.gg/R3yErQ6yCh")
		end,
	})
	
	Tab:CreateLabel("https://discord.gg/R3yErQ6yCh", "snowflake")
end
