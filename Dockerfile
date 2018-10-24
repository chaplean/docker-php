FROM webdevops/php-nginx:latest
MAINTAINER Tom - Chaplean <tom@chaplean.coop>

# Do not use wkhtmltopdf from the distro repos. See http://unix.stackexchange.com/questions/192642/wkhtmltopdf-qxcbconnection-could-not-connect-to-display
RUN curl -sL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb -o ./wkhtmltox.deb \
    && apt update \
    && apt install -y \
		php7.2-phpdbg \
        mysql-client \
        ruby \
        build-essential \
        g++ \
        nodejs \
        npm \
        composer \
        ./wkhtmltox.deb \
    && rm ./wkhtmltox.deb \
    # Elm
    && npm install -g elm@elm0.19.0 elm-format@elm0.19.0 elm-test@elm0.19.0 elm-verify-examples \
    # Capistrano
    && gem install capistrano

ADD ./php.ini /opt/docker/etc/php/php.ini
ADD ./mysql.cnf /etc/mysql/my.cnf

ENV PATH="/usr/wkhtmltox/bin:${PATH}"
ENV COMPOSER_HOME ${HOME}/cache/composer
ENV APPLICATION_PATH /var/www/symfony/
ENV WEB_DOCUMENT_ROOT /var/www/symfony/web/
ENV WEB_DOCUMENT_INDEX app_dev.php

VOLUME /var/www/symfony/
WORKDIR /var/www/symfony/
