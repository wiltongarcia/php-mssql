FROM php:fpm

MAINTAINER Wilton Garcia <wiltonog@gmail.com>

RUN apt-get update && apt-get install -y unixodbc libgss3 odbcinst devscripts debhelper dh-exec dh-autoreconf \
    libreadline-dev libltdl-dev unixodbc-dev wget unzip php7-mbstring  \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo mbstring tokenizer xml mcrypt

 RUN cd /usr/local/src/ && dget -ux http://http.debian.net/debian/pool/main/u/unixodbc/unixodbc_2.3.1-3.dsc \
    && cd unixodbc-2.3.1/ && apt-get update && dpkg-buildpackage -uc -d -us -B && cp ./exe/odbc_config /usr/local/bin/

RUN cd /usr/local/src/ \
    && wget https://download.microsoft.com/download/2/E/5/2E58F097-805C-4AB8-9FC6-71288AB4409D/msodbcsql-13.0.0.0.tar.gz \
    && tar xf msodbcsql-13.0.0.0.tar.gz && cd msodbcsql-13.0.0.0/ \
    && ldd lib64/libmsodbcsql-13.0.so.0.0; echo "RET=$?" \
    && sed -i 's/$(uname -p)/"x86_64"/g' ./install.sh \
    && ./install.sh install --force --accept-license

RUN cd /tmp && wget https://github.com/Microsoft/msphpsql/releases/download/v4.0.5-Linux/Ubuntu15.zip \
    && unzip Ubuntu15.zip \
    && mv -v Ubuntu15/* /usr/local/lib/php/extensions/no-debug-non-zts-20151012/ \
    && rm /usr/local/lib/php/extensions/no-debug-non-zts-20151012/signature

RUN "extension=php_pdo_sqlsrv_7_nts.so" >> /usr/local/etc/php/conf.d/sqlsvr.ini

# Install xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Install Redis
RUN pecl install redis && docker-php-ext-enable redis

RUN groupadd -r php -g 1000 && useradd -u 1000 -r -g php -m -d /var/www/html -s /sbin/nologin -c "App user" php 

