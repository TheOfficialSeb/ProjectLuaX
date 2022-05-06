local RunService = game:GetService("RunService")
local Motor6S = {}
Motor6S.__index = Motor6S
Motor6S.__CH = {}
function Motor6S.new(Motor6D)
	if Motor6S.__CH[Motor6D] then
		return Motor6S.__CH[Motor6D]
	end
	local self = {}
	Motor6S.__CH[Motor6D] = self
	setmetatable(self,Motor6S)
	self.OverWeld = Instance.new("Weld",Motor6D.Parent)
	self.Motor6D = Motor6D
	self.OverWeld.Part0 = Motor6D.Part0
	self.OverWeld.Part1 = Motor6D.Part1
	self.OverWeld.C0 = Motor6D.C0
	self.OverWeld.C1 = Motor6D.C1*Motor6D.Transform:Inverse()
	self.Motor6D.Enabled = false
	RunService.Stepped:Connect(function(LastStepped)
		self:UpdateCFrames(LastStepped)
	end)
end
function Motor6S:UpdateCFrames(LastStepped)
	wait(LastStepped/8)
	self.OverWeld.Part0 = self.Motor6D.Part0
	self.OverWeld.Part1 = self.Motor6D.Part1
	self.OverWeld.C0 = self.Motor6D.C0
	self.OverWeld.C1 = self.Motor6D.C1*self.Motor6D.Transform:Inverse()
end
return Motor6S
