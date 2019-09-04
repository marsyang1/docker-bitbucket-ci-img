FROM mhart/alpine-node:10
MAINTAINER MarsYang
# Reference to altassian/default-image:2 , but use alpine

ARG CLOUD_SDK_VERSION=256.0.0
# change back apk repo to default repo
RUN export APK_VER=$(cat /etc/alpine-release | cut -d "." -f 1,2) \
    &&  echo "http://dl-cdn.alpinelinux.org/alpine/v$APK_VER/main" >> /etc/apk/repositories \
    &&  echo "http://dl-cdn.alpinelinux.org/alpine/v$APK_VER/community" >> /etc/apk/repositories

RUN apk update \
    && apk add wget \
        curl \
        git \
        unzip \
        openjdk8 \
        # for base64
        coreutils
        
# split gradle to second time add        
RUN apk update && apk add gradle        

# Create dirs and users
RUN mkdir -p /opt/atlassian/bitbucketci/agent/build
RUN adduser -s /bin/sh -u 1000 -D pipelines

# install google cloud sdk
# https://github.com/GoogleCloudPlatform/cloud-sdk-docker/blob/master/alpine/Dockerfile
ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION

ENV PATH /google-cloud-sdk/bin:$PATH
RUN apk add \
        curl \
        python \
        py-crcmod \
        bash \
        libc6-compat \
        openssh-client \
        git \
        gnupg

RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud --version

# add other tools
RUN apk add \
     vim \
     py-pip \
     ansible

# Default to UTF-8 file.encoding
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    LANGUAGE=C.UTF-8

WORKDIR /opt/atlassian/bitbucketci/agent/build
ENTRYPOINT /bin/sh
