FROM ubuntu:xenial
MAINTAINER Justin Hartman <justin@hartman.me>

ENV DEBIAN_FRONTEND noninteractive
ENV MYSQL_ROOT_PASS RpgCNfRTBpEyBKdk6D

RUN echo mysql-server mysql-server/root_password \
    password $MYSQL_ROOT_PASS | debconf-set-selections
RUN echo mysql-server mysql-server/root_password_again \
    password $MYSQL_ROOT_PASS | debconf-set-selections

# Install apt-utils first so we avoid errors in Docker build.
RUN apt-get update && apt-get -y install apt-utils

# Install Apache, MySQL and PHP along with all the dependencies.
RUN apt-get -y install curl zip unzip libicu55 libmcrypt-dev g++ libicu-dev \
    libmcrypt4 pwgen git mysql-server apache2 libapache2-mod-php7.0 \
    php7.0-mysql php7.0-mcrypt php7.0-opcache php7.0 php7.0-cli php7.0-fpm \
    php7.0-gd php7.0-json php7.0-readline php7.0-common php7.0-curl \
    php7.0-mbstring php7.0-mcrypt php7.0-intl php7.0-simplexml

# Add volumes for MySQL & Apache 2
VOLUME  ["/etc/mysql", "/var/lib/mysql", "/var/www/html"]
RUN service mysql restart

# Open ports 80 and 3306. Port 8765 is for CakePHP's development server should
# you need to use it.
EXPOSE 80 3306 8765

# Remove and purge some previously installed software.
RUN requirementsToRemove="libmcrypt-dev g++ libicu-dev" \
    && apt-get purge --auto-remove -y $requirementsToRemove \
    && rm -rf /var/lib/apt/lists/*

# Default config for vhost.
ADD apache_default /etc/apache2/sites-available/000-default.conf

# Enable mod_rewrite.
RUN a2enmod rewrite

# Setup work directory for Composer and CakePHP installation.
WORKDIR /var/www/html

# Install Composer.
RUN curl -sSL https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && apt-get update \
    && apt-get install -y zlib1g-dev \
    && apt-get purge -y --auto-remove zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Install latest version of CakePHP to the configured Apache Vhost folder.
RUN /usr/local/bin/composer create-project --prefer-dist cakephp/app \
    /var/www/html/cakephp

# Make cake bake executable.
RUN chmod +x /var/www/html/cakephp/bin/cake

# Apply all the correct permissions.
RUN usermod -u 1000 www-data

# Now we can restart Apache for everything to kick in.
RUN service apache2 restart

# Run the development server just in case. You can access this on port 8765.
# RUN bin/cake server -H 0.0.0.0
