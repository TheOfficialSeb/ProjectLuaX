-- TheOfficialSeb's Animation Loader
local AnimationLoader = {}
AnimationLoader["CoreFunctions"] = {}
function AnimationLoader.CoreFunctions.GetBodyPartCFrame(self,BodyPartName,Rotation,Offset)
    local BodyPartName = BodyPartName:lower()
    if BodyPartName == "arml" or BodyPartName == "armr" then
        local X = Rotation and Rotation[1] and math.rad(-Rotation[1]) or 0
        local Y = Rotation and Rotation[2] and math.rad(-Rotation[2]) or 0
        local Z = Rotation and Rotation[3] and math.rad(-Rotation[3]) or 0
        local XP = Offset and Offset[1] and -Offset[1] or 0
        local YP = Offset and Offset[2] and -Offset[1] or 0
        local ZP = Offset and Offset[3] and -Offset[1] or 0
        return CFrame.new(XP,0.5+YP,ZP) * CFrame.Angles(X,Y,Z)
    elseif BodyPartName == "legl" or BodyPartName == "legr" then
        local X = Rotation and Rotation[1] and math.rad(-Rotation[1]) or 0
        local Y = Rotation and Rotation[2] and math.rad(-Rotation[2]) or 0
        local Z = Rotation and Rotation[3] and math.rad(-Rotation[3]) or 0
        local XP = Offset and Offset[1] and -Offset[1] or 0
        local YP = Offset and Offset[2] and -Offset[2] or 0
        local ZP = Offset and Offset[3] and -Offset[3] or 0
        return CFrame.new(XP,1+YP,ZP) * CFrame.Angles(X,Y,Z)
    elseif BodyPartName == "torso" then
        local X = Rotation and Rotation[1] and math.rad(-Rotation[1]) or 0
        local Y = Rotation and Rotation[2] and math.rad(-Rotation[2]) or 0
        local Z = Rotation and Rotation[3] and math.rad(-Rotation[3]) or 0
        local XP = Offset and Offset[1] and -Offset[1] or 0
        local YP = Offset and Offset[2] and -Offset[2] or 0
        local ZP = Offset and Offset[3] and -Offset[3] or 0
        return CFrame.Angles(X,Y,Z) * CFrame.new(XP,YP,ZP)
    elseif BodyPartName == "head" then
        local X = Rotation and Rotation[1] and math.rad(Rotation[1]) or 0
        local Y = Rotation and Rotation[2] and math.rad(Rotation[2]) or 0
        local Z = Rotation and Rotation[3] and math.rad(Rotation[3]) or 0
        local XP = Offset and Offset[1] and -Offset[1] or 0
        local YP = Offset and Offset[2] and -Offset[2] or 0
        local ZP = Offset and Offset[3] and -Offset[3] or 0
        return CFrame.new(XP,(-0.5)+YP,ZP) * CFrame.Angles(X,Y,Z)
    end
end
AnimationLoader["CharacterCache"] = {}
AnimationLoader["Animate"] = {["Parent"]=AnimationLoader}
function AnimationLoader.Animate.Set(self,Character,BodyPart,Rotation,Offset)
    if self.Parent.CharacterCache[Character] and self.Parent.CharacterCache[Character][BodyPart:lower()] then
        self.Parent.CharacterCache[Character][BodyPart:lower()].C1 = self.Parent["CoreFunctions"]:GetBodyPartCFrame(BodyPart,Rotation,Offset)
    else
        error("Not Rigged")
    end
end
function AnimationLoader.Animate.Tween(self,Character,BodyPart,TweenInfo,Rotation,Offset)
    if self.Parent.CharacterCache[Character] and self.Parent.CharacterCache[Character][BodyPart:lower()] then
        local Animator_Goal = {["C1"]=self.Parent["CoreFunctions"]:GetBodyPartCFrame(BodyPart,Rotation,Offset)}
        return game:GetService("TweenService"):Create(self.Parent.CharacterCache[Character][BodyPart:lower()],TweenInfo,Animator_Goal)
    else
        error("Not Rigged")
    end
