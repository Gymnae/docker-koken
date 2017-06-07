#!/bin/sh

# Set PHP pools to take up to 1/2 of total system memory total, split between the two pools.
# 30MB per process is conservative estimate, is usually less than that
PHP_MAX=$(expr $(grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//') / 1024 / 2 / 30 / 2)
sed -i -e"s/pm.max_children = 5/pm.max_children = $PHP_MAX/" /etc/php7/php-fpm.conf
sed -i -e"s/pm.max_children = 5/pm.max_children = $PHP_MAX/" /etc/php7/php.ini

# Set nginx worker processes to equal number of CPU cores
sed -i -e"s/worker_processes\s*4/worker_processes $(cat /proc/cpuinfo | grep processor | wc -l)/" /etc/nginx/nginx.conf

# enable opcache with recommended settings
sed -i -e"s/;opcache.enable=.*/opcache.enable=1/" /etc/php7/php.ini
sed -i -e"s/;opcache.enable_cli=.*/opcache.enable_cli=1/" /etc/php7/php.ini
sed -i -e"s/;opcache.max_accelerated_files=.*/opcache.max_accelerated_files=5/" /etc/php7/php.ini
sed -i -e"s/;opcache.memory_consumption=.*/opcache.memory_consumption=128/" /etc/php7/php.ini
sed -i -e"s/;opcache.save_comments=.*/opcache.save_comments=1/" /etc/php7/php.ini
sed -i -e"s/;opcache.revalidate_freq=.*/opcache.revalidate_freq=1/" /etc/php7/php.ini

# start php-fpm
mkdir -p /media/koken/logs/php-fpm
php-fpm7

# start nginx
mkdir -p /media/koken/logs/nginx
mkdir -p /tmp/nginx
chown nginx /tmp/nginx
nginx

