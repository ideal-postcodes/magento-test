# Reorganization Plan

## Current State

| Directory | PHP | Magento | Tag | Issues |
|-----------|-----|---------|-----|--------|
| 8.1/ | 8.1 | 2.4.4-p3 | m2.4-php8.1 | COPY path bug, libsodium from source |
| 8.2/ | 8.2 | 2.4.6-p3 | m2.4.6-php8.2 | libsodium from source |
| 2.4.7/ | 8.2 | 2.4.7 | m2.4.7 | Uses system sodium |
| 2.4.7-p5/ | 8.3 | 2.4.7-p5 | m2.4.7-p5 | mcrypt 1.0.7 |
| 8.4/ | 8.4 | 2.4.8 | m2.4.8-php8.4 | No mcrypt, has ftp ext |

## Proposed Structure

### Option A: Version Matrix with Base Image

```
magento-test/
├── base/
│   └── Dockerfile.template       # Shared base with ARGs
├── images/
│   ├── m2.4.4-php8.1/
│   │   └── Dockerfile
│   ├── m2.4.6-php8.2/
│   │   └── Dockerfile
│   ├── m2.4.7-php8.2/
│   │   └── Dockerfile
│   ├── m2.4.7-p5-php8.3/
│   │   └── Dockerfile
│   └── m2.4.8-php8.4/
│       └── Dockerfile
├── scripts/
│   └── install-magento
├── versions.json                 # Version matrix
├── Makefile
└── README.md
```

### Option B: Unified Dockerfile with Build Args

```
magento-test/
├── Dockerfile                    # Single parameterized Dockerfile
├── versions.json                 # All version combinations
├── scripts/
│   └── install-magento
├── Makefile                      # Generated or reads versions.json
└── README.md
```

### Option C: Consistent Naming (Minimal Change)

```
magento-test/
├── images/
│   ├── m2.4.4-p3-php8.1/Dockerfile
│   ├── m2.4.6-p3-php8.2/Dockerfile
│   ├── m2.4.7-php8.2/Dockerfile
│   ├── m2.4.7-p5-php8.3/Dockerfile
│   └── m2.4.8-php8.4/Dockerfile
├── install-magento
├── Makefile
└── README.md
```

## Recommendation: Option B

**Benefits:**
- Single Dockerfile = single source of truth
- `versions.json` makes adding versions trivial
- Makefile can be auto-generated or dynamic
- Differences handled via build args and conditionals

## Implementation Tasks

### Phase 1: Normalize Current Structure
- [ ] Fix COPY path in 8.1/Dockerfile
- [ ] Standardize tag naming to `m<magento>-php<php>`
- [ ] Document version differences

### Phase 2: Create Unified Dockerfile
- [ ] Create `versions.json` with all version metadata
- [ ] Build parameterized Dockerfile with ARGs
- [ ] Handle version-specific logic (mcrypt, sodium, ftp)
- [ ] Test all builds

### Phase 3: Update Build System
- [ ] Update Makefile to read from versions.json
- [ ] Add `make build VERSION=m2.4.8-php8.4` interface
- [ ] Add `make build-all` target

### Phase 4: Cleanup
- [ ] Remove old directory structure
- [ ] Update README.md
- [ ] Update CLAUDE.md and skills

## versions.json Schema

```json
{
  "images": [
    {
      "tag": "m2.4.8-php8.4",
      "php_version": "8.4",
      "magento_version": "2.4.8",
      "mcrypt": false,
      "sodium_from_source": false,
      "extra_extensions": ["ftp"]
    }
  ]
}
```

## Version-Specific Differences

| Feature | 8.1 | 8.2 | 2.4.7 | 2.4.7-p5 | 8.4 |
|---------|-----|-----|-------|----------|-----|
| mcrypt | 1.0.6 | 1.0.6 | 1.0.6 | 1.0.7 | ✗ |
| sodium ext | pecl | ✗ | docker-php | docker-php | docker-php |
| libsodium source | ✓ | ✓ | ✗ | ✗ | ✗ |
| ftp ext | ✗ | ✗ | ✗ | ✗ | ✓ |
