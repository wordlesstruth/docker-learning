ARG TEXT=docker

FROM ubuntu:20.04 as build

WORKDIR /sw/

ARG TEXT
RUN echo "$TEXT push/pull/tag are cool commands" >> test.txt

FROM ubuntu:20.04 as reader

COPY --from=build /sw/test.txt .

# sleep so we can see the text
RUN cat test.txt && sleep 5
