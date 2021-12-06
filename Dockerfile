FROM php:7.4-fpm-alpine

RUN apt-get update -q && apt-get install -y git curl

RUN pecl install gender-1.1.0 && docker-php-ext-enable gender

WORKDIR /gender

COPY . /gender

RUN curl --silent --show-error https://getcomposer.org/installer | php

RUN ./composer.phar install

RUN ./composer.phar test

RUN adduser www-data www-data

RUN chown -R www-data:www-data .

USER www-data

EXPOSE 9090

CMD ["php-fpm"]
