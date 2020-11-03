function data = importData(csv_file)
################################################################################
# 'function data = importData(csv_file)'
#
# Imports data from subject_X_cond_Y_run_Z_platformData.csv
#
# Copyright BeStable project 2020
#
################################################################################
    
    DATA = importdata(csv_file, ';', 2);
    text_data = DATA.textdata(3:end);
    
    data.step_number = DATA.data(:,1);
    data.time_stamp = DATA.data(:,2);
    data.limb_initial = text_data(1:3:end);
    data.limb_final = text_data(2:3:end);
    data.step_width = DATA.data(:,5);
    data.step_length = DATA.data(:,6);
    data.step_time = DATA.data(:,7);
    data.target_error = DATA.data(:,8);
    data.message = text_data(3:3:end);
    
    
endfunction