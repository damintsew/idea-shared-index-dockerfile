FROM alpine:3.15.0

ARG INTELLIJ_VERSION
ARG INTELLIJ_IDE_TAR=${INTELLIJ_VERSION}.tar.gz

#ENV IDEA_PROPERTIES=/opt/idea/bin/idea.properties
WORKDIR /opt

RUN wget https://download-cf.jetbrains.com/idea/${INTELLIJ_IDE_TAR} -nv && \
    tar xzf ${INTELLIJ_IDE_TAR} && \
    tar tzf ${INTELLIJ_IDE_TAR} | head -1 | sed -e 's/\/.*//' | xargs -I{} ln -s {} idea && \
    rm ${INTELLIJ_IDE_TAR}

FROM openkbs/jdk-mvn-py3

ENV COMMIT_ID=''
ENV PROJECT_ID=''
ENV IDEA_PROJECT_DIR="/var/project"
ENV SHARED_INDEX_BASE="/shared-index"

USER root
WORKDIR /opt

RUN mkdir -p /etc/idea && \
    mkdir -p /etc/idea/config && \
    mkdir -p /etc/idea/log && \
    mkdir -p /etc/idea/system && \
    mkdir ${SHARED_INDEX_BASE} && \
    mkdir ${SHARED_INDEX_BASE}/output && \
    mkdir ${SHARED_INDEX_BASE}/temp

COPY --from=0 /opt/* /opt/

RUN chmod -R 777 ${SHARED_INDEX_BASE} && \
    chmod -R 777 /etc/idea

CMD /opt/idea/bin/idea.sh dump-shared-index project \
    --project-dir=${IDEA_PROJECT_DIR} \
    --project-id=${PROJECT_ID} \
    --commit-id=${COMMIT_ID} \
    --tmp=${SHARED_INDEX_BASE}/temp \
    --output=${SHARED_INDEX_BASE}/output
