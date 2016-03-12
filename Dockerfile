FROM gymnae/webserverbase

#install packages
RUN apk-install \
imagemagick \
 php-cli \
    php-fpm \
    php-bz2 \
    php-ctype \
    php-curl \
    php-dom \
    php-exif \
    php-gd \
    php-iconv \
    php-json \
    php-mcrypt \
    php-openssl \
    php-pgsql \
    php-pdo_pgsql \
    php-posix \
    php-xml \
    php-zip \
    php-zlib \
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
