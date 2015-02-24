#
# phpmemcachedadmin Dockerfile
# hi9
#
FROM ubuntu:14.04
MAINTAINER robv email: phynias@gmail.com

# Install Nginx.
RUN apt-get update && \
    apt-get install software-properties-common python-software-properties -y && \
    add-apt-repository -y ppa:nginx/stable && \
    apt-get update && \
    apt-get install -y nginx php5-fpm wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
    chown -R www-data:www-data /var/lib/nginx

RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf
#RUN sed -i -e "s/listen.owner = www-data/;listen.owner = www-data/g" /etc/php5/fpm/pool.d/www.conf
#RUN sed -i -e "s/listen.group = www-data/;listen.group = www-data/g" /etc/php5/fpm/pool.d/www.conf
#RUN sed -i -e "s/;listen.mode = 0660/listen.mode = 0660/g" /etc/php5/fpm/pool.d/www.conf

# nginx site conf
RUN rm -Rf /etc/nginx/conf.d/*
RUN mkdir -p /etc/nginx/sites-available/
RUN mkdir -p /etc/nginx/sites-enabled/
RUN mkdir -p /etc/nginx/ssl/
ADD ./nginx-site.conf /etc/nginx/sites-available/default.conf
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf


RUN  wget http://phpmemcacheadmin.googlecode.com/files/phpMemcachedAdmin-1.2.2-r262.tar.gz && \
     tar xfz phpMemcachedAdmin-1.2.2-r262.tar.gz -C /usr/share/nginx/html/ && \
     rm phpMemcachedAdmin-1.2.2-r262.tar.gz

# Define mountable directories.

RUN chown -R www-data:www-data /usr/share/nginx/html

# Define working directory.
WORKDIR /etc/nginx


VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html", "/phpmemcachedadmin"]

# Expose ports.
EXPOSE 80
EXPOSE 443

ADD ./start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/bin/bash", "/start.sh"]
