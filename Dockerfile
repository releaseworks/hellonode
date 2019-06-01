# use a node base image
FROM node:7-onbuild

ARG BUILD_SRC
ARG BUILD_COMMIT

# Labels.
# https://medium.com/@chamilad/lets-make-your-docker-image-better-than-90-of-existing-ones-8b1e5de950d
# https://github.com/opencontainers/image-spec
# http://label-schema.org/rc1/#label-semantics
# https://github.com/opencontainers/image-spec/blob/master/annotations.md#back-compatibility-with-label-schema
# https://rehansaeed.com/docker-labels-depth/
# https://docs.docker.com/engine/reference/builder/#label
# https://microbadger.com/labels
# Label can be seen with docker inspect

LABEL maintainer="miiro@getintodevops.com" \
      org.opencontainers.image.title="Hello node" \
      org.opencontainers.image.description="NodeJS basic example" \
      org.opencontainers.image.source="${BUILD_SRC}" \
      org.opencontainers.image.version="${BUILD_COMMIT}"

# https://medium.com/capital-one-tech/multi-stage-builds-and-dockerfile-b5866d9e2f84
# FROM node:latest as builder
# WORKDIR /usr/src/app
# COPY package* ./
# COPY src/ src/
# RUN [“npm”, “install”]
#   "ARG NODE_ENV",
#                "ENV NODE_ENV $NODE_ENV",
#                "COPY package.json /usr/src/app/",
#                "RUN npm install && npm cache clean --force",
#                "COPY . /usr/src/app"
# REPOSITORY                TAG                 IMAGE ID            CREATED             SIZE
# romainx/hellonode         latest              619620e536fe        2 minutes ago       662MB


# set a health check
HEALTHCHECK --interval=5s \
            --timeout=5s \
            CMD curl -f http://127.0.0.1:8000 || exit 1

# tell docker what port to expose
EXPOSE 8000

# docker build --no-cache=true --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') -t mytool:latest .
# docker build --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') --build-arg VCS_REF=$(git rev-parse --short HEAD) -t getintodevops/hellonode:latest .