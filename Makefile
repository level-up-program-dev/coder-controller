# set TEAM_NAME to the team name provided to create-repos
# set CODER_INSTANCE_COUNT to the number of team members
env:
	aws cloudformation create-stack --stack-name $(TEAM_NAME) --template-body file://coder-workspaces.cfn.yml --parameters ParameterKey=EnvironmentCount,ParameterValue=$(CODER_INSTANCE_COUNT) ParameterKey=GitHubRepoURL,ParameterValue=https://github.com/level-up-program/team-$(TEAM_NAME).git ParameterKey=InstanceType,ParameterValue=t3.xlarge  > stack-id-$(TEAM_NAME).json

env-test:
	aws cloudformation create-stack --stack-name $(TEAM_NAME) --template-body file://coder-workspaces.cfn.yml --parameters ParameterKey=GitHubRepoURL,ParameterValue=https://github.com/level-up-program/team-$(TEAM_NAME).git ParameterKey=InstanceType,ParameterValue=t2.micro ParameterKey=EnvironmentCount,ParameterValue=2 > test-stack-id-$(TEAM_NAME).json

env-list:
	aws cloudformation describe-stacks --stack-name $(TEAM_NAME)

env-get-url:
	aws cloudformation describe-stacks --query 'Stacks[?StackName==`$(TEAM_NAME)`][].Outputs[?OutputKey==`PublicDomainName`].OutputValue' --output text > $(TEAM_NAME).URL

env-delete:
	aws cloudformation delete-stack --stack-name $(TEAM_NAME)

bootstrap:
	python3 -m pip install docker-compose

# set CODER_INSTANCE_COUNT= to the number of container to generate
compose:
	docker pull ghcr.io/jpwhite3/polyglot-code-server:latest
	python3 composer.py -n $(CODER_INSTANCE_COUNT)

# set TEAM_REPO to the git url for the code to clone
clone:	
	python3 cloner.py -r $(TEAM_REPO)

start:
	docker-compose -f docker-compose.json up -d --remove-orphans

stop:
	docker-compose -f docker-compose.json stop
