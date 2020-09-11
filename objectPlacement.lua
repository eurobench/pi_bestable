-- Coordinate mappings from visualization units to real-world units
function drs2meters(x,z)
	local x = x*0.135 --x*x_correction
	local z = z*0.165 --z*z_correction
	return x,z
end
-- Coordinate mappings from real-world units to visualization units
function meters2drs(x,z)
	local x = x/0.135
	local z = z/0.165
	return x,z
end

-- Target functions
-- function createTarget()
-- 	local objData 	= {}
-- 	return objData
-- end
function selectTarget(objData,limb)
	return ((limb == 'L') and objData.targetL) or objData.targetR
end
function placeTarget(objTarget,position)
	-- Place the target. Note: position is a table of 2 elements (x,z)
	local posX, posZ 	= meters2drs(position[1],position[2])
	objTarget:setposition(posX,-0.02,posZ)
end
function isTargetVisible(objTarget)
	return objTarget:getvisible()
end
function showTarget(objTarget)
	objTarget:show()
end
function hideTarget(objTarget)
	objTarget:hide()
end

-- General object creation
function createObjects(posX,posZ)
	objData = {}
	
	-- CoP position
	objData.cop = object.create("Cylinder","Yellow")
	objData.cop:setposition(0,0,0)
	objData.cop:setrotation(0,0,90)
	objData.cop:setscaling(0.001,0.3,0.3)
		
	-- Gait events
	objData.TOL = objects.get("TOL")
	objData.TOL:setscaling(0.2,0.02,0.2)
	objData.TOL:setposition(2,0,-2)
	
	objData.TOR = objects.get("TOR")
	objData.TOR:setscaling(0.2,0.02,0.2)
	objData.TOR:setposition(-2,0,-2)
	
	objData.HSL = objects.get("HSL")
	objData.HSL:setscaling(0.2,0.02,0.2)
	objData.HSL:setposition(2,0,2)
	
	objData.HSR = objects.get("HSR")
	objData.HSR:setscaling(0.2,0.02,0.2)
	objData.HSR:setposition(-2,0,2)
	
	objData.meanL = object.create("Cylinder","Red")
	objData.meanL:setposition(0,0,0)
	objData.meanL:setrotation(0,0,90)
	objData.meanL:setscaling(0.001,0.3,0.3)

	objData.meanR = object.create("Cylinder","Blue")
	objData.meanR:setposition(0,0,0)
	objData.meanR:setrotation(0,0,90)
	objData.meanR:setscaling(0.001,0.3,0.3)
	
	-- Stepping targets
	-- Left foot target
	objData.targetL = objects.get("foot_left")
	objData.targetL:setscaling(1,0.02,2)
	objData.targetL:setposition(-1,-0.02,-3)

	-- Right foot target
	objData.targetR = objects.get("foot_right")
	objData.targetR:setscaling(1,0.02,2)
	objData.targetR:setposition(1,-0.02,-3)

	return objData
end

-- Placement of CoP objects
function updateObjects(objData,position,gaitEvents)
	local cop_ml, cop_ap = meters2drs(position[1],position[2])
	local left_foot_off_x, left_foot_off_z = meters2drs(CoPAlgorithmStates.left_foot_off_x,CoPAlgorithmStates.left_foot_off_z)
	local right_foot_off_x, right_foot_off_z = meters2drs(CoPAlgorithmStates.right_foot_off_x,CoPAlgorithmStates.right_foot_off_z)
	local left_heel_strike_x, left_heel_strike_z = meters2drs(CoPAlgorithmStates.left_heel_strike_x,CoPAlgorithmStates.left_heel_strike_z)
	local right_heel_strike_x, right_heel_strike_z = meters2drs(CoPAlgorithmStates.right_heel_strike_x,CoPAlgorithmStates.right_heel_strike_z)
	
	--	curr_cop_ml_meters,curr_cop_ml_meters = drs2meters(curr_cop_ml,curr_cop_ap)
	--	cop_ml,cop_ap = meters2drs(curr_cop_ml_meters,curr_cop_ap_meters)

	-- CoP object
	objData.cop:setposition(cop_ml,0,cop_ap)

	-- Gait event objects
	if gaitEvents.LTO then
		objData.TOL:setposition(left_foot_off_x,0,left_foot_off_z)
		--objData.TOL:setposition(cop_ml,0,cop_ap)
		--objData.targetR:setposition(cop_ml,-0.02,cop_ap)
	end
	if gaitEvents.LHS then
		objData.HSL:setposition(left_heel_strike_x,0,left_heel_strike_z)
		--objData.HSL:setposition(cop_ml,0,cop_ap)
	end
	if gaitEvents.RTO then
		objData.TOR:setposition(right_foot_off_x,0,right_foot_off_z)
		--objData.TOR:setposition(cop_ml,0,cop_ap)
		--objData.targetL:setposition(cop_ml,-0.02,cop_ap)
	end
	if gaitEvents.RHS then
		objData.HSR:setposition(right_heel_strike_x,0,right_heel_strike_z)
		--objData.HSR:setposition(cop_ml,0,cop_ap)
	end
end

function updateObjMean(objData,SSLStart_mean,SSRStart_mean)
	local cop_ml, cop_ap = meters2drs(SSLStart_mean[1],SSLStart_mean[2])
	objData.meanL:setposition(cop_ml,0,cop_ap)
	
	local cop_ml, cop_ap = meters2drs(SSRStart_mean[1],SSRStart_mean[2])
	objData.meanR:setposition(cop_ml,0,cop_ap)
end

function createSounds()
	objSound = {}

	objSound.L					=	sound.create("D:/CAREN Resources/Projects/BeStable platform ver2/Sounds/left.wav")
	objSound.R					=	sound.create("D:/CAREN Resources/Projects/BeStable platform ver2/Sounds/right.wav")
	objSound.TargetHit			=	sound.create("D:/CAREN Resources/Projects/BeStable platform ver2/Sounds/targetHit.wav")
	objSound.TargetMissed		=	sound.create("D:/CAREN Resources/Projects/BeStable platform ver2/Sounds/targetMissed.wav")
	objSound.ProtocolFinished	=	sound.create("D:/CAREN Resources/Projects/BeStable platform ver2/Sounds/protocolFinished.wav")
	objSound.PerturbationsEnabled	=	sound.create("D:/CAREN Resources/Projects/BeStable platform ver2/Sounds/perturbationsEnabled.wav")

	return objSound
end

function playSound(limb)
	if enableSounds then
		if limb == 'L' then
			sound.play(objSound.L)
		else
			sound.play(objSound.R)
		end
	end
end

function playSoundTargetHit()
	if enableSounds then
		if dist2target < 0.1 then
			sound.play(objSound.TargetHit)
			log_message = "target hit"
		else
			sound.play(objSound.TargetMissed)
			log_message = "target missed"
		end
	end
end

function playSoundProtocolFinished()
	if enableSounds then
		sound.play(objSound.ProtocolFinished)
	end
end

function playSoundPerturbationsEnabled()
	if enableSounds then
		sound.play(objSound.PerturbationsEnabled)
	end
end
