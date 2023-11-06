.PHONY: protos
protos:
	@echo "Did you copy momentohq/client_protos/protos/*.proto to internal/protos?"
	# this file is not needed and causes errors, so make sure it's not present
	rm -f Sources/client-sdk-swift/internal/protos/httpcache.proto

	protoc -I=Sources/client-sdk-swift/internal/protos \
		--proto_path=Sources/client-sdk-swift/internal/protos \
		--plugin=$(shell which protoc-gen-grpc-swift) \
		--grpc-swift_opt=Visibility=Public \
		--grpc-swift_out=Sources/client-sdk-swift/internal/protos \
		Sources/client-sdk-swift/internal/protos/*.proto

	protoc -I=Sources/client-sdk-swift/internal/protos \
		--proto_path=Sources/client-sdk-swift/internal/protos \
		--plugin=$(shell which protoc-gen-swift) \
		--swift_opt=Visibility=Public \
		--swift_out=Sources/client-sdk-swift/internal/protos \
		Sources/client-sdk-swift/internal/protos/*.proto
