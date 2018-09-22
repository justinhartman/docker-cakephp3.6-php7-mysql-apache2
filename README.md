# CakePHP 3.6 Docker Image Container

A [CakePHP Docker Container][docker] which installs a fresh, fully configured
and operational version of CakePHP 3.6. It comes with two pre-configured
databases, for both production and testing environments and the app runs on PHP
7.2, Apache 2.4 and MySQL 5.7.

## Installation

Installation is dead-simple. Just run the following command and then access
your browser to see your newly configured CakePHP website.

```docker
docker run -p 80:80 justinhartman/cakephp3.5-php7-mysql-apache2:latest
```

## Supported tags and respective `Dockerfile` links

[`cakephp3-php7.2-apache2-mysql5`, `cakephp-php7.2-apache-mysql`, `latest` (php/apache/7.2/Dockerfile)][7.2]

The tags above install the following software versions:

1. CakePHP 3.6.11
1. PHP 7.2.10
1. Apache 2.4.29
1. MySQL 5.7.23

### TODO

There will be support in the future for additional tags to install different
software (i.e. Nginx, PHP 5.6, PHP 7.0, etc.).

## What is CakePHP?

[CakePHP][cakephp] is an open source web application framework. It follows the
Model-View-Controller (MVC) approach and is written in PHP, modelled after the
concepts of Ruby on Rails, and distributed under the MIT License.

[cakephp]: http://cakephp.org
[docker]: https://hub.docker.com/r/justinhartman/cakephp3.5-php7-mysql-apache2/
[7.2]: https://github.com/justinhartman/docker-cakephp3.5-php7-mysql-apache2/blob/c9a60c3c9ad1a4b1b7bc596fe3ac6dcc99e73d47/php/apache/7.2/Dockerfile
