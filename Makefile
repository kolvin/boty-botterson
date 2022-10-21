OP_TOKEN_IDENTIFIER := "Boty Botterson token"
BOT_TOKEN = $(shell op item get $(OP_TOKEN_IDENTIFIER) --fields credential)
(BINARY_NAME):= boty-botterson

help:
	@printf "Usage: make [target] [VARIABLE=value]\nTargets:\n"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install: ## Install pre-commit hooks
	@pre-commit install

uninstall: ## Uninstall hooks
	@pre-commit uninstall

validate: ## Validate files with pre-commit hooks
	@pre-commit run --all-files

run: ## Go Run main
	cd app; go run main.go -t $$BOT_TOKEN

binary-run: ## Build and run binary
	cd app; go build -o ./bin/$(BINARY_NAME) main.go; ./bin/$(BINARY_NAME)

build: ## Complie
	cd app; go build -o ./bin/$(BINARY_NAME) main.go

compile: ## Complie Bot for every OS and Platform
	cd app && GOOS=darwin GOARCH=amd64 go build -o bin/$(BINARY_NAME)-amd64-darwin main.go
	cd app && GOOS=windows GOARCH=amd64 go build -o bin/$(BINARY_NAME)-amd64.exe main.go
	cd app && GOOS=linux GOARCH=amd64 go build -o bin/$(BINARY_NAME)-amd64-linux main.go

clean: ## Go Clean
	cd app; go clean; rm -rf ./bin
