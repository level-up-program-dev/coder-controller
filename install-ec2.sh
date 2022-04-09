#!/bin/bash -xe

cd /
git clone https://github.com/level-up-program/coder-controller.git
cd /coder-controller
make bootstrap_ec2
make start NUM_TEAMS=$NUM_TEAMS
