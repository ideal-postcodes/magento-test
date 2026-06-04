# Unified Dockerfile for Magento Test Images
# Build with: docker buildx build --build-arg PHP_VERSION=8.4 --build-arg MAGENTO_VERSION=2.4.8 ...

ARG PHP_VERSION=8.4

FROM php:${PHP_VERSION}-apache

ARG PHP_VERSION
ARG MAGENTO_VERSION=2.4.8
ARG MCRYPT_VERSION=""
ARG SODIUM_FROM_SOURCE="false"
ARG EXTRA_EXTENSIONS=""

LABEL php_version="${PHP_VERSION}"
LABEL magento_version="${MAGENTO_VERSION}"
LABEL description="Magento ${MAGENTO_VERSION} with PHP ${PHP_VERSION}"

ENV MAGENTO_VERSION=${MAGENTO_VERSION}
ENV INSTALL_DIR=/var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

# Base requirements
RUN requirements="apache2 apt-utils libpng++-dev libzip-dev libmcrypt-dev libmcrypt4 libcurl3-dev libfreetype6 libjpeg62-turbo libjpeg62-turbo-dev libfreetype6-dev libicu-dev libxslt1-dev libonig-dev unzip libsodium-dev wget" \
    && apt-get update \
    && apt-get install -y $requirements \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install zip \
    && docker-php-ext-install intl \
    && docker-php-ext-install xsl \
    && docker-php-ext-install soap \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install sockets

# Install sodium extension (not from source)
RUN if [ "${SODIUM_FROM_SOURCE}" != "true" ]; then \
        docker-php-ext-install sodium; \
    fi

# Install mcrypt if version specified
RUN if [ -n "${MCRYPT_VERSION}" ]; then \
        yes '' | pecl install mcrypt-${MCRYPT_VERSION} \
        && echo 'extension=mcrypt.so' > /usr/local/etc/php/conf.d/mcrypt.ini; \
    fi

# Install extra extensions (space-separated list)
RUN if [ -n "${EXTRA_EXTENSIONS}" ]; then \
        for ext in ${EXTRA_EXTENSIONS}; do \
            docker-php-ext-install $ext; \
        done; \
    fi

# Install libsodium from source for older PHP versions
RUN if [ "${SODIUM_FROM_SOURCE}" = "true" ]; then \
        curl -O https://download.libsodium.org/libsodium/releases/libsodium-1.0.18.tar.gz \
        && tar xfvz libsodium-1.0.18.tar.gz \
        && cd libsodium-1.0.18 \
        && ./configure \
        && make && make install \
        && pecl install -f libsodium \
        && rm -rf libsodium-1.0.18 libsodium-1.0.18.tar.gz; \
    fi

RUN chsh -s /bin/bash www-data

# Download and extract Magento
RUN cd /tmp && \
    curl https://codeload.github.com/magento/magento2/tar.gz/${MAGENTO_VERSION} -o ${MAGENTO_VERSION}.tar.gz && \
    tar xvf ${MAGENTO_VERSION}.tar.gz && \
    mv magento2-${MAGENTO_VERSION}/* magento2-${MAGENTO_VERSION}/.htaccess ${INSTALL_DIR}

# Set permissions and install dependencies
RUN chown -R www-data:www-data /var/www
RUN su www-data -c "cd ${INSTALL_DIR} && composer install"
RUN su www-data -c "cd ${INSTALL_DIR} && composer config repositories.magento composer https://repo.magento.com/"

RUN cd ${INSTALL_DIR} \
    && find . -type d -exec chmod 770 {} \; \
    && find . -type f -exec chmod 660 {} \; \
    && chmod u+x bin/magento

# Apache configuration
RUN a2enmod rewrite
RUN echo "memory_limit=2048M" > /usr/local/etc/php/conf.d/memory-limit.ini

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install dockerize for waiting on dependencies
ENV DOCKERIZE_VERSION=v0.6.0
RUN wget https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
    && rm dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz

# Include test install script
COPY scripts/install-magento /usr/local/bin/install-magento
RUN chmod u+x /usr/local/bin/install-magento

WORKDIR ${INSTALL_DIR}
