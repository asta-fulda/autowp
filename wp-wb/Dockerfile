FROM astafulda/wp-base
MAINTAINER AStA HS-Fulda <edv@asta.hs-fulda.org>

# Defining plugins before the init script is called...
RUN printf "active-directory-integration 1.1.8\n" >> /plugins.txt

# run init in Dockerfile to embed everything within the container
# otherwise it will be added on docker run.
RUN init; \
      rm /var/www/html/wp-config.php;