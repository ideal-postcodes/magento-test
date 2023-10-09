.DEFAULT_GOAL := help

## -- PHP 7.1 --

## Build Magento 2.2 on PHP 7.1
.PHONY: build-71
build-71:
	docker build -f php.7.1/Dockerfile -t idealpostcodes/magento-test:m2.2-php7.1 .

## Publish Magento 2.2 on PHP 7.1
.PHONY: publish-71
publish-71:
	docker push idealpostcodes/magento-test:m2.2-php7.1

## -- PHP 7.2 --

## Build Magento 2.3 on PHP 7.2
.PHONY: build-72
build-72:
	docker build -f php.7.2/Dockerfile -t idealpostcodes/magento-test:m2.3-php7.2 .

## Publish Magento 2.3 on PHP 7.2
.PHONY: publish-72
publish-72:
	docker push idealpostcodes/magento-test:m2.3-php7.2

## -- PHP 7.3 --

## Build Magento 2.3 on PHP 7.3
.PHONY: build-73
build-73:
	docker build -f php.7.3/Dockerfile -t idealpostcodes/magento-test:m2.3-php7.3 .

## Publish Magento 2.3 on PHP 7.3
.PHONY: publish-73
publish-73:
	docker push idealpostcodes/magento-test:m2.3-php7.3

## Build Magento 2.3 on PHP 7.3
.PHONY: build-73-m24
build-73-m24:
	docker build -f php.7.3/Dockerfile-m2.4 -t idealpostcodes/magento-test:m2.4-php7.3 .

## Publish Magento 2.3 on PHP 7.3
.PHONY: publish-73-m243
publish-73-m24:
	docker push idealpostcodes/magento-test:m2.4-php7.3

## Build Magento 2.4.3 on PHP 7.3
.PHONY: build-73-m243
build-73-m243:
	docker build -f php.7.3/Dockerfile-m2.4.3 -t idealpostcodes/magento-test:m2.4.3-php7.3 .

## Publish Magento 2.4.3 on PHP 7.3
.PHONY: publish-73-m243
publish-73-m243:
	docker push idealpostcodes/magento-test:m2.4.3-php7.3


## Build Magento 2.4.4 on PHP 7.4
.PHONY: build-74
build-74:
	docker build -f php.7.4/Dockerfile -t idealpostcodes/magento-test:m2.4-php7.4 .

## Publish Magento 2.4.4 on PHP 7.4
.PHONY: publish-74
publish-74:
	docker push idealpostcodes/magento-test:m2.4-php7.4

## Build Magento 2.4.4 on PHP 7.4
.PHONY: build-81
build-81:
	docker build -f php.8.1/Dockerfile -t idealpostcodes/magento-test:m2.4-php8.1 .

## Publish Magento 2.4.4 on PHP 7.4
.PHONY: publish-81
publish-81:
	docker push idealpostcodes/magento-test:m2.4-php8.1

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
