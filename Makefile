CURRENT_IP  := $(shell curl -4 ifconfig.me)
CURRENT_UID := $(shell id -u)
ROOT_UID    := 0

export CURRENT_IP
export CURRENT_UID
export ROOT_UID

main:
ifeq ($(CURRENT_UID), $(ROOT_UID))
	@echo "current IP is : $(CURRENT_IP):2222"
	@echo "run : `ssh -p 2222 git@$(CURRENT_IP)` to connect to the server"
else
	@echo "You are not logged in as root"
	@echo "Switching to root with sudo..."
	@sudo -i
endif

# ==================================================

start_dk:  
	systemctl start docker

stop_dk: 
	systemctl stop docker

# ==================================================

run: 
	docker run  -d \
				-p 2222:22 \
				-v /home/bastich/Documents/temp/docker/git_server_docker/git-repositories:/home/git/repositories \
				--name git-server git-server:latest 

stop: 
	docker stop git-server

build: 
	docker build git-server/ -t git-server:latest

remove: 
	docker rm git-server
	docker rmi git-server

do: build run

redo: stop remove do

kill: stop remove

# ==================================================

exec_root: 
	docker exec -it git-server bash

exec_user: 
	docker exec -itu git git-server bash

# ==================================================

imgs:
	@docker images

ps:
	@docker ps -a

log:
	@ssh -p 2222 git@localhost

# ==================================================


.PHONY: main start_dk stop_dk run stop build remove do redo exec_root exec_user kill