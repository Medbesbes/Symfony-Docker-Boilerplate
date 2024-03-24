# Project Docker-Symfony-Boilerplate

## Introduction
The project appears to focus on "Docker-Symfony-Boilerplate," aiming to jumpstart Symfony projects with a pre-configured setup for seamless development, testing, and deployment. It's easy, efficient, and ready to use.

## Requirements
To be able to run the project you'll need docker to be installed, also configure your regular user account to be able to execute docker commands to prevent credential problems.

## Clone Project
Clone this repository using either the following command with HTTPS or with SSH:

```
git clone https://github.com/Medbesbes/Symfony-Docker-Boilerplate.git
```

```
git clone git@github.com:Medbesbes/Symfony-Docker-Boilerplate.git
```

## Getting Started
1. If not already done, [install Make](https://www.gnu.org/software/make/) on your s    ystem.
2. If not already done, [install Docker Compose](https://docs.docker.com/compose/install/) (v2.10+)
3. Run this command to build fresh images
```
make init
```

## Configuring the project
Your docker-compose.yaml use the file .env to provision informations like Posgress credential
Or pgAdmin creadential so you need to rename the env file to .env and make the neccessary modification.

## Files organisation
- "app" will contain your symfony project code.
- "data/postgres" will contain files concerning posgress container.
- "logs/nginx" will contain nginx access and error logs.
- "docker/nginx" will contain nginx configuration files that will be mapped inside nginx container.
- "docker/php" will contain the Dockerfile builds a PHP environment with the necessary dependencies and extensions to run PHP applications, particularly those utilizing PostgreSQL as a database, and sets up execution via PHP-FPM with Composer installed.

## Initiating a Shell Session
Start a shell session within a Docker container named "php" :

```
docker-compose run php sh

```


