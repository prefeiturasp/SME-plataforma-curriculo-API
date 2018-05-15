SME-plataforma-curriculo-API
=====

Project description here!

System Dependencies
-------------------

- CentOS 7
- Ruby 2.5.1
- Rails 5.2.0
- Rubygems
- Bundler (`gem install bundler`)
- PostgreSQL

Running with Docker
---------------------------

This project comes equipped to be run within Docker, but this requires a few more local dependencies. For instructions on installing and getting started with Docker go [here](https://www.docker.com/products/docker) and you need [`docker-compose`](https://docs.docker.com/compose/overview/).

On first you'll need set environment variables on your docker-compose, make sure that all environment variables have been defined below:

- Rails application environment variables (production environment):

    APPLICATION_ROOT_PATH
    PLATAFORMA_USERNAME
    PLATAFORMA_DATABASE
    PLATAFORMA_PASSWORD
    PLATAFORMA_HOST

- Database:

    POSTGRES_USER
    POSTGRES_PASSWORD
    POSTGRES_DB

Check the `database.yml` configurations, is necessary define database parameters on development environment.

Run the docker build for create database and build your application

`$ docker-compose build app_development`

The database is already created, it is only necessary to run the pending migrations

`$ docker-compose run --rm app_development bundle exec rake db:migrate `

After all the dependencies are installed and the project is built, run the application

`$ docker-compose up app_development`

On first boot you'll also need to create your database, for that use:

`$ docker-compose run --rm app_development rake db:migrate `

After setting up, you can run the application and dependencies using [docker-compose]:

`$ docker-compose up app_development`

Your Docker host is running on `localhost` then you should be able to use


Deploy with capistrano
---------------------------

Use Capistrano for deploy, there are some configuration files that are required. See the list below:

* Create a nginx.conf on `<shared_path>/docker/web/nginx.conf`. In the same folder there is a sample file.

* Create a docker-compose file on `<shared_path>/docker-compose.yml`. Get the docker-compose.yml file on root application and make your environment variables.
  - Rails application environment variables (production environment):

      PLATAFORMA_USERNAME
      PLATAFORMA_DATABASE
      PLATAFORMA_PASSWORD
      PLATAFORMA_HOST

  - Database:

      POSTGRES_USER
      POSTGRES_PASSWORD
      POSTGRES_DB

* In the shared folder `<shared_path>/config`, create the configuration files needed to run rails (master.key, database.yml, storage.yml, secrets.yml ).

* Install the [Docker](https://www.docker.com/products/docker) and [`docker-compose`](https://docs.docker.com/compose/overview/) on the server that deploy will be performed.

Run the `cap <environment> deploy:check` command to verify that all dependencies have been created.

If all the configuration files were created, run the command above to deploy the application, create the docker build, and upload the container.

`$ cap <environment> deploy `

If it is the first run run the commands below to create and run the database migrations.

  `$ cap <environment> docker:setup_db`
  `$ cap <environment> docker:migrate`

Tools
---------------------------

* Run the test suite

```ruby
    $ rspec
```
