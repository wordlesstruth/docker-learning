# basics

> *A beginning is a very delicate time.*
>
> *-Princess Irulan, Dune*

## table of contents

- [Docker vs. Virtual machine](#docker-vs.-virtual-machine)
- [Docker image vs container](#image-vs-container)
- [Docker file types](#docker-file-types)
  - [Dockerfile](#dockerfile)
  - [.dockerignore](#.dockerignore)
  - [docker-compose.yml](#docker-compose.yml)
  - [.env](#.env)

## Docker vs. Virtual machine

Docker is a lighter weight (when it wants to be) tool than full fledged virtual machine. At it's most basic level, a Docker image can be as simple as a scratch image with a binary (and what that binary needs to run).

Every image starts with some `FROM` statement. This statement dictates the nature of that image. Typically, you will see some operating system as the basis of a layer. This is, in my opinion, how some people start to get lost in the difference between docker and a virtual machine. Really all of these layers are all calling to the same linux kernel (whose architecture is dependent on the host you're running on. For windows this could be a wsl backend for instance).

All containers share the same host kernel; they don't get a copy of their own everything like a vm would. Containers are much quicker to start up, but offer much less isolation than a full fledged vm.

A simple docker image is shown below:

```docker
# use an ubuntu distribution as our basis
FROM ubuntu:20.04 as build

# install g++ so we can compile our hello-world example
RUN apt-get update \
    && apt-get install -y g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /sw/

COPY hello-world.cpp .

# Static flag throws runtime deps into the binary
# This allows us to run in a scratch image
RUN g++ -o hello-world --static hello-world.cpp


# This image is 2.05 MB, ubuntu:20.04 is 65.6MB
# when space is an issue, strategies like this can add up
FROM scratch as runtime
WORKDIR /sw/
COPY --from=build /sw/hello-world .
CMD ["./hello-world"]
```

## Image vs Container

The easiest way for me to understand this is by putting it into video game terms (I apologize if this example is unhelpful). When in a game and you run a level, or dungeon, you're placed into an instance of that level. Everything you do in there started from the same basic set of rules, but you're now changing the state of that level merely by interacting with it (attacking enemies, collecting loot). The base level in this instance is the *image* and you the player running it are inside the *container*.

Every container is spawned from some image and is an instance of that image. From the launch of that container you can change anything inside that container, download new packages, destroy the filesystem, but nothing will happen to the base image, and if you mess up - you can start fresh from the same base image.
> *There is a way to commit containers, but doing so is generally not a pattern I see too often, and is often (ime) done when you don't have time to make your image as clean as possible (we have a demo in 2 hours!)*

## Docker file types

There are a few files I find myself concerning myself with when it comes to docker.

- docker
  - Dockerfile
  - .dockerignore
- docker-compose
  - docker-compose.yml
  - .env

### Dockerfile

This is the file that lays out how an image is built. It is the way we can manage dependencies, both runtime and build time, in a deterministic fashion. It also serves as infrastructure-as-code in a sense - you're laying out how you expect the software to be built from the ground up, and how that software should run and in what conditions. This is the essence of removing the `it works on my machine` plight.

Dockerfile syntax will be covered in depth in another chapter.

### .dockerignore

This file tells the docker daemon to ignore certain files when it sends it to the context engine. The context engine by default (without this file) will send all files and folders recursively from the directory of the Dockerfile into the build context so that you can `COPY` or `ADD` any of them. It works similarly to a .gitignore file if you're familiar with that.

```.gitignore
# A helpful pattern (depending, of course, on your use)
# ignore everything, and selectively include what you want

*

!src
!include
!CMakeLists.txt
```

### docker-compose.yml

This file is for the program docker-compose, a very handy developer tool that should be in every devs toolbox (imo). Docker compose allows you to lay out networks and services in a connected way while also capturing in a configuration the runtime paramters of that image. Every docker image has some run parameters, whether its a network to attach to, a port to expose, a volume to mount.. etc. and docker compose helps encapsulate all of this.

### .env

The env file allows for programmatic insertion of variables into your docker-compose file.
