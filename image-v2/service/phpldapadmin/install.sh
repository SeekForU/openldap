#!/bin/bash -e
# this script is run during the image build

cat /container/service/phpldapadmin/assets/php7.0-fpm/pool.conf >> /etc/php/7.0/fpm/pool.d/www.conf
rm -rf /container/service/phpldapadmin/assets/php7.0-fpm/pool.conf

cp -f /container/service/phpldapadmin/assets/php7.0-fpm/opcache.ini /etc/php/7.0/fpm/conf.d/opcache.ini
rm -rf /container/service/phpldapadmin/assets/php7.0-fpm/opcache.ini

mkdir -p /var/www/tmp
chown www-data:www-data /var/www/tmp

# remove apache default host
a2dissite 000-default
rm -rf /var/www/html

# Add apache modules
a2enmod deflate expires

# delete unnecessary files
rm -rf /var/www/phpldapadmin_bootstrap/doc

# apply php5.5 patch
patch -p1 -d /var/www/phpldapadmin_bootstrap < /container/service/phpldapadmin/assets/php5.5.patch
sed -i "s/password_hash/password_hash_custom/g" /var/www/phpldapadmin_bootstrap/lib/TemplateRender.php
