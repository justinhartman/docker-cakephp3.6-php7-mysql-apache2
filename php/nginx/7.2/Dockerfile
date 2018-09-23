FROM ubuntu:bionic
LABEL name="cakephp_nginx_7.2_image"
LABEL description="Fully operational installation of CakePHP 3.6 with 2 \
databases on PHP-FPM 7.2, Nginx 1.14 and MySQL 5.7."
LABEL maintainer="Justin Hartman <justin@hartman.me>"

################################################################
# Install packages and define any enviroment variables.        #
################################################################

# Install various packages needed for operation.
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -q && apt-get install -qqy \
    git-core \
    composer \
    # Install Nginx and PHP-FPM.
    nginx \
    php-fpm \
    # Other PHP extensions.
    php-intl \
    php-mbstring \
    php-zip \
    php-xml \
    php-simplexml \
    php-curl \
    php-codesniffer \
    # Installs MySQL Server and the PHP extension.
    mysql-server \
    php-mysql && \
    # Purge the apt list software to save space.
    rm -rf /var/lib/apt/lists/*

################################################################
# Setup MySQL by creating prod and testing databases & users.  #
################################################################

# Copy the sql statments script.
COPY database.sql /etc/mysql/database.sql

# Start MySQL Server and create the two databases and users.
RUN service mysql start && \
    mysql -u root < /etc/mysql/database.sql

################################################################
# Setup Nginx vhost                                            #
################################################################

# Disable daemon mode for Nginx.
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Copy default vhost to Apache config folder.
COPY nginx_default /etc/nginx/sites-available/localhost

# Enable the nginx vhost.
RUN rm /etc/nginx/sites-enabled/default && \
    ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/ && \
    service nginx reload

################################################################
# Deploy a CakePHP 3 Git installation from source.             #
################################################################

# Change the user to run as www-data.
RUN usermod -u 1000 www-data

# Clone application instead of using composer to create the project.
RUN rm -rf /var/www/html && \
    git clone https://github.com/cakephp/app.git /var/www/html

# Set Work Dir
WORKDIR /var/www/html

# Post-git installation of application using Composer.
RUN composer -n install

# Copy the app.php file
RUN cp config/app.default.php config/app.php && \
    # Enable dotenv support in bootstrap.php.
    sed -i "52s/\/\///" config/bootstrap.php && \
    sed -i "53s/\/\///" config/bootstrap.php && \
    sed -i "54s/\/\///" config/bootstrap.php && \
    sed -i "55s/\/\///" config/bootstrap.php && \
    sed -i "56s/\/\///" config/bootstrap.php && \
    sed -i "57s/\/\///" config/bootstrap.php && \
    sed -i "58s/\/\///" config/bootstrap.php && \
    # Make Session Handler configurable via dotenv.
    sed -i -e "s/'php',/env('SESSION_DEFAULTS', 'php'),/" config/app.php && \
    # Set owner and write permissions for files and folders.
    chown -R www-data:www-data . && \
    chmod -R +rw logs tmp && \
    # Let Cake change permissions as it needs to.
    composer -n install

# Copy the repos .env file, with database connection settings, to the project.
COPY --chown=www-data:www-data env.default config/.env

####################################################
# Run startup script for Nginx, php-fpm and MySQL. #
####################################################

# Define ports 80 and 3306.
EXPOSE 80 3306

# Copy and Run the services script which checks and starts MySQL and Nginx.
COPY run_services.sh /usr/local/bin/run_services
CMD ["run_services"]
