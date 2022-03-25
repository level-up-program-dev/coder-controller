# Clean out team folders
clean:
	rm -r levelup/docker-volumes
# Create shared directories
setup:
	mkdir -p levelup/docker-volumes
	mkdir -p levelup/.m2

# Create docker compose - set NUM_TEAMS equal to the number of container to generate
compose: setup
	python3 docker-compose-composer.py $(NUM_TEAMS)

# example: make start NUM_TEAMS = 3 
start: compose
	docker-compose up -d --remove-orphans

stop:
	docker-compose stop