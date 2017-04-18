FROM mongo:2.6

MAINTAINER juliens@microsoft.com

RUN mkdir -p /usr/local/app
WORKDIR /usr/local/app

COPY drop/* /usr/local/app/

ENTRYPOINT sh run.sh
