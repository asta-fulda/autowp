FROM astafulda/wp
MAINTAINER AStA HS-Fulda <edv@asta.hs-fulda.org>

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

# Write all plugins line by line into /plugins.txt before init script is called
RUN printf "active-directory-integration 1.1.8\n" >> /plugins.txt

# Build plugins into image
# Clean up wp-config afterwards - Important!
RUN init; \
      rm /var/www/html/wp-config.php;