FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install -y less \
    && apt-get install -y wget \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean
# prepare for launching the installation of dependencies defined in install.sh
ADD install.sh install.sh
RUN sh ./install.sh && rm install.sh
# create user account, and create user home dir
RUN useradd -ms /bin/bash octave

# cp all code files into user home dir
RUN mkdir /home/octave/bestable
ADD src /home/octave/bestable
ADD run_pi /home/octave/bestable

# set the user as owner of the copied files.
RUN chown -R octave:octave /home/octave/

USER octave
WORKDIR /home/octave/bestable
