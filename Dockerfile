FROM ubuntu:xenial
LABEL maintainer="Justin Hartman <justin@hartman.me>"
LABEL description="Installs Apache 2.4, MySQL 5.7, PHP 7.0 and CakePHP 3.6."

# Install Packages, PHP 7 and Modules.
ENV DEBIAN_FRONTEND noninteractive

# Define ports 80 and 3306.
EXPOSE 80 3306

# Add volumes for MySQL & Apache 2
VOLUME  ["/etc/mysql", "/var/lib/mysql", "/etc/apache2", "/var/www/html"]

# Set the mysql root password.
RUN echo mysql-server mysql-server/root_password \
	password $MYSQL_ROOT_PASSWORD | debconf-set-selections && \
	echo mysql-server mysql-server/root_password_again \
	password $MYSQL_ROOT_PASSWORD | debconf-set-selections

RUN apt-get update -q && apt-get install -qqy \
    git-core \
    composer \
    # Installing mod-php installs both recommended PHP 7 and Apache 2.
    libapache2-mod-php \
    php-mcrypt \
    php-intl \
    php-mbstring \
    php-zip \
    php-xml \
    php-simplexml \
    php-codesniffer \
    # Install MySQL server and extension.
    mysql-server \
    php-mysql && \
    # Purge previous apt list software to save space.
    rm -rf /var/lib/apt/lists/*

# Copy core files across.
COPY config/database.sql /etc/mysql/database.sql
COPY config/apache_default /etc/apache2/sites-available/000-default.conf

# Enable mod_rewrite and set localhost as ServerName.
RUN a2enmod rewrite && echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Restart MySQL. Run database creation script.
RUN service mysql restart \
	&& mysql -u root -pRpgCNfRTBpEyBKdk6D < /etc/mysql/database.sql

# Clone your application (cloning CakePHP 3 / app instead of composer create
# project to demonstrate application deployment example).
RUN rm -rf /var/www/html && \
    git clone https://github.com/cakephp/app.git /var/www/html

# Set Work Dir
WORKDIR /var/www/html

# Composer install application
RUN composer -n install

# Copy the app.php file
RUN cp config/app.default.php config/app.php && \
    # Enable dotenv support.
    && sed -i "52s/\/\///" config/bootstrap.php \
    && sed -i "53s/\/\///" config/bootstrap.php \
    && sed -i "54s/\/\///" config/bootstrap.php \
    && sed -i "55s/\/\///" config/bootstrap.php \
    && sed -i "56s/\/\///" config/bootstrap.php \
    && sed -i "57s/\/\///" config/bootstrap.php \
    && sed -i "58s/\/\///" config/bootstrap.php \
    # Make Session Handler configurable via dotenv.
    && sed -i -e "s/'php',/env('SESSION_DEFAULTS', 'php'),/" config/app.php \
    # Set write permissions for webserver
    chgrp -R www-data logs tmp && \
    chmod -R g+rw logs tmp

# Copy the repos .env file to the project.
COPY --chown=www-data:www-data config/env.default config/.env

# Apply all the correct permissions and restart Apache.
RUN usermod -u www-data www-data && service apache2 restart

# Run Apache webserver
CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
