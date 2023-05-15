FROM composer:1.7 as composer-builder

COPY . . 

RUN composer install

FROM php:7.3.33-apache

RUN apt-get update -y \
    && apt-get upgrade -y \ 
    && apt-get clean \
    && rm -rf /var/cache/apt /var/lib/apt/lists/*

RUN sed -i "s/Listen 80/Listen 8080/" /etc/apache2/ports.conf

COPY apache.conf /etc/apache2/sites-available

RUN a2dissite 000-default \
    && a2ensite apache.conf \
    && a2enmod rewrite

USER www-data

COPY --chown=www-data:www-data --from=composer-builder /app /var/www/html/

EXPOSE 8080
