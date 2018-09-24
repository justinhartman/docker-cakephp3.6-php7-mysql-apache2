# Local Containers #
####################

# Create Docker image using -t so it has a friendly name.
docker build -t sid_apache_7.3_image debian/php/apache/7.3
docker build -t sid_apache_7.2_image debian/php/apache/7.2
docker build -t sid_apache_7.1_image debian/php/apache/7.1
docker build -t sid_apache_7.0_image debian/php/apache/7.0
docker build -t sid_nginx_7.3_image debian/php/nginx/7.3
docker build -t sid_nginx_7.2_image debian/php/nginx/7.2
docker build -t sid_nginx_7.1_image debian/php/nginx/7.1
docker build -t sid_nginx_7.0_image debian/php/nginx/7.0
# Check where the image is built.
docker image ls
# Run the app, mapping your machine’s port 4000 to the container’s port 80.
docker run -p 80:80 sid_apache_7.3_image
docker run -p 80:80 sid_apache_7.2_image
docker run -p 80:80 sid_apache_7.1_image
docker run -p 80:80 sid_apache_7.0_image
docker run -p 80:80 sid_nginx_7.3_image
docker run -p 80:80 sid_nginx_7.2_image
docker run -p 80:80 sid_nginx_7.1_image
docker run -p 80:80 sid_nginx_7.0_image
# Run the app in detached mode.
docker run -d -p 80:80 sid_apache_7.3_image
docker run -d -p 80:80 sid_apache_7.2_image
docker run -d -p 80:80 sid_apache_7.1_image
docker run -d -p 80:80 sid_apache_7.0_image
docker run -d -p 80:80 sid_nginx_7.3_image
docker run -d -p 80:80 sid_nginx_7.2_image
docker run -d -p 80:80 sid_nginx_7.1_image
docker run -d -p 80:80 sid_nginx_7.0_image
# Stop the container process.
docker image ls
docker container stop CONTAINER_ID

# Publishing Images/Containers #
################################

# Login to Docker.
docker login
# Tag the image (docker tag image_name username/repository:tag).
docker tag sid_apache_7.2_image justinhartman/cakephp3.5-php7-mysql-apache2:latest
docker tag sid_apache_7.2_image justinhartman/cakephp3.5-php7-mysql-apache2:apache-7.2
docker tag sid_apache_7.2_image justinhartman/cakephp3.5-php7-mysql-apache2:apache-php-7.2
docker tag sid_apache_7.0_image justinhartman/cakephp3.5-php7-mysql-apache2:apache-7.0
docker tag sid_apache_7.0_image justinhartman/cakephp3.5-php7-mysql-apache2:apache-php-7.0
docker tag sid_nginx_7.2_image justinhartman/cakephp3.5-php7-mysql-apache2:nginx-7.2
docker tag sid_nginx_7.2_image justinhartman/cakephp3.5-php7-mysql-apache2:nginx-php-7.2
docker tag sid_nginx_7.0_image justinhartman/cakephp3.5-php7-mysql-apache2:nginx-7.0
docker tag sid_nginx_7.0_image justinhartman/cakephp3.5-php7-mysql-apache2:nginx-php-7.0
# See list of tagged images.
docker image ls
# Publish and Upload your tagged image to the repository.
docker push justinhartman/cakephp3.5-php7-mysql-apache2:latest
docker push justinhartman/cakephp3.5-php7-mysql-apache2:apache-7.2
docker push justinhartman/cakephp3.5-php7-mysql-apache2:apache-php-7.2
docker push justinhartman/cakephp3.5-php7-mysql-apache2:apache-7.0
docker push justinhartman/cakephp3.5-php7-mysql-apache2:apache-php-7.0
docker push justinhartman/cakephp3.5-php7-mysql-apache2:nginx-7.2
docker push justinhartman/cakephp3.5-php7-mysql-apache2:nginx-php-7.2
docker push justinhartman/cakephp3.5-php7-mysql-apache2:nginx-7.0
docker push justinhartman/cakephp3.5-php7-mysql-apache2:nginx-php-7.0
# Pull and run the image from the remote repository.
docker run -p 80:80 justinhartman/cakephp3.5-php7-mysql-apache2:latest

# Running Services #
####################

# Give app a name
docker stack deploy -c docker-compose.yml getstartedlab
# Get the service ID for the application
docker service ls
# List the tasks for your service:
docker service ps getstartedlab_web

# Deploy and redeploy (run when having made changes or go live).
docker stack deploy -c docker-compose.yml getstartedlab
# Take the app down
docker stack rm getstartedlab
# Take down the swarm
docker swarm leave --force

# Cheatsheet
docker stack ls                                            # List stacks or apps
docker stack deploy -c <composefile> <appname>  # Run the specified Compose file
docker service ls                 # List running services associated with an app
docker service ps <service>                  # List tasks associated with an app
docker inspect <task or container>                   # Inspect task or container
docker container ls -q                                      # List container IDs
docker stack rm <appname>                             # Tear down an application
docker swarm leave --force      # Take down a single node swarm from the manager

# Docker Compose #
##################

# Build the app from docker-compose.yml.
docker-compose up
# Run in daemon mode.
docker-compose up -d
# Stope the daemon.
docker-compose stop
# Remove containers, bring everything down and remove volumes
docker-compose down --volumes
# Specify an alternate compose file.
docker-compose up -f docker-compose.debug.yml
# Use -p to specify a project name
docker-compose up -p sid_apache_7.3_image
# Pull a specific build item from the file
docker-compose -f php/apache/7.2/docker-compose.yml pull db

# Swarm Clusters #
##################

# Enable Swarm mode.
docker swarm init
# Join Swarm as workers.
docker swarm join

# Create a couple VMs.
docker-machine create --driver virtualbox myvm1
docker-machine create --driver virtualbox myvm2
# List VMs and get IP addresses.
docker-machine ls
# Initialise Swarm and add Nodes. Instruct myvm1 to become a swarm manager.
docker-machine ssh myvm1 "docker swarm init --advertise-addr <myvm1 ip>"
# Join workers to the Swarm. Have myvm2 join the swarm as a worker.
docker-machine ssh myvm2 "docker swarm join --token <token> <ip>:2377"
# Run docker node ls on the manager to view the nodes in this swarm.
docker-machine ssh myvm1 "docker node ls"
