# Basic Docker Guide

This guide provides an introduction to Docker, an open-source platform designed to facilitate the creation, packaging, and execution of applications in containers.

## What is Docker?

Docker is a platform that enables developers to package, distribute, and run applications in containers. Containers are isolated environments that contain everything an application needs to run, including the code, libraries, and dependencies. They ensure consistency across development, testing, and production environments, making it easy to deploy applications anywhere.

## Installation

### Linux

To install Docker on Linux, follow the official instructions [here](https://docs.docker.com/engine/install/).

### macOS

To install Docker on macOS, follow the official instructions [here](https://docs.docker.com/desktop/install/).

### Windows

To install Docker on Windows, follow the official instructions [here](https://docs.docker.com/desktop/install/).

## Basic Usage

### Running a Container

To run a container, use the `docker run` command. For example:

```bash
docker run hello-world
```

This command will download and run an image named "hello-world" from the Docker Hub.

### Listing Active Containers

To list active containers, use the `docker ps` command. For example:

```bash
docker ps
```

### Listing All Containers

To list all containers (active and inactive), use the `docker ps -a` command. For example:

```bash
docker ps -a
```

### Stopping a Container

To stop a running container, use the `docker stop` command. For example:

```bash
docker stop <container_id>
```

Replace `<container_id>` with the ID of the container you want to stop.

### User Permission

To allow a user to execute Docker commands without using `sudo`, add the user to the `docker` group. Run the following command:

```bash
sudo usermod -aG docker $USER
```

After running this command, you will need to log out and log back in for the changes to take effect.

## Creating a Dockerfile

A Dockerfile is a text file that contains instructions for building a Docker image. Here's an example of a simple Dockerfile for a Node.js application:

```Dockerfile
# Use a Node.js base image
FROM node:alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json file to the working directory
COPY package.json .

# Install dependencies
RUN npm install

# Copy the entire source code to the working directory
COPY . .

# Expose port 3000 to the outside world
EXPOSE 3000

# Command to start the application
CMD ["npm", "start"]
```

## Building an Image from Dockerfile

To build an image from the Dockerfile, use the `docker build` command. For example:

```bash
docker build -t my-app .
```

This will create an image named "my-app" based on the Dockerfile in the current directory (`.`).

## Running a Container from a Custom Image

To run a container from a custom image, use the `docker run` command. For example:

```bash
docker run -p 3000:3000 my-app
```

This will run a container of your application on port 3000 of the host.
