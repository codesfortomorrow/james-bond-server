GOBIN = ./bin

build:
	mkdir -p $(GOBIN)
	go build -o bin/main main.go
	@echo "Success";

run:
	go run main.go

clean:
	rm -rf $(GOBIN)
	@echo "Done";

all:
	make build