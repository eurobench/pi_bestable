function saveScalar(filename, data)
################################################################################
# 'function saveVector(filename, data)'
#
# Save vector data into yaml file
#
# Copyright BeStable project 2020
#
################################################################################

    fid = fopen(filename, "w");
    fputs(fid,"type: 'scalar'\n");
    vector_str = num2str(data, "%1.5f, ");
    fputs(fid,["value: [" vector_str(1:end-1) "]\n"]);
    fclose(fid);

endfunction