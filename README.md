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

Runnind with Docker
---------------------------

This project comes equipped to be run within Docker, but this requires a few more local dependencies. For instructions on installing and getting started with Docker go [here](https://www.docker.com/products/docker) and you need [`docker-compose`](https://docs.docker.com/compose/overview/).

On first you'll need set environment variables on your docker-compose, make sure that all environment variables have been defined below:

- Rails application environment variables (production environment):
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

  % docker-compose build app_development

The database is already created, it is only necessary to run the pending migrations

  % docker-compose run --rm app_development bundle exec rake db:migrate

After all the dependencies are installed and the project is built, run the application

  % docker-compose up app_development

This repository comes equipped with a self-setup script for using Docker:

    % ./bin/docker_setup

On first boot you'll also need to create your database, for that use:

    % docker-compose run --rm app rake db:migrate

After setting up, you can run the application and dependencies using [docker-compose]:

    % docker-compose up -d

Your Docker host is running on `localhost` then you should be able to use

