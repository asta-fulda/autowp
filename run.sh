#!/bin/bash

# Run a Wordpress-Environment

./stop.sh
printf "Creating runtime network...\n"
docker network create runtime
printf "Network created!\nCreating MYSQL-Container...\n"
docker run --rm --name=wpdb --net runtime -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wordpress -e MYSQL_PASSWORD=password -d mysql:5.6
printf "Waiting for the DB-Container to be ready...\n"
sleep 60
printf "DB ready!\nStarting Wordpress Instance...\n"
docker run --rm --network runtime -p 80:80 --name wp -d astafulda/wp-base:1.0-apache
printf "Done! User ./stop.sh to stop the environment.\n"