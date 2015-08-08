all:
	crystal run src/cartel.cr

build:
	crystal build -o bin/cartel src/cartel.cr
