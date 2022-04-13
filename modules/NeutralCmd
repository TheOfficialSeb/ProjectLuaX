if shared.NeutralCmd then return shared.NeutralCmd end
local _game = setmetatable({},{__index=function(self,asked)return game:GetService(asked)end})
while not _game.Players.LocalPlayer:FindFirstChild("MessageSender",true) do
	_game.RunService.Heartbeat:Wait()
end
local NeutralCmd = {
	["__commands"] = {}
}
local MessageSender_Module = _game.Players.LocalPlayer:FindFirstChild("MessageSender",true)
local ChatMain_Module = MessageSender_Module:FindFirstAncestor("ChatMain")
local MessageSender = require(MessageSender_Module)
local ChatMain = require(ChatMain_Module)
local Methods = getmetatable(MessageSender)
local SendMessage = Methods.SendMessage
local MessagePosted = ChatMain.MessagePosted
MessagePosted.rfire = MessagePosted.fire
function NeutralCmd:RegisterCommand(callname,callback,argumentNotRequired)
	self.__commands[callname] = {callback,argumentNotRequired}
	warn("[+](NeutralCmd) "..callname.." Added")
end
function NeutralCmd:LookForPlayer(Name)
    print("\""..Name.."\"")
	local Username = Name:sub(1,1) == "@"
	Name = Username and Name:sub(2) or Name
	for _,Player in next,_game.Players:GetPlayers() do
	    warn(Username and "Name" or "DisplayName",Player[Username and "Name" or "DisplayName"]:sub(1,#Name):lower(),Name:lower())
		if Player[Username and "Name" or "DisplayName"]:sub(1,#Name):lower() == Name:lower() then
			return Player
		end
	end
end
function Methods.SendMessage(self,source,channel)
	for CommandName,Command in next,NeutralCmd.__commands do
		local cmd_match = source:match(Command[2] and ("/"..CommandName) or ("/"..CommandName.."%s+(.+)"))
		if cmd_match then
			pcall(Command[1],Command[2] and {} or cmd_match:gsub("%s+"," "):split(" "))
			return
		end
	end
	SendMessage(MessageSender,source,channel)
end
function ChatMain.MessagePosted:fire(source)
	for CommandName,Command in next,NeutralCmd.__commands do
		local cmd_match = source:match(Command[2] and ("/"..CommandName) or ("/"..CommandName.."%s+(.+)"))
		if cmd_match then
			return
		end
	end
	MessagePosted:rfire(source)
end
shared.NeutralCmd = NeutralCmd
warn("[+] NeutralCmd Added")
NeutralCmd:RegisterCommand("exit",function()
	MessageSender_Module:FindFirstAncestorOfClass("Player"):Kick()
end,true)
NeutralCmd:RegisterCommand("unsit",function()
	MessageSender_Module:FindFirstAncestorOfClass("Player").Character.Humanoid.Sit = false
end,true)
NeutralCmd:RegisterCommand("lock",function()
	local HumanoidRootPart = MessageSender_Module:FindFirstAncestorOfClass("Player").Character.HumanoidRootPart
	local BodyVelocity = Instance.new("BodyVelocity",HumanoidRootPart)
	BodyVelocity.MaxForce = Vector3.new(1,1,1)*math.huge
	BodyVelocity.Velocity = Vector3.new()
end,true) -- HarIinaa
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
NeutralCmd:RegisterCommand("username",function(arguments)
    setclipboard(NeutralCmd:LookForPlayer(arguments[1]).Name)
end)
NeutralCmd:RegisterCommand("userid",function(arguments)
    setclipboard(NeutralCmd:LookForPlayer(arguments[1]).UserId)
end)
return NeutralCmd
