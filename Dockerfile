FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04
MAINTAINER H2o.ai <ops@h2o.ai>

RUN apt-get -y update && \
    apt-get -y install curl && \
    apt-get -y install default-jre

RUN curl https://s3.amazonaws.com/artifacts.h2o.ai/releases/ai/h2o/dai/rel-1.1.0.cuda9-1/x86_64-centos7/dai-1.1.0-1.x86_64.rpm --output /tmp/dai-1.1.0-1.x86_64.rpm

RUN apt get -y install alien

RUN cd /tmp && \
    alien -k dai-1.1.0-1.x86_64.rpm && \
    dpkg -i --force-architecture dai-1.1.0-1.x86_64.deb

RUN curl -H 'Cache-Control: no-cache' \
    https://raw.githubusercontent.com/nimbix/image-common/master/install-nimbix.sh \
    | bash

RUN chown -R nimbix:nimbix /opt/h2oai

# Expose port 22 for local JARVICE emulation in docker
EXPOSE 22
EXPOSE 12345
EXPOSE 54321

COPY run-dai-nimbix.sh /run-dai-nimbix.sh

# Nimbix Integrations
COPY NAE/url.txt /etc/NAE/url.txt
COPY NAE/help.html /etc/NAE/help.html
COPY NAE/AppDef.json /etc/NAE/AppDef.json
COPY NAE/AppDef.png /etc//NAE/default.png
COPY NAE/screenshot.png /etc/NAE/screenshot.png
