FROM gymnae/webserverbase:latest

#install packages
RUN apk-install \
    imagemagick \
    php7-json@testing \
    php7-msqli@testing \
    php7-exif@testing \
    php7-iconv@testing \
    php7-bz2@testing \
    php7-ctype@testing \    
    php7-posix@testing \
    php7-xml@testing \
    php7-zip@testing \
    libzip@community \
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
