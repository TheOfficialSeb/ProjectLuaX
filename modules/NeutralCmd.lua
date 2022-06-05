if shared.NeutralCmd then return shared.NeutralCmd end
local _game = setmetatable({},{__index=function(self,asked)return game:GetService(asked)end})
while not _game.Players.LocalPlayer:FindFirstChild("MessageSender",true) do
	_game.RunService.Heartbeat:Wait()
end
local NeutralCmd = {
	["__commands"] = {}
}
local LocalPlayer = _game.Players.LocalPlayer
local MessageSender_Module = LocalPlayer:FindFirstChild("MessageSender",true)
local ClientChatModules = game:GetService("Chat"):WaitForChild("ClientChatModules")
local Util_Module = ClientChatModules:WaitForChild("MessageCreatorModules"):WaitForChild("Util")
local ChatSettings_Module = ClientChatModules:WaitForChild("ChatSettings")
local ChatMain_Module = MessageSender_Module:FindFirstAncestor("ChatMain")
local MessageSender = require(MessageSender_Module)
local ChatMain = require(ChatMain_Module)
local Util = require(Util_Module)
local ChatSettings = require(ChatSettings_Module)
local SendMessage = Methods.SendMessage
local MessagePosted = ChatMain.MessagePosted
MessagePosted.rfire = MessagePosted.fire
function NeutralCmd:RegisterCommand(callname,callback,argumentNotRequired)
	self.__commands[callname] = {callback,argumentNotRequired}
	warn("[+](NeutralCmd) "..callname.." Added")
