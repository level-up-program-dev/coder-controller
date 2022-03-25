import json
import sys
import yaml
import os

#ASSUMES THIS EXISTS
m2path = "./levelup/.m2"
volumePath = "./levelup/docker-volumes/"
#ASSUMES INPUT VAR OF HOW MANY TEAMS TO CREATE
if len(sys.argv) == 2:
    numTeams = int(sys.argv[1])
else:
    numTeams = 1

docker_settings_team = {'build': '.', 'ports': ['&PORT1:9000', '&PORT2:9001', '&PORT3:9002'], 'volumes': ['&TEAM_PATH:/config', '&TEAM_HOME:/root', m2path+':/root/.m2'], 'image': 'ghcr.io/jpwhite3/polyglot-code-server:latest', 'working_dir': '/config/workspace'}
docker_settings_all_teams = {}


#clear out docker-compose.yaml
with open(r'docker-compose.yml', 'w') as file:
    file.truncate(0)

#create a set of commands for each team
for i in range(numTeams):
    settings_str = json.dumps(docker_settings_team)
    teamName = 'Team' + str(i+1)
    #create volume folder for team
    path = volumePath + teamName + "/workspace"
    pathHome = volumePath + teamName + "_home"
    if not os.path.exists(path):
        os.makedirs(path)
    if not os.path.exists(pathHome):
        os.makedirs(pathHome)

    port_base_1 = 9000 + i + 1
    port_base_2 = 10000 + i + 1
    port_base_3 = 11000 + i + 1
    settings_str = settings_str.replace("&TEAM_PATH", path)
    settings_str = settings_str.replace("&TEAM_HOME", pathHome)
    settings_str = settings_str.replace("&PORT1", str(port_base_1))
    settings_str = settings_str.replace("&PORT2", str(port_base_2))
    settings_str = settings_str.replace("&PORT3", str(port_base_3))

    team_settings_dict = json.loads(settings_str)
    docker_settings_all_teams[teamName] = team_settings_dict

docker_settings = {'services': docker_settings_all_teams}

with open(r'docker-compose.yml', 'a') as file:
    documents = yaml.dump(docker_settings, file)