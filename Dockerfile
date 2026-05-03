FROM crystallang/crystal:1.19

RUN apt-get update
RUN apt-get install --yes libsqlite3-dev
