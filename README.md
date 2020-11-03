# BeStable project

Benchmarking System for Assessment of Balance Performance (BeStaBle) is a funded project of the Eurobench cover project.

Copyright BeStable 2020

This is an example of Performance Indicator implemented in Octave.
It is prepared to be used within the Eurobench Benchmarking Software.

## Purposes

Characterize the gait performances (performance indicators - PI) of a walking human subject (step length, step width, step time and target error).
More technical details are provided within the code [README](src/README.md)

## Installation

To run the application the following Octave packages are needed:

pkg load statistics

## Usage

The script `run_pi` launches this PI from the shell of a machine with Octave installed.
The permissions of this file must be changed in order to be executable:

```console
chmod 755 run_pi
```

Assuming folder `./test_data/input/` contains the input data, and that `./test_data/output` exists and will contain the resulting files, the shell command is:

```console
./run_pi ./test_data/input/subject_2_cond_2_run_1_platformData.csv ./test_data/input/subject_2_cond_2_testbed.yaml ./test_data/input/subject_2_personalData.yaml ./test_data/output
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
docker run --rm -v $PWD/test_data/input:/in -v $PWD/out_tests:/out pi_bestable ./run_pi /in/subject_2_cond_2_run_1_platformData.csv /in/subject_2_cond_2_testbed.yaml /out
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