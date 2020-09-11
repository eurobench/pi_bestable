
function initCoPAlgorithm()
	
	local CoPAlgorithmStates = {
		left_foot_off_x = 0,
		left_heel_strike_x = 0,
		left_foot_off_z = 0,
		left_heel_strike_z = 0,
		right_foot_off_x = 0,
		right_heel_strike_x = 0,
		right_foot_off_z = 0,
		right_heel_strike_z = 0,
		front_support = false,
		rear_support = true,
		left_support_foot = true,
		right_support_foot = false,
		left_support_foot_OLD = true,
		right_support_foot_OLD = false,
		phase = 0,
		upper_limit_x = 0,
		lower_limit_x = 0,
		upper_limit_z = 0,
		lower_limit_z = 0,
		threshold_ratio_x = 0.2,
		threshold_ratio_z = 0.2,
		threshold_max_distance_z = 999,
		AP_threshold = 0,
		ML_threshold = 900,
	}
	
	return CoPAlgorithmStates
end





function updateCoPAlgorithmGaitEvent(CoPAlgorithmStates)
	
	
    gaitEvents.RHS = false;
    gaitEvents.LHS = false;
    gaitEvents.RTO = false;
    gaitEvents.LTO = false;
	
    CoPAlgorithmStates.left_support_foot_OLD = CoPAlgorithmStates.left_support_foot;
    CoPAlgorithmStates.right_support_foot_OLD = CoPAlgorithmStates.right_support_foot;
    
    if CoPAlgorithmStates.left_support_foot then
        
        if sigData.cop[1] < CoPAlgorithmStates.ML_threshold then
            CoPAlgorithmStates.left_support_foot = false
            CoPAlgorithmStates.right_support_foot = true
            CoPAlgorithmStates.lower_limit_x = sigData.cop[1]
        end
        
        if sigData.cop[1] > CoPAlgorithmStates.upper_limit_x then
            CoPAlgorithmStates.upper_limit_x = sigData.cop[1]
        end
        
        CoPAlgorithmStates.ML_threshold = (1-CoPAlgorithmStates.threshold_ratio_x)*CoPAlgorithmStates.upper_limit_x + CoPAlgorithmStates.threshold_ratio_x*CoPAlgorithmStates.lower_limit_x
        
    end
    
    if CoPAlgorithmStates.right_support_foot then
        
        if sigData.cop[1] > CoPAlgorithmStates.ML_threshold then
            CoPAlgorithmStates.left_support_foot = true
            CoPAlgorithmStates.right_support_foot = false
            CoPAlgorithmStates.upper_limit_x = sigData.cop[1]
        end
        
        if sigData.cop[1] < CoPAlgorithmStates.lower_limit_x then
            CoPAlgorithmStates.lower_limit_x = sigData.cop[1]
        end
        
        CoPAlgorithmStates.ML_threshold = CoPAlgorithmStates.threshold_ratio_x*CoPAlgorithmStates.upper_limit_x + (1-CoPAlgorithmStates.threshold_ratio_x)*CoPAlgorithmStates.lower_limit_x;
        
    end
    
    
    
    
    
    if CoPAlgorithmStates.rear_support then
        if sigData.cop[2] < CoPAlgorithmStates.AP_threshold then
            if CoPAlgorithmStates.phase == 3 then
				gaitEvents.LHS = true
                CoPAlgorithmStates.left_heel_strike_x = CoPAlgorithmStates.upper_limit_x;
                CoPAlgorithmStates.left_heel_strike_z = CoPAlgorithmStates.upper_limit_z;
                CoPAlgorithmStates.phase = 4
            else
				gaitEvents.RHS = true
                CoPAlgorithmStates.right_heel_strike_x = CoPAlgorithmStates.lower_limit_x
                CoPAlgorithmStates.right_heel_strike_z = CoPAlgorithmStates.upper_limit_z
                CoPAlgorithmStates.phase = 2
            end
            CoPAlgorithmStates.front_support = true
            CoPAlgorithmStates.rear_support = false
            CoPAlgorithmStates.lower_limit_z = sigData.cop[2]
        end
        
        if sigData.cop[2] > CoPAlgorithmStates.upper_limit_z then
            CoPAlgorithmStates.upper_limit_z = sigData.cop[2]
        end
        
        CoPAlgorithmStates.AP_threshold = (1-CoPAlgorithmStates.threshold_ratio_z)*CoPAlgorithmStates.upper_limit_z + CoPAlgorithmStates.threshold_ratio_z*CoPAlgorithmStates.lower_limit_z
        
        if CoPAlgorithmStates.upper_limit_z - CoPAlgorithmStates.AP_threshold > CoPAlgorithmStates.threshold_max_distance_z then
            AP_threshold = CoPAlgorithmStates.upper_limit_z - CoPAlgorithmStates.threshold_max_distance_z
        end
    end
    
    if CoPAlgorithmStates.front_support then
        if sigData.cop[2] > CoPAlgorithmStates.AP_threshold then
            CoPAlgorithmStates.cop_length1 = CoPAlgorithmStates.AP_threshold
            if CoPAlgorithmStates.left_support_foot then
				gaitEvents.LTO = true
                CoPAlgorithmStates.left_foot_off_x = CoPAlgorithmStates.upper_limit_x
                CoPAlgorithmStates.left_foot_off_z = CoPAlgorithmStates.lower_limit_z
                CoPAlgorithmStates.phase = 3
            else
				gaitEvents.RTO = true
                CoPAlgorithmStates.right_foot_off_x = CoPAlgorithmStates.lower_limit_x
                CoPAlgorithmStates.right_foot_off_z = CoPAlgorithmStates.lower_limit_z
                CoPAlgorithmStates.phase = 1
            end
            CoPAlgorithmStates.front_support = false
            CoPAlgorithmStates.rear_support = true
            CoPAlgorithmStates.upper_limit_z = sigData.cop[2]
        end
        
        if sigData.cop[2] < CoPAlgorithmStates.lower_limit_z then
            CoPAlgorithmStates.lower_limit_z = sigData.cop[2]
        end
        
        CoPAlgorithmStates.AP_threshold = CoPAlgorithmStates.threshold_ratio_z*CoPAlgorithmStates.upper_limit_z + (1-CoPAlgorithmStates.threshold_ratio_z)*CoPAlgorithmStates.lower_limit_z
        
        if CoPAlgorithmStates.AP_threshold - CoPAlgorithmStates.lower_limit_z > CoPAlgorithmStates.threshold_max_distance_z then
            CoPAlgorithmStates.AP_threshold = CoPAlgorithmStates.lower_limit_z + CoPAlgorithmStates.threshold_max_distance_z
        end
    end
	
	
	return gaitEvents, CoPAlgorithmStates
end