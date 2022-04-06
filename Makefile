# Clean out team folders
clean:
	rm -r levelup/docker-volumes

# Setup for ec2 - assumes sudo bas with yum install docker git already run
setup_ec2:
	curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
	ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
	service docker start

# Create shared directories
setup:
	mkdir -p levelup/docker-volumes
	mkdir -p levelup/.m2/repository
	python3 -m pip install pyyaml
	docker pull ghcr.io/jpwhite3/polyglot-code-server:latest

# Create docker compose - set NUM_TEAMS equal to the number of container to generate
compose: setup
	python3 docker-compose-composer.py $(NUM_TEAMS)

# example: make start NUM_TEAMS = 3 
start: compose
	docker-compose up -d --remove-orphans

stop:
	docker-compose stop