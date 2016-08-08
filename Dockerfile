FROM php:7.0-apache
MAINTAINER Tom - Chaplean <tom@chaplean.com>

# Install dependencies
# Install xvfb-run cause of a bug in wk, see http://unix.stackexchange.com/questions/192642/wkhtmltopdf-qxcbconnection-could-not-connect-to-display
RUN apt-get update && apt-get install -y \
    curl \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libldap2-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libpng12-dev \
    libpq-dev \
    libxml2-dev \
    ruby-full \
    unzip \
    wkhtmltopdf \
    xvfb \
    zlib1g-dev

# Install APCu
RUN pecl install apcu
RUN echo "extension=apcu.so" > /usr/local/etc/php/conf.d/apcu.ini

# Install GD
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install gd

# Install intl
RUN docker-php-ext-install intl

# Install LDAP
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu
RUN docker-php-ext-install ldap

# Install mcrypt extension
RUN docker-php-ext-install mcrypt

# Install opcache
RUN docker-php-ext-install opcache

# Install PDO
RUN docker-php-ext-install pdo_mysql

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

# Symfony projects requirements
RUN gem install bundler compass

CMD /usr/sbin/apache2ctl -D FOREGROUND
