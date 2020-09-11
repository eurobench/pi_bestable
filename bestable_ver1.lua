-- __D_FLOW inputs: Input1, Input2, Input3, Input4, Input5, Input6, Input7, Input8, Input9, Input10, Input11, Input12, Input13, Input14, Input15, Input16, Input17, Input18, Input19, Input20, Input21, Input22
-- __D_FLOW outputs: Output1, Output2, Output3, Output4, Output5, Output6, Output7, Output8, Output9, Output10, Output11, Output12, Output13, Output14, Output15, Output16, Output17, Output18, Output19, Output20, Output21, Output22, Output23, Output24, Output25, Output26, Output27, Output28, Output29
--[[ -- Script description
-- Version nr
--TODO: Add two more blocks? (L3 and R3)?
--TODO: from user, take input as to which gait event is to be based for giving perturbation (TO or HS?)
--TODO: user input: Trigger perturbation in the next block  or next next block (UpdatePBPos() and see figure in notes)
-- Unless otherwise explicitly stated, all units are in SI units
--]]

-- -------------------------------Initialization of all (not local) variables-------------------------------

ini = ini or 0


require("gaitDetectionGTXLib")
setmetatable(struct0_T, {__call =
  function(self, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19, arg20, arg21, arg22, arg23, arg24, arg25, arg26, arg27, arg28, arg29, arg30, arg31, arg32, arg33)
    local nn = self.new(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19, arg20, arg21, arg22, arg23, arg24, arg25, arg26, arg27, arg28, arg29, arg30, arg31, arg32, arg33)
    return nn
  end
  }
)
setmetatable(CircularBuffer, {__call =
  function(self, arg1)
    local t = self.new(arg1)
    return t
  end
  }
)

