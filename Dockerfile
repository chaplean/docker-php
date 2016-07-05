FROM php:7.0-apache
MAINTAINER Tom - Chaplean <tom@chaplean.com>

# Install dependencies
# Install xvfb-run cause of a bug in wk, see http://unix.stackexchange.com/questions/192642/wkhtmltopdf-qxcbconnection-could-not-connect-to-display
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    libfreetype6-dev \
    libicu-dev \
    libjpeg-dev \
    libldap2-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libpng12-dev \
    libpq-dev \
    libxml2-dev \
    wkhtmltopdf \
    xvfb \
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
RUN pecl install intl
RUN docker-php-ext-install intl

# Install Memcached
RUN curl -L -o /tmp/memcached.tar.gz "https://github.com/php-memcached-dev/php-memcached/archive/php7.tar.gz" \
    && mkdir -p /usr/src/php/ext/memcached \
    && tar -C /usr/src/php/ext/memcached -zxvf /tmp/memcached.tar.gz --strip 1 \
    && docker-php-ext-configure memcached \
    && docker-php-ext-install memcached \
    && rm /tmp/memcached.tar.gz

# Install XML module
RUN docker-php-ext-install xml

# Install Zip module
RUN docker-php-ext-install zip

# Working directory
WORKDIR /var/www/symfony/

# Install Composer and make it available in the PATH
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# Apache mods
RUN a2enmod rewrite
RUN a2enmod headers

# Permissions
RUN usermod -u 1000 www-data

# PHP Configuration
ADD ./php.ini /usr/local/etc/php/php.ini

CMD /usr/sbin/apache2ctl -D FOREGROUND
