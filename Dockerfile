FROM ubuntu:bionic

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG JAVA_VERSION
ARG JAVA_BUILD
ARG JAVA_SECURITY_BUILD
ARG S6_OVERLAY_VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="ISLE Ubuntu 18.04 (Bionic) Base Image with Oracle Java" \
      org.label-schema.description="ISLE base Docker images based on Ubuntu 18.04 (Bionic), S6 Overlay, and Oracle JDK." \
      org.label-schema.url="https://islandora-collaboration-group.github.io" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/Islandora-Collaboration-Group/isle-ubuntu-basebox" \
      org.label-schema.vendor="Islandora Collaboration Group (ICG) - islandora-consortium-group@googlegroups.com" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

## Understanding docker image layers @see https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#minimize-the-number-of-layers

## General Dependencies 
RUN GEN_DEP_PACKS="ca-certificates \
    dnsutils \
    curl \
    wget \
    rsync \
    git \
    unzip" && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update && \
    apt-get install -y --no-install-recommends $GEN_DEP_PACKS && \
    ## Cleanup phase.
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## S6-Overlay @see: https://github.com/just-containers/s6-overlay
ENV S6_OVERLAY_VERSION=${S6_OVERLAY_VERSION:-1.21.7.0}
ADD https://github.com/just-containers/s6-overlay/releases/download/v$S6_OVERLAY_VERSION/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && \
    rm /tmp/s6-overlay-amd64.tar.gz

## Java Phase (Note after January this is broken.)
ENV JAVA_VERSION=${JAVA_VERSION:-8u202}
ENV JAVA_BUILD=${JAVA_BUILD:-b08}
ENV JAVA_SECURITY_BUILD=${JAVA_SECURITY_BUILD:-1.8.0_202}
RUN cd /tmp && \
    curl -L -b "oraclelicense=a" -O http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$JAVA_BUILD/96a7b8442fe848ef90c96a2fad6ed6d1/server-jre-$JAVA_VERSION-linux-x64.tar.gz && \
    tar xf server-jre-$JAVA_VERSION-linux-x64.tar.gz && \
    mkdir -p /usr/lib/jvm && \
    mv jdk$JAVA_SECURITY_BUILD /usr/lib/jvm && \
    update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk$JAVA_SECURITY_BUILD/bin/java" 1010 && \
    update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk$JAVA_SECURITY_BUILD/bin/javac" 1010 && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

ENV JAVA_HOME=/usr/lib/jvm/jdk$JAVA_SECURITY_BUILD \
    JRE_HOME=/usr/lib/jvm/jdk$JAVA_SECURITY_BUILD/jre \
    PATH=$PATH:/usr/lib/jvm/jdk$JAVA_SECURITY_BUILD/bin:/usr/lib/jvm/jdk$JAVA_SECURITY_BUILD/jre/bin

ENTRYPOINT ["/init"]
