local AnimationTrack = {}
AnimationTrack.__index = AnimationTrack
function SnapshotMoter6Ds(Model)
	local Snapshot = {}
	for _,Descendant in next,Model:GetDescendants() do
		if Descendant:IsA("Motor6D") then
			Snapshot[Descendant] = Descendant.Transform
		end
	end
	return Snapshot
end
AnimationTrack.PlaybackSpeed = 1
function AnimationTrack.new(Character,KeyframeSequence)
	local self = setmetatable({},AnimationTrack)
	local Keyframes = {}
	local RawKeyframes = KeyframeSequence:GetKeyframes()
	table.sort(RawKeyframes,function(KeyframeA,KeyframeB)
		return KeyframeA.Time < KeyframeB.Time
	end)
	local Continue = {}
	for Index,RawKeyframe in next,RawKeyframes do
		local Keyframe = {
			["Time"] = RawKeyframe.Time,
			["Poses"] = {}
		}
		for _,RawPose in next,RawKeyframe:GetDescendants() do
			if RawPose.Parent:IsA("Pose") then
				local Pose = {
					["CFrame"] = RawPose.CFrame
				}
				Keyframe[RawPose.Name] = Pose
				Continue[RawPose.Name] = Pose
			end
		end
		for Index,Value in next,Continue do
			if not Keyframe[Index] then
				Keyframe[Index] = Value
			end
		end
		Keyframes[Index] = Keyframe
	end
	self.Character = Character
	self.KeyframeSequence = Keyframes
	self.Looped = KeyframeSequence.Loop
	return self
end
function AnimationTrack:AdjustSpeed(Speed)
	self.PlaybackSpeed = Speed
end
function AnimationTrack:Play()
	self.StartedAt = tick()
	local LastStepped = tick()
	if self.Event then
		self.Event:Disconnect()
	end
	local FrameTime = 0
	self.TimePosition = 0
	local Snapshot = SnapshotMoter6Ds(self.Character)
	for Motor6D,_ in next,Snapshot do
		Snapshot[Motor6D] = CFrame.new()
	end
	local KeyframeIndex = 1
	self.Event = game:GetService("RunService").Stepped:Connect(function(Runtime,DeltaTime)
		local StepTick = tick()
		FrameTime = FrameTime + DeltaTime*self.PlaybackSpeed
		self.TimePosition = self.TimePosition + DeltaTime*self.PlaybackSpeed
		local Keyframe = self.KeyframeSequence[KeyframeIndex]
		local Alpha = math.min(1, FrameTime / math.max(1,Keyframe.Time))
		if Keyframe.Time  == 0 then
			Alpha = 1
		end
		for _,Descendant in next,self.Character:GetDescendants() do
			if Descendant:IsA("Motor6D") and Snapshot[Descendant] then
				if Keyframe[Descendant.Part1.Name] then
					Descendant.Transform = Snapshot[Descendant]:lerp(Keyframe[Descendant.Part1.Name].CFrame,Alpha)
				elseif Descendant:IsA("Motor6D") and Snapshot[Descendant] then
					Descendant.Transform = Snapshot[Descendant]
				end
			end
		end
		if Alpha == 1 then
			KeyframeIndex = KeyframeIndex+1
			if KeyframeIndex > #self.KeyframeSequence and self.Looped then
				KeyframeIndex = 1
				self.TimePosition = 0
			elseif KeyframeIndex > #self.KeyframeSequence then
				local E = self.Event
				self.Event = nil
				return E:Disconnect()
			end
			FrameTime = 0
			Snapshot = SnapshotMoter6Ds(self.Character)
		end
	end)
end
function AnimationTrack:Stop()
	if self.Event then
		self.Event:Disconnect()
	end
end
return AnimationTrack
