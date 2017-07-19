FROM astafulda/cli-php7.1-alpine

# install the PHP extensions we need
# and cleanup afterwards
RUN set -ex; \
	\
	apk add --no-cache --virtual .build-deps \
      openldap-dev \
      libmcrypt-dev \
      curl-dev \
	; \
	\
   docker-php-ext-install ldap; \
	docker-php-ext-install mysqli; \
	docker-php-ext-install mcrypt; \
	docker-php-ext-install mbstring; \
	docker-php-ext-install curl; \
	\
	runDeps="$( \
		scanelf --needed --nobanner --recursive \
			/usr/local/lib/php/extensions \
			| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
			| sort -u \
			| xargs -r apk info --installed \
			| sort -u \
	)"; \
	apk add --virtual .wordpress-phpexts-rundeps $runDeps; \
	apk del .build-deps

USER www-data
WORKDIR /var/www/html


ARG wp_version=latest
ARG wp_locale=en_US
ARG wp_plugins

ENV WP_BUILD_VERSION wp_version
ENV WP_BUILD_LOCALE wp_locale
ENV WP_BUILD_PLUGINS wp_plugins

ENV WP_URL=localhost
ENV WP_TITLE=Wordpress
ENV WP_ADMIN_USER=admin
ENV WP_ADMIN_PASSWORD=password
ENV WP_ADMIN_EMAIL=edv@asta.hs-fulda.org

ENV MYSQL_DATABASE=wordpress
ENV MYSQL_USER=wordpress
ENV MYSQL_PASSWORD=password
ENV MYSQL_HOST=wpdb
ENV WP_PREFIX=wp_

RUN wp core download --path=/var/www/html --locale=$wp_locale --version=$wp_version --allow-root; \
   wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=$MYSQL_HOST --dbprefix=$WP_PREFIX --locale=$wp_locale; \
   wp core install --url=$WP_URL --title=$WP_TITLE --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASS --admin_email=$WP_ADMIN_EMAIL --skip-email; \
   wp plugin install active-directory-integration --version=1.1.8 --activate