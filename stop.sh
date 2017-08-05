#!/bin/bash

# Stop the Wordpress environment

printf "Stopping wordpress instance...\n"
docker rm -f wp
# not possible because sometimes write protected
#rm -R init
#rm -R wordpress
printf "Done.\nStopping database...\n"
docker rm -f wpdb
printf "Done.\nRemoving runtime network...\n"
docker network rm runtime
printf "Done.\n"