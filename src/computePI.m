function [testbed_data, sorted_data] = computePI(csv_file, testbed_file, result_dir)
################################################################################
# 'function [testbed_data, sorted_data] = computePI(csv_file, testbed_file, result_dir)'
# 
# 1) Imports following files:
#       subject_X_cond_Y_testbed.yaml
#       subject_X_cond_Y_run_Z_platformData.csv
# 2) Sort data from subject_X_cond_Y_run_Z_platformData.csv
# 3) Calculate PI statistics: step length/width/time/target error
# 4) Save PI results as text and save it in *.yaml files
# 5) Save PI results as plots and save it in *.pdf
# 
# Copyright BeStable project 2020
# 
################################################################################

    #{
    csv_file = "../test_data/input/subject_2_cond_2_run_1_platformData.csv";
    testbed_file = "../test_data/input/subject_2_cond_2_testbed.yaml";
    result_dir = "../test_data/output/";
    #}
    
    disp(["Input parameters: ", csv_file, " ", testbed_file, " ", result_dir])
    
    
    
    ## IMPORT DATA #############################################################
    display("Importing platform data...")
    data = importData(csv_file);
    
    display("Importing testbed data...")
    testbed_data = importTestbedData(testbed_file);
    
    
    
    ## SORT DATA ###############################################################
    display("Sorting data...")
    sorted_data = sortData(data);
    
    
    
    ## RESULTS IN .YAML ########################################################
    display("Saving data to yaml...")
    
    # base walking/left step length
    filename = [result_dir, "\\", "base_step_length_left.yaml"];
    saveVector(filename, sorted_data.base.l_heel_strike.step_length);
    # base walking/left step width
    filename = [result_dir, "\\", "base_step_width_left.yaml"];
    saveVector(filename, sorted_data.base.l_heel_strike.step_width);
    # base walking/left step time
    filename = [result_dir, "\\", "base_step_time_left.yaml"];
    saveVector(filename, sorted_data.base.l_heel_strike.step_time);
    # base walking/right step length
    filename = [result_dir, "\\", "base_step_length_right.yaml"];
    saveVector(filename, sorted_data.base.r_heel_strike.step_length);
    # base walking/right step width
    filename = [result_dir, "\\", "base_step_width_right.yaml"];
    saveVector(filename, sorted_data.base.r_heel_strike.step_width);
    # base walking/right step time
    filename = [result_dir, "\\", "base_step_time_right.yaml"];
    saveVector(filename, sorted_data.base.r_heel_strike.step_time);
    
    # free walking/left step length
    filename = [result_dir, "\\", "free_step_length_left.yaml"];
    saveVector(filename, sorted_data.free.l_heel_strike.step_length);
    # free walking/left step width
    filename = [result_dir, "\\", "free_step_width_left.yaml"];
    saveVector(filename, sorted_data.free.l_heel_strike.step_width);
    # free walking/left step time
    filename = [result_dir, "\\", "free_step_time_left.yaml"];
    saveVector(filename, sorted_data.free.l_heel_strike.step_time);
    # free walking/right step length
    filename = [result_dir, "\\", "free_step_length_right.yaml"];
    saveVector(filename, sorted_data.free.r_heel_strike.step_length);
    # free walking/right step width
    filename = [result_dir, "\\", "free_step_width_right.yaml"];
    saveVector(filename, sorted_data.free.r_heel_strike.step_width);
    # free walking/right step time
    filename = [result_dir, "\\", "free_step_time_right.yaml"];
    saveVector(filename, sorted_data.free.r_heel_strike.step_time);
    
    if isfield(sorted_data.pert,'fw')
      # perturbed walking/fw perturbation step of the left leg/step length
      filename = [result_dir, "\\", "pert_fw_step_length_left.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fw.l_step.step_length);
      # perturbed walking/fw perturbation step of the left leg/step width
      filename = [result_dir, "\\", "pert_fw_step_width_left.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fw.l_step.step_width);
      # perturbed walking/fw perturbation step of the left leg/step time
      filename = [result_dir, "\\", "pert_fw_step_time_left.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fw.l_step.step_time);
      # perturbed walking/fw perturbation step of the left leg/target error
      filename = [result_dir, "\\", "pert_fw_target_error_left.yaml"];
      saveVector(filename, sorted_data.pert.fw.l_step.target_error);
      # perturbed walking/fw perturbation step of the right leg/step length
      filename = [result_dir, "\\", "pert_fw_step_length_right.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fw.r_step.step_length);
      # perturbed walking/fw perturbation step of the right leg/step width
      filename = [result_dir, "\\", "pert_fw_step_width_right.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fw.r_step.step_width);
      # perturbed walking/fw perturbation step of the right leg/step time
      filename = [result_dir, "\\", "pert_fw_step_time_right.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fw.r_step.step_time);
      # perturbed walking/fw perturbation step of the right leg/target error
      filename = [result_dir, "\\", "pert_fw_target_error_right.yaml"];
      saveVector(filename, sorted_data.pert.fw.r_step.target_error);
    endif
    
    if isfield(sorted_data.pert,'fwiw')
      # perturbed walking/fwiw perturbation step of the left leg/step length
      filename = [result_dir, "\\", "pert_fwiw_step_length_left.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwiw.l_step.step_length);
      # perturbed walking/fwiw perturbation step of the left leg/step width
      filename = [result_dir, "\\", "pert_fwiw_step_width_left.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwiw.l_step.step_width);
      # perturbed walking/fwiw perturbation step of the left leg/step time
      filename = [result_dir, "\\", "pert_fwiw_step_time_left.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwiw.l_step.step_time);
      # perturbed walking/fwiw perturbation step of the left leg/target error
      filename = [result_dir, "\\", "pert_fwiw_target_error_left.yaml"];
      saveVector(filename, sorted_data.pert.fwiw.l_step.target_error);
      # perturbed walking/fwiw perturbation step of the right leg/step length
      filename = [result_dir, "\\", "pert_fwiw_step_length_right.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwiw.r_step.step_length);
      # perturbed walking/fwiw perturbation step of the right leg/step width
      filename = [result_dir, "\\", "pert_fwiw_step_width_right.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwiw.r_step.step_width);
      # perturbed walking/fwiw perturbation step of the right leg/step time
      filename = [result_dir, "\\", "pert_fwiw_step_time_right.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwiw.r_step.step_time);
      # perturbed walking/fwiw perturbation step of the right leg/target error
      filename = [result_dir, "\\", "pert_fwiw_target_error_right.yaml"];
      saveVector(filename, sorted_data.pert.fwiw.r_step.target_error);
    endif
    
    if isfield(sorted_data.pert,'fwow')
      # perturbed walking/fwow perturbation step of the left leg/step length
      filename = [result_dir, "\\", "pert_fwow_step_length_left.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwow.l_step.step_length);
      # perturbed walking/fwow perturbation step of the left leg/step width
      filename = [result_dir, "\\", "pert_fwow_step_width_left.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwow.l_step.step_width);
      # perturbed walking/fwow perturbation step of the left leg/step time
      filename = [result_dir, "\\", "pert_fwow_step_time_left.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwow.l_step.step_time);
      # perturbed walking/fwow perturbation step of the left leg/target error
      filename = [result_dir, "\\", "pert_fwow_target_error_left.yaml"];
      saveVector(filename, sorted_data.pert.fwow.l_step.target_error);
      # perturbed walking/fwow perturbation step of the right leg/step length
      filename = [result_dir, "\\", "pert_fwow_step_length_right.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwow.r_step.step_length);
      # perturbed walking/fwow perturbation step of the right leg/step width
      filename = [result_dir, "\\", "pert_fwow_step_width_right.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwow.r_step.step_width);
      # perturbed walking/fwow perturbation step of the right leg/step time
      filename = [result_dir, "\\", "pert_fwow_step_time_right.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwow.r_step.step_time);
      # perturbed walking/fwow perturbation step of the right leg/target error
      filename = [result_dir, "\\", "pert_fwow_target_error_right.yaml"];
      saveVector(filename, sorted_data.pert.fwow.r_step.target_error);
    endif
    
    if isfield(sorted_data.pert,'iw')
      # perturbed walking/iw perturbation step of the left leg/step length
      filename = [result_dir, "\\", "pert_iw_step_length_left.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.iw.l_step.step_length);
      # perturbed walking/iw perturbation step of the left leg/step width
      filename = [result_dir, "\\", "pert_iw_step_width_left.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.iw.l_step.step_width);
      # perturbed walking/iw perturbation step of the left leg/step time
      filename = [result_dir, "\\", "pert_iw_step_time_left.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.iw.l_step.step_time);
      # perturbed walking/iw perturbation step of the left leg/target error
      filename = [result_dir, "\\", "pert_iw_target_error_left.yaml"];
      saveVector(filename, sorted_data.pert.iw.l_step.target_error);
      # perturbed walking/iw perturbation step of the right leg/step length
      filename = [result_dir, "\\", "pert_iw_step_length_right.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.iw.r_step.step_length);
      # perturbed walking/iw perturbation step of the right leg/step width
      filename = [result_dir, "\\", "pert_iw_step_width_right.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.iw.r_step.step_width);
      # perturbed walking/iw perturbation step of the right leg/step time
      filename = [result_dir, "\\", "pert_iw_step_time_right.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.iw.r_step.step_time);
      # perturbed walking/iw perturbation step of the right leg/target error
      filename = [result_dir, "\\", "pert_iw_target_error_right.yaml"];
      saveVector(filename, sorted_data.pert.iw.r_step.target_error);
    endif
    
    if isfield(sorted_data.pert,'ow')
      # perturbed walking/ow perturbation step of the left leg/step length
      filename = [result_dir, "\\", "pert_ow_step_length_left.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.ow.l_step.step_length);
      # perturbed walking/ow perturbation step of the left leg/step width
      filename = [result_dir, "\\", "pert_ow_step_width_left.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.ow.l_step.step_width);
      # perturbed walking/ow perturbation step of the left leg/step time
      filename = [result_dir, "\\", "pert_ow_step_time_left.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.ow.l_step.step_time);
      # perturbed walking/ow perturbation step of the left leg/target error
      filename = [result_dir, "\\", "pert_ow_target_error_left.yaml"];
      saveVector(filename, sorted_data.pert.ow.l_step.target_error);
      # perturbed walking/ow perturbation step of the right leg/step length
      filename = [result_dir, "\\", "pert_ow_step_length_right.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.ow.r_step.step_length);
      # perturbed walking/ow perturbation step of the right leg/step width
      filename = [result_dir, "\\", "pert_ow_step_width_right.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.ow.r_step.step_width);
      # perturbed walking/ow perturbation step of the right leg/step time
      filename = [result_dir, "\\", "pert_ow_step_time_right.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.ow.r_step.step_time);
      # perturbed walking/ow perturbation step of the right leg/target error
      filename = [result_dir, "\\", "pert_ow_target_error_right.yaml"];
      saveVector(filename, sorted_data.pert.ow.r_step.target_error);
    endif
    
    
    
    ## VISUAL REPRESENTATION OF THE RESULTS IN .PDF ############################
    display("Plotting data to pdf...")
    plotResults(testbed_data,sorted_data);
    
    
endfunction