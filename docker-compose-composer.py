import sys
import yaml

# If you don't run this through make, ensure these folders exist locally
m2path = "./levelup/.m2"
volumePath = "./levelup/docker-volumes/"

# INPUT VAR OF HOW MANY TEAMS TO CREATE
if len(sys.argv) == 2:
    numTeams = int(sys.argv[1])
else:
    numTeams = 1


# clear out docker-compose.yaml
with open(r"docker-compose.yml", "w") as file:
    file.truncate(0)
docker_settings_all_teams = {}

# create a set of config for each team
for i in range(numTeams):
    # volume folder for team
    teamName = "Team" + str(i + 1)
    path = volumePath + teamName

    # Map 3 unique ports per team (first port is how to get to coder)
    port_base_1 = 9000 + i + 1
    port_base_2 = 10000 + i + 1
    port_base_3 = 11000 + i + 1

    # Docker compose structure
    team_settings_dict = {
        "build": ".",
        "ports": [
            str(port_base_1) + ":9000",
            str(port_base_2) + ":9001",
            str(port_base_3) + ":9002",
        ],
        "volumes": [path + ":/config/workspace", m2path + ":/root/.m2"],
        "image": "ghcr.io/jpwhite3/polyglot-code-server:latest",
        "working_dir": "/config/workspace",
    }

    docker_settings_all_teams[teamName] = team_settings_dict

# Add portainer as a supervisor
portainer = {
    "image": "portainer/portainer-ce:latest",
    "container_name": "portainer",
    "restart": "unless-stopped",
    "security_opt": ["no-new-privileges:true"],
    "volumes": [
        "/etc/localtime:/etc/localtime:ro",
        "/var/run/docker.sock:/var/run/docker.sock:ro",
        "./portainer-data:/data",
    ],
    "ports": ["9000:9000"],
}

docker_settings_all_teams["portainer"] = portainer

docker_settings = {"services": docker_settings_all_teams}

with open(r"docker-compose.yml", "a") as file:
    documents = yaml.dump(docker_settings, file)
