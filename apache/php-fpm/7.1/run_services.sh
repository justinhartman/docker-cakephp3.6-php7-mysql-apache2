#!/bin/bash
#
# A bash script that checks to see if MySQL, PHP-FPM and Apache are running and
# starts either service if they are down.
#
# Copyright (c) 2018 Justin Hartman <justin@hartman.me> https://justinhartman.blog
# Repo: https://github.com/justinhartman/docker-cakephp3.6-php7-mysql-apache2
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Check and start MySQL.
ps auxw | grep mysql | grep -v grep > /dev/null
if [ "$?" != "0" ]; then
  service mysql start > /dev/null
fi

# Check and start PHP-FPM.
ps auxw | grep php-fpm | grep -v grep > /dev/null
if [ "$?" != "0" ]; then
  service php7.1-fpm start > /dev/null
fi

# Check and start Apache.
ps auxw | grep apache2 | grep -v grep > /dev/null
if [ "$?" != "0" ]; then
  /usr/sbin/apache2ctl -DFOREGROUND > /dev/null
fi
