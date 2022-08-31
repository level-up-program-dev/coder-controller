import argparse
import json
from pathlib import Path

VOLUME_BASE_PATH = Path("./volumes/")
M2_CACHE_PATH = VOLUME_BASE_PATH.joinpath(".m2").absolute()
BASE_PORT = 9000
BASE_SERVICES = {
    "services": {
        "portainer": {
            "container_name": "portainer",
            "image": "portainer/portainer-ce:latest",
            "restart": "unless-stopped",
            "security_opt": ["no-new-privileges:true"],
            "ports": [f"{BASE_PORT}:{BASE_PORT}"],
            "command": '--admin-password "$$2y$$05$$aJra7SE2l6NWlmGlW.qzneJBDBtQbLNu/n2RFvYzVGZnlVxsIDiXC"',
            "volumes": [
                "/etc/localtime:/etc/localtime:ro",
                "/var/run/docker.sock:/var/run/docker.sock:ro",
                f"{VOLUME_BASE_PATH.joinpath('portainer').absolute()}:/data",
            ],
        }
    }
}


def main():
    parser = argparse.ArgumentParser(
        description="Creates a docker-compose.json file for the specified number of instances"
    )
    parser.add_argument(
        "-n",
        type=int,
        action="store",
        default=1,
        dest="num_teams",
        help="Number of instances to create (default=1)",
    )
    args = parser.parse_args()

    M2_CACHE_PATH.mkdir(exist_ok=True, parents=True)

    for i in range(1, args.num_teams + 1):
        service_name = f"coder-instance-{i}"
        volume_path = VOLUME_BASE_PATH.joinpath(service_name).absolute()
        port = BASE_PORT + i
        BASE_SERVICES["services"][service_name] = {
            "container_name": service_name,
            "image": "ghcr.io/jpwhite3/polyglot-code-server:latest",
            "restart": "unless-stopped",
            "working_dir": "/config/workspace",
            "ports": [f"{port}:{BASE_PORT}"],
            "volumes": [
                f"{volume_path}:/config/workspace",
                f"{M2_CACHE_PATH}:/root/.m2",
            ],
        }

    with open(r"docker-compose.json", "w") as file:
        json.dump(BASE_SERVICES, file, indent=4)


if __name__ == "__main__":
    main()
