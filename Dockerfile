FROM gymnae/webserverbase:latest

#install packages
RUN apk-install \
imagemagick \
    php5-json \
    php5-pdo_pgsql \
    php5-exif \
    php5-iconv \
    php5-bz2 \
    php5-ctype \    
    php5-posix \
    php5-xml \
    php5-zip \
    ffmpeg 

# Data volumes
VOLUME ["/media/koken"]

# temp folders for webserver
RUN mkdir -p /tmp/nginx/ && \
	chown nginx:www-data /tmp/nginx

# nginx site conf
COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./config/default.conf /etc/nginx/sites-available/default.conf
COPY ./config/php-fpm.conf /etc/php5/php-fpm.conf
COPY ./config/interfaces /etc/network/interfaces

EXPOSE 80

# Prepare the script that starts it all
ADD init.sh /
RUN chmod +x /init.sh && chmod 777 /init.sh

ENTRYPOINT ["/init.sh"]
