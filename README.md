# Magento Test Images

Docker images for testing [ideal-postcodes/magento](https://github.com/ideal-postcodes/magento) plugin.

## Images

| Tag | Magento | PHP | 
|-----|---------|-----|
| `m2.4-php8.1` | 2.4.4-p3 | 8.1 |
| `m2.4.6-php8.2` | 2.4.6-p3 | 8.2 |
| `m2.4.7` | 2.4.7 | 8.2 |
| `m2.4.7-p5` | 2.4.7-p5 | 8.3 |
| `m2.4.8-php8.4` | 2.4.8 | 8.4 |

## Usage

### Build Docker Images

```bash
# Build specific version
make build-m2.4.8-php8.4

# Build all versions
make build-all

# Legacy aliases still work
make build-84
```

### List Available Versions

```bash
make list-versions
```

### Incorporate into Dockerfile

```Dockerfile
FROM idealpostcodes/magento-test:m2.4.8-php8.4
```

## Structure

```
magento-test/
├── Dockerfile           # Unified parameterized Dockerfile
├── versions.json        # Version matrix (source of truth)
├── scripts/
│   └── install-magento  # Magento installation script
├── Makefile
└── README.md
```

## Adding New Versions

1. Add entry to `versions.json`
2. Add build/publish targets to `Makefile`
3. Test with `make build-<version-id>`

See `versions.json` for the schema and existing configurations.

## Licence

MIT
