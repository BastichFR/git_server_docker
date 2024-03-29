CURRENT_IP  := $(shell curl -s -4 ifconfig.me)
CURRENT_UID := $(shell id -u)
ROOT_UID    := 0

export CURRENT_IP
export CURRENT_UID
export ROOT_UID

main:
	@if [ $(CURRENT_UID) -eq $(ROOT_UID) ]; then \
		echo "====================================================================="; \
		echo "current IP is : $(CURRENT_IP):2222"; \
		echo "connect: 'ssh -p 2222 git@$(CURRENT_IP)' to connect to the server"; \
		echo "====================================================================="; \
	else \
		echo "You are not logged in as root"; \
		echo "Switching to root with sudo..."; \
		sudo -s; \
	fi

# ==================================================

start_dk:  
	systemctl start docker

stop_dk: 
	systemctl stop docker

# ==================================================

run: main
	docker run  -d \
				-p 2222:22 \
				-v ./git-repositories:/home/git/repositories \
				--name git-server git-server:latest 

stop: main
	docker stop git-server

build: main
	docker build git-server/ -t git-server:latest

remove: main
	docker rm git-server
	docker rmi git-server

restart: main
	docker restart git-server

kill: stop remove

do: build run

redo: kill do

# ==================================================

exec_root: 
	docker exec -it git-server bash

exec_user: 
	docker exec -itu git git-server bash

# ==================================================

.PHONY: main start_dk stop_dk run stop build remove kill do redo exec_root exec_user