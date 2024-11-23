.PHONY: protos
protos:
	@echo "Did you copy momentohq/client_protos/protos/*.proto to internal/protos?"
	# this file is not needed and causes errors, so make sure it's not present
	rm -f Sources/Momento/internal/protos/httpcache.proto

	protoc -I=Sources/Momento/internal/protos \
		--proto_path=Sources/Momento/internal/protos \
		--plugin=$(shell which protoc-gen-grpc-swift) \
		--grpc-swift_opt=Visibility=Public \
		--grpc-swift_out=Sources/Momento/internal/protos \
		Sources/Momento/internal/protos/*.proto

	protoc -I=Sources/Momento/internal/protos \
		--proto_path=Sources/Momento/internal/protos \
		--plugin=$(shell which protoc-gen-swift) \
		--swift_opt=Visibility=Public \
		--swift_out=Sources/Momento/internal/protos \
		Sources/Momento/internal/protos/*.proto

.PHONY: build
build:
	swift build
	
.PHONY: test
test:
	swift test
