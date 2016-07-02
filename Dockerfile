FROM php:7.0-apache
MAINTAINER Tom - Chaplean <tom@chaplean.com>

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    libfreetype6-dev \
    libjpeg-dev \
    libldap2-dev \
    libmcrypt-dev \
    libpng12-dev \
    zlib1g-dev

# Install opcache
RUN docker-php-ext-install opcache

# Install APCu
RUN pecl install apcu
RUN echo "extension=apcu.so" > /usr/local/etc/php/conf.d/apcu.ini

# Install mcrypt extension
RUN docker-php-ext-install mcrypt

# Install PDO
RUN docker-php-ext-install pdo_mysql

# Install GD
RUN docker-php-ext-configure gd --enable-gd-native-ttf --with-jpeg-dir=/usr/lib/x86_64-linux-gnu --with-png-dir=/usr/lib/x86_64-linux-gnu --with-freetype-dir=/usr/lib/x86_64-linux-gnu \
	&& docker-php-ext-install gd

# Install intl
RUN apt-get install -y libicu-dev
RUN pecl install intl
RUN docker-php-ext-install intl

# Install Memcached
RUN apt-get install -y libmemcached-dev libpq-dev
RUN curl -L -o /tmp/memcached.tar.gz "https://github.com/php-memcached-dev/php-memcached/archive/php7.tar.gz" \
    && mkdir -p /usr/src/php/ext/memcached \
    && tar -C /usr/src/php/ext/memcached -zxvf /tmp/memcached.tar.gz --strip 1 \
    && docker-php-ext-configure memcached \
    && docker-php-ext-install memcached \
    && rm /tmp/memcached.tar.gz

# Working directory
WORKDIR /var/www/symfony/

# Install Composer
RUN curl -o composer.phar https://getcomposer.org/composer.phar -L
RUN chmod +x composer.phar

# Apache mods
RUN a2enmod rewrite
RUN a2enmod headers

# Permissions
RUN usermod -u 1000 www-data

# PHP Configuration
ADD ./php.ini /usr/local/etc/php/php.ini

CMD /usr/sbin/apache2ctl -D FOREGROUND
