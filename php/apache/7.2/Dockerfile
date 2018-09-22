FROM ubuntu:bionic
LABEL maintainer="Justin Hartman <justin@hartman.me>"
LABEL description="CakePHP 3.6 running on Apache 2.4 and PHP 7.2."

################################################################
# Install packages and setup the configuration.                #
################################################################

# Install packages and PHP 7
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -q && apt-get install -qqy \
    git-core \
    composer \
    # Installing mod-php installs both recommended PHP 7 and Apache 2.
    libapache2-mod-php \
    php-intl \
    php-mbstring \
    php-zip \
    php-xml \
    php-simplexml \
    php-curl \
    php-codesniffer \
    php-mysql && \
    # Delete all the apt list files since they're big and get stale quickly
    rm -rf /var/lib/apt/lists/*

# Add apache config to enable .htaccess and do some stuff you want
COPY apache_default /etc/apache2/sites-available/000-default.conf

# Enable mod rewrite and listen to localhost
RUN a2enmod rewrite && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf

################################################################
# Deploy a CakePHP 3 Git installation from source.             #
################################################################

# Clone your application instead of using composer to create your project.
RUN rm -rf /var/www/html && \
    git clone https://github.com/cakephp/app.git /var/www/html

# Set Work Dir
WORKDIR /var/www/html

# Install application using Composer.
RUN composer -n install

# Copy the repos .env file to the project.
COPY --chown=www-data:www-data env.default config/.env

# Copy the app.php file
RUN cp config/app.default.php config/app.php \
    # Enable dotenv support.
    && sed -i "52s/\/\///" config/bootstrap.php \
    && sed -i "53s/\/\///" config/bootstrap.php \
    && sed -i "54s/\/\///" config/bootstrap.php \
    && sed -i "55s/\/\///" config/bootstrap.php \
    && sed -i "56s/\/\///" config/bootstrap.php \
    && sed -i "57s/\/\///" config/bootstrap.php \
    && sed -i "58s/\/\///" config/bootstrap.php \
    # Make Session Handler configurable via dotenv.
    && sed -i -e "s/'php',/env('SESSION_DEFAULTS', 'php'),/" config/app.php
    # Set write permissions for webserver
    chgrp -R www-data logs tmp && \
    chmod -R g+rw logs tmp

####################################################
# Expose Volumes & Port and run Apache webserver.  #
####################################################
VOLUME  ["/var/www/html"]
EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
