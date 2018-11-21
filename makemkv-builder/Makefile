COMPOSE_FILE:=docker-compose.yml
all:
	docker-compose build
	docker-compose up -d
	docker cp makemkv-builder:/output/makemkv.tar.gz .
	docker-compose down
