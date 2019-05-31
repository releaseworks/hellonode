# use a node base image
FROM node:7-onbuild

ARG IMAGE_NAME
ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION

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
      org.opencontainers.image.source="https://github.com/romainx/hellonode" \
      org.opencontainers.image.ref.name=$IMAGE_NAME \
      org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.version=$BUILD_VERSION \
      org.opencontainers.image.revision=$VCS_REF

# set a health check
HEALTHCHECK --interval=5s \
            --timeout=5s \
            CMD curl -f http://127.0.0.1:8000 || exit 1

# tell docker what port to expose
EXPOSE 8000

# docker build --no-cache=true --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') -t mytool:latest .
# docker build --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') --build-arg VCS_REF=$(git rev-parse --short HEAD) -t getintodevops/hellonode:latest .