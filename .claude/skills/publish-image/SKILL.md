---
name: publish-image
description: Publish a Docker image to Docker Hub. Use when user wants to push/publish a built image.
---

# Publish Docker Image

Push a built image to Docker Hub under `idealpostcodes/magento-test`.

## Prerequisites

1. Image must be built first using `/build-image`
2. Must be logged into Docker Hub with push access

## Available Versions

| Command | Tag |
|---------|-----|
| `make publish-m2.4.4-p3-php8.1` | m2.4-php8.1 |
| `make publish-m2.4.6-p3-php8.2` | m2.4.6-php8.2 |
| `make publish-m2.4.7-php8.2` | m2.4.7 |
| `make publish-m2.4.7-p5-php8.3` | m2.4.7-p5 |
| `make publish-m2.4.8-php8.4` | m2.4.8-php8.4 |

Legacy aliases: `publish-81`, `publish-82`, `publish-247`, `publish-247-p5`, `publish-84`

## Steps

1. Verify the image is built locally
2. Confirm Docker Hub login: `docker login`
3. Run `make publish-<version-id>` or `make publish-all`
4. Verify on Docker Hub

## Example

```bash
# Publish specific version
make publish-m2.4.8-php8.4

# Publish all versions
make publish-all

# Using legacy alias
make publish-84
```

## Warning

Publishing overwrites the existing tag on Docker Hub. Ensure the build is tested before publishing.
