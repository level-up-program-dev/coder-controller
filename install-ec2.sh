#!/bin/bash -xe

sudo yum update -y

cd /
git clone https://github.com/level-up-program/coder-controller.git
cd /coder-controller
make bootstrap-ec2
make start NUM_TEAMS=6
