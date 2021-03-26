IMAGE_NAME=hhyc2
DOCKER_RUN=docker run -it --rm --network=bridge -v $(PWD):/usr/src/pec -w /usr/src/pec $(IMAGE_NAME)

build:
	docker build -f ../Dockerfile -t $(IMAGE_NAME) .
	$(DOCKER_RUN) npm i

destroy:
	docker rmi $(IMAGE_NAME)

start:
	$(DOCKER_RUN) npm start
	
exec:
	$(DOCKER_RUN) $(ARGS)
