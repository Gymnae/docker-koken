FROM gymnae/webserverbase:latest

#install packages
RUN apk-install \
    imagemagick \
    php7-json \
    php7-mysqli \
    php7-exif \
    php7-iconv \
    php7-bz2 \
    php7-ctype \    
    php7-posix \
    php7-xml \
    php7-zip \
    php7-opcache \
    libzip \
    ffmpeg 

# Data volumes
VOLUME ["/media/koken"]

# temp folders for webserver
RUN mkdir -p /tmp/nginx/ && \
	chown nginx:www-data /tmp/nginx

# nginx site conf
COPY config/nginx.conf /etc/nginx/
COPY config/default.conf /etc/nginx/sites-available/
COPY config/php-fpm.conf /etc/php7/
COPY config/interfaces /etc/network/

EXPOSE 80 443

# Prepare the script that starts it all
ADD init.sh /
RUN chmod +x /init.sh && chmod 777 /init.sh

ENTRYPOINT ["/init.sh"]