end
function AnimationLoader.RigCharacter(self,Character,ExcludeArms,ExcludeLegs)
    if self["CharacterCache"][Character] then
        return
    end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if Humanoid and Humanoid.RigType == Enum.HumanoidRigType.R6 then
        -- Getting BodyParts
        local Character_Torso = Character:WaitForChild("Torso")
        local Character_Head = Character:FindFirstChild("Head")
        local Character_LeftArm = Character:FindFirstChild("Left Arm")
        local Character_RightArm = Character:FindFirstChild("Right Arm")
        local Character_LeftLeg = Character:FindFirstChild("Left Leg")
        local Character_RightLeg = Character:FindFirstChild("Right Leg")
        assert(Character_Head and Character_LeftArm and Character_RightArm and Character_LeftLeg and Character_RightLeg,"Limb Missing")
        local Limbs = {}
        local JointsFolder = Instance.new("Folder",Character)
        JointsFolder.Name = "JointsFolder"
        -- Helper Welds
        Limbs["head__AV"] = Instance.new("Weld",JointsFolder)
        Limbs["head__AV"].Part0 = Character.Torso
        Limbs["head__AV"].Part1 = Instance.new("Part",Limbs["head__AV"])
        Limbs["head__AV"].Part1.Size = Vector3.new(1,1,1)
        Limbs["head__AV"].Part1.Transparency = 1
        Limbs["head__AV"].Part1.CanCollide = false
        Limbs["head__AV"].C1 = CFrame.new(0,-1,0)
        if not ExcludeArms then
            Limbs["arml__AV"] = Instance.new("Weld",JointsFolder)
            Limbs["arml__AV"].Part0 = Character.Torso
            Limbs["arml__AV"].Part1 = Instance.new("Part",Limbs["arml__AV"])
            Limbs["arml__AV"].Part1.Size = Vector3.new(1,1,1)
            Limbs["arml__AV"].Part1.Transparency = 1
            Limbs["arml__AV"].Part1.CanCollide = false
            Limbs["arml__AV"].C1 = CFrame.new(1.5,-0.5,0)
            Limbs["armr__AV"] = Instance.new("Weld",JointsFolder)
            Limbs["armr__AV"].Part0 = Character.Torso
            Limbs["armr__AV"].Part1 = Instance.new("Part",Limbs["armr__AV"])
            Limbs["armr__AV"].Part1.Size = Vector3.new(1,1,1)
            Limbs["armr__AV"].Part1.Transparency = 1
            Limbs["armr__AV"].Part1.CanCollide = false
            Limbs["armr__AV"].C1 = CFrame.new(-1.5,-0.5,0)
        end
        if not ExcludeLegs then
            Limbs["legl__AV"] = Instance.new("Weld",JointsFolder)
            Limbs["legl__AV"].Part0 = Character.Torso
            Limbs["legl__AV"].Part1 = Instance.new("Part",Limbs["legl__AV"])
            Limbs["legl__AV"].Part1.Size = Vector3.new(1,1,1)
            Limbs["legl__AV"].Part1.Transparency = 1
            Limbs["legl__AV"].Part1.CanCollide = false
            Limbs["legl__AV"].C1 = CFrame.new(0.5,1,0)
            Limbs["legr__AV"] = Instance.new("Weld",JointsFolder)
            Limbs["legr__AV"].Part0 = Character.Torso
            Limbs["legr__AV"].Part1 = Instance.new("Part",Limbs["legr__AV"])
            Limbs["legr__AV"].Part1.Size = Vector3.new(1,1,1)
            Limbs["legr__AV"].Part1.Transparency = 1
            Limbs["legr__AV"].Part1.CanCollide = false
            Limbs["legr__AV"].C1 = CFrame.new(-0.5,1,0)
        end
        -- Roblox's Welds Removed
        local RobloxJoints = Instance.new("Folder")
        local RJ = Character:FindFirstChild("RootJoint",true)
        local LS = Character:FindFirstChild("Left Shoulder",true)
        local RS = Character:FindFirstChild("Right Shoulder",true)
        local LH = Character:FindFirstChild("Left Hip",true)
        local RH = Character:FindFirstChild("Right Hip",true)
        if not ExcludeArms or not ExcludeLegs then
            local Animator = Character:FindFirstChild("Animator",true)
            local AnimateLocalScript = Character:FindFirstChild("Animate",true)
            AnimateLocalScript.Disabled = true
            AnimateLocalScript.Parent = nil
            Animator.Parent = nil
        end
        setmetatable(Limbs,{["__RobloxJoint"]=RobloxJoints,["__JointsFolder"]=JointsFolder,["__AnimateLocalScript"]=AnimateLocalScript,["__Animator"]=Animator})
        if RJ and RJ:IsA("Motor6D") then
            RJ.Name = RJ.Parent.Name.."/"..RJ.Name
            RJ.Parent = RobloxJoints
        end
        if not ExcludeArms then
            if LS and LS:IsA("Motor6D") then
                LS.Name = LS.Parent.Name.."/"..LS.Name
                LS.Parent = RobloxJoints
            end
            if RS and RS:IsA("Motor6D") then
                RS.Name = RS.Parent.Name.."/"..RS.Name
                RS.Parent = RobloxJoints
            end
        end
        if not ExcludeLegs then
            if LH and LH:IsA("Motor6D") then
                LH.Name = LH.Parent.Name.."/"..LH.Name
                LH.Parent = RobloxJoints
            end
            if RH and RH:IsA("Motor6D") then
                RH.Name = RH.Parent.Name.."/"..RH.Name
                RH.Parent = RobloxJoints
            end
        end
        local RJ
        local LS
        local RS
        local LH
        local RH
        -- Main Welds
        Limbs["torso"] = Instance.new("Weld",JointsFolder)
        Limbs["torso"].Part0 = Character.HumanoidRootPart
        Limbs["torso"].Part1 = Character_Torso
        Limbs["head"] = Instance.new("Weld",JointsFolder)
        Limbs["head"].Part0 = Limbs["head__AV"].Part1
        Limbs["head"].Part1 = Character_Head
        Limbs["head"].C1 = CFrame.new(0,-0.5,0)
        if not ExcludeArms then
            Limbs["arml"] = Instance.new("Weld",JointsFolder)
            Limbs["arml"].Part0 = Limbs["arml__AV"].Part1
            Limbs["arml"].Part1 = Character_LeftArm
            Limbs["arml"].C1 = CFrame.new(0,0.5,0)
            Limbs["armr"] = Instance.new("Weld",JointsFolder)
            Limbs["armr"].Part0 = Limbs["armr__AV"].Part1
            Limbs["armr"].Part1 = Character_RightArm
            Limbs["armr"].C1 = CFrame.new(0,0.5,0)
        end
        if not ExcludeLegs then
            Limbs["legl"] = Instance.new("Weld",JointsFolder)
            Limbs["legl"].Part0 = Limbs["legl__AV"].Part1
            Limbs["legl"].Part1 = Character_LeftLeg
            Limbs["legl"].C1 = CFrame.new(0,1,0)
            Limbs["legr"] = Instance.new("Weld",JointsFolder)
            Limbs["legr"].Part0 = Limbs["legr__AV"].Part1
            Limbs["legr"].Part1 = Character_RightLeg
            Limbs["legr"].C1 = CFrame.new(0,1,0)
        end
        -- Rename & Removing
        for Index,Limb in next,Limbs do
            if Index:find("__AV") then
                Limb.Name = Limb.Part0.Name.."&&"..Limb.Part1.Name
                Limbs[Index] = nil
            else
                Limb.Name = Limb.Part0.Name.."&"..Limb.Part1.Name
            end
        end
        self["CharacterCache"][Character] = Limbs
        return self["Animate"]
    else
        error("Fail to rig!")  
    end
end
function AnimationLoader.FixRig(self,Character)
    if self["CharacterCache"][Character] then
        local JointInfo = getmetatable(self["CharacterCache"][Character])
        local RobloxJoints = JointInfo["__RobloxJoint"]
        local JointsFolder = JointInfo["__JointsFolder"]
        for _,RobloxJoint in next,RobloxJoints:GetChildren() do
            local ParentFullName = RobloxJoint.Name:match(".+/")
            local Parent = Character:FindFirstChild(ParentFullName:sub(1,#ParentFullName-1),true)
            RobloxJoint.Name = RobloxJoint.Name:sub(#ParentFullName+1)
            RobloxJoint.Parent = Parent
        end
        JointsFolder:Remove()
        if JointInfo["__Animator"] then
            JointInfo["__Animator"].Parent = Character:FindFirstChildOfClass("Humanoid")
        end
        if JointInfo["__AnimateLocalScript"] then
            JointInfo["__AnimateLocalScript"].Parent = Character
            JointInfo["__AnimateLocalScript"].Disabled = false
        end
        self["CharacterCache"][Character] = nil
    else
        error("Was never rigged")
    end
end
return AnimationLoader
