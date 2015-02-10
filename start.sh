#!/bin/bash

if [ ! -d "/phpmemcachedadmin/Config" ]; then 
    mv /usr/share/nginx/Config /phpmemcachedadmin
    ln -s /phpmemcachedadmin/Config /usr/share/nginx/
else
    rm -fr /usr/share/nginx/Config
    ln -s /phpmemcachedadmin/Config /usr/share/nginx/
fi

/usr/sbin/php5-fpm -D && /usr/sbin/nginx
