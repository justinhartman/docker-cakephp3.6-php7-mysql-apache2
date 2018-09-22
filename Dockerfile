FROM ubuntu:xenial
LABEL maintainer="Justin Hartman <justin@hartman.me>"
LABEL description="Installs Apache 2, MySQL 5.7, PHP 7.0 and CakePHP 3.6."

# Setup enviroment variables.
ENV DEBIAN_FRONTEND noninteractive
ENV MYSQL_ROOT_PASSWORD RpgCNfRTBpEyBKdk6D

# Define ports 80 and 3306.
EXPOSE 80 3306

# Set the mysql root password.
RUN echo mysql-server mysql-server/root_password \
    password $MYSQL_ROOT_PASSWORD | debconf-set-selections && \
    echo mysql-server mysql-server/root_password_again \
    password $MYSQL_ROOT_PASSWORD | debconf-set-selections

# Install apt-utils first so we avoid errors in Docker build and then,
# Then, install Apache, MySQL and PHP along with some required dependencies.
RUN apt-get update && apt-get -y install apt-utils && \
    apt-get -y install curl zip unzip libicu55 libmcrypt-dev g++ libicu-dev \
    libmcrypt4 pwgen git mysql-server apache2 libapache2-mod-php7.0 \
    php7.0-mysql php7.0-mcrypt php7.0-opcache php7.0 php7.0-cli php7.0-fpm \
    php7.0-gd php7.0-json php7.0-readline php7.0-common php7.0-curl \
    php7.0-mbstring php7.0-mcrypt php7.0-intl php7.0-simplexml

# Copy core files across.
COPY config/database.sql /etc/mysql/database.sql
COPY config/apache_default /etc/apache2/sites-available/000-default.conf

# Enable mod_rewrite and set localhost as ServerName.
RUN a2enmod rewrite && echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Remove and purge some previously installed software to save space.
RUN requirementsToRemove="libmcrypt-dev g++ libicu-dev" \
    && apt-get purge --auto-remove -y $requirementsToRemove \
    && rm -rf /var/lib/apt/lists/*

# Restart MySQL. Run database creation script.
# RUN service mysql restart
RUN mysql -u root -pRpgCNfRTBpEyBKdk6D < /etc/mysql/database.sql

# Setup work directory for Composer and CakePHP installation.
WORKDIR /var/www/html

# Clone your application (cloning CakePHP 3 / app instead of composer create
# project to demonstrate application deployment example).
RUN rm -rf /var/www/html \
    && git clone https://github.com/cakephp/app.git /var/www/html \
    && cp config/app.default.php config/app.php \
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

# Add volumes for MySQL & Apache 2
VOLUME  ["/etc/mysql", "/var/lib/mysql", "/etc/apache2", "/var/www/html"]

# Copy the repos .env file to the project.
COPY --chown=www-data:www-data config/env.default config/.env

# Apply all the correct permissions and restart Apache.
RUN usermod -u www-data www-data && service apache2 restart

# Run Apache webserver
CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
