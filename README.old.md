# Magento Test Images

This repository stores dockerfiles to build test magento images for [ideal-postcodes/magento](https://github.com/ideal-postcodes/magento)

## Images

- [Magento 2.2 on PHP 7.1](https://hub.docker.com/layers/idealpostcodes/magento-test/m2.2-php7.1/images/sha256-a1870793f832e989a0ec246b924579d6022ca2f150fe60806dfc554c5cd765d2?context=explore)
- [Magento 2.3 on PHP 7.2](https://hub.docker.com/layers/idealpostcodes/magento-test/m2.3-php7.2/images/sha256-335a2c61d9475beaa32e89f73b0d05288910c4152fffb04705ce202e92a3c7e6)
- [Magento 2.3 on PHP 7.3](https://hub.docker.com/layers/idealpostcodes/magento-test/m2.3-php7.3/images/sha256-0b82c5aa51c9dba421176d95ec7b56dfc64ce7006168f1520fba938e39f6cf8d?context=explore)

## Usage

### Build Docker Images

```bash
make build-71
make build-72
make build-73
make build-73-m24
```

### Incoporate into Dockerfile

```Dockerfile
FROM idealpostcodes/magento-test:m2.3-php7.2
```

## Licence

MIT
