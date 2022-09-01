import os
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

    args = parser.parse_args()

    clone = f"git clone {args.repo}"
    service_name = "coder-instance-*"
    
    file_list = VOLUME_BASE_PATH.glob(service_name)
    for team_dir in file_list:
        # Specifying the path where the cloned project needs to be copied
        full_dir_clone = f"{clone} {team_dir}"
        os.system(full_dir_clone)  # Cloning

if __name__ == "__main__":
    main()
