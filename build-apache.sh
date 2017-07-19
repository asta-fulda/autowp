#!/bin/bash

# The name wpdb is very important, because it is also included within the wp-base
# Dockerfile as ENV MYSQL_HOST

printf "Creating build_context network...\n"
docker network create build_context
printf "Done.\nCreating database container...\n"
docker run --rm --name=wpdb --net build_context -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wordpress -e MYSQL_PASSWORD=password -d mysql:5.6
printf "Done.\nBuilding modified apache base image...\n"
cd cli-php7.1-apache/
docker build -t astafulda/cli-php7.1-apache .
printf "Done.\nWaiting for the database container to become ready...\n"
sleep 30
cd ../wp-base
printf "Done.\nBuilding wordpress base image...\n"
docker build --no-cache --network build_context -t astafulda/wp-base:1.0-apache .
printf "Done.\nStopping database container...\n"
docker stop wpdb
printf "Done.\nRemoving build_context network...\n"
docker network rm build_context
printf "Done.\n"