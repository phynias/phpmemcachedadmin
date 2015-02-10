#!/bin/bash

if [ ! -d "/phpmemcachedadmin/Config" ]; then 
    mv /usr/share/nginx/html/Config /phpmemcachedadmin
    ln -s /phpmemcachedadmin/html/Config /usr/share/nginx/html/
else
    rm -fr /usr/share/nginx/html/Config
    ln -s /phpmemcachedadmin/html/Config /usr/share/nginx/html/
fi

/usr/sbin/php5-fpm -D && /usr/sbin/nginx
