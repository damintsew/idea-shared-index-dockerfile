# idea-shared-index-dockerfile
Repository contains Dockerfile for building Intellij Idea images   

# How to build
INTELLIJ_VERSION=<version>
docker build . --build-arg INTELLIJ_VERSION=${INTELLIJ_VERSION} -t damintsew/indexer-${INTELLIJ_VERSION}
