ARG TEXT=hello

FROM ubuntu:20.04 as build

WORKDIR /pdsw/

ARG TEXT
RUN echo "$TEXT world" >> test.txt

FROM ubuntu:20.04 as reader

COPY --from=build /pdsw/test.txt .

# sleep so we can see the text
RUN cat test.txt && sleep 5
