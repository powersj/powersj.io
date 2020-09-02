all: server

publish:
	./publish.sh

server:
	hugo server --watch

.PHONY: all publish server

