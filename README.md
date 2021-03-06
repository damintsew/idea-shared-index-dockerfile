# idea-shared-index-dockerfile

[![Idea Docker images build](https://github.com/damintsew/idea-shared-index-dockerfile/actions/workflows/idea_release_build_and_push.yml/badge.svg?branch=master)](https://github.com/damintsew/idea-shared-index-dockerfile/actions/workflows/idea_release_build_and_push.yml)
[![Goland Docker images build](https://github.com/damintsew/idea-shared-index-dockerfile/actions/workflows/go_master_build_and_push.yml/badge.svg?branch=master)](https://github.com/damintsew/idea-shared-index-dockerfile/actions/workflows/go_master_build_and_push.yml)

The repository contains Dockerfile for building Intellij Idea images that will be used for generating **project** shared indexes 
by `dump-shared-index project` command.


# Run parameters
To build shared indexes you have to provide properties `PROJECT_ID`, `COMMIT_ID` map source directory and directory with the resuls.
Where: 
- `COMMIT_ID` will be used by Idea to find an appropriate index.
- `PROJECT_ID` should be the unique Id of the project the same that in `intellij.yaml`.
- Map source folder. Internally there is `IDEA_PROJECT_DIR` which is hardcoded to `/var/project` and should be mapped by `docker volumes`
- Map folder with the results of generating indexes. Internally is hardcoded to `/shared-index/output` and should be mapped by `docker volumes`


# How to use

1. Download image `docker pull damintsew/idea-indexer-2021.3`.
2. Run image `docker run -v YOUR_PROJECT_DIR:/var/project -v GENERATED_OUTPUD_DIR:/shared-index/output 
-e COMMIT_ID=<full commit hash> -e PROJECT_ID=<project name>` 

For example: //todo 

# How to build
```
INTELLIJ_VERSION=<version>
docker build . --build-arg INTELLIJ_VERSION=${INTELLIJ_VERSION} -t damintsew/idea-indexer-${INTELLIJ_VERSION}
```
Currently, there are several docker images for different Intellij Idea versions:

| Intellij Idea Version. Image tag: damintsew/idea-indexer-${version}                   | Goland Idea version. Image tag: damintsew/goland-indexer-${version}                     |
|:---------------------------------------------------------------------------------|-------------------------------------------------------------------------------------|
|                                                                                  | [2021.3.2](https://hub.docker.com/repository/docker/damintsew/goland-indexer-2021.3.2]) |
| [2021.3.1](https://hub.docker.com/repository/docker/damintsew/idea-indexer-2021.3.1]) | [2021.3.1](https://hub.docker.com/repository/docker/damintsew/goland-indexer-2021.3.1]) |
| [2021.3](https://hub.docker.com/repository/docker/damintsew/idea-indexer-2021.3])     | [2021.2.3](https://hub.docker.com/repository/docker/damintsew/goland-indexer-2021.2.3]) |
| [2021.2.3](https://hub.docker.com/repository/docker/damintsew/idea-indexer-2021.2.3]) | [2021.2.2](https://hub.docker.com/repository/docker/damintsew/goland-indexer-2021.2.2]) |
| [2021.2.2](https://hub.docker.com/repository/docker/damintsew/idea-indexer-2021.2.2]) | [2021.1.1](https://hub.docker.com/repository/docker/damintsew/goland-indexer-2021.2.1]) |
| [2021.2.1](https://hub.docker.com/repository/docker/damintsew/idea-indexer-2021.2.1]) |                                                                                     |
