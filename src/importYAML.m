function data = importYAML(yaml_file)
################################################################################
# 'function data = importTestbedData(yaml_file)'
#
# Imports data from .yaml file and returns structure data
#
# Copyright BeStable project 2020
#
################################################################################
    
    fid = fopen(yaml_file);
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