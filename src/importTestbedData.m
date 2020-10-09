function data = importTestbedData(testbed_file)
################################################################################
# 'function data = importTestbedData(testbed_file)'
#
# Imports data from subject_X_cond_Y_run_Z_testbed.yaml
#
# Copyright BeStable project 2020
#
################################################################################
    
    fid = fopen(testbed_file);
    spec = "%s %s";
    infile = textscan(fid, spec, 'Delimiter', ':');
    labels = infile{1};
    str_values = infile{2};
    for i = 1:size(labels,1)
      label = labels{i};
      if isempty(str2num(str_values{i}))
        data.(label) = str_values{i};
      else
        data.(label) = str2num(str_values{i});
      endif
    endfor
    fclose(fid);
    
endfunction