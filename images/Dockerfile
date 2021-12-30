FROM alpine:3.15.0

ARG INTELLIJ_VERSION=ideaIU-2021.3.1
ARG INTELLIJ_IDE_TAR=${INTELLIJ_VERSION}.tar.gz

ENV IDEA_PROPERTIES=/opt/idea/bin/idea.properties
WORKDIR /opt

RUN wget https://download-cf.jetbrains.com/idea/${INTELLIJ_IDE_TAR} -nv && \
    tar xzf ${INTELLIJ_IDE_TAR} && \
    tar tzf ${INTELLIJ_IDE_TAR} | head -1 | sed -e 's/\/.*//' | xargs -I{} ln -s {} idea && \
    rm ${INTELLIJ_IDE_TAR}

