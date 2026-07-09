FROM php:8.3-fpm

# ...existing code...

# Set working directory
WORKDIR /var/www/backend

# ...existing code...

# Install Symfony CLI (optional, useful for dev)
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    && mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

# Set permissions
RUN chown -R www-data:www-data /var/www/backend

EXPOSE 9000

CMD ["php-fpm"]
