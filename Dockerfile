FROM php:7-fpm-alpine

MAINTAINER Wilton Garcia <wiltonog@gmail.com>

RUN apk add --no-cache --virtual .build-deps build-base curl git autoconf \
    freetype-dev \
    libjpeg-turbo-dev \
    postgresql-dev \
    imagemagick-dev \
    libmcrypt-dev \
    libpng-dev \
    libmemcached-dev \
    openssl-dev \
    libsasl \
    zlib-dev \
    libcurl \
    curl-dev \
    bzip2-dev \
    unixodbc-dev \
    freetds \
    unixodbc \
    && docker-php-ext-install bz2 iconv mcrypt mbstring  zip curl \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \   
    && docker-php-source extract \
    && docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr \
    && docker-php-ext-install pdo_odbc 

# Install xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Install Redis
RUN pecl install redis && docker-php-ext-enable redis

RUN adduser -D -u 1000 php