end
function NeutralCmd:LookForPlayer(Name)
	local Username = Name:sub(1,1) == "@"
	Name = Username and Name:sub(2) or Name
	for _,Player in next,_game.Players:GetPlayers() do
		if Player[Username and "Name" or "DisplayName"]:sub(1,#Name):lower() == Name:lower() then
			return Player
		end
	end
end
function NeutralCmd:LookForPlayers(Names)
	local Players = {}
	for _,Name in next,Names:split(",") do
		if Name == "*" then
			for _,Player in next,_game.Players:GetPlayers() do
				table.insert(Players,Player)
			end
		elseif Name == "." then
			table.insert(Players,_game.Players.LocalPlayer)
		else
			table.insert(Players,NeutralCmd:LookForPlayer(Name))
		end
	end
	return Players
end
local ChatMessage = {}
ChatMessage.__index = ChatMessage
function ChatMessage.__nativecreate(messageData, channelName)
	local channelObj = Util.ChatWindow:GetChannel(channelName)
	if (channelObj) then
		channelObj:AddMessageToChannel(messageData)
		ChatMain.MessageCount = ChatMain.MessageCount + 1
		ChatMain.MessagesChanged:fire(ChatMain.MessageCount)
	end
end
function ChatMessage.__nativeupdate(messageData, channelName)
	local channelObj = Util.ChatWindow:GetChannel(channelName)
	if channelObj then
		channelObj:UpdateMessageFiltered(messageData)
	end
end
function ChatMessage:Update(Text)
	self.__nativeupdate({
		["Message"] = Text,
		["MessageType"] = "Message",
		["FromSpeaker"] = "localhost",
		["IsFiltered"] = true,
		["Time"] = math.floor(tick()),
		["ID"] = self.__id,
		["OriginalChannel"] = ChatSettings.GeneralChannelName
	},ChatSettings.GeneralChannelName)
end
function NeutralCmd:CreateMessage(Text,ChatColor)
	local this = setmetatable({},ChatMessage)
	this.__id = math.pow(math.random()*15,math.random()*15)
	this.__nativecreate({
		["Message"] = Text,
		["MessageType"] = "Message",
		["FromSpeaker"] = "localhost",
		["IsFiltered"] = true,
		["Time"] = math.floor(tick()),
		["ID"] = this.__id,
		["OriginalChannel"] = ChatSettings.GeneralChannelName,
		["ExtraData"] = {
			["NameColor"] = Color3.fromRGB(255,100,100),
			["ChatColor"] = ChatColor or Color3.new(1,1,1),
			["Tags"] = {
				{
					TagText = "$",
					TagColor = Color3.fromRGB(255,100,100)
				}
			}
		}
	},ChatSettings.GeneralChannelName)
	return this
end
local Emojis = _game.HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/github/gemoji/master/db/emoji.json"))
function ParseEmojis(text)
    return text:gsub(":([a-zA-Z0-9_]+):",function(name)
        for _,Emoji in next,Emojis do
            if name:lower() == Emoji.aliases[1] then
                return Emoji.emoji
            end
        end
    end)
end
function Methods.SendMessage(self,source,channel)
	for CommandName,Command in next,NeutralCmd.__commands do
		local cmd_match = source:match(Command[2] and ("/"..CommandName) or ("/"..CommandName.."%s+(.+)"))
		if cmd_match then
			local Success,Error = pcall(Command[1],Command[2] and {} or cmd_match:gsub("%s+"," "):split(" "))
			if not Success then
				ChatMessage.__nativecreate({
					["Message"] = tostring(Error),
					["MessageType"] = "System",
					["IsFiltered"] = true,
					["Time"] = math.floor(tick()),
					["ID"] = math.pow(math.random()*15,math.random()*15),
					["OriginalChannel"] = ChatSettings.GeneralChannelName,
					["ExtraData"] = {
						["ChatColor"] = Color3.new(1,0,0),
					}
				},ChatSettings.GeneralChannelName)
			end
			return
		end
	end
    source = ParseEmojis(source)
	SendMessage(MessageSender,source,channel)
end
function ChatMain.MessagePosted:fire(source)
	for CommandName,Command in next,NeutralCmd.__commands do
		local cmd_match = source:match(Command[2] and ("/"..CommandName) or ("/"..CommandName.."%s+(.+)"))
		if cmd_match then
			return
		end
	end
    source = ParseEmojis(source)
	MessagePosted:rfire(source)
end
function NewMessage(messageData, channelName)
	local channelObj = Util.ChatWindow:GetChannel(channelName)
	if (channelObj) then
		channelObj:AddMessageToChannel(messageData)
		ChatMain.MessageCount = ChatMain.MessageCount + 1
		ChatMain.MessagesChanged:fire(ChatMain.MessageCount)
	end
end
function UpdateMessage(messageData, channelName)
	local channelObj = Util.ChatWindow:GetChannel(channelName)
	if channelObj then
		channelObj:UpdateMessageFiltered(messageData)
	end
end
shared.NeutralCmd = NeutralCmd
warn("[+] NeutralCmd Added")
NeutralCmd:RegisterCommand("exit",function()
	local NotLacking = pcall(game.Shutdown,game)
	if not NotLacking then
		MessageSender_Module:FindFirstAncestorOfClass("Player"):Kick()
	end
end,true)
NeutralCmd:RegisterCommand("unsit",function()
	MessageSender_Module:FindFirstAncestorOfClass("Player").Character.Humanoid.Sit = false
end,true)
NeutralCmd:RegisterCommand("lock",function()
	local HumanoidRootPart = MessageSender_Module:FindFirstAncestorOfClass("Player").Character.HumanoidRootPart
	local BodyVelocity = Instance.new("BodyVelocity",HumanoidRootPart)
	BodyVelocity.MaxForce = Vector3.new(1,1,1)*math.huge
	BodyVelocity.Velocity = Vector3.new()
end,true)
NeutralCmd:RegisterCommand("to",function(arguments)
	MessageSender_Module:FindFirstAncestorOfClass("Player").Character.HumanoidRootPart.CFrame = NeutralCmd:LookForPlayer(arguments[1]).Character.HumanoidRootPart.CFrame
end)
NeutralCmd:RegisterCommand("ws",function(arguments)
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = tonumber( arguments[1])
end)
NeutralCmd:RegisterCommand("unlock",function()
	local HumanoidRootPart = MessageSender_Module:FindFirstAncestorOfClass("Player").Character.HumanoidRootPart
	local BodyVelocity = HumanoidRootPart:FindFirstChildOfClass("BodyVelocity")
	BodyVelocity:Remove()
end,true)
NeutralCmd:RegisterCommand("reset",function()
	MessageSender_Module:FindFirstAncestorOfClass("Player").Character.Humanoid.Health = 0
end,true)
NeutralCmd:RegisterCommand("fixlighting",function()
	for _,Child in next,_game.Lighting:GetChildren() do
		pcall(function()Child.Enabled = false end)
	end
end,true)
NeutralCmd:RegisterCommand("rj",function()
	game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,game.JobId,_game.Players.LocalPlayer)
end,true)
NeutralCmd:RegisterCommand("age",function(arguments)
	local Players = NeutralCmd:LookForPlayers(arguments[1])
	assert(#Players > 0,"No Players Found")
	for _,Player in next,Players do
		local AccountAge = Player.AccountAge
		local Years = math.floor(AccountAge/365)
		local Days = AccountAge%365
		local Date = os.date("*t",os.time()-(AccountAge*86400))
		NeutralCmd:CreateMessage(("@%s %d/%d/%d (%dD %dY)"):format(Player.Name,Date.month,Date.day,Date.year,Days,Years))
	end
end)
if getfenv()["setclipboard"] then
	NeutralCmd:RegisterCommand("username",function(arguments)
		setclipboard(NeutralCmd:LookForPlayer(arguments[1]).Name)
	end)
	NeutralCmd:RegisterCommand("userid",function(arguments)
		setclipboard(NeutralCmd:LookForPlayer(arguments[1]).UserId)
	end)
end
return NeutralCmd
