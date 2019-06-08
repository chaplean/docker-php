# Debian jessie based
FROM php:7.2-apache
MAINTAINER Tom - Chaplean <tom@chaplean.coop>

# Install dependencies
RUN apt-get update && apt-get install -y \
    bison \
    build-essential \
    curl \
    flex \
    g++ \
    git \
    gperf \
    gnupg \
    libfontconfig1-dev \
    libfreetype6 \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libldap2-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libpng-dev \
    libpq-dev \
    libsqlite3-dev \
    libssl-dev \
    libx11-dev \
    libxext-dev \
    libxml2-dev \
    netbase \
    pdftk \
    perl \
    python \
    ruby-full \
    unzip \
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

# Install opcache
RUN docker-php-ext-install opcache

# Install PDO
RUN docker-php-ext-install pdo_mysql

# Install XML module
RUN docker-php-ext-install xml

# Install Zip module
RUN docker-php-ext-install zip

# Install Wkhtmltox
# Do not use wkhtmltopdf 0.12.1-2 (or only with xvfb). See http://unix.stackexchange.com/questions/192642/wkhtmltopdf-qxcbconnection-could-not-connect-to-display
RUN curl -sL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz -o wkhtmltox.tar.xz
RUN tar -C /usr/ -xf wkhtmltox.tar.xz
RUN rm wkhtmltox.tar.xz
ENV PATH="/usr/wkhtmltox/bin:${PATH}"

# Install MySQL
RUN apt-get install -y \
    mysql-client

ADD ./mysql.cnf /etc/mysql/my.cnf

WORKDIR /tmp/

# Install NPM
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs

# Install Elm
RUN npm install -g elm elm-test elm-format elm-doc-test --unsafe-perm

# Working directory
WORKDIR /var/www/symfony/

## Install XDebug
RUN pecl install xdebug-2.7.2

# Install Composer and make it available in the PATH
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# Apache mods
RUN a2enmod rewrite
RUN a2enmod headers

# Permissions
RUN usermod -u 1000 www-data

# PHP Configuration
ADD ./php.ini /usr/local/etc/php/php.ini

# Symfony deploy requirements
RUN gem install bundler

CMD /usr/sbin/apache2ctl -D FOREGROUND
