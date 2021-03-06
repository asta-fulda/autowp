FROM astafulda/wp-cli
MAINTAINER AStA HS-Fulda <edv@asta.hs-fulda.org>

ARG wp_build_version=latest
ARG wp_build_locale=en_US

ENV WP_VERSION="${wp_build_version}" \
   WP_LOCALE="${wp_build_locale}"

ENV WP_URL=localhost \
   WP_TITLE=Wordpress \
   WP_ADMIN_USER=admin \
   # If admin pass is not defined wp will generate a random password
   # and print it to the build log
   #WP_ADMIN_PASSWORD=password \
   WP_ADMIN_EMAIL=admin@some.thing

ENV MYSQL_DATABASE=wordpress \
   MYSQL_USER=wordpress \
   MYSQL_PASSWORD=password \
   MYSQL_HOST=wpdb \
   WP_PREFIX=wp_

COPY init /usr/local/bin
RUN chmod +x /usr/local/bin/init
COPY wp-base-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/wp-base-entrypoint.sh

RUN mkdir /init

# Write all plugins line by line into /plugins.txt before init script is called
RUN printf "active-directory-integration 1.1.8\n" >> /plugins.txt

# - Actual installation of Wordpress against a running db container
#   within a build_context network happens in the init script
# - Clean up wp-config after build process, so we can assume that it
#   is not present.
# - run init in Dockerfile to embed everything within the container
#   otherwise it will be added on docker run.
RUN init; \
      rm /var/www/html/wp-config.php; \
      echo "This is an image embedded wordpress." >> /var/www/html/embedded

ENTRYPOINT ["wp-base-entrypoint.sh"]