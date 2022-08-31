# Requires

docker desktop, docker compose, python3, Linux OS, awscli
docker pull ghcr.io/jpwhite3/polyglot-code-server:latest

# Assumptions

You need to already have created an EC2 SSh key named: coder-ec2-keypair

# Setup and start/stop for coder instances for teams

Makefile contains necessary commands
All directories for volume mounts will be created in the directory you execute in

## Create and start coder containers

```bash
make compose CODER_INSTANCE_COUNT=3
make start
```

will create a docker-compose.json with the settings for 3 containers. It will also ensure you have folders for each container's primary volume.

```bash
make stop
```

will stop all running coder containers

## PORTS to connect

- 8000 - Connect to portainer instance
- 8000+Instance# (ie 9001 for Instance #1) - Connect to coder instance
