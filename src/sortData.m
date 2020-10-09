function sorted_data = sortData(data)
################################################################################
# 'function sorted_data = sortData(data)'
#
# Sort data containing PI of consecutive steps to:
#   1) base: unperturbed walking before enabling perturbations
#   2) free: unperturbed walking after enabling perturbations
#   3) pert: perturbed walking as a stepping response to applied perturbations
#
# Copyright BeStable project 2020
#
################################################################################
    
    sorted_data = struct(...
            'base',[],...
            'free',[],...
            'pert',[]);

    pert_en = false;
    idx_base_r_heel_strike = 1;
    idx_base_l_heel_strike = 1;
    idx_free_r_heel_strike = 1;
    idx_free_l_heel_strike = 1;
    flag_continue = 0;
    idx_fw_l_step = 1;
    idx_fw_r_step = 1;
    idx_iw_l_step = 1;
    idx_iw_r_step = 1;
    idx_fwiw_l_step = 1;
    idx_fwiw_r_step = 1;
    idx_fwow_l_step = 1;
    idx_fwow_r_step = 1;
    idx_ow_l_step = 1;
    idx_ow_r_step = 1;
    NO_STEPS_AFTER_PERT = 4;

    for n = 1:length(data.message)
        str_message = char(data.message(n));
        
        if flag_continue <= NO_STEPS_AFTER_PERT && flag_continue >= 1
            flag_continue = flag_continue - 1;
            continue;
        endif
        
        if strcmp(str_message,'free') && ~pert_en
            
            if strcmp(char(data.limb_final(n)),'R')
                sorted_data.base.r_heel_strike.step_length(idx_base_r_heel_strike) = data.step_length(n);
                sorted_data.base.r_heel_strike.step_width(idx_base_r_heel_strike) = data.step_width(n);
                sorted_data.base.r_heel_strike.step_time(idx_base_r_heel_strike) = data.step_time(n);
                idx_base_r_heel_strike = idx_base_r_heel_strike + 1;
            else
                sorted_data.base.l_heel_strike.step_length(idx_base_l_heel_strike) = data.step_length(n);
                sorted_data.base.l_heel_strike.step_width(idx_base_l_heel_strike) = data.step_width(n);
                sorted_data.base.l_heel_strike.step_time(idx_base_l_heel_strike) = data.step_time(n);
                idx_base_l_heel_strike = idx_base_l_heel_strike + 1;
            endif
            
        elseif ~isempty(strfind(str_message,'Pert'))
            
            pert_en = true;
            
            switch str_message(7:end)
                case 'fw (L)'
                    sorted_data.pert.fw.l_step.step_length(idx_fw_l_step,:) = data.step_length(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.fw.l_step.step_width(idx_fw_l_step,:) = data.step_width(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.fw.l_step.step_time(idx_fw_l_step,:) = data.step_time(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.fw.l_step.target_error(idx_fw_l_step) = data.target_error(n+2);
                    idx_fw_l_step = idx_fw_l_step + 1;
                case 'fw (R)'
                    sorted_data.pert.fw.r_step.step_length(idx_fw_r_step,:) = data.step_length(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.fw.r_step.step_width(idx_fw_r_step,:) = data.step_width(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.fw.r_step.step_time(idx_fw_r_step,:) = data.step_time(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.fw.r_step.target_error(idx_fw_r_step) = data.target_error(n+2);
                    idx_fw_r_step = idx_fw_r_step + 1;
                case 'iw (L)'
                    sorted_data.pert.iw.l_step.step_length(idx_iw_l_step,:) = data.step_length(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.iw.l_step.step_width(idx_iw_l_step,:) = data.step_width(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.iw.l_step.step_time(idx_iw_l_step,:) = data.step_time(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.iw.l_step.target_error(idx_iw_l_step) = data.target_error(n+2);
                    idx_iw_l_step = idx_iw_l_step + 1;
                case 'iw (R)'
                    sorted_data.pert.iw.r_step.step_length(idx_iw_r_step,:) = data.step_length(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.iw.r_step.step_width(idx_iw_r_step,:) = data.step_width(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.iw.r_step.step_time(idx_iw_r_step,:) = data.step_time(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.iw.r_step.target_error(idx_iw_r_step) = data.target_error(n+2);
                    idx_iw_r_step = idx_iw_r_step + 1;
                case 'fwiw (L)'
                    sorted_data.pert.fwiw.l_step.step_length(idx_fwiw_l_step,:) = data.step_length(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.fwiw.l_step.step_width(idx_fwiw_l_step,:) = data.step_width(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.fwiw.l_step.step_time(idx_fwiw_l_step,:) = data.step_time(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.fwiw.l_step.target_error(idx_fwiw_l_step) = data.target_error(n+2);
                    idx_fwiw_l_step = idx_fwiw_l_step + 1;
                case 'fwiw (R)'
                    sorted_data.pert.fwiw.r_step.step_length(idx_fwiw_r_step,:) = data.step_length(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.fwiw.r_step.step_width(idx_fwiw_r_step,:) = data.step_width(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.fwiw.r_step.step_time(idx_fwiw_r_step,:) = data.step_time(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.fwiw.r_step.target_error(idx_fwiw_r_step) = data.target_error(n+2);
                    idx_fwiw_r_step = idx_fwiw_r_step + 1;
                case 'fwow (L)'
                    sorted_data.pert.fwow.l_step.step_length(idx_fwow_l_step,:) = data.step_length(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.fwow.l_step.step_width(idx_fwow_l_step,:) = data.step_width(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.fwow.l_step.step_time(idx_fwow_l_step,:) = data.step_time(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.fwow.l_step.target_error(idx_fwow_l_step) = data.target_error(n+2);
                    idx_fwow_l_step = idx_fwow_l_step + 1;
                case 'fwow (R)'
                    sorted_data.pert.fwow.r_step.step_length(idx_fwow_r_step,:) = data.step_length(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.fwow.r_step.step_width(idx_fwow_r_step,:) = data.step_width(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.fwow.r_step.step_time(idx_fwow_r_step,:) = data.step_time(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.fwow.r_step.target_error(idx_fwow_r_step) = data.target_error(n+2);
                    idx_fwow_r_step = idx_fwow_r_step + 1;
                case 'ow (L)'
                    sorted_data.pert.ow.l_step.step_length(idx_ow_l_step,:) = data.step_length(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.ow.l_step.step_width(idx_ow_l_step,:) = data.step_width(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.ow.l_step.step_time(idx_ow_l_step,:) = data.step_time(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.ow.l_step.target_error(idx_ow_l_step) = data.target_error(n+2);
                    idx_ow_l_step = idx_ow_l_step + 1;
                case 'ow (R)'
                    sorted_data.pert.ow.r_step.step_length(idx_ow_r_step,:) = data.step_length(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.ow.r_step.step_width(idx_ow_r_step,:) = data.step_width(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.ow.r_step.step_time(idx_ow_r_step,:) = data.step_time(n+1:n+NO_STEPS_AFTER_PERT);
                    sorted_data.pert.ow.r_step.target_error(idx_ow_r_step) = data.target_error(n+2);
                    idx_ow_r_step = idx_ow_r_step + 1;
            endswitch
            flag_continue = NO_STEPS_AFTER_PERT;
            
        elseif strcmp(str_message,'free') && pert_en
            
            if strcmp(char(data.limb_final(n)),'R')
                sorted_data.free.r_heel_strike.step_length(idx_free_r_heel_strike) = data.step_length(n);
                sorted_data.free.r_heel_strike.step_width(idx_free_r_heel_strike) = data.step_width(n);
                sorted_data.free.r_heel_strike.step_time(idx_free_r_heel_strike) = data.step_time(n);
                idx_free_r_heel_strike = idx_free_r_heel_strike + 1;
            else
                sorted_data.free.l_heel_strike.step_length(idx_free_l_heel_strike) = data.step_length(n);
                sorted_data.free.l_heel_strike.step_width(idx_free_l_heel_strike) = data.step_width(n);
                sorted_data.free.l_heel_strike.step_time(idx_free_l_heel_strike) = data.step_time(n);
                idx_free_l_heel_strike = idx_free_l_heel_strike + 1;
            endif
            
        endif
        
    endfor
    
endfunction