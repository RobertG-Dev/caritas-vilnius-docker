FROM wordpress:php8.1

WORKDIR /var/www/html

# Setup the OS
RUN apt-get -qq update ; apt-get -y install unzip curl sudo subversion mariadb-client \
    && apt-get autoclean \
    && chsh -s /bin/bash www-data

# Install wp-cli
RUN curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /usr/local/bin/wp-cli.phar \
    && echo "#!/bin/bash" > /usr/local/bin/wp-cli \
    && echo "su www-data -c \"/usr/local/bin/wp-cli.phar --path=/var/www/html \$*\"" >> /usr/local/bin/wp-cli \
    && chmod 755 /usr/local/bin/wp-cli* \
    && echo "*** wp-cli command installed"

# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer \
    && chmod ugo+x /usr/local/bin/composer \
    && echo "*** composer command installed"

RUN composer global require phpunit/phpunit=^9 --dev \
    && composer global require --dev yoast/phpunit-polyfills \
    && composer global require wp-coding-standards/wpcs --dev \
    && composer global require phpcompatibility/php-compatibility --dev \
    && composer global require phpcompatibility/phpcompatibility-paragonie --dev \
    && composer global require phpcompatibility/phpcompatibility-wp --dev

ENV PATH="${PATH}:/root/.composer/vendor/bin"

RUN phpcs --config-set installed_paths /root/.composer/vendor/wp-coding-standards/wpcs,/root/.composer/vendor/phpcompatibility/php-compatibility,/root/.composer/vendor/phpcompatibility/phpcompatibility-paragonie,/root/.composer/vendor/phpcompatibility/phpcompatibility-wp

ENV WP_TESTS_PHPUNIT_POLYFILLS_PATH="/root/.composer/vendor/yoast/phpunit-polyfills"