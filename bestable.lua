-- Description: This will contain a library of some helper scripts for the Bestable platform

-- Cumulative mean of a 1D signal with internal states and functions
cumulativeMean = {nPoints = 0, sum = 0, mean = 0}
function cumulativeMean:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    self.nPoints = 0
    self.sum = 0
    self.mean = 0
    return obj
end
function cumulativeMean:reset()
    self.nPoints = 0
    self.sum = 0
    self.mean = 0
end
function cumulativeMean:addSample(newSample)
    self.nPoints = self.nPoints + 1
    self.sum = self.sum + newSample
    self.mean = self.sum/self.nPoints
end

function isNewGaitEvent(gaitEvents)
    return gaitEvents.LTO or gaitEvents.LHS or gaitEvents.RTO or gaitEvents.RHS
end

function printRow(rowData)
    for k,v in pairs(rowData) do
        print(k,v)
    end
end

bestable = {}

function bestable.xor(x,y)
    return (x or y) and not (x and y)
end
function bestable.numtobool(x)
    return (x > 0)
end

function bestable.checkStance(GE,isStance)
    -- Global variables used: GE, isStance
    -- isStance.L
    -- isStance.R
    -- isStance.single

    -- Check whether each limb is currently in stance
    -- Update isStance only if events occur in the current frame
    if GE.LHS then
        isStance.L = true
    elseif GE.LTO then
        isStance.L = false
    end
    if GE.RHS then
        isStance.R = true
    elseif GE.RTO then
        isStance.R = false
    end

    -- Check if single support
    isStance.single = bestable.xor(isStance.L,isStance.R)

    return isStance
end


-- Writing output data
function bestable.writeFile(fileName)
    -- In progress: Consider also optionally writing the header here
end

function bestable.writeLine(fileObj,lineData,sep)
    local sep = sep or ','
    for k,v in ipairs(lineData) do
        if k>1 then 
            fileObj:write(sep) 
        end
        if type(v) == 'string' then
            -- Add string qualifer; allows commas in text
            fileObj:write([["]]..v..[["]])
        else
            fileObj:write(v)
        end
    end
    fileObj:write('\n') 
end

function bestable.writeTab(fileName, tabData, writeHeader, sep)
    -- Description: Write table contents to file

    local writeHeader = writeHeader or false
    local sep = sep or ','
	local file = assert(io.open(fileName, "w"))
    
    -- Write header
	local j = 1
	for k,v in pairs(tabData[1]) do
		if j>1 then file:write(sep) end
		file:write(k)
		j = j + 1
	end
	file:write('\n')

    -- Write data
    for i=1,#tabData do
		local j = 1
		for k,v in pairs(tabData[i]) do
            if j>1 then file:write(sep) end
			file:write(v)
			j = j + 1
        end
        file:write('\n')
    end
    file:close()
end



function moving_average(period)
	local t = {}
	function sum(a, ...)
		if a then return a+sum(...) else return 0 end
	end
	function average(n)
		if #t == period then table.remove(t, 1) end
		t[#t + 1] = n
		return sum(unpack(t)) / #t
	end
	return average
end
MOVING_AVERAGE_WINDOW = 3  -- average of 5 previous gait cycles
moving_average_LCoPxStart_function = moving_average(MOVING_AVERAGE_WINDOW)
moving_average_LCoPzStart_function = moving_average(MOVING_AVERAGE_WINDOW)
moving_average_RCoPxStart_function = moving_average(MOVING_AVERAGE_WINDOW)
moving_average_RCoPzStart_function = moving_average(MOVING_AVERAGE_WINDOW)

