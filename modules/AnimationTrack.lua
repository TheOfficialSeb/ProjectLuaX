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
	local Used = {}
	local LastTime = 0
	for Index,RawKeyframe in next,RawKeyframes do
		local Keyframe = {
			["Time"] = RawKeyframe.Time,
			["Duration"] = RawKeyframe.Time-LastTime,
			["Pose"] = {}
		}
		LastTime = RawKeyframe.Time
		for _,RawPose in next,RawKeyframe:GetDescendants() do
			if RawPose.Parent:IsA("Pose") and RawPose:IsA("Pose") then
				Keyframe.Pose[RawPose.Name] = {
					["CFrame"] = RawPose.CFrame
				}
				if RawKeyframe.Time == 0 then
					Used[RawPose.Name] = RawPose.CFrame
				elseif not Used[RawPose.Name] then
					Used[RawPose.Name] = CFrame.new()
				end
			end
		end
		for Index,Value in next,Used do
			if not Keyframe.Pose[Index] then
				Keyframe.Pose[Index] = Value
			end
		end
		Keyframes[Index] = Keyframe
	end
	for _,Keyframe in next,Keyframes do
		for Index,Value in next,Used do
			if not Keyframe.Pose[Index] then
				Keyframe.Pose[Index] = Value
			end
		end
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
	if self.Event then
		self.Event:Disconnect()
	end
	local FrameTime = 0
	local Snapshot = SnapshotMoter6Ds(self.Character)
	for Motor6D,_ in next,Snapshot do
		Snapshot[Motor6D] = CFrame.new()
	end
	local KeyframeIndex = 1
	self.Event = RunService.Stepped:Connect(function(Runtime,DeltaTime)
		FrameTime = FrameTime + (DeltaTime*self.PlaybackSpeed)
		local Keyframe = self.KeyframeSequence[KeyframeIndex]
		local Alpha = math.min(1, FrameTime / Keyframe.Duration)
		if Keyframe.Time  == 0 then
			Alpha = 1
		end
		for _,Descendant in next,self.Character:GetDescendants() do
			if Descendant:IsA("Motor6D") and Snapshot[Descendant] then
				if Keyframe.Pose[Descendant.Part1.Name] then
					Descendant.Transform = Snapshot[Descendant]:lerp(Keyframe.Pose[Descendant.Part1.Name].CFrame,Alpha)
				elseif Descendant:IsA("Motor6D") and Snapshot[Descendant] then
					Descendant.Transform = Snapshot[Descendant]
				end
			end
		end
		if Alpha == 1 then
			KeyframeIndex = KeyframeIndex+1
			if KeyframeIndex > #self.KeyframeSequence and self.Looped then
				KeyframeIndex = 1
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
