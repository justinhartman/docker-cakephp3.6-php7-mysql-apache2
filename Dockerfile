FROM ubuntu:xenial
MAINTAINER Justin Hartman <justin@hartman.me>

ENV DEBIAN_FRONTEND noninteractive
ENV MYSQL_ROOT_PASS RpgCNfRTBpEyBKdk6D

RUN echo mysql-server mysql-server/root_password \
    password $MYSQL_ROOT_PASS | debconf-set-selections
RUN echo mysql-server mysql-server/root_password_again \
    password $MYSQL_ROOT_PASS | debconf-set-selections

# Install Apache, MySQL and PHP.
RUN apt-get update && \
    apt-get -y install apt-utils git apache2 libapache2-mod-php7.0 \
    mysql-server php7.0-mysql pwgen php7.0-mcrypt php7.0-opcache php7.0 \
    php7.0-cli php7.0-fpm php7.0-gd php7.0-json php7.0-readline php7.0-common \
    php7.0-curl php7.0-mbstring

# Add volumes for MySQL & Apache 2
VOLUME  ["/etc/mysql", "/var/lib/mysql", "/var/www/html"]
RUN service mysql restart

# Open ports 80 and 3306.
EXPOSE 80 3306

# Install additional, required PHP modules.
RUN requirements="libmcrypt-dev g++ libicu-dev libmcrypt4 libicu55 curl \
    php7.0-mcrypt php7.0-intl php7.0-curl" \
    && apt-get install -y $requirements \
    && requirementsToRemove="libmcrypt-dev g++ libicu-dev" \
    && apt-get purge --auto-remove -y $requirementsToRemove \
    && rm -rf /var/lib/apt/lists/*

# Setup apache directory.
WORKDIR /var/www/html

# Default config for vhost.
ADD apache_default /etc/apache2/sites-available/000-default.conf

# Enable mod_rewrite.
RUN a2enmod rewrite

# Now we can restart Apache for everything to kick in.
RUN service apache2 restart

# Install Composer.
RUN curl -sSL https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && apt-get install -y zlib1g-dev git \
    && apt-get purge -y --auto-remove zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Install CakePHP 3.6 to the default Apache folder.
RUN cd /var/www/html
RUN /usr/local/bin/composer self-update && \
    /usr/local/bin/composer create-project --prefer-dist cakephp/app .

# Apply all the correct permissions.
RUN usermod -u 1000 www-data
