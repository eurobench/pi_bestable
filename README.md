# BeStable project

Copyright BeStable 2020

This is an example of Performance Indicator implemented in Octave.
It is prepared to be used within the Eurobench Benchmarking Software.


## Purposes

Characterize the gait performances (performance indicators - PI) of a walking human subject (step length, step width, step time and target error).
More technical details are provided within the code [README](src/README.md)


## Installation


## Usage

The script `run_pi` launches this PI from the shell of a machine with Octave installed.
The permissions of this file must be changed in order to be executable:

```console
chmod 755 run_pi
```

Assuming folder `./test_data/input/` contains the input data, and that `./test_data/output` exists and will contain the resulting files, the shell command is:

```console
./run_pi ./test_data/input/subject_10_trial_01.csv ./test_data/input/subject_10_anthropometry.yaml ./test_data/output
```


## Build docker image

## Launch the docker image

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