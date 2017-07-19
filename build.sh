#!/bin/bash

# The name wpdb is very important, because it is also included within the wp-base
# Dockerfile as ENV MYSQL_HOST

docker network create build_context
docker run --rm --name=wpdb --net build_context -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wordpress -e MYSQL_PASSWORD=password -d mysql:5.6
cd cli-php7.1-fpm-alpine/
docker build -t astafulda/cli-php7.1-fpm-alpine .
cd ../wp-base
docker build --network build_context -t astafulda/wp-base:1.0 .
docker stop wpdb
docker network rm build_context