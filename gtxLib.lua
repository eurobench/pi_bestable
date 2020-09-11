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

function initIMU()
	local bufferDuration = 2
	
	--parameters for gaitDetector2
	local imuPars = {
		nAccStatR = 10,
		nAccStatL = 10,
		PSwMPH = 50,
		PSwMPD = 1.5,
		PSwMPP = 75,
		SwMPH = 50,
		SwMPD = 1.5,
		SwMPP = 100,
		arraySize = math.floor(bufferDuration / framedelta())
	}
	
	--buffers for sensor measurements
	local imuBuf = {
		t 		= CircularBuffer(imuPars.arraySize),
		nAccL 	= CircularBuffer(imuPars.arraySize),
		angVelL = CircularBuffer(imuPars.arraySize),
		nAccR 	= CircularBuffer(imuPars.arraySize),
		angVelR = CircularBuffer(imuPars.arraySize)
	}
	
	-- to compare with last call of gaitDetector2
	local imuStates = {
		prevLTO = 0, prevLHS = 0, prevRTO = 0, prevRHS = 0,
		buf = imuBuf,
		ISTGFL = struct0_T(), ISTGFR = struct0_T()
	}
		
	imuStates.ISTGFL:set_IndexPSw(1)
	imuStates.ISTGFL:set_IndexSw(1)
	imuStates.ISTGFL:set_IndexMSt(1)
	imuStates.ISTGFL:set_IndexHS(1)
	imuStates.ISTGFL:set_IndexTO(1)

	imuStates.ISTGFR:set_IndexPSw(1)
	imuStates.ISTGFR:set_IndexSw(1)
	imuStates.ISTGFR:set_IndexMSt(1)
	imuStates.ISTGFR:set_IndexHS(1)
	imuStates.ISTGFR:set_IndexTO(1)
	
	return imuPars, imuStates
end

function updateImuGaitEvent(imuPars,imuStates,imuSigs)
	-- Formerly "IMUGaitDetectionMonitor()"	
	
	imuStates.buf.t:put(imuSigs.t)
	imuStates.buf.angVelL:put(imuSigs.angVelL)
	imuStates.buf.nAccL:put(imuSigs.nAccL)
	imuStates.buf.angVelR:put(imuSigs.angVelR)
	imuStates.buf.nAccR:put(imuSigs.nAccR)

	gaitDetector2(imuPars.arraySize, imuStates.buf.t, imuStates.buf.nAccL, imuStates.buf.angVelL, imuStates.ISTGFL, imuPars.nAccStatL, imuPars.PSwMPH, imuPars.PSwMPD, imuPars.PSwMPP, imuPars.SwMPH, imuPars.SwMPD, imuPars.SwMPP)
	gaitDetector2(imuPars.arraySize, imuStates.buf.t, imuStates.buf.nAccR, imuStates.buf.angVelR, imuStates.ISTGFR, imuPars.nAccStatR, imuPars.PSwMPH, imuPars.PSwMPD, imuPars.PSwMPP, imuPars.SwMPH, imuPars.SwMPD, imuPars.SwMPP)
	
	currLTO = imuStates.ISTGFL:LocTO() 
	currLHS = imuStates.ISTGFL:LocHS() 

	currRTO = imuStates.ISTGFR:LocTO() 
	currRHS = imuStates.ISTGFR:LocHS() 
	
	-- Left IMU
	if currLTO ~= imuStates.prevLTO then 				--Comes here when LTO is detected
		gaitEvents.LTO = true
		gaitEvents.LHS = false
		--outputs.set(3,ISTGFL:LocTO())
		--print("LTO")
	elseif currLHS ~= imuStates.prevLHS then			--Comes here when LHS is detected
		gaitEvents.LTO = false
		gaitEvents.LHS = true
		--outputs.set(4,ISTGFL:LocHS())
		--print("LHS")
	else
		gaitEvents.LTO = false
		gaitEvents.LHS = false
	end

	-- Right IMU
	if currRTO ~= imuStates.prevRTO then 			--Comes here when LTO is detected
		gaitEvents.RTO = true
		gaitEvents.RHS = false
		--outputs.set(5,ISTGFR:LocTO())
		--print("RTO")
	elseif currRHS ~= imuStates.prevRHS then			--Comes here when LHS is detected
		gaitEvents.RTO = false
		gaitEvents.RHS = true
		--outputs.set(6,ISTGFR:LocHS())
		 --print("RHS")
	else
		gaitEvents.RTO=false
		gaitEvents.RHS=false	
	end

	imuStates.prevLTO = currLTO
	imuStates.prevLHS = currLHS
	imuStates.prevRTO = currRTO
	imuStates.prevRHS = currRHS
	
	return gaitEvents, imuStates
end