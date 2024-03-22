FROM php:apache

# Установка необходимых инструментов для Composer и Git
RUN apt-get update \
    && apt-get install -y zip unzip git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Установка расширений mysqli и pdo_mysql
RUN docker-php-ext-install mysqli pdo_mysql

# Активация модуля mod_rewrite для htaccess
RUN a2enmod rewrite

# Установка Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Копирование файлов composer.json и composer.lock
COPY composer.json composer.lock /var/www/html/

# Установка зависимостей Slim через Composer
RUN cd /var/www/html/ && composer install --no-dev --optimize-autoloader

# Копирование .htaccess файла
COPY .htaccess /var/www/html/

# Копирование остального приложения
COPY . /var/www/html

# Права на файлы
RUN chown -R www-data:www-data /var/www/html/
