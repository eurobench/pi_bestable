function data = computePI(csv_file, testbed_file, personal_file, result_dir)
################################################################################
# 'function data = computePI(csv_file, testbed_file, personal_file, result_dir)'
# 
# 1) Imports following files:
#       subject_X_cond_Y_run_Z_platformData.csv
#       subject_X_cond_Y_testbed.yaml
#       subject_X_personalData.yaml
# 2) Sorts data from subject_X_cond_Y_run_Z_platformData.csv
# 3) Calculates PI statistics:
#       - step length
#       - step width
#       - step time
#       - target error
#       - success rate
# 4) Saves PI results as text and save it in *.yaml files
# 5) Plots PI results and save it as *.pdf
# 6) The function computePI() returns structured data containing:
#       - personal data
#       - testbed data
#       - raw data
#       - sorted data
# 
# Copyright BeStable project 2020
# 
################################################################################
    
    #{
    csv_file = "../test_data/input/subject_19_cond_2_run_1_platformData.csv";
    testbed_file = "../test_data/input/subject_19_cond_2_testbed.yaml";
    personal_file = "../test_data/input/subject_19_personalData.yaml";
    result_dir = "../test_data/output/";
    #}
    
    disp(["Input parameters: ", csv_file, " ", testbed_file, " ", personal_file, " ", result_dir])
    
    
    
    ## IMPORT DATA #############################################################
    display("Importing platform data...")
    raw_data = importData(csv_file);
    
    display("Importing testbed data...")
    testbed_data = importYAML(testbed_file);
    
    display("Importing personal data...")
    personal_data = importYAML(personal_file);
    
    
    
    ## SORT DATA ###############################################################
    display("Sorting data...")
    sorted_data = sortData(raw_data,testbed_data);
    
    
    
    ## RESULTS IN .YAML ########################################################
    display("Saving data to yaml...")
    
    # base walking/left step length
    filename = [result_dir, "/", "base_step_length_left.yaml"];
    saveVector(filename, sorted_data.base.l_heel_strike.step_length);
    # base walking/left step width
    filename = [result_dir, "/", "base_step_width_left.yaml"];
    saveVector(filename, sorted_data.base.l_heel_strike.step_width);
    # base walking/left step time
    filename = [result_dir, "/", "base_step_time_left.yaml"];
    saveVector(filename, sorted_data.base.l_heel_strike.step_time);
    # base walking/right step length
    filename = [result_dir, "/", "base_step_length_right.yaml"];
    saveVector(filename, sorted_data.base.r_heel_strike.step_length);
    # base walking/right step width
    filename = [result_dir, "/", "base_step_width_right.yaml"];
    saveVector(filename, sorted_data.base.r_heel_strike.step_width);
    # base walking/right step time
    filename = [result_dir, "/", "base_step_time_right.yaml"];
    saveVector(filename, sorted_data.base.r_heel_strike.step_time);
    
    # free walking/left step length
    filename = [result_dir, "/", "free_step_length_left.yaml"];
    saveVector(filename, sorted_data.free.l_heel_strike.step_length);
    # free walking/left step width
    filename = [result_dir, "/", "free_step_width_left.yaml"];
    saveVector(filename, sorted_data.free.l_heel_strike.step_width);
    # free walking/left step time
    filename = [result_dir, "/", "free_step_time_left.yaml"];
    saveVector(filename, sorted_data.free.l_heel_strike.step_time);
    # free walking/right step length
    filename = [result_dir, "/", "free_step_length_right.yaml"];
    saveVector(filename, sorted_data.free.r_heel_strike.step_length);
    # free walking/right step width
    filename = [result_dir, "/", "free_step_width_right.yaml"];
    saveVector(filename, sorted_data.free.r_heel_strike.step_width);
    # free walking/right step time
    filename = [result_dir, "/", "free_step_time_right.yaml"];
    saveVector(filename, sorted_data.free.r_heel_strike.step_time);
    
    if isfield(sorted_data.pert,'fw')
      if ~isfield(sorted_data.pert.fw,'l_step')
        sorted_data.pert.fw.l_step.step_length = nan(1,4);
        sorted_data.pert.fw.l_step.step_width = nan(1,4);
        sorted_data.pert.fw.l_step.step_time = nan(1,4);
        sorted_data.pert.fw.l_step.target_error = nan;
        sorted_data.pert.fw.l_step.success_rate = 0;
      end
      # perturbed walking/fw perturbation step with left foot/step length
      filename = [result_dir, "/", "pert_left_fw_step_length.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fw.l_step.step_length);
      # perturbed walking/fw perturbation step with left foot/step width
      filename = [result_dir, "/", "pert_left_fw_step_width.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fw.l_step.step_width);
      # perturbed walking/fw perturbation step with left foot/step time
      filename = [result_dir, "/", "pert_left_fw_step_time.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fw.l_step.step_time);
      # perturbed walking/fw perturbation step with left foot/target error
      filename = [result_dir, "/", "pert_left_fw_target_error.yaml"];
      saveVector(filename, sorted_data.pert.fw.l_step.target_error);
      # perturbed walking/fw perturbation step with left foot/success_rate
      filename = [result_dir, "/", "pert_left_fw_success_rate.yaml"];
      saveScalar(filename, sorted_data.pert.fw.l_step.success_rate);
      if ~isfield(sorted_data.pert.fw,'r_step')
        sorted_data.pert.fw.r_step.step_length = nan(1,4);
        sorted_data.pert.fw.r_step.step_width = nan(1,4);
        sorted_data.pert.fw.r_step.step_time = nan(1,4);
        sorted_data.pert.fw.r_step.target_error = nan;
        sorted_data.pert.fw.r_step.success_rate = 0;
      end
      # perturbed walking/fw perturbation step with right foot/step length
      filename = [result_dir, "/", "pert_right_fw_step_length.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fw.r_step.step_length);
      # perturbed walking/fw perturbation step with right foot/step width
      filename = [result_dir, "/", "pert_right_fw_step_width.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fw.r_step.step_width);
      # perturbed walking/fw perturbation step with right foot/step time
      filename = [result_dir, "/", "pert_right_fw_step_time.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fw.r_step.step_time);
      # perturbed walking/fw perturbation step with right foot/target error
      filename = [result_dir, "/", "pert_right_fw_target_error.yaml"];
      saveVector(filename, sorted_data.pert.fw.r_step.target_error);
      # perturbed walking/fw perturbation step with right foot/success_rate
      filename = [result_dir, "/", "pert_right_fw_success_rate.yaml"];
      saveScalar(filename, sorted_data.pert.fw.r_step.success_rate);
    endif
    
    if isfield(sorted_data.pert,'fwiw')
      if ~isfield(sorted_data.pert.fwiw,'l_step')
        sorted_data.pert.fwiw.l_step.step_length = nan(1,4);
        sorted_data.pert.fwiw.l_step.step_width = nan(1,4);
        sorted_data.pert.fwiw.l_step.step_time = nan(1,4);
        sorted_data.pert.fwiw.l_step.target_error = nan;
        sorted_data.pert.fwiw.l_step.success_rate = 0;
      end
      # perturbed walking/fwiw perturbation step with left foot/step length
      filename = [result_dir, "/", "pert_left_fwiw_step_length.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwiw.l_step.step_length);
      # perturbed walking/fwiw perturbation step with left foot/step width
      filename = [result_dir, "/", "pert_left_fwiw_step_width.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwiw.l_step.step_width);
      # perturbed walking/fwiw perturbation step with left foot/step time
      filename = [result_dir, "/", "pert_left_fwiw_step_time.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwiw.l_step.step_time);
      # perturbed walking/fwiw perturbation step with left foot/target error
      filename = [result_dir, "/", "pert_left_fwiw_target_error.yaml"];
      saveVector(filename, sorted_data.pert.fwiw.l_step.target_error);
      # perturbed walking/fwiw perturbation step with left foot/success_rate
      filename = [result_dir, "/", "pert_left_fwiw_success_rate.yaml"];
      saveScalar(filename, sorted_data.pert.fwiw.l_step.success_rate);
      if ~isfield(sorted_data.pert.fwiw,'r_step')
        sorted_data.pert.fwiw.r_step.step_length = nan(1,4);
        sorted_data.pert.fwiw.r_step.step_width = nan(1,4);
        sorted_data.pert.fwiw.r_step.step_time = nan(1,4);
        sorted_data.pert.fwiw.r_step.target_error = nan;
        sorted_data.pert.fwiw.r_step.success_rate = 0;
      end
      # perturbed walking/fwiw perturbation step with right foot/step length
      filename = [result_dir, "/", "pert_right_fwiw_step_length.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwiw.r_step.step_length);
      # perturbed walking/fwiw perturbation step with right foot/step width
      filename = [result_dir, "/", "pert_right_fwiw_step_width.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwiw.r_step.step_width);
      # perturbed walking/fwiw perturbation step with right foot/step time
      filename = [result_dir, "/", "pert_right_fwiw_step_time.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwiw.r_step.step_time);
      # perturbed walking/fwiw perturbation step with right foot/target error
      filename = [result_dir, "/", "pert_right_fwiw_target_error.yaml"];
      saveVector(filename, sorted_data.pert.fwiw.r_step.target_error);
      # perturbed walking/fwiw perturbation step with right foot/success_rate
      filename = [result_dir, "/", "pert_right_fwiw_success_rate.yaml"];
      saveScalar(filename, sorted_data.pert.fwiw.r_step.success_rate);
    endif
    
    if isfield(sorted_data.pert,'fwow')
      if ~isfield(sorted_data.pert.fwow,'l_step')
        sorted_data.pert.fwow.l_step.step_length = nan(1,4);
        sorted_data.pert.fwow.l_step.step_width = nan(1,4);
        sorted_data.pert.fwow.l_step.step_time = nan(1,4);
        sorted_data.pert.fwow.l_step.target_error = nan;
        sorted_data.pert.fwow.l_step.success_rate = 0;
      end
      # perturbed walking/fwow perturbation step with left foot/step length
      filename = [result_dir, "/", "pert_left_fwow_step_length.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwow.l_step.step_length);
      # perturbed walking/fwow perturbation step with left foot/step width
      filename = [result_dir, "/", "pert_left_fwow_step_width.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwow.l_step.step_width);
      # perturbed walking/fwow perturbation step with left foot/step time
      filename = [result_dir, "/", "pert_left_fwow_step_time.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwow.l_step.step_time);
      # perturbed walking/fwow perturbation step with left foot/target error
      filename = [result_dir, "/", "pert_left_fwow_target_error.yaml"];
      saveVector(filename, sorted_data.pert.fwow.l_step.target_error);
      # perturbed walking/fwow perturbation step with left foot/success_rate
      filename = [result_dir, "/", "pert_left_fwow_success_rate.yaml"];
      saveScalar(filename, sorted_data.pert.fwow.l_step.success_rate);
      if ~isfield(sorted_data.pert.fwow,'r_step')
        sorted_data.pert.fwow.r_step.step_length = nan(1,4);
        sorted_data.pert.fwow.r_step.step_width = nan(1,4);
        sorted_data.pert.fwow.r_step.step_time = nan(1,4);
        sorted_data.pert.fwow.r_step.target_error = nan;
        sorted_data.pert.fwow.r_step.success_rate = 0;
      end
      # perturbed walking/fwow perturbation step with right foot/step length
      filename = [result_dir, "/", "pert_right_fwow_step_length.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwow.r_step.step_length);
      # perturbed walking/fwow perturbation step with right foot/step width
      filename = [result_dir, "/", "pert_right_fwow_step_width.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwow.r_step.step_width);
      # perturbed walking/fwow perturbation step with right foot/step time
      filename = [result_dir, "/", "pert_right_fwow_step_time.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.fwow.r_step.step_time);
      # perturbed walking/fwow perturbation step with right foot/target error
      filename = [result_dir, "/", "pert_right_fwow_target_error.yaml"];
      saveVector(filename, sorted_data.pert.fwow.r_step.target_error);
      # perturbed walking/fwow perturbation step with right foot/success_rate
      filename = [result_dir, "/", "pert_right_fwow_success_rate.yaml"];
      saveScalar(filename, sorted_data.pert.fwow.r_step.success_rate);
    endif
    
    if isfield(sorted_data.pert,'iw')
      if ~isfield(sorted_data.pert.iw,'l_step')
        sorted_data.pert.iw.l_step.step_length = nan(1,4);
        sorted_data.pert.iw.l_step.step_width = nan(1,4);
        sorted_data.pert.iw.l_step.step_time = nan(1,4);
        sorted_data.pert.iw.l_step.target_error = nan;
        sorted_data.pert.iw.l_step.success_rate = 0;
      end
      # perturbed walking/iw perturbation step with left foot/step length
      filename = [result_dir, "/", "pert_left_iw_step_length.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.iw.l_step.step_length);
      # perturbed walking/iw perturbation step with left foot/step width
      filename = [result_dir, "/", "pert_left_iw_step_width.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.iw.l_step.step_width);
      # perturbed walking/iw perturbation step with left foot/step time
      filename = [result_dir, "/", "pert_left_iw_step_time.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.iw.l_step.step_time);
      # perturbed walking/iw perturbation step with left foot/target error
      filename = [result_dir, "/", "pert_left_iw_target_error.yaml"];
      saveVector(filename, sorted_data.pert.iw.l_step.target_error);
      # perturbed walking/iw perturbation step with left foot/success_rate
      filename = [result_dir, "/", "pert_left_iw_success_rate.yaml"];
      saveScalar(filename, sorted_data.pert.iw.l_step.success_rate);
      if ~isfield(sorted_data.pert.iw,'r_step')
        sorted_data.pert.iw.r_step.step_length = nan(1,4);
        sorted_data.pert.iw.r_step.step_width = nan(1,4);
        sorted_data.pert.iw.r_step.step_time = nan(1,4);
        sorted_data.pert.iw.r_step.target_error = nan;
        sorted_data.pert.iw.r_step.success_rate = 0;
      end
      # perturbed walking/iw perturbation step with right foot/step length
      filename = [result_dir, "/", "pert_right_iw_step_length.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.iw.r_step.step_length);
      # perturbed walking/iw perturbation step with right foot/step width
      filename = [result_dir, "/", "pert_right_iw_step_width.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.iw.r_step.step_width);
      # perturbed walking/iw perturbation step with right foot/step time
      filename = [result_dir, "/", "pert_right_iw_step_time.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.iw.r_step.step_time);
      # perturbed walking/iw perturbation step with right foot/target error
      filename = [result_dir, "/", "pert_right_iw_target_error.yaml"];
      saveVector(filename, sorted_data.pert.iw.r_step.target_error);
      # perturbed walking/iw perturbation step with right foot/success_rate
      filename = [result_dir, "/", "pert_right_iw_success_rate.yaml"];
      saveScalar(filename, sorted_data.pert.iw.r_step.success_rate);
    endif
    
    if isfield(sorted_data.pert,'ow')
      if ~isfield(sorted_data.pert.ow,'l_step')
        sorted_data.pert.ow.l_step.step_length = nan(1,4);
        sorted_data.pert.ow.l_step.step_width = nan(1,4);
        sorted_data.pert.ow.l_step.step_time = nan(1,4);
        sorted_data.pert.ow.l_step.target_error = nan;
        sorted_data.pert.ow.l_step.success_rate = 0;
      end
      # perturbed walking/ow perturbation step with left foot/step length
      filename = [result_dir, "/", "pert_left_ow_step_length.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.ow.l_step.step_length);
      # perturbed walking/ow perturbation step with left foot/step width
      filename = [result_dir, "/", "pert_left_ow_step_width.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.ow.l_step.step_width);
      # perturbed walking/ow perturbation step with left foot/step time
      filename = [result_dir, "/", "pert_left_ow_step_time.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.ow.l_step.step_time);
      # perturbed walking/ow perturbation step with left foot/target error
      filename = [result_dir, "/", "pert_left_ow_target_error.yaml"];
      saveVector(filename, sorted_data.pert.ow.l_step.target_error);
      # perturbed walking/ow perturbation step with left foot/success_rate
      filename = [result_dir, "/", "pert_left_ow_success_rate.yaml"];
      saveScalar(filename, sorted_data.pert.ow.l_step.success_rate);
      if ~isfield(sorted_data.pert.ow,'r_step')
        sorted_data.pert.ow.r_step.step_length = nan(1,4);
        sorted_data.pert.ow.r_step.step_width = nan(1,4);
        sorted_data.pert.ow.r_step.step_time = nan(1,4);
        sorted_data.pert.ow.r_step.target_error = nan;
        sorted_data.pert.ow.r_step.success_rate = 0;
      end
      # perturbed walking/ow perturbation step with right foot/step length
      filename = [result_dir, "/", "pert_right_ow_step_length.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.ow.r_step.step_length);
      # perturbed walking/ow perturbation step with right foot/step width
      filename = [result_dir, "/", "pert_right_ow_step_width.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.ow.r_step.step_width);
      # perturbed walking/ow perturbation step with right foot/step time
      filename = [result_dir, "/", "pert_right_ow_step_time.yaml"];
      saveLabelledMatrix(filename, sorted_data.pert.ow.r_step.step_time);
      # perturbed walking/ow perturbation step with right foot/target error
      filename = [result_dir, "/", "pert_right_ow_target_error.yaml"];
      saveVector(filename, sorted_data.pert.ow.r_step.target_error);
      # perturbed walking/ow perturbation step with right foot/success_rate
      filename = [result_dir, "/", "pert_right_ow_success_rate.yaml"];
      saveScalar(filename, sorted_data.pert.ow.r_step.success_rate);
    endif
    
    
    
    ## VISUAL REPRESENTATION OF THE RESULTS IN .PDF ############################
    display("Plotting data to pdf...")
    
    filename = [result_dir, "/", "plot_results.pdf"];
    plotResults(filename, personal_data, testbed_data, sorted_data);
    
    
    ## OUTPUT DATA AS STRUCTURE
    data.raw_data = raw_data;
    data.testbed_data = testbed_data;
    data.personal_data = personal_data;
    data.sorted_data = sorted_data;
    
    
endfunction