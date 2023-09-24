RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(RUN_ARGS):;@:)

build:
	docker build -t docker-swarm-expose-test-nextjs .

publish:
	docker tag docker-swarm-expose-test-nextjs indapublic/docker-swarm-expose-test-nextjs:$(RUN_ARGS) && \
	docker push indapublic/docker-swarm-expose-test-nextjs:$(RUN_ARGS) && \
	docker image rm indapublic/docker-swarm-expose-test-nextjs:$(RUN_ARGS) && \
	docker image rm docker-swarm-expose-test-nextjs

deploy:
	docker stack deploy --with-registry-auth -c stack.yaml docker-swarm-expose-test-nextjs
