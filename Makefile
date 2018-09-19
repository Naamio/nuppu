# Build Output Directories
CONTAINER_NAME = nuppu
CONTAINER_VERSION = 0.0
CONTAINER_URL = naamio/$(CONTAINER_NAME):$(CONTAINER_VERSION)

NPM_BIN = $(shell npm bin)

BUILD_DIR = .build
SRC_BUILD_DIR = lib
ASSETS_DIR = assets
TEMPLATES_DIR = stencils
CONTENT_DIR = content
IMAGES_DIR = images
STYLES_DIR = styles
CONFIG_DIR = config

CONFIG_RAW_DIR = $(ASSETS_RAW_DIR)/$(CONFIG_DIR)
CONTENT_RAW_DIR = $(CONTENT_DIR)
TEMPLATES_RAW_DIR = $(TEMPLATES_DIR)
ASSETS_RAW_DIR = $(ASSETS_DIR)
JS_RAW_DIR = $(ASSETS_RAW_DIR)/scripts/js
IMAGES_RAW_DIR = $(ASSETS_RAW_DIR)/$(IMAGES_DIR)
STYLES_RAW_DIR = $(ASSETS_RAW_DIR)/$(STYLES_DIR)

CONTENT_BUILD_DIR = $(BUILD_DIR)/$(CONTENT_DIR)
ASSETS_BUILD_DIR = $(BUILD_DIR)/$(ASSETS_DIR)
TEMPLATES_BUILD_DIR = $(BUILD_DIR)/$(TEMPLATES_DIR)
JS_BUILD_DIR = $(ASSETS_BUILD_DIR)/scripts/js
IMAGES_BUILD_DIR = $(ASSETS_BUILD_DIR)/$(IMAGES_DIR)
STYLES_BUILD_DIR = $(ASSETS_BUILD_DIR)/$(STYLES_DIR)

# Prepare for build
prepare:

	npm install

# Perform clean up
clean:

	# TypeScript
	if    [ -d "$(BUILD_DIR)" ]; then \
		rm -rf $(BUILD_DIR) ; \
	fi

test: build

	npm run test

# Build distribution bundle
build: clean

	mkdir -p $(ASSETS_BUILD_DIR)
	mkdir -p $(JS_BUILD_DIR)

    #cp -r $(CONFIG_RAW_DIR)/development.json $(JS_BUILD_DIR)/config.json

	cp -r $(TEMPLATES_RAW_DIR) $(TEMPLATES_BUILD_DIR)
	cp -r $(CONTENT_RAW_DIR) $(CONTENT_BUILD_DIR)
	cp -r $(IMAGES_RAW_DIR) $(IMAGES_BUILD_DIR)
	cp -r $(STYLES_RAW_DIR) $(STYLES_BUILD_DIR)

	for file in $(JS_RAW_DIR)/*.js ; do \
		input=$${file} ; \
		output=$(BUILD_DIR)/$${file%.js}.js ; \
	done

	npm run build

	cp -r $(SRC_BUILD_DIR)/* $(JS_BUILD_DIR)

clean-container:

	-docker stop $(CONTAINER_NAME)
	-docker rm $(CONTAINER_NAME)
	-docker rmi $(CONTAINER_URL)

build-container: clean-container build

	docker build -t $(CONTAINER_URL) .

run-container: build-container

	docker run -d --name $(CONTAINER_NAME) -p 8090:8090 -it $(CONTAINER_URL) -v  $$(pwd)/$(BUILD_DIR):/usr/share/naamio/copan

all: test build

.PHONY: all prepare clean build