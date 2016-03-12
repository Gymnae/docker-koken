FROM gymnae/webserverbase

#install packages
RUN apk-install \
imagemagick \
    php-json \
    php-mcrypt \
    php-openssl \
    php-pgsql \
    php-pdo_pgsql \
    php-zlib \
    php-exif \
    php-gd \
    php-iconv \
    php-bz2 \
    php-ctype \    
    php-posix \
    php-xml \
    php-zip \
    ffmpeg 

# Data volumes
VOLUME ["/media/koken"]

# temp folders for webserver
RUN mkdir /tmp/nginx/

# nginx site conf
ADD ./config/nginx.conf /etc/nginx/nginx.conf
ADD ./config/default.conf /etc/nginx/sites-available/default.conf
ADD ./config/php-fpm.conf /etc/php/php-fpm.conf
ADD ./config/interfaces /etc/network/interfaces

EXPOSE 80

# Prepare the script that starts it all
ADD init.sh /
RUN chmod +x /init.sh && chmod 777 /init.sh

CMD ["/init.sh"]
