.PHONY: build

run:
	love .

build:
	ruby ./scripts/build.rb

debug:
	love . --console