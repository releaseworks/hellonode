# ---- Base Node ----
# Example from: https://gist.github.com/praveenweb/acd27014e6d244c3194d3e9d7da04e17
FROM node:carbon AS builder
# Create app directory
WORKDIR /app
# ---- Dependencies ----
# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./
# Install app dependencies including 'devDependencies'
RUN npm install
# ---- Copy Files/Build ----
WORKDIR /app
COPY src /app

# ---- Release with Alpine ----
FROM node:8.9-alpine AS release

## ---- Labels ----
# can be seen with docker inspect
# Refs (TODO: clean refs):
# - https://medium.com/@chamilad/lets-make-your-docker-image-better-than-90-of-existing-ones-8b1e5de950d
# - https://github.com/opencontainers/image-spec
# - http://label-schema.org/rc1/#label-semantics
# - https://github.com/opencontainers/image-spec/blob/master/annotations.md#back-compatibility-with-label-schema
# - https://rehansaeed.com/docker-labels-depth/
# - https://docs.docker.com/engine/reference/builder/#label
# - https://microbadger.com/labels

# Args
ARG BUILD_SRC
ARG BUILD_COMMIT

LABEL maintainer="miiro@getintodevops.com" \
      org.opencontainers.image.title="Hello node" \
      org.opencontainers.image.description="NodeJS basic example" \
      org.opencontainers.image.source="${BUILD_SRC}" \
      org.opencontainers.image.version="${BUILD_COMMIT}"

## ---- Setup App ----
WORKDIR /app
# Copy app from the builder
COPY --from=builder /app ./
# Install app dependencies
RUN npm install --only=production

## ---- Define health check ----
HEALTHCHECK --interval=5s \
            --timeout=5s \
            CMD curl -f http://127.0.0.1:8000 || exit 1

## ---- Start App ----
EXPOSE 8080
CMD ["npm", "start"]