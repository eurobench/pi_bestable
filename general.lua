-- General functions

-- Converting boolean to number
function boolToNum(x)
	return (x and 1) or 0
end

-- Converting number to boolean
function numToBool(x)
    return (x > 0)
end

-- Exclusive or
function xor(x,y)
    return (x or y) and not (x and y)
end

-- Checks whether a variable is undefined, an empty string, or an empty table
function isempty(x)
	return (x == nil) or (x == '') or ( (type(x) == 'table') and (next(x) == nil) )
end

-- Swap keys and values in tables. This allows values to be matched to retrieve the key.
function invertKeysValues(tab1)
    local tab2 = {}
    for key,value in pairs(tab1) do
        tab2[value]     = key
    end
    return tab2
end