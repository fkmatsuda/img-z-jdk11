# Copyright (c) 2021 fkmatsuda <fabio@fkmatsuda.dev>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

FROM node:lts-bullseye-slim
ARG TARGETPLATFORM
ENV DOWNLOAD_URL=invalid
ENV ZULU_TAR=invalid
RUN case "${TARGETPLATFORM}" in \
         "linux/amd64")     DOWNLOAD_URL=https://cdn.azul.com/zulu/bin/zulu11.58.15-ca-jdk11.0.16-linux_x64.tar.gz               \
                            ZULU_TAR="zulu11.58.15-ca-jdk11.0.16-linux_x64"        ;; \
         "linux/arm64")     DOWNLOAD_URL=https://cdn.azul.com/zulu-embedded/bin/zulu11.58.15-ca-jdk11.0.16-linux_aarch64.tar.gz           \
                            ZULU_TAR="zulu11.58.15-ca-jdk11.0.16-linux_aarch64"    ;; \
    esac && \
    apt-get update -qq && apt-get upgrade -qq --autoremove --purge && \
    apt-get install -qq wget git java-common libasound2 libxi6 libxtst6 && \
    apt-get clean && \
    mkdir -p /opt/maven /opt/jdk && \
    wget ${DOWNLOAD_URL} && \
    tar -C /opt/jdk -xzf ./${ZULU_TAR}.tar.gz && \
    mv /opt/jdk/${ZULU_TAR} /opt/jdk/zulu && \
    rm ./${ZULU_TAR}.tar.gz && \
    wget https://dlcdn.apache.org/maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz && \
    tar -C /opt/maven/ -xzf ./apache-maven-3.8.4-bin.tar.gz && \
    rm ./apache-maven-3.8.4-bin.tar.gz

ENV MAVEN_HOME="/opt/maven/apache-maven-3.8.4"
ENV JAVA_HOME="/opt/jdk/zulu"
ENV PATH="$JAVA_HOME/bin:$PATH:$MAVEN_HOME/bin"
