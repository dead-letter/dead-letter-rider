PB_DIR_IN=../dead-letter-manifests/protos
PB_DIR_OUT=./pb
PROTOC=$(shell which protoc)

## help: print this help message
.PHONY: help
help:
	@echo "Usage:"
	@sed -n "s/^##//p" ${MAKEFILE_LIST} | column -t -s ":" |  sed -e "s/^/ /"

# proto/check: check for necessary build tools and directories
.PHONY: proto/check
proto/check:
	@which protoc > /dev/null || { echo "❌ protoc not found"; exit 1; }
	@which protoc-gen-python_betterproto > /dev/null || { echo "❌ protoc-gen-python_betterproto not found"; exit 1; }
	@[ -d "$(PB_DIR_IN)" ] || { echo "❌ PB_DIR_IN $(PB_DIR_IN) does not exist"; exit 1; }


## proto/gen: generate protoc stubs
.PHONY: proto/gen
proto/gen: proto/check
	@mkdir -p $(PB_DIR_OUT)
	python -m grpc_tools.protoc \
		--proto_path=$(PB_DIR_IN) \
		--python_betterproto_out=$(PB_DIR_OUT) \
		data.proto
	@echo "✅ Generated gRPC code for data.proto"


## proto/clean: clean generated files
.PHONY: proto/clean
proto/clean:
	@rm -f $(PB_DIR_OUT)/*.py
	@echo "🗑️  Cleaned generated files"

# confirmation dialog helper
.PHONY: confirm
confirm:
	@echo -n "Are you sure? [y/N] " && read ans && [ $${ans:-N} = y ]
