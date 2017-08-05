# AutoWP

This repo provides our sources for the creation of a tree-like wordpress image creation process.

To have more management control over our wordpress applications and to reuse specific plugins and settings we are developing some automation for this. In principle there is the following hierachy of images:

- php7.1-{apache|fpm-alpine} (modified version)
   - astafulda/wp-base:{apache|fpm-alpine}
      - astafulda/application:{apache|fpm-alpine}

In the first layer the basic system with wp-cli and it's version is defined. The second layer defines packages and plugins that are common for every site. The third layer defines application specific packages and plugins. In every layer are version definitions.

To install wordpress into the container with all the needed plugins we fire-up a database container along the build environment which will be thrown away afterwards.

## Usage

### Use cases

1. Use the embedded version
2. Use with an existing installation

The embedded version gets installed within the image and wordpress does not have any rights in changing it's own files. All plugins and themes have to be defined in the recommended way.

### Building and running the images

Right now there are three small scripts for the development process:

```bash
$ ./build-apache.sh
$ ./run.sh
$ ./stop.sh
```

With `build-apache.sh` the wp-base image against php7.1-apache will be build.

### Configuration

The version of wordpress and locale can be changed with environment variables.

Additional plugins can be defined in three ways:

1. Put them into `/init/plugins.txt` volume
2. Put them into `/var/www/html/plugins.txt` volume
3. Define them in the `Dockerfile`

**Example plugin definition:**

```docker
RUN printf "active-directory-integration 1.1.8\n" >> /plugins.txt
```

If you want to use the embedded version with persistent content/media mount the `/var/www/html/wp-content/uploads` folder. If you mount the `wp-content` folder you can persist also plugins and themes, though this is discouraged. Instead define plugins and themes in the init script or image definition.

If you want to start with an existing installation of wordpress including an sql dumb:

1. mount your wordpress folder to `/var/www/html`
2. mount the sql dumb to `/init/database.sql`

Only if there is no `/var/www/html/wp-config.php` the config will be created from the ENV.

Don't forget to set the right ENVs for your new container if you want the config to be created by the init script.

**Example container run command (with wp volume and db dump):**

```bash
$ docker run --name=wp --net runtime -v $PWD/wordpress:/var/www/html -v $PWD/wordpress.sql:/init/database.sql -e WP_PREFIX=wp_custom_ -p 80:80 -d astafulda/wp-base:1.0-apache
```

## Future

* 'config_env.sh, which can be used to set the settings in one main instance and output the corresponding database.sql file for later use.
* 'check_version.sh' to check the internal defined version against the latest versions on the net to fail automated builds.
* CI integration for automated builds of all apps
* List of Plugins and their build/runtime dependencies; process this list and install all needed plugins on image build
* Have some automation to update the container with a prior test setup, for example have a second container that is up to date, copies the volumes and dumps and import the database in a local db container to preview the changes...
* Include a real "ready"-test for the db container
* At the moment it is not possible to mount an empty volume to /var/www/html. A wordpress has to be present if something is mounted to this path.