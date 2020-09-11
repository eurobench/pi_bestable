protocol = {}

-- Private functions
function parseCSVLine(line,sep) 
	-- Taken form here: http://lua-users.org/wiki/LuaCsv
	-- Note:
	-- * Values read as type string.
	-- * Empty values stored as empty strings, different from nil.
	local lineTab = {}
	local pos = 1
	sep = sep or ','
	while true do 
		local c = string.sub(line,pos,pos)
		if (c == "") then break end
		if (c == '"') then
			-- quoted value (ignore separator within)
			local txt = ""
			repeat
				local startp,endp = string.find(line,'^%b""',pos)
				txt = txt..string.sub(line,startp+1,endp-1)
				pos = endp + 1
				c = string.sub(line,pos,pos) 
				if (c == '"') then txt = txt..'"' end 
				-- check first char AFTER quoted string, if it is another
				-- quoted string without separator, then append it
				-- this is the way to "escape" the quote char in a quote. example:
				--   value1,"blub""blip""boing",value3  will lineTabult in blub"blip"boing  for the middle
			until (c ~= '"')
			table.insert(lineTab,txt)
			assert(c == sep or c == "")
			pos = pos + 1
		else	
			-- no quotes used, just look for the first separator
			local startp,endp = string.find(line,sep,pos)
			if (startp) then 
				table.insert(lineTab,string.sub(line,pos,startp-1))
				pos = endp + 1
			else
				-- no separator found -> use rest of string and terminate
				table.insert(lineTab,string.sub(line,pos))
				break
			end 
		end
	end
	return lineTab
end

-- Public functions
function protocol.read(fileName,skipFirstRow)
    -- Description: Read each line of the CSV file containing the protocol and store it in a table. Add a random delay.

    local skipFirstRow = skipFirstRow or false
    local pertList = {}

    file = io.open(fileName,"r")
    io.input(file)
    if skipFirstRow then
        io.read()
    end

    local iLine = 0
    for line in io.lines() do
        iLine = iLine + 1
        local lineTab = parseCSVLine(line)
        local nReps = isempty(lineTab[5]) and 1 or tonumber(lineTab[5]) -- Number of repetitions: if field is empty, set to 1
        if nReps == nil then -- tonumber() will return nil if the contents are not completely numeric
            error("Invalid value for nReps (line "..tostring(iLine)..").")
        end

        for iRep = 1,nReps do
            pertList[#pertList+1] = {
                                        name = lineTab[1], 
                                        deltaML = tonumber(lineTab[2]), 
                                        deltaAP = tonumber(lineTab[3]), 
                                        limb = lineTab[4]
                                    }
        end
    end
    io.close(file)
    return pertList
end

function protocol.manual(pertDir,pertLimbCode,nReps)
	-- pertLimb: 1='L', 2='R', 3='both'

	-- Definitions of each type of perturbation
	local lookup = { fw 	= {deltaML =  0,		deltaAP = -1},
					fwiw 	= {deltaML =  0.7071,	deltaAP = -0.7071},
					fwow 	= {deltaML = -0.7071,	deltaAP = -0.7071},
					iw 		= {deltaML =  1,		deltaAP = 0},
					ow 		= {deltaML = -1,		deltaAP = 0}
					}

	local pertList = {}
	local pertLimb = {}
	if pertLimbCode == 1 then
		pertLimb = {'L'}
	elseif pertLimbCode == 2 then
		pertLimb = {'R'}
	else
		pertLimb = {'L','R'}
	end

	for nameDir, isDir in pairs(pertDir) do
		if isDir then			
			for iLimb, nameLimb in pairs(pertLimb) do
				for iRep = 1,nReps do
					pertList[#pertList+1] = {
						name = nameDir,
						deltaML = lookup[nameDir].deltaML,
						deltaAP = lookup[nameDir].deltaAP,
						limb = nameLimb
					}
				end
			end
		end
	end
	return pertList
end

function protocol.scale(pertList,scaleFactor)
    for i = 1,#pertList do
        pertList[i].deltaML = pertList[i].deltaML*scaleFactor
        pertList[i].deltaAP = pertList[i].deltaAP*scaleFactor
    end
end

function protocol.randomizeOrder(pertList)
	-- Fisher-Yates shuffle: interchange elements randomly, resulting in an unbiased permutation
	for i = #pertList, 2, -1 do
		local j = math.random(i)
		pertList[i], pertList[j] = pertList[j], pertList[i]
    end
end

function protocol.randomizeDelay(pertList,delayMin,delayMax)
    for i = 1,#pertList do
        pertList[i].delay = math.random(delayMin,delayMax)
    end
end

function protocol.print(pertList)
    print("order","name","limb","deltaML","deltaAP","delay")
    for iPert = 1,#pertList do
        print(tostring(iPert)..":", pertList[iPert].name, pertList[iPert].limb, pertList[iPert].deltaML, pertList[iPert].deltaAP, pertList[iPert].delay)
    end
end

function protocol.printLine(pertLine)
	print(pertLine.name, pertLine.limb, "Width: "..tostring(pertLine.deltaML), "Length: "..tostring(pertLine.deltaAP), "Delay: "..tostring(pertLine.delay))
end

function protocol.targetPos(pertLine)
	-- Global variables: SSLStart_mean, SSRStart_mean
	local pertPos 	= {}
	if pertLine.limb == 'L' then
		return {-pertLine.deltaML + SSLStart_mean[1], pertLine.deltaAP + SSLStart_mean[2]}
	else
		return {pertLine.deltaML + SSRStart_mean[1], pertLine.deltaAP + SSRStart_mean[2]}
	end
end