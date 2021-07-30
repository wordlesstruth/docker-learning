# docker-learning

> *It works on my machine..*

This quote has become famous in the developer world. Managing dependencies and run configurations is a challenge for any developer writing complex software. Docker provides a convenient mechanism to avoid *most* of these headaches. As with any software it's not perfect and neither are we and there are things we are learning every day.

Docker is a very important tool for us, and understanding its value is equally important. On this page we will outline some of the key things every developer should know. Below is a non-comprehensive list of things to concern yourself with when working with docker.

## Syllabus

- Basics:
  - Docker vs Virtual Machine
  - Image vs Container
  - The Dockerfile, docker-compose.yml, and .dockerignore files
- Setup:
  - Docker for windows and Windows Subsystem for Linux (WSL)
  - Docker daemon configuration
    - Insecure repos
    - Buildkit
  - Docker login to allow for pushing to a remote repo artifactory
  - Developing inside of a docker container
  - Running `docker run hello-world`
- Building:
  - Building our first image
    - What are layers?
    - How can we keep the size of our image down?
    - Multi-stage docker builds?
- Running:
  - Running our first image as a container
    - Run flags, which do i need to concern myself with?
    - Why does my container immediately exit?
- Docker volumes:
  - Anonymous vs named vs bind-mounted volume
  - How to access volume contents
- Docker networking:
  - Host network vs bridge vs named network vs macvlan
  - Exposing a port for your service
  - Networking in windows vs linux; host.docker.internal
- Docker compose:
  - What is docker-compose and what utility does it provide?
  - How do I connect two services?

## Command line reference

Please see the [reference](./Reference/README.md) page.
