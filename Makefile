all: server

server:
	hugo server --watch

update:
	git submodule init
	git submodule update --remote

.PHONY: all server update
