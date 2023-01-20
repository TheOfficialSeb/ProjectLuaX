local UserInputService = game:GetService("UserInputService")
local Debugger = {}
Debugger.__index = Debugger
Debugger.Types = {
	["Number"] = 0,
	["String"] = 1,
	["Boolean"] = 2,
	["Instance"] = 3,
	["Vector3"] = 4,
	["CFrame"] = 5,
	["Ray"] = 6,
}
function Debugger.new(Parent)
	local self = setmetatable({},Debugger)
	self.Variables = {}
	self.ScreenGui = Instance.new("ScreenGui",Parent)
	self.Frame = Instance.new("Frame",self.ScreenGui)
	self.Frame.Size = UDim2.fromScale(1,1)
	self.Frame.BackgroundTransparency = 1
	self.UIListLayout = Instance.new("UIListLayout",self.Frame)
	self.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	self.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UserInputService.InputBegan:Connect(function(InputObject)
		if InputObject.KeyCode == Enum.KeyCode.PageUp and self.ScreenGui.Enabled then
			self.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
			self.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
			for _,Variable in next,self.Variables do
				Variable.Label.TextXAlignment = Enum.TextXAlignment.Left
				Variable.Label.Text = Variable:UpdateSuffix(Variable.Text)
				Variable.Button.Position = UDim2.new(0,3,0.5,0)
				Variable.Button.AnchorPoint = Vector2.new(0,0.5)
			end
		elseif InputObject.KeyCode == Enum.KeyCode.PageDown and self.ScreenGui.Enabled then
			self.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
			self.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
			for _,Variable in next,self.Variables do
				Variable.Label.TextXAlignment = Enum.TextXAlignment.Right
				Variable.Label.Text = Variable:UpdateSuffix(Variable.Text)
				Variable.Button.Position = UDim2.new(1,-3,0.5,0)
				Variable.Button.AnchorPoint = Vector2.new(1,0.5)
			end
		elseif InputObject.KeyCode == Enum.KeyCode.End then
			self.ScreenGui.Enabled = not self.ScreenGui.Enabled
		end
	end)
	return self
end
local Variable = {}
Variable.__index = Variable
Variable.__types = Debugger.Types
function Debugger:CreateVariable(Name,Type)
	local ThisVariable = setmetatable({},Variable)
	ThisVariable.Name = Name
	ThisVariable.Type = Type
	ThisVariable.Label = Instance.new("TextLabel",self.Frame)
	ThisVariable.Label.Size = UDim2.new(1,0,0,23)
	ThisVariable.Label.TextXAlignment = Enum.TextXAlignment.Right
	ThisVariable.Label.Font = Enum.Font.RobotoMono
	ThisVariable.Label.TextSize = 19
	ThisVariable.Label.BackgroundTransparency = 1
	ThisVariable.Button = Instance.new("TextButton",ThisVariable.Label)
	ThisVariable.Button.TextTransparency = 1
	ThisVariable.Button.Size = UDim2.new(0,10,0.8,0)
	ThisVariable.Button.Position = UDim2.fromScale(1,0.5)
	ThisVariable.Button.AnchorPoint = Vector2.new(1,0.5)
	
	ThisVariable.Label.TextColor3 = ThisVariable.Button.BackgroundColor3
	ThisVariable.Label.TextStrokeColor3 = ThisVariable.Button.BackgroundColor3
	ThisVariable.Text = "UNDEFINED"
	ThisVariable:UpdateSuffix(ThisVariable.Text)
	Instance.new("UICorner",ThisVariable.Button).CornerRadius = UDim.new(1)
	table.insert(self.Variables,ThisVariable)
	return ThisVariable
end
function Variable:UpdateSuffix(Text)
	local TypeName
	for Index,Value in next,self.__types do
		if Value == self.Type then
			TypeName = Index
		end
	end
	if self.Label.TextXAlignment == Enum.TextXAlignment.Right then
		return Text .." ["..self.Name.."]["..TypeName.."]"..("\t"):rep(5)
	end
    print(TypeName,self.Name,Text)
	return ("\t"):rep(5) .."["..TypeName.."]["..self.Name.."] ".. Text
end
function Variable:Update(Value)
	if self.Type == self.__types["Number"] then
		self.Text = tostring(Value)
		self.Label.Text = self:UpdateSuffix(self.Text)
		self.Label.TextColor3 = typeof(Value) == "number" and Color3.fromRGB(75,255,75) or Color3.fromRGB(255,75,75)
	elseif self.Type == self.__types["String"] then
		self.Label.Text = self:UpdateSuffix(tostring(Value))
		self.Label.TextColor3 = typeof(Value) == "string" and Color3.fromRGB(75,255,75) or Color3.fromRGB(255,75,75)
	elseif self.Type == self.__types["Boolean"] then
		local Value = not (not Value)
		self.Text = tostring(Value)
		self.Label.Text = self:UpdateSuffix(self.Text)
		self.Label.TextColor3 = Value and Color3.fromRGB(75,255,75) or Color3.fromRGB(255,255,75)
	elseif self.Type == self.__types["Instance"] then
		local Text = typeof(Value) == "Instance" and Value:GetFullName()
		self.Text = tostring(Text or "NIL")
		self.Label.Text = self:UpdateSuffix(self.Text)
		self.Label.TextColor3 = typeof(Value) == "Instance" and Color3.fromRGB(75,255,75) or Color3.fromRGB(255,75,75)
	elseif self.Type == self.__types["Vector3"] then
		local Text = typeof(Value) == "Vector3" and tostring(Value)
		self.Text = Text or "NIL"
		self.Label.Text = self:UpdateSuffix(self.Text)
		self.Label.TextColor3 = typeof(Value) == "Vector3" and Color3.fromRGB(75,255,75) or Color3.fromRGB(255,75,75)
	end
	self.Label.TextStrokeColor3 = self.Label.TextColor3
	self.Button.BackgroundColor3 = self.Label.TextColor3
end
shared.Debugger = Debugger
return Debugger
