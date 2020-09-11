-- __D_FLOW inputs: subj_ID, subj_age, subj_height, subj_mass, subj_gender, subj_side, protocol_fromFile, enable_sounds, protocol_FW, protocol_FWIW, protocol_FWOW, protocol_IW, protocol_OW, protocol_randomize, protocol_limbCode, protocol_nReps, protocol_delayMin, protocol_delayMax, CoP_ml, CoP_ap, time, Input21_LAngVel, Input22_LnAcc, Input23_RAngVel, Input24_RnAcc, treadmillVel, treadmillPos, treadmillTargetVel
-- __D_FLOW outputs: gaitEvents_LTO, gaitEvents_LHS, gaitEvents_RTO, gaitEvents_RHS, stepData_width, stepData_length, stepData_num, stepData_limbCode, isEnablePert, isEnableRecord
--[[    -- Script description
        -- Version nr
--]]

-- To do:
-- * Clean up code, move blocks of code into own functions

----------
-- Include external scripts
require("general")
require("gaitDetectionGTXLib")
require("gtxLib")
require("objectPlacement")
require("protocol")
require("bestable")
require("uriLib")

----------
-- Initialization of all global variables
-- State machine variables
STATES		= {stop = 0, init = 1, base = 2, free = 3, pert = 4} -- Constant
STATES_keys = invertKeysValues(STATES)
state 		= state or {prev = STATES.init, next = STATES.init, steps = 0}
isEnablePert	= isEnablePert or false
isEnableRecord	= isEnableRecord or false 

-- Visualization
objData				= objData or {} -- Visualization objects
objActiveTarget	= objActiveTarget or {}

-- Sounds
objSound	= objSound or {}
enableSounds = numToBool(inputs.get("enable_sounds"))


-- Gait events and stepping parameters
gaitEvents 	= gaitEvents or {LTO = false , RTO = false, LHS = false, RHS = false} -- Gait events
isStance 	= isStance or {L = false, R = false, single = false} -- Stance state: left contact, right contact, single contact
stanceCoP 	= stanceCoP or {cumulativeMean:new(nil), cumulativeMean:new(nil)} -- Single support mean CoP: ML, AP
stanceData 	= stanceData or {} -- Table of single-support stance phase event times and CoP locations
stepData 	= stepData or {} -- Table of derived stepping parameters (length, width, time, limb)
isNewStep 	= isNewStep or false -- True at end of single-support phase
SSLStart_mean = SSLStart_mean or {0,0}
SSRStart_mean = SSRStart_mean or {0,0}
dist2target = dist2target or 999 -- Minimum distance from CoP to target


-- IMU algorithm
imuPars		= imuPars or {}
imuStates	= imuStates or {}

-- CoP algorithm
CoPAlgorithmStates 	= CoPAlgorithmStates or {}


-- Perturbation specification
subjData 			= subjData or {}
fileNameProtocol 	= "../Protocols/bestableProtocol.csv"
skipFirstRow 		= true -- Skip the first line (header row) of the file, if used
randomizeProtocol = true
delayMin 			= delayMin or 5 -- Number of steps to wait before triggering a perturbation
delayMax 			= delayMax or 10
pertNumber 			= pertNumber or 0 -- Perturbation counter
pertList 			= pertList or {} -- Table of perturbations
pertCurrent 		= pertCurrent or {} -- Current row of pertList, i.e. pertList[pertNumber]

-- Writing data
fileNameData 		= fileNameData or nil
fileObjData 		= fileObjData or nil
log_message			= log_message or "free"
log_targetError	= log_targetError or -1

-- Measured signals
--sigData 		= sigData or {cop = {}}
--sigData.cop[1] 	= inputs.get("CoP_ml")	-- CoP ML
--sigData.cop[2] 	= inputs.get("CoP_ap")	-- CoP AP
sigData			= sigData or {}
sigData.cop 	= {inputs.get("CoP_ml"), inputs.get("CoP_ap")}
sigData.tmPos 	= inputs.get("treadmillPos")
imuSigs 	= {
	t 			= inputs.get("time"), -- currentT
	angVelL 	= inputs.get(21), -- currAngVelL
	nAccL 	= inputs.get(22), -- currNAccL
	angVelR 	= inputs.get(23), -- currAngVelR
	nAccR 	= inputs.get(24)  -- currNAccR
}

