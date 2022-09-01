import os
import sys
import argparse
from pathlib import Path

VOLUME_BASE_PATH = Path("./volumes/")


def main():
    parser = argparse.ArgumentParser(
        description="Clones the team's repo into each container's volumes"
    )
    parser.add_argument(
        "-r",
        type=str,
        action="store",
        dest="repo",
        required=True,
        help="Repository to clone",
    )
    parser.add_argument(
        "-n",
        type=int,
        action="store",
        default=1,
        dest="num_teams",
        help="Number of instances to clone into (default=1)",
    )
    args = parser.parse_args()

    clone = f"git clone {args.repo}"
    
    for i in range(1, args.num_teams + 1):
        service_name = f"coder-instance-{i}"
        volume_path = VOLUME_BASE_PATH.joinpath(service_name).absolute()

        # Specifying the path where the cloned project needs to be copied
        os.chdir(volume_path)
        os.system(clone)  # Cloning

if __name__ == "__main__":
    main()
