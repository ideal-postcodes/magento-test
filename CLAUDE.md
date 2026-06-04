# Magento Test Images

Docker images for testing [ideal-postcodes/magento](https://github.com/ideal-postcodes/magento) plugin.

## Commands

- `make help` - Show all available commands
- `make list-versions` - List all available image versions
- `make build-<id>` - Build specific version (e.g., `make build-m2.4.8-php8.4`)
- `make build-all` - Build all versions
- `make publish-<id>` - Publish specific version to Docker Hub
- Legacy aliases: `build-81`, `build-82`, `build-247`, `build-247-p5`, `build-84`

## Structure

- `Dockerfile` - Unified parameterized Dockerfile
- `versions.json` - Version matrix (source of truth)
- `scripts/install-magento` - Magento installation script

## Conventions

- Images tagged as `idealpostcodes/magento-test:<tag>`
- Tags defined in `versions.json`
- Multi-platform builds: linux/amd64, linux/arm64, linux/arm/v7
- Use `docker buildx` for cross-platform builds

## Adding Versions

1. Add entry to `versions.json` with: id, tag, php_version, magento_version, mcrypt_version, sodium_from_source, extra_extensions
2. Add build/publish targets to `Makefile`

## Skills

- `/build-image` - Build a Docker image for a specific version
- `/publish-image` - Publish a Docker image to Docker Hub
- `/add-version` - Add support for a new Magento/PHP version
