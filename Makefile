# Clean out team folders
clean:
	rm -r levelup/docker-volumes

infrastructure:
	aws cloudformation create-stack --stack-name coder-stack --template-body file://coder-workspaces.cfn.yml --parameters ParameterKey=NumTeams,ParameterValue=4 ParameterKey=InstanceType,ParameterValue=t3.2xlarge > stack-id.json

infrastructure-list:
	aws cloudformation describe-stacks --stack-name coder-stack

infrastructure-delete:
	aws cloudformation delete-stack --stack-name coder-stack

# Setup for ec2 - assumes sudo bash with yum install docker git already run
bootstrap-ec2:
	service docker start
	curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64" -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
	ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Create shared directories
bootstrap:
	mkdir -p levelup/docker-volumes
	mkdir -p levelup/.m2/repository
	python3 -m pip install pyyaml
	python3 -m pip install docker-compose
	docker pull ghcr.io/jpwhite3/polyglot-code-server:latest

# Create docker compose - set NUM_TEAMS equal to the number of container to generate
compose: bootstrap
	python3 docker-compose-composer.py $(NUM_TEAMS)

# example: make start NUM_TEAMS = 3 
start: compose
	docker-compose up -d --remove-orphans

stop:
	docker-compose stop
