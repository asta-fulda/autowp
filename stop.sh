#!/bin/bash

# Stop the Wordpress environment

printf "Stopping wordpress instance...\n"
docker stop wp
printf "Done.\nStopping database...\n"
docker stop wpdb
printf "Done.\nRemoving runtime network...\n"
docker network rm runtime
printf "Done.\n"