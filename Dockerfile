FROM ubuntu:xenial 
MAINTAINER Justin Hartman <justin@hartman.me> 

ENV DEBIAN_FRONTEND noninteractive 
ENV MYSQL_ROOT_PASS RpgCNfRTBpEyBKdk6D 

RUN echo mysql-server mysql-server/root_password password $MYSQL_ROOT_PASS | debconf-set-selections
RUN echo mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASS | debconf-set-selections

RUN apt-get update && \
    apt-get -y install git apache2 libapache2-mod-php7.0 mysql-server php7.0-mysql pwgen php7.0-mcrypt php7.0-opcache php7.0 php7.0-cli php7.0-fpm php7.0-gd php7.0-json php7.0-readline php7.0-common php7.0-curl php7.0-mbstring

# config to enable .htaccess 
ADD apache_default /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# Add volumes for MySQL & Apache 2
VOLUME  ["/etc/mysql", "/var/lib/mysql"]
RUN service mysql restart

EXPOSE 80 3306 

RUN requirements="libmcrypt-dev g++ libicu-dev libmcrypt4 libicu55 curl php7.0-mcrypt php7.0-intl php7.0-curl" \
    && apt-get update && apt-get install -y $requirements \
    && requirementsToRemove="libmcrypt-dev g++ libicu-dev" \
    && apt-get purge --auto-remove -y $requirementsToRemove \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && apt-get update \
    && apt-get install -y zlib1g-dev git \
    && apt-get purge -y --auto-remove zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite

WORKDIR /var/www/html

RUN usermod -u 1000 www-data
