ARG TEXT="a part of your"

FROM ubuntu:20.04 as build

WORKDIR /sw/

ARG TEXT
RUN echo "$TEXT world" >> test.txt

FROM ubuntu:20.04 as reader

COPY --from=build /sw/test.txt .

# sleep so we can see the text
RUN cat test.txt && sleep 5