if ini==0 then

	TM_Length=inputs.get(15)	--Tread mill length in meters
	normalSL=inputs.get(16)	--Normal step length
	loopLength=4*normalSL
	LNormPos=inputs.get(17)	--Normal position of left foot on treadmill (along x-axis )
	RNormPos=inputs.get(18)	--Normal position of left foot on treadmill (along z-axis )
	CheckLPInRT = inputs.get(19) --Check leg placement in real time?
	PerturbBlockNumber=inputs.get(20)
	
	
	GE={}			--Gait event
	GE.LTO=false	--Note: Although single force plate system, motek's gait algorithm can distinguish between left and right leg events from the butterfly profile 
	GE.RTO=false
	GE.LHS=false
	GE.RHS=false
	
	FP={}
	FP.COP={0,0,0}	--Center Of Pressure
	FP.For={0,0,0}	--Force
	FP.Mom={0,0,0}	--Moment
	
	PB={}				--Projection blocks
	PB.Obj={}			--Projection blocks' object handles
	PB.Obj.L1 = objects.get("Left_Rect1")
	PB.Obj.R1 = objects.get("Right_Rect1")
	PB.Obj.L2 = objects.get("Left_Rect2")
	PB.Obj.R2 = objects.get("Right_Rect2")
	-- PB.Obj.L1 = objects.get("L_Rectangle")
	-- PB.Obj.R1 = objects.get("R_Rectangle")
	-- PB.Obj.L2 = objects.get("L_Rectangle2")
	-- PB.Obj.R2 = objects.get("R_Rectangle2")

	PB.Pos={}			--Projection blocks' position cordinates
	PB.Pos.L1={LNormPos,0,0}
	PB.Pos.R1={RNormPos,0,0}
	PB.Pos.L2={LNormPos,0,0}
	PB.Pos.R2={RNormPos,0,0}

	PB.Pos.dL1={0,0,0}	--delta x,y,x by which the foot is to be moved (to be input by user based on valuator module
	PB.Pos.dR1={0,0,0}
	PB.Pos.dL2={0,0,0}
	PB.Pos.dR2={0,0,0}
	
	PB.Stat={}
	PB.Stat.L1=false	--status to be true when there is a gait event detected and the placement of the step is close to the corresponding projection block
	PB.Stat.R1=false
	PB.Stat.L2=false
	PB.Stat.R2=false
	
	xTol=0.2	--what tolerance is acceptable between COP and PB cordinates to accept that the foot was indeed placed "close enough"
	zTol=0.4
	
	--parameters for gaitDetector2
	nAccStatR = 10
	nAccStatL = 10
	PSwMPH = 50
	PSwMPD = 1.5
	PSwMPP = 75
	SwMPH = 50
	SwMPD = 1.5
	SwMPP = 100
	bufferDuration = 2
	arraySize = math.floor(bufferDuration / framedelta())
	--buffers for sensor measurements
	t = CircularBuffer(arraySize)
	nAccL = CircularBuffer(arraySize)
	angVelL = CircularBuffer(arraySize)
	nAccR = CircularBuffer(arraySize)
	angVelR = CircularBuffer(arraySize)
	-- to compare with last call of gaitDetector2
	ISTGFL = struct0_T()
	ISTGFR = struct0_T()

	ISTGFL:set_IndexPSw(1)
	ISTGFL:set_IndexSw(1)
	ISTGFL:set_IndexMSt(1)
	ISTGFL:set_IndexHS(1)
	ISTGFL:set_IndexTO(1)

	ISTGFR:set_IndexPSw(1)
	ISTGFR:set_IndexSw(1)
	ISTGFR:set_IndexMSt(1)
	ISTGFR:set_IndexHS(1)
	ISTGFR:set_IndexTO(1)

	currLTO = 0
	prevLTO = 0
	currLHS = 0
	prevLHS = 0

	currRTO = 0
	prevRTO = 0
	currRHS = 0
	prevRHS = 0

	currT = 0
	currNAccL = 0
	currAngVelL = 0
	currNAccR = 0
	currAngVelR = 0

	ini=1
	print("once")
end









-- -----------------------------------Function definitions----------------------------------

function CalculatePB_NormalPos_withTMDistInput()
	TM_Dist = inputs.get(1)/100	--The total distance covered by treadmill since the activity started (input recieved from treadmill in centimeters, converted to meters)
	
	PB.Pos.L1[1]=LNormPos
	PB.Pos.R1[1]=RNormPos
	PB.Pos.L2[1]=LNormPos
	PB.Pos.R2[1]=RNormPos
	
	PB.Pos.L1[3] = EvalNormalPosPerPB(TM_Dist,  0)
	PB.Pos.R1[3] = EvalNormalPosPerPB(TM_Dist,0.25*loopLength)	--TM_Length
	PB.Pos.L2[3] = EvalNormalPosPerPB(TM_Dist,0.50*loopLength)
	PB.Pos.R2[3] = EvalNormalPosPerPB(TM_Dist,0.75*loopLength)
end

function EvalNormalPosPerPB(PosOld, constDelZ)
	PosOld=PosOld*100		--convert units to centimeters temporarily for modulus operation
	constDelZ=constDelZ*100	--convert units to centimeters temporarily for modulus operation
	TM_LengthCM=TM_Length*100
	loopLengthCM=loopLength*100
	
	PosNew=((PosOld+ constDelZ)%loopLengthCM)-TM_LengthCM	--To be updated at motek: Treadmill length is assumed to be 200
	-- PosNew=((PosOld+ constDelZ)%TM_LengthCM)-TM_LengthCM	--To be updated at motek: Treadmill length is assumed to be 200
	PosNew=PosNew/100										--Divide by 100 to convert the unit back from centemeter to meter 
	
	return PosNew
end

function CalculatePB_DeltaPos_BasedOnUserInput()

	minPos=math.min(PB.Pos.L1[3],PB.Pos.R1[3],PB.Pos.L2[3],PB.Pos.R2[3])
		if hasaction("Action") and PB.Pos.L1[3]==minPos then	--Note:hasaction() returns true only in that one iteration during which the user presses the action key
			PB.Pos.dL1[1] = inputs.get(2)	--Take input delta x position from user (left valuator module)
			PB.Pos.dL1[3] = inputs.get(3)	--Take input delta z position from user (left valuator module)
			--print(PB.Pos.dL1[1])
		elseif  PB.Pos.L1[3]>-0.01 then
			PB.Pos.dL1[1] = 0
			PB.Pos.dL1[3] = 0	--Reset stat for next treadmill loop
		end

		if hasaction("Action") and PB.Pos.R1[3]==minPos then
			PB.Pos.dR1[1] = inputs.get(4)	--Take input delta x position from user (right valuator module)
			PB.Pos.dR1[3] = inputs.get(5)	--Take input delta z position from user (right valuator module)
		elseif  PB.Pos.R1[3]>-0.01 then
			PB.Pos.dR1[1] = 0
			PB.Pos.dR1[3] = 0
		end

		if hasaction("Action") and PB.Pos.L2[3]==minPos then
			PB.Pos.dL2[1] = inputs.get(2)	--Take input delta x position from user (valuator module)
			PB.Pos.dL2[3] = inputs.get(3)	--Take input delta z position from user (valuator module)
		elseif  PB.Pos.L2[3]>-0.01 then
			PB.Pos.dL2[1] = 0
			PB.Pos.dL2[3] = 0
		end

		if hasaction("Action") and PB.Pos.R2[3]==minPos then
			PB.Pos.dR2[1] = inputs.get(4)	--Take input delta x position from user (valuator module)
			PB.Pos.dR2[3] = inputs.get(5)	--Take input delta z position from user (valuator module)
		elseif  PB.Pos.R2[3]>-0.01 then
			PB.Pos.dR2[1] = 0
			PB.Pos.dR2[3] = 0
			
		end

end

function IMUGaitDetectionMonitor()
	currentT = inputs.get(12) 	--Time
	currAngVelL = inputs.get(6)
	currNAccL   = inputs.get(7)
	currAngVelR = inputs.get(8)
	currNAccR   = inputs.get(9)


	t:put(currentT)
	angVelL:put(currAngVelL)
	nAccL:put(currNAccL)
	angVelR:put(currAngVelR)
	nAccR:put(currNAccR)

	gaitDetector2(arraySize,t, nAccL, angVelL, ISTGFL, nAccStatL, PSwMPH, PSwMPD, PSwMPP, SwMPH, SwMPD, SwMPP)
	gaitDetector2(arraySize,t, nAccR, angVelR, ISTGFR, nAccStatR, PSwMPH, PSwMPD, PSwMPP, SwMPH, SwMPD, SwMPP)
	
	currLTO = ISTGFL:LocTO() 
	currLHS = ISTGFL:LocHS() 

	currRTO = ISTGFR:LocTO() 
	currRHS = ISTGFR:LocHS() 
	
	if currLTO ~= prevLTO then 				--Comes here when LTO is detected
		GE.LTO = true
		--outputs.set(3,ISTGFL:LocTO())
		--print("LTO")
	elseif currLHS ~= prevLHS then			--Comes here when LHS is detected
		GE.LHS = true
		--outputs.set(4,ISTGFL:LocHS())
		--print("LHS")
	elseif currRTO ~= prevRTO then 				--Comes here when LTO is detected
		GE.RTO = true
		--outputs.set(5,ISTGFR:LocTO())
		--print("RTO")
	elseif currRHS ~= prevRHS then			--Comes here when LHS is detected
		GE.RHS = true
		--outputs.set(6,ISTGFR:LocHS())
		 --print("RHS")
	else
		GE.LTO=false	--Note: Although single force plate system, motek's gait algorithm can distinguish between left and right leg events from the butterfly profile 
		GE.RTO=false
		GE.LHS=false
		GE.RHS=false
	end
	prevLTO = currLTO
	prevLHS = currLHS
	prevRTO = currRTO
	prevRHS = currRHS

end


function DidUserApproachPerturbation()

if PerturbBlockNumber==2 then
	if GE.RTO == true then
		
			PB.Stat.L1=false
			PB.Stat.L2=false

	end
	
	if GE.LTO == true then
		
			PB.Stat.R1=false
			PB.Stat.R2=false

	end
elseif PerturbBlockNumber==1 then
	if GE.LTO == true then
		
			PB.Stat.L1=false
			PB.Stat.L2=false

	end
	
	if GE.RTO == true then
		
			PB.Stat.R1=false
			PB.Stat.R2=false

	end		
		

end
end



function DidUserPlaceLegCloseToPB()
	-- compare COP measurements with cordinates of projection blocks to see if any of them that reported a gait event in the current iteration is physically close enough to the COP cordinates

	if CheckLPInRT==0 then
		HSorTO_Left =inputs.get(11)
		HSorTO_Right=inputs.get(14)
		
		--after a gait event is detected, let's say LTO, we want to identify whether this event happened close to L1 or L2 so that the status of that PB can be updated
		if HSorTO_Left==0 then
			if GE.LTO == true then
				temp1=math.abs(PB.Pos.R1[3]-FP.COP[3])
				temp2=math.abs(PB.Pos.R2[3]-FP.COP[3])
				closerPBtoGaitEvent=math.min(temp1,temp2)
				if temp1==closerPBtoGaitEvent then
					PB.Stat.L2=true
					startTimeL2=inputs.get(12)
				elseif temp2==closerPBtoGaitEvent then
					PB.Stat.L1=true
					startTimeL1=inputs.get(12)
				end
			end
			if GE.RTO == true then
				temp1=math.abs(PB.Pos.L1[3]-FP.COP[3])
				temp2=math.abs(PB.Pos.L2[3]-FP.COP[3])
				closerPBtoGaitEvent=math.min(temp1,temp2)
				if temp1==closerPBtoGaitEvent then
					PB.Stat.R1=true
					startTimeR1=inputs.get(12)
				elseif temp2==closerPBtoGaitEvent then
					PB.Stat.R2=true
					startTimeR2=inputs.get(12)
				end
			end

		elseif HSorTO_Left==1 then
			if GE.LHS == true then
				temp1=math.abs(PB.Pos.L1[3]-FP.COP[3])
				temp2=math.abs(PB.Pos.L2[3]-FP.COP[3])
				closerPBtoGaitEvent=math.min(temp1,temp2)
				if temp1==closerPBtoGaitEvent then
					PB.Stat.L1=true
					startTimeL1=inputs.get(12)
				elseif temp2==closerPBtoGaitEvent then
					PB.Stat.L2=true
					startTimeL2=inputs.get(12)
				end
			end
			if GE.RHS == true then
				temp1=math.abs(PB.Pos.R1[3]-FP.COP[3])
				temp2=math.abs(PB.Pos.R2[3]-FP.COP[3])
				closerPBtoGaitEvent=math.min(temp1,temp2)
				if temp1==closerPBtoGaitEvent then
					PB.Stat.R1=true
					startTimeR1=inputs.get(12)
				elseif temp2==closerPBtoGaitEvent then
					PB.Stat.R2=true
					startTimeR2=inputs.get(12)
				end
			end
		end
			
	
	elseif CheckLPInRT==1 then
		FP.COP[1]=inputs.get(21)
		FP.COP[3]=inputs.get(22)

		if GE.RTO == true then
			if math.abs(PB.Pos.L1[1]-FP.COP[1])<xTol and math.abs(PB.Pos.L1[3]-FP.COP[3])<zTol then
				PB.Stat.L1=true
				startTimeL1=inputs.get(12)
				print("L1 placed correctly")
			elseif math.abs(PB.Pos.L2[1]-FP.COP[1])<xTol and math.abs(PB.Pos.L2[3]-FP.COP[3])<zTol then
				PB.Stat.L2=true
				startTimeL2=inputs.get(12)
				print("L2 placed correctly")
			end
		elseif GE.LTO == true then
			if math.abs(PB.Pos.R1[1]-FP.COP[1])<xTol and math.abs(PB.Pos.R1[3]-FP.COP[3])<zTol then
				PB.Stat.R1=true
				startTimeR1=inputs.get(12)
				print("R1")
			elseif math.abs(PB.Pos.R2[1]-FP.COP[1])<xTol and math.abs(PB.Pos.R2[3]-FP.COP[3])<zTol then
				PB.Stat.R2=true
				startTimeR2=inputs.get(12)
				print("R2")
			end
		end
	end
			
end


function UpdatePBPos()
	tempTime    =inputs.get(12)
	deltaT_Left =inputs.get(10)
	deltaT_Right=inputs.get(13)
	
	if PerturbBlockNumber==1 then
		if PB.Stat.R2 == true and (tempTime-startTimeR2)>deltaT_Right then
			PB.Pos.L2[1]=PB.Pos.L2[1] + PB.Pos.dL2[1]
			PB.Pos.L2[3]=PB.Pos.L2[3] + PB.Pos.dL2[3]
		end
		if PB.Stat.L1 == true and (tempTime-startTimeL1)>deltaT_Left then
			PB.Pos.R2[1]=PB.Pos.R2[1] + PB.Pos.dR2[1]
			PB.Pos.R2[3]=PB.Pos.R2[3] + PB.Pos.dR2[3]
		end
		if PB.Stat.R1 == true  and (tempTime-startTimeR1)>deltaT_Right then
			PB.Pos.L1[1]=PB.Pos.L1[1] + PB.Pos.dL1[1]
			PB.Pos.L1[3]=PB.Pos.L1[3] + PB.Pos.dL1[3]
		end
		if PB.Stat.L2 == true  and (tempTime-startTimeL2)>deltaT_Left then	
			PB.Pos.R1[1]=PB.Pos.R1[1] + PB.Pos.dR1[1]
			PB.Pos.R1[3]=PB.Pos.R1[3] + PB.Pos.dR1[3]
		end
	elseif PerturbBlockNumber==2 then
		if PB.Stat.R2 == true and (tempTime-startTimeR2)>deltaT_Right then
			PB.Pos.R1[1]=PB.Pos.R1[1] + PB.Pos.dR1[1]
			PB.Pos.R1[3]=PB.Pos.R1[3] + PB.Pos.dR1[3]
		end
		if PB.Stat.L1 == true and (tempTime-startTimeL1)>deltaT_Left then
			PB.Pos.L2[1]=PB.Pos.L2[1] + PB.Pos.dL2[1]
			PB.Pos.L2[3]=PB.Pos.L2[3] + PB.Pos.dL2[3]
		end
		if PB.Stat.R1 == true  and (tempTime-startTimeR1)>deltaT_Right then
			PB.Pos.R2[1]=PB.Pos.R2[1] + PB.Pos.dR2[1]
			PB.Pos.R2[3]=PB.Pos.R2[3] + PB.Pos.dR2[3]
		end
		if PB.Stat.L2 == true  and (tempTime-startTimeL2)>deltaT_Left then	
			PB.Pos.L1[1]=PB.Pos.L1[1] + PB.Pos.dL1[1]
			PB.Pos.L1[3]=PB.Pos.L1[3] + PB.Pos.dL1[3]
		end
	end
end

function SetPBPosition()
	object.setposition(PB.Obj.L1, PB.Pos.L1)	
	object.setposition(PB.Obj.R1, PB.Pos.R1)

	object.setposition(PB.Obj.L2, PB.Pos.L2)	
	object.setposition(PB.Obj.R2, PB.Pos.R2)
	
end

function ShowOrHidePBs()

	if PB.Pos.L1[3]>0 then
		object.hide(PB.Obj.L1)
	else
		object.show(PB.Obj.L1)
	end

	if PB.Pos.R1[3]>0  then
		object.hide(PB.Obj.R1)
	else
		object.show(PB.Obj.R1)
	end
	
	if PB.Pos.L2[3]>0 then
		object.hide(PB.Obj.L2)
	else
		object.show(PB.Obj.L2)
	end

	if PB.Pos.R2[3]>0  then
		object.hide(PB.Obj.R2)
	else
		object.show(PB.Obj.R2)
	end
	
end

function boolToNumber(value)
	return value and 1 or 0
end

function SetOutputsForRecording()
	outputs.set(1,PB.Pos.L1[1])
	outputs.set(2,PB.Pos.L1[3])
	outputs.set(3,PB.Pos.L2[1])
	outputs.set(4,PB.Pos.L2[3])
	outputs.set(5,PB.Pos.R1[1])
	outputs.set(6,PB.Pos.R1[3])
	outputs.set(7,PB.Pos.R2[1])
	outputs.set(8,PB.Pos.R2[3])

	outputs.set(9, PB.Pos.dL1[1])
	outputs.set(10,PB.Pos.dL1[3])
	outputs.set(11,PB.Pos.dL2[1])
	outputs.set(12,PB.Pos.dL2[3])
	outputs.set(13,PB.Pos.dR1[1])
	outputs.set(14,PB.Pos.dR1[3])
	outputs.set(15,PB.Pos.dR2[1])
	outputs.set(16,PB.Pos.dR2[3])

	outputs.set(17,currLTO)
	outputs.set(18,currLHS)
	outputs.set(19,currRTO)
	outputs.set(20,currRHS)

	outputs.set(21,boolToNumber(PB.Stat.L1))
	outputs.set(22,boolToNumber(PB.Stat.L2))
	outputs.set(23,boolToNumber(PB.Stat.R1))
	outputs.set(24,boolToNumber(PB.Stat.R2))	

	if hasaction("Action") then
		outputs.set(25,1)
	else
		outputs.set(25,0)
	end
	
	outputs.set(26,boolToNumber(GE.LTO))
	outputs.set(27,boolToNumber(GE.LHS))
	outputs.set(28,boolToNumber(GE.RTO))
	outputs.set(29,boolToNumber(GE.RHS))
end
-- -------------------Script update (all parts below are part of the script update)----------------------------

CalculatePB_NormalPos_withTMDistInput()

CalculatePB_DeltaPos_BasedOnUserInput()

IMUGaitDetectionMonitor() 		--Call gait detection script and update the flag corresponding to any gait events that might have happened in the current frame

DidUserApproachPerturbation()

DidUserPlaceLegCloseToPB()

UpdatePBPos()

SetPBPosition()

ShowOrHidePBs()

SetOutputsForRecording()




