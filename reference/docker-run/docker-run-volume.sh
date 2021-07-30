#!/bin/bash

docker build -t hello-world-v:latest .
docker run --rm -it hello-world-v:latest "cat" "hello-world.txt"

docker run -d --rm --name tx_agent -v myvolume:/root ubuntu:20.04 tail -f /dev/null
docker cp volume-override/hello-world.txt tx_agent:/root/hello-world.txt
docker stop tx_agent

docker run --rm -it -v myvolume:/sw/ hello-world-v:latest "cat" "hello-world.txt"
