.DEFAULT_GOAL := help

PLATFORMS := linux/amd64,linux/arm64,linux/arm/v7
IMAGE_BASE := idealpostcodes/magento-test

# Build args extracted from versions.json for each target
# Format: PHP_VERSION MAGENTO_VERSION MCRYPT_VERSION SODIUM_FROM_SOURCE EXTRA_EXTENSIONS TAG

define build_image
	docker buildx build \
		--platform=$(PLATFORMS) \
		--build-arg PHP_VERSION=$(1) \
		--build-arg MAGENTO_VERSION=$(2) \
		--build-arg MCRYPT_VERSION=$(3) \
		--build-arg SODIUM_FROM_SOURCE=$(4) \
		--build-arg EXTRA_EXTENSIONS="$(5)" \
		-t $(IMAGE_BASE):$(6) \
		.
endef

define push_image
	docker push $(IMAGE_BASE):$(1)
endef

## -- Build Targets --

## Build Magento 2.4.4-p3 on PHP 8.1
.PHONY: build-m2.4.4-p3-php8.1
build-m2.4.4-p3-php8.1:
	$(call build_image,8.1,2.4.4-p3,1.0.6,true,,m2.4-php8.1)

## Build Magento 2.4.6-p3 on PHP 8.2
.PHONY: build-m2.4.6-p3-php8.2
build-m2.4.6-p3-php8.2:
	$(call build_image,8.2,2.4.6-p3,1.0.6,true,,m2.4.6-php8.2)

## Build Magento 2.4.7 on PHP 8.2
.PHONY: build-m2.4.7-php8.2
build-m2.4.7-php8.2:
	$(call build_image,8.2,2.4.7,1.0.6,false,,m2.4.7)

## Build Magento 2.4.7-p5 on PHP 8.3
.PHONY: build-m2.4.7-p5-php8.3
build-m2.4.7-p5-php8.3:
	$(call build_image,8.3,2.4.7-p5,1.0.7,false,,m2.4.7-p5)

## Build Magento 2.4.8 on PHP 8.4
.PHONY: build-m2.4.8-php8.4
build-m2.4.8-php8.4:
	$(call build_image,8.4,2.4.8,,false,ftp,m2.4.8-php8.4)

## Build Magento 2.4.8-p4 on PHP 8.4 (64-bit only, no arm/v7)
.PHONY: build-m2.4.8-p4-php8.4
build-m2.4.8-p4-php8.4:
	docker buildx build \
		--platform=linux/amd64,linux/arm64 \
		--build-arg PHP_VERSION=8.4 \
		--build-arg MAGENTO_VERSION=2.4.8-p4 \
		--build-arg MCRYPT_VERSION= \
		--build-arg SODIUM_FROM_SOURCE=false \
		--build-arg EXTRA_EXTENSIONS="ftp" \
		-t $(IMAGE_BASE):m2.4.8-p4-php8.4 \
		--push \
		.

## Build all images
.PHONY: build-all
build-all: build-m2.4.4-p3-php8.1 build-m2.4.6-p3-php8.2 build-m2.4.7-php8.2 build-m2.4.7-p5-php8.3 build-m2.4.8-php8.4 build-m2.4.8-p4-php8.4

## -- Publish Targets --

## Publish Magento 2.4.4-p3 on PHP 8.1
.PHONY: publish-m2.4.4-p3-php8.1
publish-m2.4.4-p3-php8.1:
	$(call push_image,m2.4-php8.1)

## Publish Magento 2.4.6-p3 on PHP 8.2
.PHONY: publish-m2.4.6-p3-php8.2
publish-m2.4.6-p3-php8.2:
	$(call push_image,m2.4.6-php8.2)

## Publish Magento 2.4.7 on PHP 8.2
.PHONY: publish-m2.4.7-php8.2
publish-m2.4.7-php8.2:
	$(call push_image,m2.4.7)

## Publish Magento 2.4.7-p5 on PHP 8.3
.PHONY: publish-m2.4.7-p5-php8.3
publish-m2.4.7-p5-php8.3:
	$(call push_image,m2.4.7-p5)

## Publish Magento 2.4.8 on PHP 8.4
.PHONY: publish-m2.4.8-php8.4
publish-m2.4.8-php8.4:
	$(call push_image,m2.4.8-php8.4)

## Publish Magento 2.4.8-p4 on PHP 8.4
.PHONY: publish-m2.4.8-p4-php8.4
publish-m2.4.8-p4-php8.4:
	$(call push_image,m2.4.8-p4-php8.4)

## Publish all images
.PHONY: publish-all
publish-all: publish-m2.4.4-p3-php8.1 publish-m2.4.6-p3-php8.2 publish-m2.4.7-php8.2 publish-m2.4.7-p5-php8.3 publish-m2.4.8-php8.4 publish-m2.4.8-p4-php8.4

## -- Legacy Aliases (backward compatibility) --

.PHONY: build-81
build-81: build-m2.4.4-p3-php8.1

.PHONY: publish-81
publish-81: publish-m2.4.4-p3-php8.1

.PHONY: build-82
build-82: build-m2.4.6-p3-php8.2

.PHONY: publish-82
publish-82: publish-m2.4.6-p3-php8.2

.PHONY: build-247
build-247: build-m2.4.7-php8.2

.PHONY: publish-247
publish-247: publish-m2.4.7-php8.2

.PHONY: build-247-p5
build-247-p5: build-m2.4.7-p5-php8.3

.PHONY: publish-247-p5
publish-247-p5: publish-m2.4.7-p5-php8.3

.PHONY: build-84
build-84: build-m2.4.8-php8.4

.PHONY: publish-84
publish-84: publish-m2.4.8-php8.4

## -- Utilities --

## List all available images from versions.json
.PHONY: list-versions
list-versions:
	@cat versions.json | python3 -c "import sys,json; [print(f\"{i['id']}: {i['tag']}\") for i in json.load(sys.stdin)['images']]"

## Update repository against origin/master
.PHONY: update
update:
	git fetch
	git merge --ff-only origin/master

## -- Help --

## How to use this Makefile
.PHONY: help
help:
	@printf "Usage\n";

	@awk '{ \
			if ($$0 ~ /^.PHONY: [a-zA-Z\-\_0-9.]+$$/) { \
				helpCommand = substr($$0, index($$0, ":") + 2); \
				if (helpMessage) { \
					printf "\033[36m%-30s\033[0m %s\n", \
						helpCommand, helpMessage; \
					helpMessage = ""; \
				} \
			} else if ($$0 ~ /^[a-zA-Z\-\_0-9.]+:/) { \
				helpCommand = substr($$0, 0, index($$0, ":")); \
				if (helpMessage) { \
					printf "\033[36m%-30s\033[0m %s\n", \
						helpCommand, helpMessage; \
					helpMessage = ""; \
				} \
			} else if ($$0 ~ /^##/) { \
				if (helpMessage) { \
					helpMessage = helpMessage"\n                               "substr($$0, 3); \
				} else { \
					helpMessage = substr($$0, 3); \
				} \
			} else { \
				if (helpMessage) { \
					print "\n                               "helpMessage"\n" \
				} \
				helpMessage = ""; \
			} \
		}' \
		$(MAKEFILE_LIST)
