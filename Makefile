SHELL := /bin/bash

.PHONY: all check test clean list

all: check

check test:
	./scripts/check_all.sh

clean:
	./scripts/clean_all.sh

list:
	./scripts/list_assignments.sh
