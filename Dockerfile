FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04
MAINTAINER H2o.ai <ops@h2o.ai>

RUN apt-get -y update && \
    apt-get -y install curl default-jre nginx libzmq-dev apache2-utils

RUN curl https://s3.amazonaws.com/artifacts.h2o.ai/releases/ai/h2o/dai/rel-1.1.0-5/x86_64-centos7/dai_1.1.0_amd64.deb

RUN dpkg -i --force-architecture dai_1.1.0_amd64.deb && \
    rm dai_1.1.0_amd64.deb

RUN curl -H 'Cache-Control: no-cache' \
    https://raw.githubusercontent.com/nimbix/image-common/master/install-nimbix.sh \
    | bash

RUN chown -R nimbix:nimbix /opt/h2oai

# Expose port 22 for local JARVICE emulation in docker
EXPOSE 22
EXPOSE 12345
EXPOSE 54321

COPY run-dai-nimbix.sh /run-dai-nimbix.sh

# Nginx Configuration
COPY NAE/nginx.conf /etc/nginx/nginx.conf
COPY NAE/default /etc/nginx/sites-enabled/default

# Nimbix Integrations
COPY NAE/url.txt /etc/NAE/url.txt
COPY NAE/help.html /etc/NAE/help.html
COPY NAE/AppDef.json /etc/NAE/AppDef.json
COPY NAE/AppDef.png /etc//NAE/default.png
COPY NAE/screenshot.png /etc/NAE/screenshot.png
