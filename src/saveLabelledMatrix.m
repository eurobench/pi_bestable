function saveLabelledMatrix(filename, data)
################################################################################
# 'function saveLabelledMatrix(filename, data)'
#
# Save labelled matrix data into yaml file where each column represent 
# PI score of the consecutive step after perturbation onset for all perturbation
# repetitions:
#               | step1 | step2 | step3 | step4 |
#   ------------|-------|-------|-------|-------|
#   repetition1 |       |       |       |       |
#   repetition2 |       |       |       |       |
#       ...     |       |       |       |       |
#   repetitionN |       |       |       |       |
#
# Copyright BeStable project 2020
#
################################################################################

    fid = fopen(filename, "w");
    fputs(fid,"type: 'matrix'\n");
    fputs(fid,"col_label: [step1, step2, step3, step4]\n");

    row_label = "";
    for k = 1:size(data,1)
      row_label = [row_label, ["repetition" num2str(k) ", "]];
    endfor
    fputs(fid,["row_label: [" row_label(1:end-2) "]\n"]);

    labelled_matrix_str = "value: [";
    for k = 1:size(data,1)
      row_str = num2str(data(k,:), "%1.5f, ");
      labelled_matrix_str = [labelled_matrix_str, ["[" row_str(1:end-1) "], "]];
    endfor
    labelled_matrix_str = [labelled_matrix_str(1:end-2) "]\n"];
    fputs(fid,labelled_matrix_str);
    fclose(fid);
endfunction
