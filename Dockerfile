FROM php:7.4-fpm

RUN apt-get update -y \
    && apt-get install -y nginx

# PHP_CPPFLAGS are used by the docker-php-ext-* scripts
ENV PHP_CPPFLAGS="$PHP_CPPFLAGS -std=c++11"

RUN docker-php-ext-install opcache \
    && apt-get install libicu-dev -y \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && apt-get remove libicu-dev icu-devtools -y
RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=2'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/php-opocache-cfg.ini

RUN pecl install gender-1.1.0 && docker-php-ext-enable gender

RUN { \
        echo 'server {'; \
        echo 'listen   9090;'; \
        echo 'root    /var/www/gender;'; \
        echo 'include /etc/nginx/default.d/*.conf;'; \
        echo 'index index.php;'; \
        echo 'client_max_body_size 30m;'; \
        echo 'location / {'; \
        echo 'try_files $uri $uri/ /index.php$is_args$args;'; \
        echo '}'; \
        echo 'location ~ [^/]\.php(/|$) {'; \
        echo 'fastcgi_split_path_info ^(.+?\.php)(/.*)$;'; \
        echo 'fastcgi_param HTTP_PROXY "";'; \
        echo 'fastcgi_pass 127.0.0.1:9000;'; \
        echo 'fastcgi_index index.php;'; \
        echo 'include fastcgi.conf;'; \
        echo '}'; \
        echo '}'; \
    } > /etc/nginx/conf.d/default.conf


COPY --chown=www-data:www-data . /var/www/gender

WORKDIR /var/www/gender

EXPOSE 9090

CMD service nginx start && php-fpm