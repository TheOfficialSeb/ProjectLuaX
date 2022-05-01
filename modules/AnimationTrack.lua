local AnimationTrack = {}
AnimationTrack.__index = AnimationTrack
function InverseLerp(x,y,z)
	return (z - x) / (y - x)
end
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
		return KeyframeA.Time > KeyframeB.Time
	end)
	for Index,RawKeyframe in next,KeyframeSequence:GetKeyframes() do
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
			end
		end
		Keyframes[Index] = Keyframe
	end
	if true then
		--assert(false,"Paused")
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
			if Descendant:IsA("Motor6D") and Snapshot[Descendant] and Keyframe[Descendant.Part1.Name] then
				Descendant.Transform = Snapshot[Descendant]:lerp(Keyframe[Descendant.Part1.Name].CFrame,Alpha)
			end
		end
		if Alpha == 1 then
			KeyframeIndex = KeyframeIndex+1
			if KeyframeIndex > #self.KeyframeSequence and self.Looped then
				KeyframeIndex = 1
				self.TimePosition = 0
			elseif KeyframeIndex > #self.KeyframeSequence then
				return self.Event:Disconnect()
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
