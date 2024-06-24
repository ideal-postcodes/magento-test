.DEFAULT_GOAL := help

## Build Magento 2.4.4 on PHP 7.4
.PHONY: build-81
build-81:
	docker build -f 8.1/Dockerfile -t idealpostcodes/magento-test:m2.4-php8.1 .

## Publish Magento 2.4.4 on PHP 7.4
.PHONY: publish-81
publish-81:
	docker push idealpostcodes/magento-test:m2.4-php8.1

## Build Magento 2.4.6 on PHP 8.2
.PHONY: build-82
build-82:
	docker build -f 8.2/Dockerfile -t idealpostcodes/magento-test:m2.4.6-php8.2 .

## Publish Magento 2.4.6 on PHP 8.2
.PHONY: publish-82
publish-82:
	docker push idealpostcodes/magento-test:m2.4.6-php8.2

## Build Magento 2.4.7 on PHP 8.2
.PHONY: build-247
build-247:
	docker build -f 2.4.7/Dockerfile -t idealpostcodes/magento-test:m2.4.7 .

## Publish Magento 2.4.6 on PHP 8.2
.PHONY: publish-247
publish-247:
	docker push idealpostcodes/magento-test:m2.4.7

## Update repository against origin/master
.PHONY: update
update:
	git fetch
	git merge --ff-only origin/master

## -- Misc --

## How to use this Makefile
.PHONY: help
help:
	@printf "Usage\n";

	@awk '{ \
			if ($$0 ~ /^.PHONY: [a-zA-Z\-\_0-9]+$$/) { \
				helpCommand = substr($$0, index($$0, ":") + 2); \
				if (helpMessage) { \
					printf "\033[36m%-20s\033[0m %s\n", \
						helpCommand, helpMessage; \
					helpMessage = ""; \
				} \
			} else if ($$0 ~ /^[a-zA-Z\-\_0-9.]+:/) { \
				helpCommand = substr($$0, 0, index($$0, ":")); \
				if (helpMessage) { \
					printf "\033[36m%-20s\033[0m %s\n", \
						helpCommand, helpMessage; \
					helpMessage = ""; \
				} \
			} else if ($$0 ~ /^##/) { \
				if (helpMessage) { \
					helpMessage = helpMessage"\n                     "substr($$0, 3); \
				} else { \
					helpMessage = substr($$0, 3); \
				} \
			} else { \
				if (helpMessage) { \
					print "\n                     "helpMessage"\n" \
				} \
				helpMessage = ""; \
			} \
		}' \
		$(MAKEFILE_LIST)
