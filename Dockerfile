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
        composer \
        ./wkhtmltox.deb \
		gnupg \
    # node LTS and yarn
    && curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
    && echo "deb https://deb.nodesource.com/node_10.x bionic main" | tee /etc/apt/sources.list.d/nodesource.list \
    && echo "deb-src https://deb.nodesource.com/node_10.x bionic main" | tee -a /etc/apt/sources.list.d/nodesource.list \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt update \
    && apt install -y \
        nodejs \
		yarn \
    # Capistrano
    && gem install capistrano \
	# Cleanup
	&& rm -rf /var/lib/apt/lists/* \
	&& apt-get clean \
    && rm ./wkhtmltox.deb

ADD ./php.ini /opt/docker/etc/php/php.ini
ADD ./mysql.cnf /etc/mysql/my.cnf

ENV PATH="/usr/wkhtmltox/bin:${PATH}"
ENV COMPOSER_HOME ${HOME}/cache/composer
ENV APPLICATION_PATH /var/www/symfony/
ENV WEB_DOCUMENT_ROOT /var/www/symfony/web/
ENV WEB_DOCUMENT_INDEX app_dev.php

VOLUME /var/www/symfony/
WORKDIR /var/www/symfony/

USER application
RUN echo "prefix=/home/application/.npm-packages" >> ~/.npmrc \
    && npm install -g \
      # Bower
	  bower \
      # Elm
	  elm@elm0.19.0 elm-format@elm0.19.0 elm-test@elm0.19.0 elm-verify-examples