----------
-- Function definitions
-- (See imported packages)

----------
-- Handle external actions
-- if hasaction("Stop") then
-- 	state = STATES.stop
-- end
if hasaction("Custom 1") then -- Toggle switch enable perturbations
	isEnablePert  = not isEnablePert
	print("isEnablePert:",isEnablePert)
	if isEnablePert then	
		playSoundPerturbationsEnabled()
	end
end
if hasaction("Custom 2") then -- Toggle switch enable recording
	isEnableRecord  = not isEnableRecord
	print("isEnableRecord:",isEnableRecord)
end
if hasaction("Custom 3") then -- Stop: Close recording file first.
	state.prev 	= STATES.stop
end

----------
-- Program execution
-- State machine
if state.prev == STATES.init then
	print("State:",STATES_keys[state.prev])

	-- Object visualization
	objData = createObjects()
	hideTarget(objData.targetL)
	hideTarget(objData.targetR)

	-- IMU gait event detection algorithm
	--	imuPars, imuStates = initIMU()

	-- COP gait event detection algorithm
	CoPAlgorithmStates = initCoPAlgorithm()

	-- Sounds
	objSound = createSounds()

	-- Load the user parameters
	subjData = {
		ID					= inputs.get("subj_ID"),
		age				= inputs.get("subj_age"),
		height			= inputs.get("subj_height")/100,
		mass				= inputs.get("subj_mass"),
		gender			= inputs.get("subj_gender"),
		affectedSide	= inputs.get("subj_side"),
		treadmillSpeed = inputs.get("treadmillTargetVel")
	}
	print("Treadmill velocity: ",subjData.treadmillSpeed," m/s")

	local scaleFactor = 0.530*subjData.height -- Leg length (Winter2009, "Biomechanics and motor control of human movement", pp 83)
	scaleFactor	= scaleFactor*0.3 -- Perturbation amplitude = 0.3 m/1 m leg length

	-- Construct a table 'pertList' from the protocol specifications. 
	-- Each row represent the perturbation number (in sequence) and contains the following fields: name, stepWidth, stepLength, limb, delay
	local readProtocolFromFile = numToBool(inputs.get("protocol_fromFile"))
	if readProtocolFromFile then
		-- Read from file
		print("Protocol from file...")
		pertList = protocol.read(fileNameProtocol,skipFirstRow)
	else
		-- Read instead from Runtime Console parameters
		print("Protocol from Runtime Console...")
		local pertDir = {
			fw 	= numToBool(inputs.get("protocol_FW")),
			fwiw 	= numToBool(inputs.get("protocol_FWIW")),
			fwow 	= numToBool(inputs.get("protocol_FWOW")),
			iw 	= numToBool(inputs.get("protocol_IW")),
			ow 	= numToBool(inputs.get("protocol_OW"))
		}
		local randomizeProtocol = numToBool(inputs.get("protocol_randomize"))
		local pertLimbCode = inputs.get("protocol_limbCode")
		local nReps = inputs.get("protocol_nReps")
		delayMin 	= inputs.get("protocol_delayMin")
		delayMax 	= inputs.get("protocol_delayMax")
		
		pertList = protocol.manual(pertDir,pertLimbCode,nReps)

		end
	-- Scale and randomize the stepping perturbations
	protocol.scale(pertList,scaleFactor)
	math.randomseed(os.time()); math.random(); math.random(); math.random()
	protocol.randomizeOrder(pertList)
	protocol.randomizeDelay(pertList,delayMin,delayMax)
	print("... loaded.")
	-- protocol.print(pertList)

	-- Generate the data logging filename as a timestamp
	date = os.date("*t")
	fileNameData = string.format("D:/CAREN Resources/Projects/BeStable platform ver2/Data/%04d%02d%02d_%02d%02d%02d.csv",date.year,date.month,date.day, date.hour,date.min,date.sec)
	fileObjData = assert(io.open(fileNameData,"w"))
	print("Logging to: "..fileNameData)
	fileObjData:write("sep=,\n") -- Needed for Excel to automatically understand the CSV format
	-- fileObjData:write(string.format("")) -- Print subject data here
	bestable.writeLine(fileObjData,{"ID","age","height","mass","gender","affectedSide","treadmillSpeed","perturbationAmplitude"})
	bestable.writeLine(fileObjData,{subjData.ID,subjData.age,subjData.height,subjData.mass,subjData.gender,subjData.affectedSide,subjData.treadmillSpeed,scaleFactor})
	bestable.writeLine(fileObjData,{"stepNumber","timeStamp","limbInitial","limbFinal","stepWidth","stepLength","stepTime","targetError","message"})
	numCharsHeader 	= fileObjData:seek("end")

	state.next = STATES.base

