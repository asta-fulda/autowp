# AutoWP

This repo provides our sources for the creation of a tree-like wordpress image creation process.

To have more management control over our wordpress applications and to reuse specific plugins and settings we are developing some automation for this. In principle there is the following hierachy of images:

- php7.1-{apache|fpm-alpine} (modified version)
   - astafulda/wp-base:{apache|fpm-alpine}
      - astafulda/application:{apache|fpm-alpine}

In the first layer the basic system with wp-cli and it's version is defined. The second layer defines packages and plugins that are common for every site. The third layer defines application specific packages and plugins. In every layer are version definitions.

To install wordpress into the container with all the needed plugins we fire-up a database container along the build environment which will be thrown away afterwards.

## Usage

Right now there are three small scripts for the development process:

```
./build-apache.sh
./run.sh
./stop.sh
```

With `build-apache.sh` the wp-base image against php7.1-apache will be build.

## Future

* 'config_env.sh, which can be used to set the settings in one main instance and output the corresponding database.sql file for later use.
* 'check_version.sh' to check the internal defined version against the latest versions on the net to fail automated builds.
* CI integration for automated builds of all apps