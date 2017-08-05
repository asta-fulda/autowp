FROM astafulda/cli-php7.1-apache

# install the PHP extensions we need
# and cleanup afterwards
RUN set -ex; \
	\
	apt-get update; \
      apt-get install -y \
            libldap2-dev \
            libmcrypt-dev \
            libcurl3-dev \
	; \
	\
	rm -rf /var/lib/apt/lists/*; \
	\
      docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/; \
      docker-php-ext-install ldap; \
	docker-php-ext-install mcrypt; \
	docker-php-ext-install mbstring; \
	docker-php-ext-install curl

ARG wp_version=latest
ARG wp_locale=en_US
ARG wp_plugins

ENV WP_BUILD_VERSION=wp_version \
   WP_BUILD_LOCALE=wp_locale \
   WP_BUILD_PLUGINS=wp_plugins

ENV WP_URL=localhost \
   WP_TITLE=Wordpress \
   WP_ADMIN_USER=admin \
   WP_ADMIN_PASSWORD=password \
   WP_ADMIN_EMAIL=edv@asta.hs-fulda.org

ENV MYSQL_DATABASE=wordpress \
   MYSQL_USER=wordpress \
   MYSQL_PASSWORD=password \
   MYSQL_HOST=wpdb \
   WP_PREFIX=wp_


COPY init.sh /init.sh
RUN chmod +x /init.sh

RUN /init.sh

ENTRYPOINT ["/init.sh && apache2-foreground"]