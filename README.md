# BeStable project

Benchmarking System for Assessment of Balance Performance (BeStaBle) is a funded project of the Eurobench cover project.

Copyright BeStable 2020

This is an example of Performance Indicator implemented in Octave.
It is prepared to be used within the Eurobench Benchmarking Software.

## Purposes

Characterize the gait performances (performance indicators - PI) of a walking human subject (step length, step width, step time and target error).
More technical details are provided within the code [README](src/README.md)

### Testbed data collection

The operator inputs subject information and selects perturbation parameters (protocol condition) in D-Flow testbed software (Runtime Console). 

The system checks if perturbation parameters are the same as in previous run (if any). If yes, the system increase run (Z) number, while the condition file (Y) remains the same. If not, the system increase Y and start with new run (Z=1).
Note that only previous condition file is checked with current protocol parameters.
Block diagram. 

The BeStable testbed outputs the following files:
1. subject_X_info.yaml
2. subject_X_condition_Y.yaml
3. subject_X_cond_Y_run_Z_platformData.csv
4. subject_X_cond_Y_run_Z_gaitEvents.csv

Files 1-3 need to be uploaded for the performance indicators calculation process, where the following files are generated:
1. base_step_length_{left, right}.yaml
2. base_step_width_{left, right}.yaml
3. base_step_time_{left, right}.yaml

4. free_step_length_{left, right}.yaml
5. free_step_width_{left, right}.yaml
6. free_step_time_{left, right}.yaml

7. pert_{left, right}_{fw, fwiw, fwow, iw, ow}_step_length.yaml
8. pert_{left, right}_{fw, fwiw, fwow, iw, ow}_step_width.yaml
9. pert_{left, right}_{fw, fwiw, fwow, iw, ow}_step_time.yaml
10. pert_{left, right}_{fw, fwiw, fwow, iw, ow}_target_error.yaml
11. pert_{left, right}_{fw, fwiw, fwow, iw, ow}_success_rate.yaml

12. data (Octave file containing all data)
13. plot_results.pdf (plotted results with boxplots)

Performance indicators collected in files 1-3 relate to nonperturbed baseline walking (before enabling perturbations).
Performance indicators collected in files 4-6 relate to nonperturbed walking inbetween perturbations (free walking).
Performance indicators collected in files 7-11 relate to perturbed walking, 4 steps from perturbation onset. See details in Readme.md


## Installation

To run the application the following dependencies are needed:

```console
sudo apt install fig2dev
pkg load statistics
```

## Usage

### from octave

Assuming we are in an Octave terminal, located at the root of this repository, the computation can be launched as follows:

```octave
# add source location to the octave path
addpath('src')
# we assume that a folder test_output has been previously created
computePI('test_data/input/subject_19_cond_2_run_1_platformData.csv', 'test_data/input/subject_19_condition_2.yaml', 'test_data/input/subject_19_info.yaml','test_output')
```

All Performance indicator files will be placed in the indicated folder `test_output`.


### using the script

The script `run_pi` launches this PI from the shell of a machine with Octave installed.
The permissions of this file must be changed in order to be executable:

```console
chmod 755 run_pi
```

Assuming folder `./test_data/input/` contains the input data, and that `./test_output` exists and will contain the resulting files, the shell command is:

```console
./run_pi ./test_data/input/subject_19_cond_2_run_1_platformData.csv  ./test_data/input/subject_19_condition_2.yaml ./test_data/input/subject_19_info.yaml ./out_tests
```

## Build docker image

_(only tested under linux)_

Run the following command in order to create the docker image for this PI:

```console
docker build . -t pi_bestable
```

## Launch the docker image

Assuming the `test_data/input` contains the input data, and that the directory `out_tests/` is **already created**, and will contain the PI output:

```shell
docker run --rm -v $PWD/test_data/input:/in -v $PWD/out_tests:/out pi_bestable ./run_pi /in/subject_19_cond_2_run_1_platformData.csv /in/subject_19_condition_2.yaml /in/subject_19_info.yaml /out
```

## Acknowledgements

<a href="http://eurobench2020.eu">
  <img src="http://eurobench2020.eu/wp-content/uploads/2018/06/cropped-logoweb.png"
       alt="rosin_logo" height="60" >
</a>

Supported by Eurobench - the European robotic platform for bipedal locomotion benchmarking.
More information: [Eurobench website][eurobench_website]

<img src="http://eurobench2020.eu/wp-content/uploads/2018/02/euflag.png"
     alt="eu_flag" width="100" align="left" >

This project has received funding from the European Union’s Horizon 2020
research and innovation programme under grant agreement no. 779963.

The opinions and arguments expressed reflect only the author‘s view and
reflect in no way the European Commission‘s opinions.
The European Commission is not responsible for any use that may be made
of the information it contains.

[eurobench_logo]: http://eurobench2020.eu/wp-content/uploads/2018/06/cropped-logoweb.png
[eurobench_website]: http://eurobench2020.eu "Go to website"
