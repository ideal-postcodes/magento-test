---
description: Build a Docker image for Magento testing
---

# Build Docker Image

Build a multi-platform Docker image for Magento testing.

## Prerequisites

Ensure Docker buildx is configured:
```bash
docker buildx ls
```

## List Available Versions

```bash
make list-versions
```

## Available Versions

| Command | Magento | PHP | Tag |
|---------|---------|-----|-----|
| `make build-m2.4.4-p3-php8.1` | 2.4.4-p3 | 8.1 | m2.4-php8.1 |
| `make build-m2.4.6-p3-php8.2` | 2.4.6-p3 | 8.2 | m2.4.6-php8.2 |
| `make build-m2.4.7-php8.2` | 2.4.7 | 8.2 | m2.4.7 |
| `make build-m2.4.7-p5-php8.3` | 2.4.7-p5 | 8.3 | m2.4.7-p5 |
| `make build-m2.4.8-php8.4` | 2.4.8 | 8.4 | m2.4.8-php8.4 |

Legacy aliases: `build-81`, `build-82`, `build-247`, `build-247-p5`, `build-84`

## Steps

1. Run `make list-versions` to see available versions
2. Run `make build-<version-id>` for specific version
3. Or run `make build-all` for all versions

## Example

```bash
# Build specific version
make build-m2.4.8-php8.4

# Build all versions
make build-all

# Using legacy alias
make build-84
```
