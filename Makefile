# ensure target stops if there is an error; run on a single shell
# .ONESHELL:
# SHELL = /usr/bin/perl
# .SHELLFLAGS = -e

# check if fvm command exists, otherwise use empty string
FVM_CMD := $(shell command -v fvm 2> /dev/null)
DART_CMD := $(FVM_CMD) dart

export PATH := $(HOME)/.pub-cache/bin:$(PATH)


.PHONY: all-short
all-short: version get analyze doc dry-run test

.PHONY: all
all: version get analyze doc dry-run test-all

.PHONY: kill
kill: 
	@echo "Killing service..."
	@kill -9 $(shell lsof -t -i:8181) || echo "Port 8181 is not in use"

.PHONY: publish
publish: all
	@echo "Publishing package..."
	$(DART_CMD) pub publish --force

.PHONY: dry-run
dry-run: kill
	@echo "Running dry-run..."
	$(DART_CMD) pub publish --dry-run

.PHONY: test
test: test-integration
	@echo "Running tests (exhaustive flag OFF)..."
	$(DART_CMD) test --test-randomize-ordering-seed=random

.PHONY: test-all
test-all: test-integration
	@echo "Running all tests (exhaustive flag ON)..."
	$(DART_CMD) --define=exhaustive=true test --test-randomize-ordering-seed=random --use-data-isolate-strategy

.PHONY: coverage
coverage:
	@echo "Running tests..."
	$(DART_CMD) pub global activate coverage
	$(DART_CMD) run coverage:test_with_coverage
	$(MAKE) format_lcov

.PHONY: get
get:
	@echo "Getting dependencies..."
	$(DART_CMD) pub get 

.PHONY: upgrade
upgrade:
	@echo "Upgrading dependencies..."
	$(DART_CMD) pub upgrade

.PHONY: downgrade
downgrade:
	@echo "Downgrading dependencies..."
	$(DART_CMD) pub downgrade


.PHONY: doc
doc:
	@echo "Generating documentation..."
	@$(DART_CMD) doc || echo "Failed to generate documentation - maybe it's dart 2.12?"

.PHONY: analyze
analyze:
	@echo "Analyzing..."
	$(DART_CMD) analyze --fatal-infos --fatal-warnings
	$(DART_CMD) format --set-exit-if-changed .

.PHONY: fix 
fix:
	$(DART_CMD) analyze || echo "Found errors to fix"
	$(DART_CMD) fix --apply

.PHONY: version
version:
	@echo "Checking version..."
	$(DART_CMD) --version


### Coverage ###

# ensure all files listed in the coverage report are relative paths
CWD := $(shell pwd)
FILES := $(shell find coverage/*.info -type f ! -path "$(CWD)")

.PHONY: format_lcov
format_lcov:
	@mkdir -p coverage
	@echo "Formatting lcov.info..."
	@echo "CWD: $(CWD)"
	@echo "FILES: $(FILES)"
	@for file in $(FILES); do \
		sed -i'' -e 's|$(CWD)/||g' $$file ; \
	done

.PHONY: test-integration
test-integration:
	@echo "Running integration tests..."
	@# compile the test file:
	@$(DART_CMD) compile exe test/integration/integration_test.dart -o test/integration/integration_test.bin
	@# run the compiled test file and check the content of the output:
	@./test/integration/integration_test.bin | grep -q "running in debug mode: false" || (echo "Integration tests failed" && exit 1)
	@echo "Integration tests passed"

