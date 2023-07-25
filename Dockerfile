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

FROM node:lts-bookworm-slim
ARG TARGETPLATFORM
ENV DOWNLOAD_URL=invalid
ENV ZULU_DEB=invalid
RUN case "${TARGETPLATFORM}" in \
         "linux/amd64")     DOWNLOAD_URL=https://cdn.azul.com/zulu/bin/zulu11.66.15-ca-jdk11.0.20-linux_amd64.deb             && \
                            ln -s /usr/lib/jvm/zulu-11-amd64 /java-home                                                              && \
                            ZULU_DEB="zulu11.66.15-ca-jdk11.0.20-linux_amd64.deb"        ;; \
         "linux/arm64")     DOWNLOAD_URL=https://cdn.azul.com/zulu/bin/zulu11.66.15-ca-jdk11.0.20-linux_arm64.deb      && \
                            ln -s /usr/lib/jvm/zulu-11-arm64 /java-home                                                              && \
                            ZULU_DEB="zulu11.66.15-ca-jdk11.0.20-linux_arm64.deb"    ;; \
    esac && \
    apt-get update -qq && apt-get upgrade -qq --autoremove --purge && \
    apt-get install -qq wget git java-common libasound2 libxi6 libxtst6 wait-for-it libxrender1 libfontconfig1 && \
    apt-get clean && \
    wget ${DOWNLOAD_URL} && \
    dpkg -i ./${ZULU_DEB} && \
    rm ./${ZULU_DEB}

RUN wget https://dlcdn.apache.org/maven/maven-3/3.9.3/binaries/apache-maven-3.9.3-bin.tar.gz && \
    tar -xzf apache-maven-3.9.3-bin.tar.gz && \
    mv apache-maven-3.9.3 /usr/local/maven && \
    rm apache-maven-3.9.3-bin.tar.gz

ENV MAVEN_HOME="/usr/local/maven"
ENV JAVA_HOME="/java-home"
ENV PATH="$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH"
