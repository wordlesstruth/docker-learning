FROM ubuntu:20.04 as build

RUN apt-get update \
    && apt-get install -y g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /sw/

COPY hello-world.cpp .

RUN g++ -o hello-world --static hello-world.cpp

FROM scratch as runtime
WORKDIR /sw/
COPY --from=build /sw/hello-world .
CMD ["./hello-world"]