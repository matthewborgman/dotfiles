#!/usr/bin/env bash

# Define custom Docker-related aliases

source "${DOTFILES_PATH}/functions/bootstrap.bash"

if commandExists docker; then

	alias dcl='docker ps'						# dcl:	List containers
	alias dcsa='docker stop $(docker ps -a -q)'	# dcsa:	Stop all running containers
	alias devl='docker events'					# devl:	Display events
	alias dexc='docker exec -it'				# dexc:	Execute a command in an interactive shell
	alias dl='docker logs'						# dl:	Display logs
	alias dlf='docker logs -f'					# dlf:	Display logs in real-time
	alias dnl='docker network ls'				# dnl:	List networks
	alias dnp='docker network prune'			# dnp:	Remove all unused networks
	alias dsp='docker system prune'				# dsp:	Remove unused data
	alias dvl='docker docker volume ls'			# dvl:	List volumes
	alias dvp='docker volume prune'				# dvp:	Remove all unused volumes
fi

if commandExists docker-compose; then

	alias dcd='docker-compose down --remove-orphans'			# dcd:	Stop and remove containers, networks, images' and volumes
	alias dclf='docker-compose logs -f'							# dclf:	Display container logs in real-time
#	alias dcu='docker-compose up --build --force-recreate -d'	# dcu:	Create and start containers
	alias dcu='docker-compose up -d'							# dcu:	Create and start containers
	alias dcp='docker-compose pause'							# dcp:	Pause containers
	alias dcup='docker-compose unpause'							# dcup:	Unpause containers
fi