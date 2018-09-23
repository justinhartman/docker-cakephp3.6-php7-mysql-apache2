#!/bin/bash

ps auxw | grep mysql | grep -v grep > /dev/null
if [ "$?" != "0" ]; then
  service mysql start > /dev/null
fi

ps auxw | grep php-fpm | grep -v grep > /dev/null
if [ "$?" != "0" ]; then
  service php7.2-fpm start > /dev/null
fi

ps auxw | grep nginx | grep -v grep > /dev/null
if [ "$?" != "0" ]; then
  service nginx start > /dev/null
fi
