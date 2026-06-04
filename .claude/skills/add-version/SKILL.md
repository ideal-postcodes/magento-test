---
name: add-version
description: Add support for a new Magento or PHP version. Use when adding new version support.
---

# Add New Version Support

Add a new Magento/PHP combination using the unified Dockerfile.

## Steps

1. **Add entry to versions.json**
   ```json
   {
     "id": "m2.4.9-php8.5",
     "tag": "m2.4.9-php8.5",
     "php_version": "8.5",
     "magento_version": "2.4.9",
     "mcrypt_version": null,
     "sodium_from_source": false,
     "extra_extensions": []
   }
   ```

2. **Add Makefile targets**
   ```makefile
   ## Build Magento 2.4.9 on PHP 8.5
   .PHONY: build-m2.4.9-php8.5
   build-m2.4.9-php8.5:
   	$(call build_image,8.5,2.4.9,,false,,m2.4.9-php8.5)

   ## Publish Magento 2.4.9 on PHP 8.5
   .PHONY: publish-m2.4.9-php8.5
   publish-m2.4.9-php8.5:
   	$(call push_image,m2.4.9-php8.5)
   ```

3. **Update build-all and publish-all targets** to include new version

4. **Test the build**
   ```bash
   make build-m2.4.9-php8.5
   ```

## Version Configuration

| Field | Description |
|-------|-------------|
| `id` | Unique identifier, format: `m<magento>-php<php>` |
| `tag` | Docker Hub tag |
| `php_version` | PHP version (e.g., `8.5`) |
| `magento_version` | Magento version (e.g., `2.4.9`) |
| `mcrypt_version` | mcrypt PECL version or `null` if not needed |
| `sodium_from_source` | `true` for PHP < 8.2 requiring libsodium build |
| `extra_extensions` | Array of additional PHP extensions (e.g., `["ftp"]`) |
