# Reference

This utility was inspired by a team-members file affectionately referred to as `DefenseAgainstTheDarkArts.txt`

> *The Dark Arts are many, varied, ever-changing and eternal. Fighting them is like fighting a many-headed monster, which, each time a neck is severed, sprouts a head even fiercer and cleverer than before. You are fighting that which is unfixed, mutating, indestructible.*

## Command Line

This list and the usage/examples are meant to separate the wheat from the chaff and get to the heart of the **most useful only (ime)** docker commands. There are quite a few flags, and for full reference you can view the docker hub, but that's not what this is for.

## Table of contents

- [docker build](#build)
- [docker run](#run)
- [docker images, ps](#images/ps)
- [docker push, pull, tag](#push/pull/tag)
- [docker exec](#exec)
- [docker rm, rmi](#rm/rmi)
- [docker save, load](#save/load)
- [docker cp](#cp)
- [one off commands](#misc)


## build

These are my most used build commands and flags

This section of commands assumes you to be in [docker-build](./docker-build)

```bash
# -t
# 'normal' docker build with a tag and context
docker build -t my-hello-world .

# --target
# build a particular stage of the Dockerfile with --target=<name_of_stage>; useful for multi-stage
docker build --target=build -t my-hello-world-builder .

# --no-cache
# build a particular image without using the cache, useful when you want to force curl/wget to grab a new item
docker build --no-cache -t my-hello-world .

# -f
# use a different Dockerfile with -f
docker build -f Dockerfile.goodbye -t my-goodbye-world .

# --build-arg
# pass a build time argument to the dockerfile (just please not secrets)
docker build --build-arg TEXT="it's a small" -t my-hello-world .

# context/.
# different directory context
docker build -t my-a-part-of-your-world context/.
```

## run

These are my most used run commands and flags

see [docker-run-volume.sh](./docker-run/docker-run-volume.sh) for a more in depth view of the `-v` flag

```bash
# --rm
# remove the container after use
docker run --rm ubuntu:20.04 "echo" "hello-world"

# --name
# gives the container a name you can reference it by, instead of the random one
docker run --name 'goodbye-world' ubuntu:20.04 "echo" "hello-world"
docker rm 'goodbye-world'

# -it (typically used together, though distinct flags!)
# interactive mode (type exit once inside the container and done)
docker run -it --rm ubuntu:20.04 bash

# -d
# run as a detached process - note the container runs for 10 seconds and then sleeps
docker run --rm -d ubuntu:20.04 "sleep" "10"

# -e
# set an environment variable at runtime
docker run --rm -it -e TEXT="hello world" ubuntu:20.04 env

# --network
# set the network to use at runtime
docker run --rm -it --network="host" ubuntu:20.04 hostname

# -v
# NOTE: volumes will merit their own section, so we'll focus on syntax here
# but there is a script that lays out how to transfer to a volume
# ro --> readonly
docker run --rm -it -v /unnamed_volume ubuntu:20.04 "echo" "unnamed volume"
docker run --rm -it -v myvolume:/my-volume-with-long-name-so-you-can-see ubuntu:20.04 "ls" "/"
docker run -it --rm \
  -w /sw/ \
  -v ${PWD}/input/:/sw/:ro \
  ubuntu:20.04 "cat" "hello-world.txt"

```

## images/ps

Shows images and containers on the system

```bash
# docker images will show you the images on the system
docker images
# REPOSITORY       TAG      IMAGE ID       CREATED          SIZE
# builder          latest   8551bf1ca518   24 minutes ago   72.8MB
# hello-world-v    latest   684c935f0834   51 minutes ago   72.8MB
# <none>           <none>   9e8b24d6ab6f   52 minutes ago   72.8MB
# <none>           <none>   3c0b6b7a0eaa   52 minutes ago   72.8MB

docker ps
# CONTAINER ID   IMAGE            COMMAND                  CREATED      STATUS       PORTS     NAMES
# abd9b51ad425   vsc-ubuntu-dev   "/bin/sh -c 'echo Co…"   3 days ago   Up 8 hours             sleepy_babbage

# show stopped containers
docker ps -a
```

## push/pull/tag

### **NOTE**

This section assumes you're in the folder [docker-push-pull-tag](./docker-push-pull-tag). It also pre-supposes you have an artifactory repo you can push and pull to.

```bash
# first build an image, yes - you could tag it here as well
docker build --target=build -t builder:latest .

# tag the image
docker tag builder:latest <artifactory>/builder-test:latest

# push the image
docker push <artifactory>/builder-test:latest

# remove to test pull
docker rmi builder:latest
docker rmi <artifactory>/builder-test:latest

# pull image
docker pull <artifactory>/builder-test:latest
```

## exec

Execute a command inside of a container, or, more commonly IME, attach to a running container.

```bash
# run an image in a spinning loop
docker run --name=spinner -d --rm ubuntu:20.04 tail -f /dev/null

# exec a command in spinny container
docker exec spinner "echo" "hello-from-spinner"

# -e
# execute a command with an environment variable
docker exec -e SPIN="my-world-is-spinning" spinner env

# -it
# NOTE: this is the main utility I have gotten out of exec
# allows for on the fly container debugging/attaching; exit in container when done
docker exec -it spinner bash

# cleanup; goodbye spinner
docker rm -f spinner
```

## rm/rmi

Remove an image or remove a container

```bash
# run hello-world to ensure we have this image; can skip if this exists
docker run --rm hello-world

# rmi
# remove hello world image
docker rmi hello-world

# rm -f
# remove running container forcefully
docker run -d --name=to-rm ubuntu:20.04 tail -f /dev/null
docker rm -f to-rm

# remove by sha
docker run --name=to-rm ubuntu:20.04
docker ps -a -f name=to
# CONTAINER ID   IMAGE          COMMAND   CREATED          STATUS                      PORTS     NAMES
# a0f5c36489ec   ubuntu:20.04   "bash"    13 seconds ago   Exited (0) 13 seconds ago             to-rm
docker rm a0f5 # <-- whatever the first 3-4 digits of your sha are

# remove dangling images
docker rmi $(docker images -f "dangling=true" -q)
```

## save/load

Saving and loading docker images

```bash
# run hello world to ensure it's on the system
docker run --rm hello-world

# save
docker save -o hello-world.tgz hello-world

# remove the image
docker rmi hello-world

# load
docker load -i hello-world.tgz
```

## cp

Copy a file to or from a running container

```bash
# run a spinner
docker run -d --rm --name tx_agent ubuntu:20.04 tail -f /dev/null

####################################################
# copy the README at this directory to the spinner #
# note this directory must exist                   #
####################################################
docker cp README.md tx_agent:/root/

# tail the readme to prove the file is there
docker exec tx_agent tail /root/README.md

####################################################
# copy from the container                          #
####################################################
docker cp tx_agent:/root/README.md README.tgz

docker rm -f tx_agent
```

## misc

```bash
# follow logs of a running container
docker logs -f <container_id>

# like top but for docker
docker stats
```
