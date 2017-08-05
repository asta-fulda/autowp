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

ARG wp_build_version=latest
ARG wp_build_locale=en_US

ENV WP_VERSION="${wp_build_version}" \
   WP_LOCALE="${wp_build_locale}"

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
COPY wp-base-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/wp-base-entrypoint.sh

RUN mkdir /init

# Defining plugins before the init script is called...
RUN printf "active-directory-integration 1.1.8\n" >> /plugins.txt
ENTRYPOINT ["wp-base-entrypoint.sh"]