elseif state.prev == STATES.base then
	-- Compute moving average of CoP at start of single-support phase of both legs for completed step
	if (#stanceData>0) and isNewStep then
		if stanceData[#stanceData].limb == "L" then
			SSLStart_mean = {moving_average_LCoPxStart_function(stanceData[#stanceData].CoPStart[1]),moving_average_LCoPzStart_function(stanceData[#stanceData].CoPStart[2])}
   		else
			SSRStart_mean = {moving_average_RCoPxStart_function(stanceData[#stanceData].CoPStart[1]),moving_average_RCoPzStart_function(stanceData[#stanceData].CoPStart[2])}
		end
	end

	-- Stay in the current state until the "Enable Perturbations" button is pressed.
	if isEnablePert then
		pertNumber				= pertNumber + 1
		pertCurrent				= pertList[pertNumber]
		targetPos				= protocol.targetPos(pertCurrent)
		objActiveTarget		= selectTarget(objData,pertCurrent.limb)
		protocol.printLine(pertCurrent)

		state.next 		= STATES.free
	else
		-- Otherwise, stay in the current state
		state.next 		= STATES.base
	end

elseif state.prev == STATES.free then
	-- Do nothing. Just measure gait parameters until a perturbation is applied.

--	print(isEnablePert,pertCurrent,state.steps,pertCurrent.delay)

	-- Apply the next perturbation if all of the following are true:
	--	(1) perturbations are enabled by the operator
	--	(2) a perturbation is available in the pertList
	-- (3) the specified number of steps has been reached
	if isEnablePert and next(pertCurrent) and (state.steps > pertCurrent.delay) then
		state.next = STATES.pert
	else
		-- Otherwise, stay in the current state
		state.next = STATES.free
	end

elseif state.prev == STATES.pert then
	-- Apply the perturbation

	-- Perturbation is shown at the end of the single-support phase of the perturbed limb one gait cycle before stepping, and removed one cycle later.
	-- Single-support ends for the left leg at RHS, or for the right leg at LHS.
	local isEndSingleSupport = next(pertCurrent) and ((pertCurrent.limb == 'L') and gaitEvents.RHS) or ((pertCurrent.limb == 'R') and gaitEvents.LHS)
	
	dist2target = math.min(dist2target, math.sqrt((targetPos[1]-sigData.cop[1])^2+(targetPos[2]-sigData.cop[2])^2))

	-- Show or hide the perturbation when 
	if isEndSingleSupport then
		if not isTargetVisible(objActiveTarget) then	
			-- Target is hidden and should now be shown
			placeTarget(objActiveTarget, targetPos)
			showTarget(objActiveTarget)
			print(string.format("TargetPos: [%0.2f, %0.2f]",targetPos[1],targetPos[2]))
			print("Target"..pertCurrent.limb.." displayed.")
			playSound(pertCurrent.limb)
			log_message = string.format("Pert: %s (%s)",pertCurrent.name,pertCurrent.limb)
			log_targetError = -1

			dist2target = math.sqrt((targetPos[1]-sigData.cop[1])^2+(targetPos[2]-sigData.cop[2])^2)

			-- Wait in this state until the target should be hidden
			state.next 	= STATES.pert
		else
			-- Perturbation is finished and target should be hidden
			hideTarget(objActiveTarget)
			print("Target"..pertCurrent.limb.." hidden.")
			print(string.format("Error: %0.2f m",dist2target))
			playSoundTargetHit()
			
		--	log_message = string.format("Pert: %s (%s)",pertCurrent.name,pertCurrent.limb)
			log_targetError = dist2target
			--stepData[#stepData].message		= string.format("Pert: %s (%s)",pertCurrent.name,pertCurrent.limb) -- DEBUG ME
			--stepData[#stepData].targetError	= dist2target
			--print(">>> DEBUG#259: ",#stepData,stepData[#stepData].message,stepData[#stepData].targetError)

			-- Load and place the next perturbation
			if pertNumber < #pertList then
				pertNumber	= pertNumber + 1
				pertCurrent	= pertList[pertNumber]
				targetPos	= protocol.targetPos(pertCurrent)
				objActiveTarget	= selectTarget(objData,pertCurrent.limb)
				print(pertNumber); protocol.printLine(pertCurrent)
				
--				print(">>> DEBUG#266: ",#stepData,string.format("Pert: %s (%s)",pertCurrent.name,pertCurrent.limb))
--				stepData[#stepData].message		= string.format("Pert: %s (%s)",pertCurrent.name,pertCurrent.limb) -- DEBUG ME
--				stepData[#stepData].targetError	= dist2target
--				print(">>> DEBUG#269: ",#stepData,stepData[#stepData].message)
			else
				-- No more perturbations are available
				pertCurrent 		= {}
				objActiveTarget	= nil
				print("===== Protocol finished =====")
				playSoundProtocolFinished()
			end

			state.next = STATES.free
		end
	else
		-- Wait in this state until one of the above events occur
		state.next 	= STATES.pert
	end

else -- state.prev == STATES.stop
	
	if fileObjData then
		local numCharsWritten     = fileObjData:seek("end")

		-- Close logging file
		fileObjData:close()
		fileObjData = nil
		print("File closed.")

		-- Delete the logging file if nothing was recorded
		if numCharsWritten <= numCharsHeader then
			os.remove(fileNameData)
			print("Empty file removed: "..fileNameData)
		end
	end
	-- Broadcast STOP to all scripts
	broadcast("Stop","Text","Execution stopped")
	stop() --stop this script
	--broadcast("Reset","Text","Execution reset")
	
	-- Stay in this state
	state.next = STATES.stop

end






-- Below is not in state machine: Executes in all states.

-- Update gait events
--gaitEvents, imuStates = updateImuGaitEvent(imuPars,imuStates,imuSigs)
gaitEvents, CoPAlgorithmStates = updateCoPAlgorithmGaitEvent(CoPAlgorithmStates)

-- Compute stepping parameters
-- To do: Make this block into a single function, e.g. stepData,stanceData = extractGaitPars(stanceData,isStance,sigData)
isNewStep = false
if isNewGaitEvent(gaitEvents) then
	local isSingleStance_prev = isStance.single
    isStance = bestable.checkStance(gaitEvents,isStance)

    if isStance.single and not isSingleStance_prev then
        -- Start of single support
        stanceData[#stanceData+1] = {
            limb 		= ((isStance.L and 'L') or 'R'),
            timeStart 	= frametime(),
            --CoPStart 	= sigData.cop,
			CoPStart 	= ((isStance.L and {CoPAlgorithmStates.right_foot_off_x,CoPAlgorithmStates.right_foot_off_z}) or {CoPAlgorithmStates.left_foot_off_x,CoPAlgorithmStates.left_foot_off_z}),
			tmPosStart	= sigData.tmPos
		}
		-- Reset moving average filter for CoP
        stanceCoP[1]:reset(); stanceCoP[2]:reset()
    elseif not isStance.single and isSingleStance_prev and (#stanceData>0) then
        -- End of single support
        stanceData[#stanceData].timeStop 	= frametime()
        stanceData[#stanceData].CoPStop 	= sigData.cop
        stanceData[#stanceData].CoPMean 	= {stanceCoP[1].mean,stanceCoP[2].mean}
        stanceData[#stanceData].tmPosStop = sigData.tmPos

		-- Compute stepping parameters at the end of the stance phase
		if (#stanceData > 1) then
			-- Step width sign: positive if moving towards final limb. Lateral CoP is positive towards the right, so flip the sign if left leg.
			-- Step length sign: positive if foot placed forward. AP CoP is positive towards the posterior, so multiply by -1.
			local signWidth 	= (((stanceData[#stanceData].limb == 'R') and 1) or -1)
			local tmPosDelta 	= stanceData[#stanceData].tmPosStart - stanceData[#stanceData-1].tmPosStart
			stepData[#stepData+1] = {
				stepTime 		= stanceData[#stanceData].timeStart - stanceData[#stanceData-1].timeStart,
				stepWidth 		= signWidth*( stanceData[#stanceData].CoPMean[1] - stanceData[#stanceData-1].CoPMean[1] ),
			--	stepWidth 		= signWidth*( stanceData[#stanceData].CoPStart[1] - stanceData[#stanceData-1].CoPStart[1] ),
				stepLength 		= -( stanceData[#stanceData].CoPStart[2] - stanceData[#stanceData-1].CoPStart[2] ) + tmPosDelta,
				limbInitial 	= stanceData[#stanceData-1].limb,
				limbFinal 		= stanceData[#stanceData].limb
			}
--			print("    MESSAGE#366: ",#stepData,stepData[#stepData].message)
--			print("DEBUG#367 computation:",stepData[#stepData].stepWidth)
--			print(stepData[#stepData].limbInitial.."-"..stepData[#stepData].limbFinal, "stepWidth: "..tostring(stepData[#stepData].stepWidth),"stepLength: "..tostring(stepData[#stepData].stepLength))
		end
		
		isNewStep 	= true
    end
end
stanceCoP[1]:addSample(sigData.cop[1]); stanceCoP[2]:addSample(sigData.cop[2])


-- Visualization of CoP and gait events
updateObjects(objData,sigData.cop,gaitEvents)
updateObjMean(objData,SSLStart_mean,SSRStart_mean)

-- Set outputs
outputs.set("gaitEvents_LTO",boolToNum(gaitEvents.LTO))
outputs.set("gaitEvents_LHS",boolToNum(gaitEvents.LHS))
outputs.set("gaitEvents_RTO",boolToNum(gaitEvents.RTO))
outputs.set("gaitEvents_RHS",boolToNum(gaitEvents.RHS))
outputs.set("stepData_num",#stepData)
if gaitEvents.LHS or gaitEvents.RHS then
	outputs.set("stepData_limbCode", ((gaitEvents.LHS and 1) or 2))
end
if #stepData > 0 then
	--outputs.set("stepData_limbCode", (((stepData[#stepData].limbFinal == 'L') and 1) or 2) )
	outputs.set("stepData_width",stepData[#stepData].stepWidth)
	outputs.set("stepData_length",stepData[#stepData].stepLength)
--	outputs.set("stepData_width",sigData.cop[1])
--	outputs.set("stepData_length",sigData.cop[2])
else
	outputs.set("stepData_limbCode",0)
	outputs.set("stepData_width",0)
	outputs.set("stepData_length",0)
end
outputs.set("isEnablePert",boolToNum(isEnablePert))
outputs.set("isEnableRecord",boolToNum(isEnableRecord))

-- Update the state machine & write data to file
if isNewStep then
	-- The number of steps in the current state
	state.steps = state.steps + 1
	
	if #stepData > 0 then
		-- Select signals for logging
		--print(">> DEBUG#411 writing:",#stepData,stepData[#stepData].stepWidth,log_targetError,log_message)
		local dataLine = {
			#stepData, 
			imuSigs.t,
			stepData[#stepData].limbInitial, 
			stepData[#stepData].limbFinal, 
			stepData[#stepData].stepWidth, 
			stepData[#stepData].stepLength, 
			stepData[#stepData].stepTime,
			log_targetError,
			log_message
		}
		-- Write data to file
		bestable.writeLine(fileObjData,dataLine)
		log_targetError = -1
		if string.sub(log_message,1,4) == "Pert" then
			log_message = "action"
		else
			log_message = "free"
		end
	end
end
-- Remove unused data to save program memory: DEBUG ME
--numStepsToKeep 	= 10
--if #stanceData > numStepsToKeep then
--	stanceData[#stanceData-numStepsToKeep] 	= nil
--end
--if #stepData > numStepsToKeep then
--	stepData[#stepData-numStepsToKeep] 		= nil
--end

-- If the state has changed, print the new state
if state.next ~= state.prev then
	state.steps = 0
	print("State:",STATES_keys[state.next])
end
state.prev = state.next

