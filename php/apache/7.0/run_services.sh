#!/bin/bash

ps auxw | grep mysql | grep -v grep > /dev/null
if [ "$?" != "0" ]; then
  service mysql start > /dev/null
fi

ps auxw | grep apache2 | grep -v grep > /dev/null
if [ "$?" != "0" ]; then
  /usr/sbin/apache2ctl -DFOREGROUND > /dev/null
fi
