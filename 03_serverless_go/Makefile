.PHONY: build clean deploy

build:
	env GOARCH=amd64 GOOS=linux go build -ldflags="-s -w" -o bin/gecho gecho/main.go
	env GOARCH=amd64 GOOS=linux go build -ldflags="-s -w" -o bin/world world/main.go

clean:
	rm -rf ./bin

deploy: clean build
	sls deploy --stage local --verbose
