# Gait performance analysis

The code was developed by BeStable for Eurobench purposes.

## Description

The current entry point is [computePI.m](computePI.m).

```octave
computePI("[path_to]/platformData.csv", "[path_to]/testbed.yaml", result_dir)
```

Current test files are located in [input folder](../test_data/input)
- `csv_file = "../test_data/input/subject_2_cond_2_run_1_platformData.csv"`
- `testbed_file = "../test_data/input/subject_2_cond_2_testbed.yaml"`

and the results are stored in the [output folder](../test_data/output).
- `result_dir = "../test_data/output/"`

The input parameters are:

- `platformData.csv`: a *csv* file containing stepstamped PI data with the following header:

    | variable 1 | variable 2 | variable 3 | variable 4 | variable 5 | variable 6 | variable 7 | variable 8 | variable 9 |
    | -- | -- | -- | -- | -- | -- | -- | -- | -- |
    | step_number | time_stamp | limb_initial | limb_final | step_width	| step_length |	step_time |	target_error | message |

- `testbed.yaml`: a *yaml* file containing subject information and protocol parameters.
- `result_dir`: a *path* to directory, where output *yaml* files should be stored

The current code is to be launched **per trial**.
The file `subject_2_cond_2_run_1_gaitEvents.txt` is currently not used as an input by any function.

## Code structure

The main function `computePI.m` uses six functions to obtain measured data from the BeStable testbed:

- `importData.m`: Imports data from `subject_X_cond_Y_run_Z_platformData.csv` file.

- `importTestbedData.m`: Imports data from `subject_X_cond_Y_run_Z_testbed.yaml`

- `sortData.m`: Sort data containing PI of consecutive steps to:
    1. **base**: unperturbed walking before enabling perturbations
    2. **free**: unperturbed walking after enabling perturbations
    3. **pert**: perturbed walking as a stepping response to applied perturbations

- `saveVector.m`:
Save vector data into *yaml* file

- `saveLabelledMatrix.m`: Save labelled matrix data into *yaml* file where each column represent PI score of the consecutive step after perturbation onset for all perturbation repetitions. It has the following structure:

    |  | step 1 | step 2 | step 3 | step 4 |
    | -- | -- | -- | -- | -- |
    | repetition 1 | PI score | PI score | PI score | PI score |
    | repetition 2 | PI score | PI score | PI score | PI score |
    | ...          | PI score | PI score | PI score | PI score |
    | repetition N | PI score | PI score | PI score | PI score |

- `plotResults.m`: Plots the results and save as *pdf*. 