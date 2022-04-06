# Requires 
docker desktop, and docker compose; Linux OS
# Setup and start/stop for coder instances for teams
Make file contains necessary commands
All directories for volume mounts will be created in the directory you execute in
Extra goal added for setting up an EC2 instance to run this

## Create and start coder containers

* make start NUM_TEAMS=3
  
will create a docker-compose.yml with the settings for 3 containers. It will also ensure you have folders for each container's primary volume.

* make stop

will stop all running coder containers

* make clean 

will remove team-specific folders, but keep persistent volumes like .m2

## PORTS to connect
Each team gets 3 ports  

* 9000+Team# (ie 9001 for Team1) - Connect to coder  
* 10000+Team# (ie 10001 for Team1) - Available for use from the container
* 11000+Team# (ie 11001 for Team1) - Available for use from the containr
